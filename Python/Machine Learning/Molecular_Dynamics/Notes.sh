# E=1 V=1 R=0
grep restrain /storage1/fs1/bolton/Active/projects/BWILEYtest/Ribociclib_Bind/Comp/CompE1_V1_R0/Ribociclib_Bind_CompE1_V1_R0_compboxproddyn.key
restrain-position 2812,5179 5.0 2
restrain-groups 1 2 0.0 0 2

# E=0 V=* R=1
grep restrain /storage1/fs1/bolton/Active/projects/BWILEYtest/Ribociclib_Bind/Comp/CompE0_V0.95_R1/Ribociclib_Bind_CompE0_V0-95_R1_compboxproddyn.key
restrain-position 2812,5179 5.0 2
restrain-groups 1 2 10.0 0 2
# E=0 V=* R=1
grep restrain /storage1/fs1/bolton/Active/projects/BWILEYtest/Ribociclib_Bind/Comp/CompE0_V0.75_R1/Ribociclib_Bind_CompE0_V0-75_R1_compboxproddyn.key
restrain-position 2812,5179 5.0 2
restrain-groups 1 2 10.0 0 2

# E=* V=1 R=1
grep restrain /storage1/fs1/bolton/Active/projects/BWILEYtest/Ribociclib_Bind/Comp/CompE0.2_V1_R1/Ribociclib_Bind_CompE0-2_V1_R1_compboxproddyn.key
restrain-position 2812,5179 5.0 2
restrain-groups 1 2 10.0 0 2
# E=* V=1 R=1
grep restrain /storage1/fs1/bolton/Active/projects/BWILEYtest/Ribociclib_Bind/Comp/CompE0.4_V1_R1/Ribociclib_Bind_CompE0-4_V1_R1_compboxproddyn.key
restrain-position 2812,5179 5.0 2
restrain-groups 1 2 10.0 0 2


num=1:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gvendor=nvidia

bsub -Is -n8 -G compute-bolton -q general-interactive -M 32G -R "gpuhost rusage[mem=32GB]" -gpu "num=1:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gvendor=nvidia" -a "docker($POLTYPE_G)" /bin/bash psi4 1_5_Index_0_GrowFragment_0-opt-1_2-3-135.psi4 1_5_Index_0_GrowFragment_0-opt-1_2-3-135.log

python $POLRUN

bsub -oo gpu.log -G compute-bolton -q general -M 180G -R "gpuhost rusage[mem=180GB]" -gpu "num=1:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/gromacs:gpu1.0)" ./clusterer_submission2.sh

bsub -n4 -oo gpu.log -G compute-bolton -g /bwileytest -q general -M 48G -R "gpuhost rusage[mem=48GB]" -gpu "num=1:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker($POLTYPE_Gxtb)" python $POLRUN

bsub -n16 -oo cpu.log -G compute-bolton -g /bwileytest -q general -M 164G -R "select[mem>164GB] rusage[mem=164GB]" -a "docker($POLTYPE_Gxtb)" python $POLRUN
bsub -n4 -oo cpu.log -G compute-bolton -g /bwileytest -q general -M 10G -R "rusage[mem=10GB]" -a "docker(kboltonlab/poltype:gpu_xtb)" python /storage1/fs1/bolton/Active/projects/BWILEYtest/poltype2/PoltypeModules/poltype.py
bsub -n16 -Is -G compute-bolton -g /bwileytest -q general-interactive -M 160G -R "rusage[mem=160GB]" -a "docker($POLTYPE_Gxtb)" /bin/bash

https://www.cancer-research-network.com/breast-cancer/dovitinib-is-a-multi-targeted-tyrosine-kinase-inhibitor/2022-01-11/
bsub -n16 -oo gpu.log -G compute-bolton -g /bwileytest -q general -M 64G -R "gpuhost rusage[mem=64GB] span[hosts=1]" -gpu "num=1:gmodel=TeslaV100_SXM2_32GB" -a "docker($POLTYPE_Gxtb)" /opt/conda/envs/amoebamdpoltypetestfinal/bin/python $POLRUN

