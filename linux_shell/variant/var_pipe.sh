#! /usr/bin/bash

### run like 
	#chmod +x var_pipe.sh
	#./var_pipe.sh srr.ids &
	# Requires installing TRIMMOMATIC, freebayes, vcflib as adding vcflib binaries folder to your $PATH

# IMPORTANT !!!!! Update THIS to you Trimmomatic jar path and freebayes binary !!!!!
export TRIMMOMATIC=$TOOLS/Trimmomatic-0.39/trimmomatic-0.39.jar;
export FREEBAYES=$TOOLS/freebayes-v1.3.0-1;

# get reference for freebayes and indexes from bowtie2
wget https://genome-idx.s3.amazonaws.com/bt/hg19.zip
unzip hg19.zip
wget ftp://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/latest/hg19.fa.gz
gunzip hg19.fa.gz
samtools faidx hg19.fa

# get reads from SRA
#parallel -a $1 fastq-dump --split-files --origfmt --gzip;

# run qc on all downloads
#fastqc *.fastq.gz

# read in srr.ids file
readarray -t mySRRs < $1

for id in "${mySRRs[@]}"; do
	java -jar $TRIMMOMATIC PE ${id}_1.fastq.gz ${id}_2.fastq.gz \
		${id}_1.trim.fastq.gz ${id}_1un.trim.fastq.gz \
		${id}_2.trim.fastq.gz ${id}_2un.trim.fastq.gz \
		SLIDINGWINDOW:4:20 \
		MINLEN:20;

	fastqc ${id}_*.trim.fastq.gz
	
	bowtie2 -x hg19 -1 ${id}_1.trim.fastq.gz -2 ${id}_2.trim.fastq.gz --threads 32 --fast -S ${id}_paired.hg19.trim.sam;
	samtools sort ${id}_paired.hg19.trim.sam -o ${id}_paired.hg19.trim.sorted.bam -O bam;
	samtools index ${id}_paired.hg19.trim.sorted.bam;

	$FREEBAYES -f hg19.fa ${id}_paired.hg19.trim.sorted.bam -r chr17:0-81195210 > ${id}_paired.hg19.trim.vcf;

	vcffilter -f "DP > 10 & AF = 0.5" ${id}_paired.hg19.trim.vcf > ${id}_paired.hg19.trim.filtered.vcf;
	vcfannotate -b refGene_BRCA1_exons_hg19_transcript1.bed \
		-k REFGENE \
		${id}_paired.hg19.trim.filtered.vcf > ${id}_paired.hg19.trim.filtered.annot.vcf;
		
	echo ${id};
	bedtools intersect -a ${id}_paired.hg19.trim.filtered.vcf -b refGene_BRCA1_exons_hg19_transcript1.bed | wc -l;

done;
