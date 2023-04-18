#!/bin/bash
gen=$1
kid=$2
gro_path=$(grep gmx_mpi lsf_submission | tr " " "\n" | grep '.gro' | head -n1)
cp $gro_path .
gro=$(basename $gro_path)
export APBS=/opt/apbs/bin/apbs; export OMP_NUM_THREADS=128;
gmx grompp -f /storage1/fs1/jheld/Active/Jason/MDS/1ERK_WT_2214495508/Brian/md.mdp -c $gro -p $HOME/topol.top -o md -maxwarn 2 -r $gro -n /storage1/fs1/jheld/Active/Jason/MDS/1ERK_WT_2214495508/Brian/index.ndx
echo '19' | /opt/g_mmpbsa/bin/g_mmpbsa -f /storage1/fs1/jheld/Active/Jason/MDS/FASTPockets_WILEY_1ERK_183THP2_185TP2_dt004/msm/trajectories_full/trj_gen0${gen}_kid00${kid}.xtc -s md.tpr -n $3 -pol polar-FULL.xvg -mme -mm energy_MM-FULL.xvg -pbsa -apol apolar-FULL.xvg -i $PROJECTS/BWILEYtest/GROMACS/I_D_G250E/Comp/mmpbsa.mdp -incl_14 -nodiff -mmcon contrib_MM_CYS63.dat -pcon contrib_pol_CYS63.dat -apcon contrib_apol_CYS63.dat
