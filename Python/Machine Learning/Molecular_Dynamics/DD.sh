bcftools +mocha \
  -g GRCh38 \
  --input-stats calls/tcgaSNP6.stats.tsv \
  -Oz -o test.as.vcf.gz \
  --variants ^results_single_batch/tcgaSNP6.xcl.bcf \
  --calls TCGA.calls.tsv \
  --stats TCGA.stats.tsv \
  --ucsc-bed TCGA.ucsc.bed \
  --cnp /storage1/fs1/bolton/Active/projects/mocha/resources/cnp.grch38.bed \
  --mhc $mhc_reg \
  --kir $kir_reg \
  --threads 64 \
  results_single_batch/tcgaSNP6.as.bcf


mhc_reg="6:27486711-33448264"
kir_reg="19:54574747-55504099"

bcftools +mocha \
  -g GRCh38 \
  --input-stats computed.gender.tsv \
  -Oz -o test.as.vcf.gz \
  --variants ^results_single_batch/tcgaSNP6.xcl.bcf \
  --calls TCGA.self_reported_gender.calls.tsv \
  --stats TCGA.self_reported_gender.stats.tsv \
  --ucsc-bed TCGA.self_reported_gender.ucsc.bed \
  --cnp /storage1/fs1/bolton/Active/projects/mocha/resources/cnp.grch38.bed \
  --mhc $mhc_reg \
  --kir $kir_reg \
  --threads 64 \
  results_single_batch/tcgaSNP6.as.bcf

https://github.com/jamesgleave/Deep-Docking-NonAutomated/issues/16
obabel -ipdbqt * -osdf -m
https://autodock-vina.readthedocs.io/en/latest/docking_multiple_ligands.html

# For molecular_file_count_updated.py AND sampling.py the option left_mol_directory is the directory where molecules are sampled; for iteration 1, left_mol_directory is the directory storing the Morgan fingerprints of the database; BUT for subsequent iterations this must be the path to morgan_1024_predictions folder of the previous iteration.
python Deep-Docking-NonAutomated/phase_1/molecular_file_count_updated.py -pt DeepDockABL1 -it 1 -cdd D2/morgan/fingerprint -t_pos 32 -t_samp 15000
python Deep-Docking-NonAutomated/phase_1/sampling.py -pt DeepDockABL1 -fp /storage1/fs1/bolton/Active/projects/BWILEYtest/test -it 1 -dd D2/morgan/fingerprint -t_pos 32 -tr_sz 12000 -vl_sz 3000
# 2
python Deep-Docking-NonAutomated/phase_1/molecular_file_count_updated.py -pt DeepDockABL1 -it 11 -cdd test/DeepDockABL1/iteration_9/morgan_1024_predictions -t_pos 32 -t_samp 10000
python Deep-Docking-NonAutomated/phase_1/sampling.py -pt DeepDockABL1 -fp /storage1/fs1/bolton/Active/projects/BWILEYtest/test -it 10 -dd test/DeepDockABL1/iteration_9/morgan_1024_predictions -t_pos 32 -tr_sz 20000 -vl_sz 5000


python Morgan_fing.py -sfp D2/smiles3D -fp D2/morgan3D -fn fingerprint -tp 4

python Deep-Docking-NonAutomated/phase_1/sanity_check.py -pt DeepDockABL1 -fp /storage1/fs1/bolton/Active/projects/BWILEYtest/test -it 10
python Deep-Docking-NonAutomated/phase_1/Extracting_morgan.py -pt DeepDockABL1 -fp /storage1/fs1/bolton/Active/projects/BWILEYtest/test -it 10 -md D2/morgan/fingerprint -t_pos 32
python Deep-Docking-NonAutomated/phase_1/Extracting_smiles.py -pt DeepDockABL1 -fp /storage1/fs1/bolton/Active/projects/BWILEYtest/test -it 10 -smd D2/smiles -t_pos 32
sleep 3



# cat smile/*.smi | while read smiles zinc_id; do 
# for smile in $(cat damn.txt | cut -d: -f1 | sort | uniq | cut -d/ -f2 | cut -d. -f1); do
# grep $smile smile/*.smi | cut -d: -f2 | while read smiles zinc_id; do 
# cat smile/*.smi | grep -v -f damn.txt | tail -n+2 | cut -d: -f2 | while read smiles zinc_id; do 

