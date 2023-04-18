#!/bin/bash
gen=3
for kid in {0..9}; do
    cd $MDS/FASTPockets_WILEY_1ERK_183THP2_185TP2_dt004/gen${gen}/kid${kid}; 
    ls $MDS/FASTPockets_WILEY_1ERK_183THP2_185TP2_dt004/msm/trajectories_full/trj_gen00${gen}_kid00${kid}.xtc frame0.xtc; 
    # do it for the trjconv file
    bsub -oo get_groups_ndx.log -G compute-bolton -g /bwileytest -q general -M 4G -R "rusage[mem=4GB] " -a "docker($GROMACS)" /storage1/fs1/jheld/Active/Brian_Wiley/get_groups_ndx.sh 0${gen} $kid
done


gen=0 kid=0

#!/bin/bash
gen=$1
kid=$2
gro_path=$(grep gmx_mpi lsf_submission | tr " " "\n" | grep '.gro' | head -n1)
cp $gro_path .
gro=$(basename $gro_path)
export APBS=/opt/apbs/bin/apbs; export OMP_NUM_THREADS=128;
gmx grompp -f /storage1/fs1/jheld/Active/Jason/MDS/1ERK_WT_2214495508/Brian/md.mdp -c $gro -p $HOME/topol.top -o md -maxwarn 2 -r $gro -n /storage1/fs1/jheld/Active/Jason/MDS/1ERK_WT_2214495508/Brian/index.ndx
echo '19' | /opt/g_mmpbsa/bin/g_mmpbsa -f /storage1/fs1/jheld/Active/Jason/MDS/FASTPockets_WILEY_1ERK_183THP2_185TP2_dt004/msm/trajectories_full/trj_gen0${gen}_kid00${kid}.xtc -s md.tpr -n $MDS/FASTPockets_WILEY_1ERK_183THP2_185TP2_dt004/gen0/kid0/63.ndx -pol polar-FULL.xvg -mme -mm energy_MM-FULL.xvg -pbsa -apol apolar-FULL.xvg -i $PROJECTS/BWILEYtest/GROMACS/I_D_G250E/Comp/mmpbsa.mdp -incl_14 -nodiff -mmcon contrib_MM_CYS63.dat -pcon contrib_pol_CYS63.dat -apcon contrib_apol_CYS63.dat

gen=1
for gen in {26..29}; do
    for kid in {0..9}; do
        cd $MDS/FASTPockets_WILEY_1ERK_183THP2_185TP2_dt004/gen${gen}/kid${kid}; 
        bsub -n4 -oo g_mmpbsa.log -G compute-bolton -g /bwileytest -q general -M 4G -R "rusage[mem=4GB] " -a "docker(kboltonlab/g_mmpbsa)" /storage1/fs1/jheld/Active/Brian_Wiley/g_mmpbsa_CYS63.sh ${gen} $kid $HOME/test.ndx
    done
done
for gen in {26..29}; do
    for kid in {0..9}; do
        cd $MDS/FASTPockets_WILEY_1ERK_dt004/gen${gen}/kid${kid}; 
        bsub -n4 -oo g_mmpbsa.log -G compute-bolton -g /bwileytest -q general -M 4G -R "rusage[mem=4GB] " -a "docker(kboltonlab/g_mmpbsa)" /storage1/fs1/jheld/Active/Brian_Wiley/g_mmpbsa_CYS63_WT.sh ${gen} $kid $HOME/test_WT.ndx
    done
done

#!/bin/bash
export APBS=/opt/apbs/bin/apbs; export OMP_NUM_THREADS=128;
gmx grompp -f md.mdp -c start2.gro -p topol.top -o md -maxwarn 2 -r start2.gro -n index.ndx
echo '10' | /opt/g_mmpbsa/bin/g_mmpbsa -f centers.GMX.xtc -s md.tpr -n index.ndx -pol polar-FULL.xvg -mme -mm energy_MM-FULL.xvg -pbsa -apol apolar-FULL.xvg -i $PROJECTS/BWILEYtest/GROMACS/I_D_G250E/Comp/mmpbsa.mdp -incl_14 -nodiff -mmcon contrib_MM_CYS63.dat -pcon contrib_pol_CYS63.dat -apcon contrib_apol_CYS63.dat

cd 