bsub -n16 -oo cpu.log -G compute-bolton -g /bwileytest -q general -M 524G -R "rusage[mem=524GB] span[hosts=1]" -a "docker($POLTYPE_G)" python $POLRUN
bsub -n8 -oo cpu.log -G compute-bolton -g /bwileytest -q general -M 120G -R "rusage[mem=120GB] span[hosts=1]" -a "docker($POLTYPE_Gxtb)" python $POLRUN
for dir in $(ls -d */ | tail -n+2); do
   echo $dir
   dir=$(basename $dir)
   cd /storage1/fs1/bolton/Active/projects/BWILEYtest/Trilaciclib_Bind/Solv/$dir
   ls -lt *.dyn *.arc
   bsub -n2 -oo dir.log -G compute-bolton -g /bwileytest -q general -M 16G -R "rusage[mem=16GB] span[hosts=1]" -a "docker(ubuntu)" tar czf $dir.tar.gz *.dyn *.arc
   #ls $dir.tar.gz
   #rm *.dyn *.arc
done
cd ../

/scratch1/fs1/bolton/brian/poltype2/PoltypeModules/poltype.py

head -n11 Alpelisib_Bind2_proddynamicsjobs.txt | while read line
head -n10 Bimiralisib_Bind_proddynamicsjobs.txt | while read line
# 995489 995490; 995503-5
grep "CompE0_V1_R1\|CompE0.6_V1_R1\|CompE0.7_V1_R1" Alpelisib_Bind2_proddynamicsjobs.txt | while read line 
cat Bimiralisib_Bind_proddynamicsjobs.txt | head -n13 | while read line
grep 2500000 Ribociclib_Bind_proddynamicsjobs.txt | grep -v CompE0_V0_R1 | while read line; do

cat Bimiralisib_Bind_proddynamicsjobs.txt 
grep -v Comp Trilaciclib_Bind_proddynamicsjobs.txt | tail -n+11 
for folder in $(cat Solv/solv.left); do
grep Comp Trilaciclib_Bind_proddynamicsjobs.txt | tail -n16 | while read line; do
grep CompE0_V0.45_R1 Bimiralisib_Bind_proddynamicsjobs.txt | sed 's/5000000/3809000/' | while read line; do
grep "CompE0_V0.52_R1\|CompE0_V0.56_R1\|CompE0_V0.58_R1\|CompE0_V0.62_R1\|CompE0_V0.64_R1\|CompE0_V0.67_R1\|CompE0_V0.6_R1\|CompE0_V0.7_R1" Trilaciclib_Bind_proddynamicsjobs.txt | while read line; do

# first 12 and last 26
tail -n+20 MD_proddynamicsjobs.txt | head -n7 | while read line; do
# cat ../solv.run.txt | while read line; do
  line=$(echo "$line" | cut -d= -f2 | sed 's/ --numproc//')
  chg_dir=$(echo "$line" | cut -d';' -f1) 
  $chg_dir
  mkdir -p outputs
  cp *.out* *.log *.bar outputs
  pwd
  ls *.arc *.dyn *.bar
  log=$(basename $(pwd))
  com=$(echo "$line" | cut -d';' -f2)
  # for bar must be capital BAR.log
  bsub -n4 -oo $log.log -G compute-timley -g /bwileytest -q general -M 16G -R "gpuhost rusage[mem=16GB]" -gpu "num=1:gmodel=TeslaV100_SXM2_32GB:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gvendor=nvidia" -a "docker($POLTYPE_Gxtb)" /bin/bash -c "$com"
done