# for smile in $(grep -v -f docking/ran.txt docking/run.txt); do
# grep $smile smile/*.smi | cut -d: -f2 | while read smiles zinc_id; do

ls docking/*.sdf | cut -d/ -f2 | cut -d. -f1 > all.sdfs
cat smile/*.smi > all.smiles
grep -v -f all.sdfs all.smiles > remaining.smiles
split -l 1000 -d all.smiles batch_smi_
# for batch in $(ls batch_smi* | grep -v log | tail -n+2); do
for batch in $(ls batch_smi* | grep -v log | head -n1); do
    ls $batch
    bsub -n2 -oo $batch.log -G compute-bolton -g /bwileytest -q general -M 2G -R "rusage[mem=2GB] " -a "docker($OBABEL)" ../obabel.sh $batch
done
cat ../smile/smiles2.csv | while read smiles zinc_id; do
    echo $smiles $zinc_id; 
    obabel -:"$smiles" -osdf -h --gen3D -O $zinc_id.sdf;    
done
grep "0.0000    0.0000    0.0000" *.sdf | cut -d: -f1 | cut -d. -f1 | uniq > damn.txt
for smile in $(cat damn.txt | tail -n+2); do
for smile in $(cat damn2.txt | awk '{print $1}'); do
    grep $smile ../smile/*.smi | cut -d: -f2 | while read smiles zinc_id; do 
        echo $zinc_id $smiles
        # obabel -:"$smiles" -ocan | obabel -ismi -h --gen2d -osdf | obabel -isdf -h --gen3d -omol2 -O $zinc_id.sdf
        #obabel -:"$smiles" -ocan | obabel -ismi -h --gen2d -omol2 | obabel -imol2 -h --gen3d -omol2 | obabel -imol2 -h -osdf -O $zinc_id.sdf
    done
done
for smile in $(cat damn2.txt); do
    grep $smile ../smile/*.smi | cut -d: -f2 | while read smiles zinc_id; do
    printf "$zinc_id\t"
    head -n10 $zinc_id.sdf | tail -n6 | awk '$3==0.0000' | wc -l
done
done | awk '$2==6 {print $1}' > damn4.txt
for zinc_id in $(ls *.sdf | cut -d. -f1); do
 printf "$zinc_id\t"
head -n10 $zinc_id.sdf | tail -n6 | awk '$3==0.0000' | wc -l
done | awk '$2==6 {print $1}' > damn5.txt

kboltonlab/obabel
bsub -n16 -oo cpu.log -G compute-bolton -g /bwileytest -q general -M 400G -R "select[mem>400GB] rusage[mem=400GB]" -a "docker(kboltonlab/obabel)" ./rdkit.sh
for smile in $(cat damn5.txt); do
# for smile in $(grep -v -f all.pdbqts all.sdfs); do
    # grep $smile ../smile/*.smi | cut -d: -f2 | while read smiles zinc_id; do
    grep $smile ../smiles.csv | while read id smiles zinc_id; do
        echo $smiles $zinc_id
        /usr/local/bin/python3.7 $PROJECTS/BWILEYtest/test/DeepDockABL1/3d.py $smiles $zinc_id.sdf
    done
done

## ON MACBOOK
# for smile in $(cat damn4.txt | awk '{print $1}'); do
# for smile in $(grep -v -f all.xmls.txt all.sdfs.txt | grep -v -f damn3.txt | grep -v test); do
#     grep $smile ../smile/*.smi | cut -d: -f2 | while read smiles zinc_id; do 
#         echo $zinc_id $smiles
#         obabel -:"$smiles" -ocan | obabel -ismi -h -o sdf --gen2d | obabel -isdf -omol2  --gen3d | obabel -imol2 -osdf -O $zinc_id.sdf
#     done
# done

obabel -ipdb -opdbqt -xr --partialcharge gasteiger -O protein.pdbqt protein.pdb

pythonsh $TOOLS/mgltools_1.5.7_MacOS-X/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_flexreceptor4.py -r protein.pdbqt -s protein:A:LEU16_GLU18_GLN20_ASP149_PHE150 -g protein_rigid.pdbqt -x protein_flex.pdbqt
pythonsh
# export PATH=$PATH:/opt/mgltools_x86_64Linux2_1.5.7/bin
pythonsh /opt/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_flexreceptor4.py -r protein.pdbqt -s protein:A:LEU16_GLU18_GLN20_ASP149_PHE150 -g protein_rigid.pdbqt -x protein_flex.pdbqt
~/tools/mgltools_x86_64Linux2_1.5.7/bin/pythonsh ~/tools/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_flexreceptor4.py -r protein.pdbqt -s protein:A:LEU16_GLU18_GLN20_ASP149_PHE150 -g protein_rigid.pdbqt -x protein_flex.pdbqt
# -d durectory with ligands (*.pdbqt files)
pythonsh /opt/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_gpf4.py -r protein_rigid.pdbqt -x protein_flex.pdbqt -d ligands -i sample.gpf -p npts="60,60,60" -p gridcenter="-5.6700,-15.420,-30.130" -p spacing="0.375" -o protein_rigid.gpf

pythonsh /opt/mgltools_x86_64Linux2_1.5.7/bin/pythonsh /opt/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/process_VSResults.py -d 822135435 -r protein.pdbqt -B


pythonsh $TOOLS/mgltools_1.5.7_MacOS-X/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_gpf4.py -r protein_rigid.pdbqt -x protein_flex.pdbqt -d iteration_1/docking -i sample.gpf -p npts="60,60,60" -p gridcenter="-5.6700,-15.420,-30.130" -p spacing="0.3" -o protein_rigid.gpf
# pythonsh $TOOLS/mgltools_1.5.7_MacOS-X/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_gpf4.py -r protein_rigid.pdbqt -x protein_flex.pdbqt -l 1607482449.pdbqt -i sample.gpf -p npts="60,60,60" -p gridcenter="-5.6700,-15.420,-30.130" -p spacing="0.375" -p gridfld="protein_rigid.silicon.maps.fld" -o silicon.gpf
# pythonsh $TOOLS/mgltools_1.5.7_MacOS-X/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_gpf4.py -r protein_rigid.pdbqt -x protein_flex.pdbqt -l 1807026463.pdbqt -i sample.gpf -p npts="60,60,60" -p gridcenter="-5.6700,-15.420,-30.130" -p spacing="0.6375" -p gridfld="protein_rigid.phosphate.maps.fld" -o phosphate.gpf
pythonsh $TOOLS/mgltools_1.5.7_MacOS-X/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_gpf4.py -r protein_rigid.pdbqt -x protein_flex.pdbqt -l 584987281.pdbqt -i sample.gpf -p npts="60,60,60" -p gridcenter="-5.6700,-15.420,-30.130" -p spacing="0.400" -p gridfld="protein_rigid.boron.maps.fld" -o boron.gpf 
# pythonsh $TOOLS/mgltools_1.5.7_MacOS-X/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_gpf4.py -r protein_rigid.pdbqt -x protein_flex.pdbqt -l 2295859.pdbqt -i sample.gpf -p npts="200,200,200" -p gridcenter="-5.6700,-15.420,-30.130" -p spacing="0.5" -p gridfld="protein_rigid.phosphate_chlorine.maps.fld" -o phosphate_chlorine.gpf
pythonsh $TOOLS/mgltools_1.5.7_MacOS-X/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_gpf4.py -r protein_rigid.pdbqt -x protein_flex.pdbqt -l docking/1807024100.pdbqt -i sample.gpf -p npts="60,60,60" -p gridcenter="-5.6700,-15.420,-30.130" -p spacing="0.375" -p gridfld="protein_rigid.phosphate_chlorine_flourine.maps.fld" -o phosphate_chlorine_flourine.gpf

$TOOLS/MacOSX/autogrid4 -p protein_rigid.gpf
$TOOLS/MacOSX/autogrid4 -p silicon.gpf
$TOOLS/MacOSX/autogrid4 -p phosphate.gpf
$TOOLS/MacOSX/autogrid4 -p boron.gpf
$TOOLS/MacOSX/autogrid4 -p phosphate_chlorine.gpf
$TOOLS/MacOSX/autogrid4 -p phosphate_chlorine_flourine.gpf
# pythonsh $TOOLS/mgltools_1.5.7_MacOS-X/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_dpf4.py -r protein_rigid.pdbqt -x protein_flex.pdbqt -l iteration_1/docking/run/974769965.pdbqt -o iteration_1/docking/run/974769965.dpf


    #prepare_ligand -l $mol2.mol2 -o $mol2.pdbqt -A bonds_hydrogens
ls *.sdf | cut -d. -f1 > all.sdfs
ls *.pdbqt | grep -v protein | cut -d. -f1 > all.pdbqts
for sdf in $(grep -v -f all.pdbqts2 all.sdfs); do
# for sdf in $(cat damn5.txt); do
for sdf in $(ls *.sdf | cut -d. -f1 | head -n2500); do
# for sdf in $(ls *.sdf | cut -d. -f1 | head -n15000 | tail -n5000); do
# for sdf in $(grep -v -f all.pdbqts all.sdfs); do
# for sdf in 19632618 4261765; do
    echo $sdf
    echo $sdf >> total.sdfs.txt
    mk_prepare_ligand.py -i $sdf.sdf -o $sdf.pdbqt
done

ls *.pdbqt | grep -v protein | cut -d. -f1 > all.pdbqts
split -l 500 -d all.pdbqts batch_pdb_
# split -l 200 -d meeko.redo redo_batch_
for batch in $(ls batch_pdb_* | grep -v log); do
   (printf "protein_rigid.maps.fld\n"
    for ligand in $(echo dasatinib imatinib); do
        echo $ligand.pdbqt
        echo $ligand
    done
   ) > ad_submit_${batch}
done
for batch in $(ls ad_submit_batch_pdb_{00..00}); do
    ls $batch
    bsub -oo $batch.log -g /bwileytest3 -G compute-timley -q general-interactive -M 64G -R 'gpuhost rusage[mem=64GB]' -q general -gpu "num=1:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/ad_gpu)" /opt/AutoDock-GPU/bin/autodock_gpu_64wi --filelist batch -nrun 1000 -lsmet ad -heuristics 1 --flexres protein_flex.pdbqt
    sleep 1
done
Vardict_gt_AF,Mutect2_gt_AF,Mutect2_FILTER,key,gene_aachange,sample_id,ch_pd2,samplekey,average_AF






# /Users/brian/tools/MacOSX/autodock4 -p iteration_1/docking/run/974769965.dpf
# /opt/AutoDock-GPU/bin/autodock_gpu_64wi --ffile protein_rigid.maps.fld --flexres protein_flex.pdbqt --lfile iteration_1/docking/run/974769965.pdbqt --nrun 100 --resnam test.out
/opt/AutoDock-GPU/bin/autodock_gpu_64wi --filelist batch2.txt -nrun 100 -lsmet ad -heuristics 1 --flexres protein_flex.pdbqt

pythonsh $TOOLS/mgltools_1.5.7_MacOS-X/MGLToolsPckgs/AutoDockTools/Utilities24/process_VSResults.py -d 544936672 -r protein.pdbqt -B

/opt/mgltools_x86_64Linux2_1.5.7/bin/pythonsh /opt/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/process_VSResults.py -d 822135435 -r protein.pdbqt -B
pythonsh /opt/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/process_VSResults.py -d dasatinib -r protein.pdbqt -B

cd */docking
/opt/mgltools_x86_64Linux2_1.5.7/bin/pythonsh /opt/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/process_VSResults.py -d 19632618 -r protein.pdbqt -B
cp 1591346155* 1591346155
544936672

