for dir in $(ls -d Comp*ligand*/ | head -n1); do
    dir=$(basename $dir)
    ls *$dir*
    #mv *$dir* $dir
done

for dir in $(ls -d Comp*ligand*/); do
    dir=$(basename $dir)
    mv $dir Solv
    #mv *$dir* $dir
done

for dir in $(ls -d CompE*/ | grep -v ligand | tail -n+2); do
    dir=$(basename $dir)
    ls md*$dir*
    mv md*$dir* $dir
done

for dir in $(ls -d CompE*/ | grep -v ligand); do
    dir=$(basename $dir)
    mv $dir Comp
done


for dir in $(ls -d */ | tail -n+6); do
for dir in $(ls -lt */*.xtc | tail -n+13 | head -n11 | awk '{print $10}' | cut -d/ -f1); do
    dir=$(basename $dir)
    echo $dir
    cd /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Ribociclib/Comp/$dir
    gmx check -f $(ls *.xtc | grep -v center) &> log
    step=$(grep 'Step' log | awk '{print $2}')
    if [[ $step -lt 5000 ]]; then
        echo RUNNING $dir
        sed 's/nstenergy               = 5000/nstenergy               = 1000/' md.$dir.mdp | sed 's/nstlog                  = 5000/nstlog                  = 1000/' | sed 's/nstxout-compressed      = 5000/nstxout-compressed      = 1000/' | sed 's/every 10.0 ps/every 2.0 ps/g' > tmp.mdp && mv tmp.mdp md.$dir.mdp
for dir in $(ls -lt */*.xvg | grep md.Comp | grep "Aug " | awk '{print $10}' | tail -n+2); do        
    bsub -n4 -oo $dir.log -G compute-bolton -g /bwileytest -q general -M 14G -R "rusage[mem=14GB] select[gpuhost]" -gpu "num=1:mode=shared:mps=no:j_exclusive=yes:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/mpi_gpu:thread2.0)" /bin/bash -c "gmx grompp -f md.$dir.mdp -c ../../npt.gro -t ../../npt.cpt -p ../../topol.top -n ../../index.ndx -o md.$dir.tpr && gmx mdrun -deffnm md.$dir -nb gpu -v -bonded gpu -pin on"
    sleep 200;
done
    gmx check -f md.$dir.xtc
gmx grompp -f md.$dir.mdp -c ../../nvt_300K.gro -t ../../nvt_300K.cpt -p ../../topol.top -n ../../index.ndx -o md.$dir.tpr && gmx mdrun -deffnm md.$dir -nb gpu -v -pin on -cpi state

    -m 'compute1-exec-201.ris.wustl.edu'

    bsub -n2 -oo $dir.log -G compute-bolton -g /bwileytest -q general -M 12G -R "rusage[mem=12GB] select[gpuhost]"  -gpu "num=1:mode=shared:mps=yes:j_exclusive=yes:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/mpi_gpu:thread2.0)" /bin/bash -c "top -bn1 > output.txt && cat output.txt; echo; echo; nvidia-smi; echo CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES; gmx mdrun -gpu_id 0 -deffnm md.$dir -ntmpi 2 -ntomp 6 -pme gpu -npme 1 -nb gpu -v -pin on -cpi state"

    /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Ribociclib/Comp/CompE0.2_V1

for dir in $(ls -d ); do
for dir in $(grep -v -f ran run); do
    dir=$(basename $dir)
    echo $dir
    cd /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Ribociclib/Solv/$dir
    gmx check -f $(ls *.xtc | grep -v center) &> log
    step=$(grep 'Step' log | awk '{print $2}')
    if [[ $step -lt 5000 ]]; then
        echo RUNNING $dir
        sed 's/nstenergy               = 5000/nstenergy               = 1000/' md.$dir.mdp | sed 's/nstlog                  = 5000/nstlog                  = 1000/' | sed 's/nstxout-compressed      = 5000/nstxout-compressed      = 1000/' | sed 's/every 10.0 ps/every 2.0 ps/g' > tmp.mdp && mv tmp.mdp md.$dir.mdp
        # gmx grompp -f md.$dir.mdp -c ../../npt.ligand.gro -t ../../npt.ligand.cpt -p ../../topol.ligand.top -n ../../index.ligand.ndx -o md.$dir.tpr &&
for dir in $(ls -lt CompE0.*_V1.ligand/*.xvg | tail -n+3 | awk '{print $10}' | cut -d/ -f1 | tail -n+2); do
for dir in $(ls -lt */*.xvg | grep -v old | grep -v "Sep " | awk '{print $10}' | cut -d/ -f1 | tail -n+2); do
echo $dir
cd /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Ribociclib/Solv/$dir
        bsub -n4 -oo $dir.log -G compute-bolton -g /bwileytest -q general -M 4G -R "rusage[mem=4GB] select[gpuhost]" -gpu "num=1:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/mpi_gpu:thread2.0)" /bin/bash -c "gmx grompp -f md.$dir.mdp -c ../../npt.ligand.gro -t ../../npt.ligand.cpt -p ../../topol.ligand.top -n ../../index.ligand.ndx -o md.$dir.tpr && gmx mdrun -deffnm md.$dir -nb gpu -v -pin on"
        sleep 60