gen=2
for kid in {0..9}; do
    cd $MDS/FASTPockets_WILEY_1ERK_dt004/gen${gen}/kid${kid}; 
    ls $MDS/FASTPockets_WILEY_1ERK_dt004/msm/trajectories_full/trj_gen00${gen}_kid00${kid}.xtc frame0.xtc; 
    # do it for the trjconv file
    bsub -oo get_groups_ndx.log -G compute-bolton -g /bwileytest -q general -M 4G -R "rusage[mem=4GB] " -a "docker($GROMACS)" /storage1/fs1/jheld/Active/Brian_Wiley/get_groups_ndx_WT.sh 0${gen} $kid
done

#CA
cp /storage1/fs1/jheld/Active/Jason/MDS/1ERK_WT_2214495508/Brian/index.ndx .
gro_path=$(grep gmx_mpi lsf_submission | tr " " "\n" | grep '.gro' | head -n1)
cp $gro_path .
gro=$(basename $gro_path)
grep CA $gro | grep -v 63CYS | awk '{print $3}' > CA.atoms.indicies.txt

#CA
i=2
cat CA.atoms.indicies.txt | awk '$2=999' | while read CA CA63; do
    if [[ $i -eq 63 ]]; then
        i=64
    fi
    echo "[ CA_${i}-CA_63 ]" 
    echo $CA $CA63
    i=$((i+1))
done > CA.distance.ndx

echo {0..355} | tr ' ' '\n' | gmx distance -n CA.distance.ndx -f frame0.xtc -s md.tpr -oav -oall > avg.CA.dist.txt
(paste <(grep CA_ avg.CA.dist.txt) <(grep Average avg.CA.dist.txt) | awk '$4 <= 1.0' | cut -d- -f1 | cut -d_ -f2; echo 63) > gmx_ndx_input.txt
#my_string=`cat gmx_ndx_input.txt | while read resi; do printf "r $resi | "; done`


#subset HOH
echo -e 'r 63\nq' | gmx make_ndx -f $gro -o 63CYS.ndx
gmx select -f frame0.xtc -s md.tpr -n 63CYS.ndx -select 'group 13 and same residue as within 1.0 of group 19' -on output.ndx
grep -v '\[' output.ndx | tr ' ' '\n' | grep -v ^$ | sort | uniq -c | sort -k1,1rn | awk '$1>=20' | awk '{print $2}' > test.HOH.atoms.indicies.txt
for idx in $(cat test.HOH.atoms.indicies.txt); do
    printf "$idx\t" 
    awk -v idx=$idx '$3==idx || $2=="O"idx || $2~"O"idx" " || $2=="H1"idx || $2~"H1"idx" " || $2=="H2"idx || $2~"H2"idx" " {gsub("[0-9]","",$2); print $1"_"$2}' $gro
done > test2.HOH.atoms.indicies.txt
npairs=$(wc -l test2.HOH.atoms.indicies.txt | awk '{print $1}')
cat test2.HOH.atoms.indicies.txt| while read idx label; do
    echo "[ ${label}-CA_63 ]" 
    echo $idx 999
done > HOH.distance.ndx
for ((i=0; i<npairs; i++)); do echo "$i"; done | gmx distance -n HOH.distance.ndx -f frame0.xtc -s md.tpr -oav -oall > avg.HOH_CYS63.dist.txt

(paste <(grep CA_63 avg.HOH_CYS63.dist.txt) <(grep Average avg.HOH_CYS63.dist.txt) | awk '$4 <= 3.0' | cut -d_ -f1 | sort | uniq | awk '{gsub("HOH","",$1); print}') > gmx_ndx_HOH_input.txt
#my_string_HOH=$(cat gmx_ndx_HOH_input.txt | while read resi; do printf "r $resi | "; done)

# make final index between CA groups and subset HOH groups
# echo -e "${my_string%??}\n${my_string_HOH%??}\nq\n" | gmx make_ndx -f $gro -o residues10angstromsCA63.H2O_30anstromsCA63.ndx

# call g_mmpbsa
# ugh need to make g_mmpbsa script
bsub -n32 -oo g_mmpbsa.log -G compute-bolton -g /bwileytest -q general -M 32G -R "rusage[mem=32GB] " -a "docker(kboltonlab/g_mmpbsa)" /storage1/fs1/jheld/Active/Brian_Wiley/g_mmpbsa.sh