(printf "../protein_rigid.maps.fld\n"; for zinc in $(ls docking/run/*.pdbqt | cut -d/ -f3 | cut -d. -f1); do
echo ./docking/run/$zinc.pdbqt
echo $zinc
done) > batch.txt
./iteration_1/docking/run/632406051.pdbqt
632406051

python Deep-Docking-NonAutomated/phase_2-3/Extract_labels.py -if False -n_it 1 -protein DeepDockABL1 -file_path /storage1/fs1/bolton/Active/projects/BWILEYtest/test -t_pos 3 -score VINA -zincid "ZINC:"

## just make our own labels file
testing_labels.txt  smile/test_smiles_final_updated.smi
training_labels.txt  smile/train_smiles_final_updated.smi
validation_labels.txt smile/valid_smiles_final_updated.smi

IS_B $OBABEL 8 2
(echo "r_i_docking_score,ZINC_ID";
cat smile/test_smiles_final_updated.smi | while read smiles zinc_id; do
    bind_energy=$(/usr/local/bin/python3.7 $PROJECTS/BWILEYtest/test/DeepDockABL1/parse_xml.py docking/$zinc_id.xml)
     printf '%s,%s\n' "${bind_energy}" "${zinc_id}"
done) > testing_labels.txt
(echo "r_i_docking_score,ZINC_ID";
cat smile/train_smiles_final_updated.smi | while read smiles zinc_id; do
    bind_energy=$(/usr/local/bin/python3.7 $PROJECTS/BWILEYtest/test/DeepDockABL1/parse_xml.py docking/$zinc_id.xml)
    printf '%s,%s\n' "${bind_energy}" "${zinc_id}"
done) > training_labels.txt
(echo "r_i_docking_score,ZINC_ID";
cat smile/valid_smiles_final_updated.smi | while read smiles zinc_id; do
    bind_energy=$(/usr/local/bin/python3.7 $PROJECTS/BWILEYtest/test/DeepDockABL1/parse_xml.py docking/$zinc_id.xml)
    printf '%s,%s\n' "${bind_energy}" "${zinc_id}"
done) > validation_labels.txt
sleep 10
# final
(echo "r_i_docking_score,ZINC_ID";
cat all.smiles | while read smiles zinc_id; do
    bind_energy=$(/usr/local/bin/python3.7 $PROJECTS/BWILEYtest/test/DeepDockABL1/parse_xml.py docking/$zinc_id.xml)
    printf '%s,%s\n' "${bind_energy}" "${zinc_id}"
done) > labels.txt

for zid in $(ls *.xml | cut -d. -f1); do
    grep $zid all.smiles | while read smiles zinc_id; do
        bind_energy=$(/usr/local/bin/python3.7 $PROJECTS/BWILEYtest/test/DeepDockABL1/parse_xml.py $zinc_id.xml)
        printf '%s,%s\n' "${bind_energy}" "${zinc_id}"
    done
done
printf "1795992598
1795992604
452867849
896466994
896466995
896466996
896470688"


python Deep-Docking-NonAutomated/phase_2-3/simple_job_models.py -n_it 1 -mdd /storage1/fs1/bolton/Active/projects/BWILEYtest/D2/morgan/fingerprint -time 00-04:00 -file_path /storage1/fs1/bolton/Active/projects/BWILEYtest/test/DeepDockABL1 -nhp 4 -titr 2 -n_mol 100 --percent_first_mols 0.01 -ct 0.9 --percent_last_mols 0.0001
# parser.add_argument('-isl','--is_last',required=False, action='store_true',help='True/False for is this last iteration')
python Deep-Docking-NonAutomated/phase_2-3/simple_job_models.py -n_it 10 -isl -mdd /storage1/fs1/bolton/Active/projects/BWILEYtest/D2/morgan/fingerprint -time 00-04:00 -file_path /storage1/fs1/bolton/Active/projects/BWILEYtest/test/DeepDockABL1 -nhp 4 -titr 11 --percent_first_mols 0.01 -ct 0.9 --percent_last_mols 0.001
for script in $(ls test/DeepDockABL1/iteration_10/simple_job/*.sh); do echo $script; chmod u+x /storage1/fs1/bolton/Active/projects/BWILEYtest $script; $script; echo; done


python Deep-Docking-NonAutomated/phase_2-3/hyperparameter_result_evaluation.py -n_it 10 --data_path /storage1/fs1/bolton/Active/projects/BWILEYtest/test/DeepDockABL1 -mdd /storage1/fs1/bolton/Active/projects/BWILEYtest/D2/morgan/fingerprint -n_mol 5000
python Deep-Docking-NonAutomated/phase_2-3/simple_job_predictions.py -protein DeepDockABL1 -file_path /storage1/fs1/bolton/Active/projects/BWILEYtest/test/DeepDockABL1 -n_it 10 -mdd /storage1/fs1/bolton/Active/projects/BWILEYtest/D2/morgan/fingerprint

for i in 9 10 11; do chmod u+x test/DeepDockABL1/iteration_10/simple_job_predictions/simple_job_${i}.sh; bsub -n4 -oo test/DeepDockABL1/iteration_10/simple_job_predictions/simple_job_${i}.log -G compute-bolton -g /bwileytest -q general -M 96G -R "gpuhost rusage[mem=96GB]" -gpu "num=1:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/deepdock:tf2.0)" test/DeepDockABL1/iteration_10/simple_job_predictions/simple_job_${i}.sh; done

bsub -n8 -oo finalDD4.log -G compute-bolton -g /bwileytest -q general -M 224G -R "select[mem>224GB] rusage[mem=224GB]" -a "docker(kboltonlab/deepdock:tf2.0)" python Deep-Docking-NonAutomated/final_phase/final_extraction.py -smile_dir D2/smiles -prediction_dir test/DeepDockABL1/iteration_10/morgan_1024_predictions -processors 16 -mols_to_dock 5000



for file in $(ls *txt | tail -n+3); do
    echo $file
    (echo smiles zinc_id; grep -v ^smiles $file) > tmp && mv tmp $file
done


1527191914
1787496437
617204677
1407010313
1012870757
463863047
1115635709
583870403
1452385521
960736529

obabel -:"$smiles" -ocan | obabel -ismi -h --gen3d -osdf -O docking/$zinc_id.sdf



grep "0.0000    0.0000    0.0000" docking/*.sdf
for file in $(ls docking/*.sdf); do
    grep "0.0000    0.0000    0.0000" 

pythonsh /Users/brian/tools/AutoDock-Vina-1.2.3/example/autodock_scripts/prepare_flexreceptor.py -r 2hyy_G250E.noHets.fixed.pdbqt -s LEU248_GLU250_GLN252_ASP381_PHE382

id=822135435
for id in $(tail -n+2 pharmocophore/ligands.txt | awk '{print $2}'); do
    iteration=$(grep $id iteration_*/smile/*smile* | cut -d/ -f1)
    mkdir -p $iteration/docking/$id
    cp $iteration/docking/$id* $iteration/docking/$id
    pythonsh /opt/mgltools_x86_64Linux2_1.5.7/MGLToolsPckgs/AutoDockTools/Utilities24/process_VSResults.py -d $iteration/docking/$id -r protein.pdbqt -B
done
for id in $(tail -n+1 pharmocophore/ligands.txt | awk '{print $2}'); do
iteration=$(grep $id iteration_*/smile/*smile* | cut -d/ -f1)
h=$(grep -n 'BEGIN_RES LEU' $iteration/docking/$id/*_vs*.pdbqt | cut -d: -f1)
head -n $((h-1)) $iteration/docking/$id/*_vs*.pdbqt > $iteration/docking/$id/final.pdbqt
obabel -ipdbqt -opdb -h -O pharmocophore/ligands/$id.pdb $iteration/docking/$id/final.pdbqt
obabel -ipdbqt -osdf -h -O pharmocophore/ligands/$id.sdf $iteration/docking/$id/final.pdbqt
done

mol=dasatinib
h=$(grep -n 'BEGIN_RES LEU' $mol/*_vs*.pdbqt | cut -d: -f1)
head -n $((h-1)) $mol/*_vs*.pdbqt > $mol/final.pdbqt
grep -v "USER  AD> [1-9]" $mol/final.pdbqt | grep -v 'USER  AD> protein' | grep -v "USER  AD> $mol" | obabel -ipdbqt -osdf -h -O $mol/$mol.sdf
obabel -ipdbqt -opdb -h -O $mol/$mol.pdb $mol/final.pdbqt
obabel -ipdbqt -osdf -h -O $mol/$mol.sdf $mol/$mol.pdb