done
gmx mdrun -deffnm md.$dir -ntmpi 2 -ntomp 6 -pme gpu -npme 1 -nb gpu -v -pin on -cpi state
for ligdir in $(ls -d */ | grep -v CompE0_V0.ligand | grep -v CompE0_V0.45.ligand); do
    ligdir=$(basename $ligdir);
    cd /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Ribociclib/Solv/$ligdir
    sed 's/tau_t                   = 0.1   0.1/tau_t                   = 1.0   1.0' md.$ligdir.mdp

CompE0_V0.62.ligand
ls: cannot access '*.xtc': No such file or directory
CompE0_V0.75.ligand
ls: cannot access '*.xtc': No such file or directory



bsub -n4 -oo 0.log -G compute-bolton -g /bwileytest -q general -M 8G -R "rusage[mem=8GB] select[gpuhost]" -gpu "num=1:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/mpi_gpu:thread1.0)" /bin/bash -c "gmx mdrun -deffnm md.0_0.45 -ntmpi 4 -ntomp 8 -npme 1 -nb gpu -v -pin on -cpi state"

bsub -n4 -oo zero.log -G compute-bolton -g /bwileytest -q general -M 8G -R "rusage[mem=8GB] select[gpuhost]" -gpu "num=1:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/mpi_gpu:thread1.0)" /bin/bash -c "gmx mdrun -deffnm md.0_0 -ntmpi 4 -ntomp 8 -npme 1 -nb gpu -v -pin on -cpi state"


for dir in $(ls -d */ | grep -v CompE0.2_V1.ligand | grep -v CompE0_V1.ligand | grep -v CompE0.1_V1.ligand); do 
    dir=$(basename $dir)
    cd /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Alpelisib/Solv/$dir
    # mkdir old 
    # cp md.$dir.* old
    #sed -i 's/= 50000/= 1000/g' md.$dir.mdp
    #gmx grompp -f md.$dir.mdp -c ../../npt_300K.Alpelisib.gro -r ../../npt_300K.Alpelisib.gro -t ../../npt_300K.Alpelisib.cpt -o md.$dir.tpr -p ../../Alpelisib.top -n ../../index.Alpelisib.ndx
    bsub -n2 -oo $dir.log -G compute-bolton -g /bwileytest -q general -M 4G -R "rusage[mem=4GB] select[gpuhost]" -gpu "num=1:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/mpi_gpu:thread2.0)" /bin/bash -c "gmx mdrun -deffnm md.$dir -nb gpu -v -pin on -cpi md.$dir.cpt"
    sleep 90
done

gmx grompp -f md.$dir.mdp -c ../../npt.ligand.gro -r ../../npt.ligand.gro -t ../../npt.ligand.cpt -o md.$dir.tpr -p ../../topol.ligand.top -n ../../index.ligand.ndx

gmx grompp -f npt.ligand.mdp -c nvt_300K.ligand.gro -r nvt_300K.ligand.gro -t nvt_300K.ligand.cpt -o npt.ligand.tpr -p topol.ligand.top -n index.ligand.ndx

bsub -n2 -oo $dir.log -G compute-bolton -g /bwileytest -q general -M 4G -R "rusage[mem=4GB] select[gpuhost]" -gpu "num=1:mode=shared:mps=no:j_exclusive=yes:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/mpi_gpu:thread2.0)" /bin/bash -c "gmx mdrun -deffnm md.$dir -nb gpu -v -pin on -cpi md.$dir.cpt"