#!/bin/bash
#my_string=$(cat gmx_ndx_input.txt | while read resi; do printf "r $resi | "; done)
#my_string_HOH=$(cat gmx_ndx_HOH_input.txt | while read resi; do printf "r $resi | "; done)

gro_path=$(grep gmx_mpi lsf_submission | tr " " "\n" | grep '.gro' | head -n1)
cp $gro_path .
gro=$(basename $gro_path)
## 26 and 27 group if using gmx in kboltonlab/g_mmpbsa
echo -e "${my_string%??}\n${my_string_HOH%??}\nq\n" | gmx make_ndx -f $gro -o residues10angstromsCA63.H2O_30anstromsCA63.ndx

export APBS=/opt/apbs/bin/apbs; export OMP_NUM_THREADS=128;
gmx grompp -f /storage1/fs1/jheld/Active/Jason/MDS/1ERK_WT_2214495508/Brian/md.mdp -c $gro -p $HOME/topol.top -o md -maxwarn 2 -r $gro -n /storage1/fs1/jheld/Active/Jason/MDS/1ERK_WT_2214495508/Brian/index.ndx
echo '26 27' | /opt/g_mmpbsa/bin/g_mmpbsa -f frame0.xtc -s md.tpr -n residues10angstromsCA63.H2O_30anstromsCA63.ndx -pol polar.xvg -mme -mm energy_MM.xvg -pbsa -apol apolar.xvg -i $PROJECTS/BWILEYtest/GROMACS/I_D_G250E/Comp/mmpbsa.mdp -xvg xmgrace -pdie 2 -decomp


i*<num columns>+<column number>
# polar: multiple groups, i.e. running g_mmpbsa with -diff
for i in {0..9}; do
    printf "\$$((i*4+2)),";
done
for i in {0..9}; do tail -n+25 kid${i}/polar.xvg > $i.polar.CA.txt; done
paste *.polar.CA.txt | awk '{print $2,$6,$10,$14,$18,$22,$26,$30,$34,$3}' > all_polar_CA.txt
awk '{sum = 0; for (i = 1; i <= NF; i++) sum += $i; sum /= NF; print sum}' all_polar_CA.txt > avg_polar_CA.txt

# polar: single group, i.e. running g_mmpbsa with -nodiff
for i in {0..9}; do
    printf "\$$((i*2+2)),";
done
for gen in {25..29}; do
    cd $MDS/FASTPockets_WILEY_1ERK_dt004/gen$gen
    for i in {0..9}; do tail -n+23 kid${i}/polar-FULL.xvg > $i.polar.CYS63.txt; done
    paste *.polar.CYS63.txt | awk '{print $2,$4,$6,$8,$10,$12,$14,$16,$18,$20}' > all_polar_CYS63.txt
    awk '{sum = 0; for (i = 1; i <= NF; i++) sum += $i; sum /= NF; print sum}' all_polar_CYS63.txt > avg_polar_CYS63.txt
done

energy_MM-FULL.xvg

## MM
# VdW Energy
for i in {0..9}; do
    printf "\$$((i*4+2)),";
done
for gen in {0..3}; do
cd $MDS/FASTPockets_WILEY_1ERK_dt004/gen$gen
    for i in {0..9}; do tail -n+25 kid${i}/energy_MM-FULL.xvg > $i.VDW.CYS63.txt; done
    paste *.VDW.CYS63.txt | awk '{print $2,$6,$10,$14,$18,$22,$26,$30,$34,$38}' > all_VDW_CYS63.txt
    awk '{sum = 0; for (i = 1; i <= NF; i++) sum += $i; sum /= NF; print sum}' all_VDW_CYS63.txt > avg_VDW_CYS63.txt
done
# Electrostatic
for i in {0..9}; do
    printf "\$$((i*4+3)),";
done
for gen in {0..3}; do
cd $MDS/FASTPockets_WILEY_1ERK_dt004/gen$gen
    for i in {0..9}; do tail -n+25 kid${i}/energy_MM-FULL.xvg > $i.Coul.CYS63.txt; done
    paste *.Coul.CYS63.txt | awk '{print $3,$7,$11,$15,$19,$23,$27,$31,$35,$39}' > all_Coul_CYS63.txt
    awk '{sum = 0; for (i = 1; i <= NF; i++) sum += $i; sum /= NF; print sum}' all_Coul_CYS63.txt > avg_Coul_CYS63.txt
done