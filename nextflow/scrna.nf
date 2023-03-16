/*
    Sample Alignment
*/

// Declare syntax version
nextflow.enable.dsl=2

process sample_alignment {

    cpus 8
    memory { '114.GB' * task.attempt }

    container 'oandrefonseca/scaligners:1.0'
    label "Sample_Alignment"

    tag "Processing ${sample_id}"

    input:
        tuple val(sample_id), val(prefix), path(first_read), path(second_read), path(reference)
        //path  reference

    output:
        //path("L002/L002.mri.tgz")
        path("${sample_id}/*")

    script:
        avail_mem = task.memory.toGiga()
        """
        echo $task.cpus
        echo $avail_mem
        grep MemTotal /proc/meminfo

        cellranger \\
            count \\
            --id '${sample_id}' \\
            --fastqs . \\
            --transcriptome ${reference} \\
            --sample ${prefix} \\
            --no-bam \\
            --localcores=8 \\
            --localmem=64
        """

}


params.index_fasta = "csv_entry.csv"

workflow {
    
    Channel.fromPath(params.index_fasta) \
        | splitCsv(header:true)
        | map { row-> tuple(row.sample, row.prefix, file(row.fastq_1), file(row.fastq_2), file(row.ref)) }
        | sample_alignment

}