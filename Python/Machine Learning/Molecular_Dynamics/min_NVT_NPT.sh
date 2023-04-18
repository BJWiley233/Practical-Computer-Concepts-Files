export PYTHONPATH="/storage1/fs1/jheld/Active/Brian_Wiley:$PYTHONPATH"
export PATH="$PATH:/opt/docs/enspara/bin:/usr/local/gromacs/bin"

vim ~/.bashrc
cd /storage1/fs1/jheld/Active/Brian_Wiley
bsub -n4 -oo gpu.log -G compute-jheld -g /jheldtest -q general -M 32G -R "gpuhost rusage[mem=32GB] span[hosts=1]" -gpu "num=1:gmodel=TeslaV100_SXM2_32GB:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gvendor=nvidia" -a "docker(kboltonlab/gromacs:gpu1.0)" /opt/docs/enspara/bin/python3.7 example-fast-script-clean_held.py

bsub -n4 -Is -G compute-jheld -g /jheldtest -q general-interactive -M 32G -R "gpuhost rusage[mem=32GB] span[hosts=1]" -gpu "num=1:gmodel=TeslaV100_SXM2_32GB:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gvendor=nvidia" -a "docker(kboltonlab/gromacs:gpu1.0)" /bin/bash 

cd /storage1/fs1/jheld/Active/Brian_Wiley
/opt/docs/enspara/bin/python3.7 example-fast-script-clean_held.py


# steep first
gmx grompp -f minim.steep.mdp -c /storage1/fs1/bolton/Active/projects/BWILEYtest/fast/Brian_Wiley/FASTPockets_Temp/gen0/kid0/start.gro -p /storage1/fs1/bolton/Active/projects/BWILEYtest/fast/Brian_Wiley/1ERK_T183E_T185E_2215328203/topol.top -o minim.steep.tpr -r /storage1/fs1/bolton/Active/projects/BWILEYtest/fast/Brian_Wiley/FASTPockets_Temp/gen0/kid0/start.gro -maxwarn 2
gmx mdrun -v -deffnm minim.steep

# then cg
gmx grompp -f minim.cg.mdp -c /storage1/fs1/bolton/Active/projects/BWILEYtest/fast/Brian_Wiley/FASTPockets_Temp/gen0/kid0/minim.steep.gro -p /storage1/fs1/bolton/Active/projects/BWILEYtest/fast/Brian_Wiley/1ERK_T183E_T185E_2215328203/topol.top -o minim.cg.tpr -r /storage1/fs1/bolton/Active/projects/BWILEYtest/fast/Brian_Wiley/FASTPockets_Temp/gen0/kid0/start.gro -maxwarn 2
gmx mdrun -v -deffnm minim.cg


gmx grompp -f nvt.mdp -c minim.cg.gro -r minim.cg.gro -p /storage1/fs1/bolton/Active/projects/BWILEYtest/fast/Brian_Wiley/1ERK_T183E_T185E_2215328203/topol.top -o nvt.tpr
gmx mdrun -deffnm nvt

gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p /storage1/fs1/bolton/Active/projects/BWILEYtest/fast/Brian_Wiley/1ERK_T183E_T185E_2215328203/topol.top -o npt.tpr
gmx mdrun -deffnm npt


gmx grompp -f /storage1/fs1/bolton/Active/projects/BWILEYtest/fast/Brian_Wiley/1ERK_T183E_T185E_2215328203/md2.mdp -c npt.gro -r npt.gro -t npt.cpt -p /storage1/fs1/bolton/Active/projects/BWILEYtest/fast/Brian_Wiley/1ERK_T183E_T185E_2215328203/topol.top -o md.tpr
gmx mdrun -deffnm md



