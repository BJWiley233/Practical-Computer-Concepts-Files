#!/bin/bash
gen=$1
kid=$2
my_string=$(cat gmx_ndx_input.txt | while read resi; do printf "r $resi | "; done)
my_string_HOH=$(cat gmx_ndx_HOH_input.txt | while read resi; do printf "r $resi | "; done)

gro_path=$(grep gmx_mpi lsf_submission | tr " " "\n" | grep '.gro' | head -n1)
cp $gro_path .
gro=$(basename $gro_path)
## 19 and 20 group if using gmx in kboltonlab/g_mmpbsa
echo -e "${my_string%??}\n${my_string_HOH%??}\nq\n" | gmx make_ndx -f $gro -o residues10angstromsCA63.H2O_30anstromsCA63.ndx

export APBS=/opt/apbs/bin/apbs; export OMP_NUM_THREADS=128;
gmx grompp -f /storage1/fs1/jheld/Active/Jason/MDS/1ERK_WT_2214495508/Brian/md.mdp -c $gro -p $HOME/topol_WT.top -o md -maxwarn 2 -r $gro -n /storage1/fs1/jheld/Active/Jason/MDS/1ERK_WT_2214495508/Brian/non_phosphorylated/index.ndx
echo '19 20' | /opt/g_mmpbsa/bin/g_mmpbsa -f /storage1/fs1/jheld/Active/Jason/MDS/FASTPockets_WILEY_1ERK_dt004/msm/trajectories_full/trj_gen0${gen}_kid00${kid}.xtc -s md.tpr -n residues10angstromsCA63.H2O_30anstromsCA63.ndx -pol polar.xvg -mme -mm energy_MM.xvg -pbsa -apol apolar.xvg -i $PROJECTS/BWILEYtest/GROMACS/I_D_G250E/Comp/mmpbsa.mdp -xvg xmgrace -pdie 2 -decomp