for dir in $(ls -d /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Alpelisib/Solv/*/ | grep -v CompE0.2_V1.ligand | grep -v CompE0_V1.ligand | grep -v CompE0.1_V1.ligand | grep -v CompE0.3_V1.ligand | grep -v CompE0.4_V1.ligand | cut -d/ -f11); do 
    #dir=$(basename $dir)
    mkdir -p /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Ribociclib/Solv4/$dir
    cd /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Ribociclib/Solv4/$dir
    # mkdir old 
    # cp md.$dir.* old
    sed 's/= 50000/= 1000/g' /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Alpelisib/Solv/$dir/md.$dir.mdp | sed 's/1LT/6ZZ/g' | sed 's/= 1.6/= 1.75/g' > md.$dir.mdp
    gmx grompp -f md.$dir.mdp -c ../../npt.ligand.gro -r ../../npt.ligand.gro -t ../../npt.ligand.cpt -o md.$dir.tpr -p ../../topol.ligand.top -n ../../index_ligand.ndx
for dir in CompE0_V0.58.ligand CompE0_V0.6.ligand CompE0_V0.62.ligand CompE0_V0.64.ligand CompE0_V0.67.ligand CompE0_V0.7.ligand CompE0_V0.75.ligand CompE0_V0.8.ligand CompE0_V0.85.ligand CompE0_V0.9.ligand CompE0_V0.95.ligand CompE0_V0.ligand CompE1_V1.ligand; do
    cd /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Ribociclib/Solv4/$dir
    bsub -n2 -oo $dir.log -G compute-bolton -g /bwileytest -q general -M 4G -R "rusage[mem=4GB] select[gpuhost && hname!='compute1-exec-195.ris.wustl.edu' && hname!='compute1-exec-202.ris.wustl.edu' && hname!='compute1-exec-209.ris.wustl.edu' && hname!='compute1-exec-216.ris.wustl.edu'] " -gpu "num=1:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/mpi_gpu:thread2.0)" /bin/bash -c "gmx mdrun -deffnm md.$dir -nb gpu -v -pin on"
    echo
    sleep 120
done

195: 5
196: 1
200: 0 
201: 0
202: 3
203:

gmx grompp -f md.$dir.mdp -c ../../npt.gro -r ../../npt.gro -t ../../npt.cpt -o md.$dir.tpr -p ../../topol.top -n ../../index.ndx


gmx bar -f CompE0_V0.56/md.CompE0_V0.56.xvg CompE0_V0.52/md.CompE0_V0.52.xvg CompE0_V0.45/md.CompE0_V0.45.xvg CompE0_V0/md.CompE0_V0.xvg


873639	2*compute1-exec-208.	md.CompE0_V0.58.ligand
873654	2*compute1-exec-208.	md.CompE0_V0.6.ligand KILLED now 887509
873750	2*compute1-exec-208.	md.CompE0_V0.67.ligand KILLED
873798	2*compute1-exec-208.	md.CompE0_V0.85.ligand
866873	2*compute1-exec-203.	md.CompE0_V0.52.ligand KILLED
867001	2*compute1-exec-203.	md.CompE0_V0.85.ligand
867308	2*compute1-exec-203.	md.CompE0.8_V1.ligand
866861	2*compute1-exec-206.	md.CompE0_V0.45.ligand
866984	2*compute1-exec-206.	md.CompE0_V0.75.ligand
866880	2*compute1-exec-207.	md.CompE0_V0.56.ligand KILLED
866990	2*compute1-exec-207.	md.CompE0_V0.8.ligand KILLED
873720	2*compute1-exec-207.	md.CompE0_V0.64.ligand
873786	2*compute1-exec-207.	md.CompE0_V0.8.ligand
866834	2*compute1-exec-201.	md.CompE0.7_V1.ligand KILLED
866841	2*compute1-exec-201.	md.CompE0.8_V1.ligand KILLED
866853	2*compute1-exec-201.	md.CompE0.9_V1.ligand KILLED 
873766	2*compute1-exec-201.	md.CompE0_V0.7.ligand
873808	2*compute1-exec-201.	md.CompE0_V0.9.ligand
873844	2*compute1-exec-201.	md.CompE1_V1.ligand
867309	2*compute1-exec-204.	md.CompE0.9_V1.ligand KILLED
873695	2*compute1-exec-204.	md.CompE0_V0.62.ligand KILLED
873778	2*compute1-exec-204.	md.CompE0_V0.75.ligand
873820	2*compute1-exec-204.	md.CompE0_V0.95.ligand
867313	2*compute1-exec-195.	md.CompE0_V0.52.ligand
867312	2*compute1-exec-216.	md.CompE0_V0.45.ligand

867307	2*compute1-exec-214.	md.CompE0.7_V1.ligand
867314	2*compute1-exec-214.	md.CompE0_V0.56.ligand

for dir in CompE0_V0.67.ligand CompE0_V0.52.ligand CompE0_V0.56.ligand CompE0_V0.8.ligand CompE0.7_V1.ligand CompE0.8_V1.ligand CompE0.9_V1.ligand CompE0.9_V1.ligand CompE0_V0.62.ligand; do
for dir in CompE0_V0.8.ligand CompE0.8_V1.ligand CompE0_V0.6.ligand; do 
    cd /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Ribociclib/Solv4/$dir
    bsub -n4 -oo $dir.log -G compute-bolton -g /bwileytest -q general -M 16G -R "rusage[mem=16GB] select[gpuhost && hname!='compute1-exec-201.ris.wustl.edu' && hname!='compute1-exec-208.ris.wustl.edu' && hname!='compute1-exec-203.ris.wustl.edu' && hname!='compute1-exec-207.ris.wustl.edu' && hname!='compute1-exec-216.ris.wustl.edu' && hname!='compute1-exec-204.ris.wustl.edu' && hname!='compute1-exec-202.ris.wustl.edu' && hname!='compute1-exec-214.ris.wustl.edu'] " -gpu "num=1:mode=shared:mps=no:j_exclusive=yes:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/mpi_gpu:thread2.0)" /bin/bash -c "gmx mdrun -deffnm md.$dir -nb gpu -v -pin on -cpi md.$dir.cpt"
    echo
    sleep 220
done
bsub -n4 -oo $dir.log -G compute-bolton -g /bwileytest -q general -M 16G -R "rusage[mem=16GB] select[gpuhost && hname!='compute1-exec-203.ris.wustl.edu'] " -gpu "num=1:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/mpi_gpu:thread2.0)" /bin/bash -c "gmx mdrun -deffnm md.$dir -nb gpu -v -pin on -cpi md.$dir.cpt"