for log in $(ls */*/*bar.log); do
  dir=$(echo $log | cut -d/ -f1,2)
  log_base=$(basename $log .bar.log)
  cd /storage1/fs1/bolton/Active/projects/BWILEYtest/pdbs/I_D_WT2/$dir
  echo $log_base
  ls $log_base.bar.log
  mv $log_base.bar.log $log_base.BAR.log
done

for dir in $(grep -v Dynamics ../solv.rerun.tsv); do
  printf "$dir\t"; grep "Dynamics Steps" $dir/*.out | tail -n1; printf "\n"
done
function ISGM {
    bsub -n${3} -Is -G compute-timley -g /bwileytest -q general-interactive -M ${2}G -R "gpuhost rusage[mem=${2}GB] span[hosts=1]" -gpu "num=1:gmodel=TeslaV100_SXM2_32GB:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gvendor=nvidia" -a "docker($1)" -m "compute1-exec-${4}.ris.wustl.edu" /bin/bash
}
grep "SolvE0.5_V1 " ../../MD_proddynamicsjobs.txt | sed 's/2500000/598000/'

for dir in SolvE0_V0 SolvE0_V0.45 SolvE0_V0.52 SolvE0_V0.8; do
  grep "$dir " ../MD_proddynamicsjobs.txt
done > ../solv.run.txt


for dir in $(ls | grep -v log); do
echo $dir
  bsub -n4 -oo $dir.log -G compute-timley -g /bwileytest -q general -M 4G  -a "docker(ubuntu)" /bin/bash -c "cd /storage1/fs1/bolton/Active/projects/BWILEYtest/pdbs/Bimiralisib_Bind/Comp/$dir && tar czf $dir.arc.tar.gz *.arc"
done
for dir in $(ls | grep -v log); do
echo $dir
  bsub -n4 -oo $dir.log -G compute-timley -g /bwileytest -q general -M 4G  -a "docker(ubuntu)" /bin/bash -c "cd /storage1/fs1/bolton/Active/projects/BWILEYtest/pdbs/Bimiralisib_Bind/Solv/$dir && tar czf $dir.arc.tar.gz *.arc"
done

done
bsub -n4 -oo CompE0_V0.62_R1.2.log -G compute-timley -g /bwileytest -q general -M 32G -R "gpuhost rusage[mem=32GB] span[hosts=1]" -gpu "num=1:gmodel=TeslaV100_SXM2_32GB:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gvendor=nvidia" -a "docker($POLTYPE_G)" /bin/bash -c "dynamic9 Bimiralisib_Bind_CompE0-8_V1_R1_compboxproddyn.arc -k Bimiralisib_Bind_CompE0-8_V1_R1_compboxproddyn.key 1000000 2 2 4 300 1  > Bimiralisib_Bind_CompE0.8_V1_R1.out"

kboltonlab/gromacs:gpu1.0 32

bsub -n4 -oo gpu.log -G compute-timley -g /bwileytest -q general -M 32G -R "gpuhost rusage[mem=32GB] span[hosts=1]" -gpu "num=1:gmodel=TeslaV100_SXM2_32GB:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gvendor=nvidia" -a "docker(kboltonlab/gromacs:gpu1.0)" /opt/docs/enspara/bin/python3.7 example-fast-script.py

grep "CompE0.9_V1_R1\|CompE0_V0.6_R1\|CompE0_V0.9_R1\|CompE1_V1_R0" Ribociclib_Bind_proddynamicsjobs.txt | sed 's/607000/2500000/' | while read line 
do
  line=$(echo "$line" | cut -d= -f2 | sed 's/ --numproc//')
  chg_dir=$(echo "$line" | cut -d';' -f1) 
  $chg_dir
  pwd
  ls *.arc *.dyn
  log=$(basename $(pwd))
  com=$(echo "$line" | cut -d';' -f2)
  bsub -n4 -oo $log.2.log -G compute-timley -g /bwileytest -q general -M 32G -R "gpuhost rusage[mem=32GB] span[hosts=1]" -gpu "num=1:gmodel=TeslaV100_SXM2_32GB:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gvendor=nvidia" -a "docker($POLTYPE_G)" /bin/bash -c "$com"
done


-gpu "num=1:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gvendor=nvidia"










grep CompE0.6 "Ribociclib_Bind_proddynamicsjobs.txt" > Ribociclib_Bind_proddynamicsjobs.CompE0.6.txt
grep CompE0.5 "Ribociclib_Bind_proddynamicsjobs.txt" > Ribociclib_Bind_proddynamicsjobs.CompE0.5.txt
grep "SolvE0_V0.9 " "Ribociclib_Bind_proddynamicsjobs.txt" > Ribociclib_Bind_proddynamicsjobs.SolvE0_V0.9.txt

while read -r line
do
  line=$(echo "$line" | cut -d= -f2 | sed 's/ --numproc//')
  chg_dir=$(echo "$line" | cut -d';' -f1) 
  $chg_dir
  log=$(basename $(pwd))
  com=$(echo "$line" | cut -d';' -f2)
  bsub -n4 -oo $log.log -G compute-timley -g /bwileytest -q general -M 196G -R "gpuhost rusage[mem=196GB] span[hosts=1]" -gpu "num=1:gmodel=TeslaV100_SXM2_32GB" -a "docker($POLTYPE_Gxtb)" /bin/bash -c "$com"
done < "Ribociclib_Bind_proddynamicsjobs.SolvE0_V0.9.txt"

while read -r line
do
  line=$(echo "$line" | cut -d= -f2 | sed 's/ --numproc//')
  chg_dir=$(echo "$line" | cut -d';' -f1) 
  $chg_dir
  ls $(pwd)/*.out
  log=$(basename $(pwd))
  com=$(echo "$line" | cut -d';' -f2)
  bsub -n4 -oo $log.log -G compute-timley -g /bwileytest -q general -M 196G -R "gpuhost rusage[mem=196GB] span[hosts=1]" -gpu "num=1:gmodel=TeslaV100_SXM2_32GB" -a "docker($POLTYPE_Gxtb)" /bin/bash -c "$com"
done < "gpu.jobs3"
cd ..

 (bjobs -o "JOBID:10 SUBMIT_TIME:13 USER:5 STAT:5 QUEUE:6 EXEC_HOST:20 JOB_NAME"  | cut -d' ' -f21 | grep -v ^$ | cut -d. -f1 | sed 's/-/./g'; cat run.ran) > temp && mv temp run.ran

(cat gpu.jobs2 | cut -d' ' -f6 | cut -d. -f1 | sed 's/-/./g'; cat run.ran) > run.ran2


grep -v -f run.ran2 Ribociclib_Bind_proddynamicsjobs.txt > gpu.jobs3

Rib bar
tail n+2 Ribociclib_Bind_barjobs.txt > test.bar
while read -r line
do
  line=$(echo "$line" | cut -d= -f2 | sed 's/ --numproc//')
  chg_dir=$(echo "$line" | cut -d';' -f1) 
  $chg_dir
  ls $(pwd)/*.out
  log=$(basename $(pwd))
  com=$(echo "$line" | cut -d';' -f2)
  bsub -n4 -oo $log.log -G compute-timley -g /bwileytest -q general -M 196G -R "gpuhost rusage[mem=196GB] span[hosts=1]" -gpu "num=1:gmodel=TeslaV100_SXM2_32GB" -a "docker($POLTYPE_G)" /bin/bash -c "$com"
done < test.bar
cd ../..








trilaciclib

head -n5 Trilaciclib_Bind_proddynamicsjobs.txt > gpu.jobs3
tail -n+6 Trilaciclib_Bind_proddynamicsjobs.txt | head > gpu.jobs2
tail -n+11 Trilaciclib_Bind_proddynamicsjobs.txt > gpu.jobs1
Trilaciclib_Bind_proddynamicsjobs.CompE0.8_V1_R1.txt
grep CompE0_V0.8_R1 Trilaciclib_Bind_proddynamicsjobs.txt

/bin/bash -c " bar9 1 /storage1/fs1/bolton/Active/projects/BWILEYtest/Trilaciclib_Bind/Comp/CompE0_V0.8_R1/Trilaciclib_Bind_CompE0_V0-8_R1_compboxproddyn.arc 300 /storage1/fs1/bolton/Active/projects/BWILEYtest/Trilaciclib_Bind/Comp/CompE0_V0.85_R1/Trilaciclib_Bind_CompE0_V0-85_R1_compboxproddyn.arc 300 N > Trilaciclib_Bind_CompE0_V0.85_R1CompE0_V0.8_R1BAR1.out"

while read -r line
do
  line=$(echo "$line" | cut -d= -f2 | sed 's/ --numproc//')
  chg_dir=$(echo "$line" | cut -d';' -f1) 
  $chg_dir
  ls $(pwd)/*.out
  log=$(basename $(pwd))
  com=$(echo "$line" | cut -d';' -f2)
  bsub -n4 -oo $log.log -G compute-timley -g /bwileytest -q general -M 196G -R "gpuhost rusage[mem=196GB] span[hosts=1]" -gpu "num=1:gmodel=TeslaV100_SXM2_32GB" -a "docker($POLTYPE_G)" /bin/bash -c "$com"
done < "gpu.jobs.final"
cd ../..
while read -r line
do
  line=$(echo "$line" | cut -d= -f2 | sed 's/ --numproc//')
  chg_dir=$(echo "$line" | cut -d';' -f1) 
  $chg_dir
  ls $(pwd)/*.out
  log=$(basename $(pwd))
  com=$(echo "$line" | cut -d';' -f2)
  bsub -n4 -oo $log.log -G compute-timley -g /bwileytest -q general -M 196G -R "gpuhost rusage[mem=196GB] span[hosts=1]" -gpu "num=1:gmodel=TeslaV100_SXM2_32GB" -a "docker($POLTYPE_G)" /bin/bash -c "$com"
done < "Trilaciclib_Bind_barjobs.txt"

grep -f rerun.bar.txt Trilaciclib_Bind_barjobs.txt > go.txt

while read -r line
do
  line=$(echo "$line" | cut -d= -f2 | sed 's/ --numproc//')
  com=$(echo "$line" | cut -d';' -f2)
  echo $com | cut -d' ' -f3,5 | tr ' ' '\n'
done < "go.txt"