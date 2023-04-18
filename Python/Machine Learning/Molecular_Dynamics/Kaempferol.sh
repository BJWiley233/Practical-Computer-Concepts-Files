/Users/brian/gromacs_tutorials/GROMACSPDB.sh CDK6_clean.pdb CDK6_clean.GMX.pdb CHARMM
/Users/brian/gromacs_tutorials/GROMACSPDB.sh CDK6_clean2.pdb CDK6_clean2.GMX.pdb CHARMM
gmx pdb2gmx -f CDK6_clean.GMX.pdb -o CDK6_clean.gro -water spce -ff charmm36 -vsite hydrogens
gmx pdb2gmx -f CDK6_clean2.GMX.pdb -o CDK6_clean2.gro -water spce -ff charmm36 -vsite hydrogens -p topol.protein.top # proteins only

cp CDK6_clean2.gro complex.gro 
atom_count=$(head -n2 complex.gro | tail -n1)
ligand_atom_count=$(head -n2 KAE.acpype/KAE_GMX.gro | tail -n1)
new_count=$(($atom_count+$ligand_atom_count))
(head -n $((2+$atom_count)) complex.gro; tail -n+3 KAE.acpype/KAE_GMX.gro | head -n $ligand_atom_count; tail -n1 complex.gro) | sed "s/$atom_count/$new_count/" > tmp && mv tmp complex.gro

gmx editconf -f CDK6_clean2.gro -o CDK6_clean.newbox.gro -bt dodecahedron -d 1.0 # proteins only
gmx editconf -f complex.gro -o newbox.gro -bt dodecahedron -d 1.0
gmx solvate -cp CDK6_clean.newbox.gro -cs spc216.gro -p topol.protein.top -o solv.protein.gro # proteins only
gmx solvate -cp newbox.gro -cs spc216.gro -p topol.top -o solv.gro

; https://www.researchgate.net/post/How_do_I_solve_this_error_in_GROMACS_invalid_order_for_the_directive_defaults
; /usr/local/gromacs/share/gromacs/top/oplsaa.ff/ffnonbonded.itp also has atomtypes
; q.prm files from ligpargen are not gromacs prm files, https://github.com/qusers/qligfep/blob/master/IO.py#L142
gmx make_ndx -f solv.gro -o index.ndx
gmx grompp -f ions.mdp -c solv.gro -p topol.top -o ions.tpr -n index.ndx
echo -e '0\nq\n' | gmx make_ndx -f solv.protein.gro -o index.protein.ndx # proteins only
gmx grompp -f ions.mdp -c solv.protein.gro -p topol.protein.top -o ions.protein.tpr -n index.protein.ndx # proteins only
gmx genion -conc 0.150 -s ions.tpr -o solv_ions.gro -p topol.top -pname NA -nname CL -neutral -n index.ndx 
gmx genion -s ions.protein.tpr -o solv_ions.protein.gro -p topol.protein.top -pname NA -nname CL -neutral -n index.protein.ndx # proteins only

gmx grompp -f em.mdp -c solv_ions.gro -r solv_ions.gro -p topol.top -o em.tpr -n index.ndx
gmx grompp -f em.protein.mdp -c solv_ions.protein.gro -r solv_ions.protein.gro -p topol.protein.top -o em.protein.tpr -n index.protein.ndx # proteins only
gmx mdrun -nb gpu -pin on -v -deffnm em.protein # proteins only
gmx grompp -f em.cg.protein.mdp -c em.protein.gro -r em.protein.gro -p topol.protein.top -o em.cg.protein.tpr -n index.protein.ndx # proteins only
gmx mdrun -nb gpu -pin on -v -deffnm em.cg.protein # proteins only
gmx grompp -f em.cg.mdp -c em.gro -r em.gro -p topol.top -o em.cg.tpr -n index.ndx
echo -e '0\nq\n' | gmx make_ndx -f em.cg.gro -o index.ndx

bsub -n4 -oo em.log -G compute-bolton -g /bwileytest -q general -M 32G -R "rusage[mem=32GB] select[gpuhost && hname!='compute1-exec-196.ris.wustl.edu']" -gpu "num=1:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/mpi_gpu:thread2.0)" /bin/bash -c "gmx mdrun -v -deffnm em -nb gpu"

gmx grompp -f nvt_50K.mdp -c em.cg.gro -r em.cg.gro -p topol.top -n index.ndx -o nvt_50K.tpr
gmx grompp -f nvt_50K.mdp -c ../../em.cg.gro -r ../../em.cg.gro -p ../../topol.top -n ../../index.ndx -o nvt_50K.tpr

gmx mdrun -nb gpu -pin on -v -deffnm nvt_50K

gmx grompp -f nvt_100K.mdp -c ../../nvt_50K.gro -r ../../nvt_50K.gro -p ../../topol.top -n ../../index.ndx -o nvt_100K.tpr
gmx mdrun -nb gpu -pin on -v -deffnm nvt_100K
gmx grompp -f nvt_200K.mdp -c nvt_100K.gro -r nvt_100K.gro -t nvt_100K.cpt -p topol.top -n index.ndx -o nvt_200K.tpr
gmx grompp -f nvt_200K.mdp -c nvt_100K.gro -r nvt_100K.gro -t nvt_100K.cpt -p ../../topol.top -n ../../index.ndx -o nvt_200K.tpr
gmx mdrun -nb gpu -pin on -v -deffnm nvt_200K


echo -e '0\nq\n' | gmx make_ndx -f em.cg.protein.gro -o index.protein.ndx # proteins only
gmx grompp -f nvt_300K.protein.mdp -c em.cg.protein.gro -r em.cg.protein.gro -p topol.protein.top -n index.protein.ndx -o nvt_300K.protein.tpr # proteins only
gmx grompp -f npt_300K.protein.mdp -c nvt_300K.protein.gro -r nvt_300K.protein.gro -t nvt_300K.protein.cpt -p topol.protein.top -n index.protein.ndx -o npt.protein.tpr -maxwarn 1 # proteins only
gmx mdrun -nb gpu -pin on -v -deffnm nvt_300K.protein # proteins only
gmx mdrun -nb gpu -pin on -v -deffnm npt.protein # proteins only
gmx grompp -f Prot${state}.mdp -c ../../npt.protein.gro -r ../../npt.protein.gro -t ../../npt.protein.cpt -o Prot${state}.tpr -p ../../topol.protein.top -n ../../index.protein.ndx  # proteins only
gmx grompp -f Prot${state}.mdp -c ../../../npt.protein.gro -r ../../../npt.protein.gro -t ../../../npt.protein.cpt -o Prot${state}.tpr -p ../../../topol.protein.top -n ../../../index.protein.ndx
gmx mdrun -nb gpu -pin on -v -deffnm Prot${state} -cpi Prot${state}.cpt # proteins only

gmx grompp -f npt_300K.mdp -c nvt_300K.gro -r nvt_300K.gro -t nvt_300K.cpt -p topol.top -n index.ndx -o npt_300K.tpr
gmx grompp -f npt_300K.mdp -c ../../nvt_300K.gro -r ../../nvt_300K.gro -t ../../nvt_300K.cpt -p ../../topol.top -n ../../index.ndx -o npt_300K.tpr
gmx mdrun -nb gpu -pin on -v -deffnm npt_300K
gmx grompp -f npt2_300K.mdp -c npt_300K.gro -r npt_300K.gro -t npt_300K.cpt -p topol.top -n index.ndx -o npt2_300K.tpr
gmx mdrun -nb gpu -pin on -v -deffnm npt2_300K

; Applying restraints to the ligand
gmx make_ndx -f solv_ions.gro -o crystal_water.ndx
gmx make_ndx -f ligpargen/Alpelisib.gmx.gro -o alpelisib.ndx
0 & ! a H* ; system and not atom H*
gmx genrestr -f solv_ions.gro -n crystal_water.ndx -o crystal_water.itp -fc 2000 2000 2000 ; group 3
gmx genrestr -f ligpargen/Alpelisib.gmx.gro -n alpelisib.ndx -o posre_alpelisib.itp -fc 1000 1000 1000

gmx grompp -f nvt_50K.mdp -c em..gro -r em.gro -p topol.top -n index.ndx -o nvt_50K.tpr
gmx mdrun -nb gpu -pin on -v -deffnm nvt_50K
gmx grompp -f nvt_100K.mdp -c nvt_50K.gro -t nvt_50K.cpt -r em.gro -p topol.top -n index.ndx -o nvt_100K.tpr
gmx mdrun -nb gpu -pin on -v -deffnm nvt_100K
;Location matters! You must put the call for posre_jz4.itp in the topology as indicated. The parameters within jz4.itp define a [ moleculetype ] directive for our ligand. The moleculetype ends with the inclusion of the water topology (tip3p.itp). Placing the call to posre_jz4.itp anywhere else will attempt to apply the position restraint parameters to the wrong moleculetype.

;The typical approach is to set tc-grps = Protein Non-Protein and carry on. Unfortunately, the "Non-Protein" group also encompasses JZ4. Since JZ4 and the protein are physically linked very tightly, it is best to consider them as a single entity. That is, JZ4 is grouped with the protein for the purposes of temperature coupling. In the same way, the few Cl- ions we inserted are considered part of the solvent.
echo -e "1 | 13\nq\nn" | gmx make_ndx -f em.cg.gro -o index.ndx

gmx grompp -f nvt_50K.mdp -c em.gro -r em.gro -p topol.top -n index.ndx -o nvt_50K.tpr ; 50 K
gmx mdrun -deffnm nvt_50K



;Ligand in water
gmx editconf -f KAE.acpype/KAE_GMX.gro -o Kaempferol.newbox.gro -bt cubic -d 1.0
gmx solvate -cp Kaempferol.newbox.gro -cs spc216.gro -p Kaempferol.top -o Kaempferol.solv.gro

gmx grompp -f ions.mdp -c Kaempferol.solv.gro -p Kaempferol.top -o Kaempferol.ions.tpr
gmx grompp -f ions.mdp -c b4ions.gro -p topol-noions.top -o after.ions.tpr
gmx genion -s Kaempferol.ions.tpr -o Kaempferol.solv_ions.gro -p Kaempferol.top -pname NA -nname CL -neutral

gmx grompp -f em.Kaempferol.mdp -c Kaempferol.solv_ions.gro -p Kaempferol.top -o em.KAE.tpr
gmx mdrun -v -deffnm em.KAE -nb gpu
gmx grompp -f em.cg.Kaempferol.mdp -c em.KAE.gro -p Kaempferol.top -o em.cg.KAE.tpr
gmx mdrun -v -deffnm em.cg.KAE 

gmx make_ndx -f em.cg.KAE.gro -o index.Kaempferol.ndx 
2 & ! a H* ; system and not atom H*
gmx genrestr -f KAE.acpype/KAE_GMX.gro -n index.Kaempferol.ndx -o posre_KAE.itp -fc 1000 1000 1000

; gmx grompp -f em.Alpelisib.mdp -c em.1LT.gro -p Alpelisib.top -o em.1LT.cg.tpr
; gmx mdrun -v -deffnm em.1LT.cg -nb gpu -ntmpi

gmx grompp -f nvt_50K.Kaempferol.mdp -c em.cg.KAE.gro -r em.cg.KAE.gro -p Kaempferol.top -n index.Kaempferol.ndx -o nvt_50K.Kaempferol.tpr
gmx mdrun -nb gpu -pin on -v -deffnm nvt_50K.Kaempferol

gmx grompp -f nvt_100K.Kaempferol.mdp -c nvt_50K.Kaempferol.gro -t nvt_50K.Kaempferol.cpt -r nvt_50K.Kaempferol.gro -p Kaempferol.top -n index.Kaempferol.ndx -o nvt_100K.Kaempferol.tpr
gmx mdrun -nb gpu -pin on -v -deffnm nvt_100K.Kaempferol

gmx grompp -f nvt_200K.Kaempferol.mdp -c nvt_100K.Kaempferol.gro -t nvt_100K.Kaempferol.cpt -r nvt_100K.Kaempferol.gro -p Kaempferol.top -n index.Kaempferol.ndx -o nvt_200K.Kaempferol.tpr

gmx grompp -f nvt_300K.Kaempferol.mdp -c nvt_200K.Kaempferol.gro -t nvt_200K.Kaempferol.cpt -r nvt_200K.Kaempferol.gro -p Kaempferol.top -n index.Kaempferol.ndx -o nvt_300K.Kaempferol.tpr

gmx grompp -f npt_300K.Kaempferol.mdp -c nvt_300K.Kaempferol.gro -t nvt_300K.Kaempferol.cpt -r nvt_300K.Kaempferol.gro -p Kaempferol.top -n index.Kaempferol.ndx -o npt_300K.Kaempferol.tpr

for state in $(tail -n+5 vdw_coul_states_folder.txt | awk '{print $4}'); do
    #mkdir -p Comp${state} 
    #sed 's/1LT/KAE/g' ../../Alpelisib/Comp/Comp${state}/md.Comp${state}.mdp | sed 's/= 1.7/= 1.2/g' | sed 's/= 1.5/= 1.2/g' | sed 's/= 0.002/= 0.0032/' | sed 's/lincs_iter              = 1/lincs_iter              = 2/' | sed 's/lincs_order             = 4/lincs_order             = 6/' | sed 's/h-bonds/h-bonds/' | sed 's/H20_Water_and_ions/Water_and_ions/' > Comp${state}/Comp${state}.mdp
    cd /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Kaempferol/Comp/Comp${state}
    gmx grompp -f Comp${state}.mdp -c ../../npt_300K.gro -r ../../npt_300K.gro -t ../../npt_300K.cpt -o Comp${state}.tpr -p ../../topol.top -n ../../index.ndx
    cd ..
done
gmx grompp -f comp.mdp -c ../../npt_300K.gro -r ../../npt_300K.gro -t ../../npt_300K.cpt -o comp.tpr -p ../../topol.top -n ../../index.ndx
for state in $(tail -n+4 vdw_coul_states_folder.txt | awk '{print $4}'); do
    cd /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Kaempferol/Comp/Comp${state}
    bsub -n4 -oo Compute.Comp${state}.log -G compute-bolton -g /bwileytest -q general -R "select[gpuhost] " -gpu "num=1:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/mpi_gpu:thread2.0)" /bin/bash -c "gmx mdrun -deffnm Comp${state} -nb gpu -v -pin on -cpi Comp${state}.cpt"
    sleep 120
done
bsub -n8 -oo Compute.Comp${state}.log -G compute-bolton -g /bwileytest -q general -M 8G -R "select[mem>16GB] rusage[mem=16GB]" -a "docker(kboltonlab/mpi_gpu:thread2.0)" /bin/bash -c "gmx mdrun -deffnm Comp${state} -v -pin on -cpi Comp${state}.cpt"

for vdw in 75 8 85 9; do 
state=E0_V0.$vdw
cd /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Kaempferol/Solv/Solv${state}
ls Solv${state}.cpt
bsub -n4 -oo Compute.Solv${state}.log -G compute-bolton -g /bwileytest -q general -M 8G -R "select[mem>8GB] rusage[mem=8GB]" -a "docker(kboltonlab/mpi_gpu:thread2.0)" /bin/bash -c "gmx mdrun -deffnm Solv${state} -v -pin on -ntmpi 1 -ntomp 8 -cpi Solv${state}.cpt"
done
bsub -n4 -oo Compute.Solv${state}.log -G compute-bolton -g /bwileytest -q general -R "select[gpuhost] " -gpu "num=1:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/mpi_gpu:thread2.0)" /bin/bash -c "gmx mdrun -deffnm Solv${state} -nb gpu -v -pin on -cpi Solv${state}.cpt"



tail -n+6 vdw_coul_states_folder.txt | head -n21 | awk '{print $3,$4}' | while read state folder; do
sed "s/init-lambda-state       = 0/init-lambda-state       = $state/" blank.mdp > Prot$folder/Prot$folder.mdp
cd /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Kaempferol/Prot/Prot$folder
gmx grompp -f Prot${folder}.mdp -c ../../npt.protein.gro -r ../../npt.protein.gro -t ../../npt.protein.cpt -o Prot${folder}.tpr -p ../../topol.protein.top -n ../../index.protein.ndx
gmx grompp -f Prot${folder}.mdp -c ../../npt.protein.gro -r ../../npt.protein.gro -t ../../npt.protein.cpt -o Prot${folder}.tpr -p ../../topol.protein.top -n index.protein.ndx 
gmx make_ndx -f ../../npt.protein.gro -o index.protein.ndx 
bsub -oo Compute.Prot${folder}.log -G compute-bolton -g /bwileytest -q general -M 8G -R "select[mem>8GB] rusage[mem=8GB]" -a "docker(kboltonlab/mpi_gpu:thread2.0)" /bin/bash -c "gmx mdrun -deffnm Prot${folder} -v -pin on -ntmpi 1 -ntomp 8"
cd ..
done
for esp in {3..9}; do
    state=E0.${esp}_V1
    cd /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Kaempferol/Prot/Prot$state
    ls
    echo
    echo
    bsub -n4 -oo Compute.Prot${state}.log -G compute-bolton -g /bwileytest -q general -M 4G -R "rusage[mem=4GB] select[gpuhost] " -gpu "num=1:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/mpi_gpu:thread2.0)" /bin/bash -c "gmx mdrun -deffnm Prot${state} -nb gpu -v -pin on -cpi Prot${state}.cpt"
    sleep 90
done




for state in $(tail -n+2 vdw_coul_states_folder.txt | awk '{print $4}' | head -n1); do
    #mkdir Solv${state} 
    sed 's/1LT/KAE/g' ../../Alpelisib/Solv/Comp${state}.ligand/md.Comp${state}.ligand.mdp | sed 's/= 1.6/= 1.2/g' | sed 's/= 0.002/= 0.004/' | sed 's/lincs_iter              = 1/lincs_iter              = 2/' | sed 's/lincs_order             = 4/lincs_order             = 6/' | sed 's/h-bonds/all-bonds/' > Solv${state}/Solv${state}.mdp
    cd /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Kaempferol/Solv/Solv${state}
    gmx grompp -f Solv${state}.mdp -c ../../npt_300K.Kaempferol.gro -r ../../npt_300K.Kaempferol.gro -t ../../npt_300K.Kaempferol.cpt -o Solv${state}.tpr -p ../../Kaempferol.top -n ../../index.Kaempferol.ndx
    gmx grompp -f Solv${state}.mdp -c npt_300K.KAE.gro -r npt_300K.KAE.gro -t npt_300K.KAE.cpt -o Solv${state}.tpr -p ../../Kaempferol.top -n ../../index.Kaempferol.ndx
done
#  && hname!='compute1-exec-195.ris.wustl.edu' && hname!='compute1-exec-202.ris.wustl.edu' && hname!='compute1-exec-209.ris.wustl.edu' && hname!='compute1-exec-216.ris.wustl.edu'
for state in $(tail -n+2 vdw_coul_states_folder.txt | awk '{print $4}' | tail -n+11); do
    cd /storage1/fs1/bolton/Active/projects/BWILEYtest/GROMACS/Kaempferol/Solv/Solv${state}
    bsub -n4 -oo Compute.Solv${state}.log -G compute-bolton -g /bwileytest -q general -M 4G -R "rusage[mem=4GB] select[gpuhost] " -gpu "num=1:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/mpi_gpu:thread2.0)" /bin/bash -c "gmx mdrun -deffnm Solv${state} -nb gpu -v -pin on"
    sleep 60
done

# pdbfixer and pdbqr test
GROMACSPDB /Users/brian/books/chem430/gromacs_tutorials/Ribociclib/test/6YZ4.fixed.pdb pdbfixer.gromacs.pdb
echo 18 | gmx pdb2gmx -f gtest.pdb -o pdbfixer_processed.gro -water spce


; TINKER 8.2.23 FREE ENERGY PERTURBATION KEYWORDS
CHG-LAMBDA DPL-LAMBDA LAMBDA LIGAND MPOLE-LAMBDA MUTATE POLAR-LAMBDA VDWANNIHILATE VDW-LAMBDA

; VDW-LAMBDA [real] 
Sets the value of the lambda scaling parameters for vdw interactions during
free energy calculations and similar. The real number modifier sets the position along path
from the initial state (lambda=0) to the final state (lambda=1). Alternatively, this parameter
can set the state of decoupling or annihilation for specified groups from none (lambda=1) to
complete (lambda=0). The groups involved in the scaling are given separately via LIGAND
or MUTATE keywords.

; GROMACs
vdw-lambdas
[array] Zero, one or more lambda values for which Delta H values will be determined and written to dhdl.xvg every nstdhdl steps. Values must be between 0 and 1. Only the van der Waals interactions are controlled with this component of the lambda vector.



; ELE-LAMBDA [real]
Sets the value of the lambda scaling parameters for electrostatic interactions during
free energy calculations and similar. The real number modifier sets the position along path
from the initial state (lambda=0) to the final state (lambda=1). Alternatively, this parameter
can set the state of decoupling or annihilation for specified groups from none (lambda=1) to
complete (lambda=0). The groups involved in the scaling are given separately via LIGAND
or MUTATE keywords.





; VDW-CUTOFF [real] 
Sets the cutoff distance value in Angstroms for van der Waals potential energy interactions. 
The energy for any pair of van der Waals sites beyond the cutoff distance
will be set to zero. Other keywords can be used to select a smoothing scheme near the cutoff
distance. The default cutoff distance in the absence of the VDW-CUTOFF keyword is infinite
for nonperiodic systems and 9.0 for periodic systems. (9.0 A = 0.9 nm)

ewald-cutoff 7
vdw-cutoff 12 ; 1.2 nm


fitted
pbc
gmx trjconv -f old/ProtE1_V1.xtc -s old/ProtE1_V1.tpr -pbc nojump -n index.protein.ndx -center -o pbc.center.xtc
gmx trjconv -f pbc.center.xtc -s old/ProtE1_V1.tpr -n index.protein.ndx -fit rot+trans -o fitted.xtc

gmx trjconv -f old/ProtE1_V1.xtc -s old/ProtE1_V1.tpr -n index.protein.ndx -pbc nojump -fit rot+trans -o test.xtc

gmx_MMPBSA -O -i mmpbsa.in -cs old/ProtE1_V1.tpr -ci index.protein.ndx -cg 18 19 -ct fitted.xtc -o FINAL_RESULTS_MMPBSA.dat -eo FINAL_RESULTS_MMPBSA.csv -cp ../../topol.protein.top


Solv
gmx trjconv -f SolvE1_V1.xtc -s SolvE1_V1.tpr -pbc mol -n ../../index.Kaempferol.ndx -center -o pbc.center.xtc
gmx trjconv -f pbc.center.xtc -s SolvE1_V1.tpr -n ../../index.Kaempferol.ndx -fit rot+trans -o fitted.xtc
gmx_MMPBSA -O -i mmpbsa.in -cs SolvE1_V1.tpr -ci ../../index.Kaempferol.ndx -cg 2 3 -ct fitted.xtc -o FINAL_RESULTS_MMPBSA.dat -eo FINAL_RESULTS_MMPBSA.csv -cp ../../Kaempferol.top


Comp
gmx trjconv -f CompE0.1_V1.xtc -s CompE0.1_V1.tpr -pbc mol -n ../../index.ndx -center -o pbc.center.xtc
gmx trjconv -f pbc.center.xtc -s CompE0.1_V1.tpr -n ../../index.ndx -fit rot+trans -o fitted.xtc
gmx_MMPBSA -O -i mmpbsa.in -cs CompE0.1_V1.tpr -ci ../../index.ndx -cg 1 19 -ct fitted.xtc -o FINAL_RESULTS_MMPBSA.dat -eo FINAL_RESULTS_MMPBSA.csv -cp ../../topol.top

-DGROMACS_INCLUDE_DIR=/usr/local/gromacs/include
cmake .. -DAPBS_INSTALL=/Volumes/APBS-1.4.2-osx-img/APBS.app/Contents/MacOS -DGROMACS_INCLUDE_DIR=/Users/brian/tools/gromacs-2022.2/src -DGMX_PATH=/usr/local/gromacs -DAPBS_LIB1=/Volumes/APBS-1.4.2-osx-img/APBS.app/Contents/Frameworks -DAPBS_LIB2=/Volumes/APBS-1.4.2-osx-img/APBS.app/Contents/Frameworks -DAPBS_SRC=$TOOLS/apbs-1.4.2/src -DAPBS_BLAS=/Volumes/APBS-1.4.2-osx-img/APBS.app/Contents/Frameworks -DMALOC=/Volumes/APBS-1.4.2-osx-img/APBS.app/Contents/Frameworks -DAPBSGEN=/Volumes/APBS-1.4.2-osx-img/APBS.app/Contents/Frameworks -DCMAKE_C_FLAGS="-I/Users/brian/Bolton/data/gromacs-2022.2/api/legacy/include -I/Users/brian/tools/gromacs-2022.2/src -I/usr/local/gromacs/include -I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include -L/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk/usr/lib -I/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk/usr/include/c++/v1/ -mmacosx-version-min=11.3" -DCMAKE_CXX_FLAGS="-I/Users/brian/Bolton/data/gromacs-2022.2/api/legacy/include -I/Users/brian/tools/gromacs-2022.2/src -I/usr/local/gromacs/include -I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include -L/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk/usr/lib -I/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk/usr/include/c++/v1/ -mmacosx-version-min=11.3 -stdlib=libc++" -DCMAKE_OSX_DEPLOYMENT_TARGET=11.6 -DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk

CC=clang XCC=clang++ CFLAGS="-I/Users/brian/Bolton/data/gromacs-2022.2/api/legacy/include -I/Users/brian/tools/gromacs-2022.2/src -I/usr/local/gromacs/include -L/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk/usr/lib -I/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk/usr/include/c++/v1/ -mmacosx-version-min=11.3" CPPFLAGS="-I/Users/brian/Bolton/data/gromacs-2022.2/api/legacy/include -I/Users/brian/tools/gromacs-2022.2/src -I/usr/local/gromacs/include -L/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk/usr/lib -I/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk/usr/include/c++/v1/ -mmacosx-version-min=11.3 -stdlib=libc++ -DUSE_STD_NAMESPACE" VERBOSE=2 make SHELL='sh -x'


bsub -n8 -oo g_mmpbsa.log -G compute-bolton -g /bwileytest -q general -M 32G -R "rusage[mem=32GB] " -a "docker(kboltonlab/g_mmpbsa)" /bin/bash -c "export APBS=/opt/apbs/bin/apbs; export OMP_NUM_THREADS=32; echo '1 13' | /opt/g_mmpbsa/bin/g_mmpbsa -f ../CompE1_V1.xtc -s ../CompE1_V1.tpr -n ../../../index.ndx -i mmpbsa.mdp -nomme -pbsa -decomp -pol polar.xvg -apol apolar.xvg"

gmx grompp -f em.cg.mdp -c em.gro -r em.gro -o em.cg.tpr -p topol.top -n index.ndx
gmx mdrun -v -nb gpu -deffnm em.cg
gmx grompp -f nvt_300K.mdp -c em.cg.gro -r em.cg.gro -o nvt_300K.tpr -p topol.top -n index.ndx
gmx mdrun -v -nb gpu -deffnm nvt_300K
gmx grompp -f CompE0_V0.mdp -c npt_300K.gro -r npt_300K.gro -t npt_300K.cpt -o CompE0_V0.tpr -p ../../topol.top -n ../../index.ndx
gmx mdrun -v -nb gpu -deffnm CompE0_V0

state=E0_V0
gmx grompp -f Solv$state.mdp -c npt_300K.KAE.gro -r npt_300K.KAE.gro -o Solv$state.tpr -p ../../Kaempferol.top -n ../../index.Kaempferol.ndx


bsub -n8 -oo g_mmpbsa.log -G compute-bolton -g /bwileytest -q general -M 32G -R "rusage[mem=32GB] " -a "docker(kboltonlab/g_mmpbsa)" /bin/bash -c "export APBS=/opt/apbs/bin/apbs; export OMP_NUM_THREADS=32; echo '1 13' | /opt/g_mmpbsa/bin/g_mmpbsa -f CompE0_V0.xtc -s CompE0_V0.tpr -n ../../index.ndx -i mmpbsa.mdp -nomme -pbsa -decomp -pol polar.xvg -apol apolar.xvg"

bsub -n16 -oo g_mmpbsa.log -G compute-bolton -g /bwileytest -q general -M 32G -R "rusage[mem=32GB] " -a "docker(kboltonlab/g_mmpbsa)" /bin/bash -c "export APBS=/opt/apbs/bin/apbs; export OMP_NUM_THREADS=64; echo '1 13' | /opt/g_mmpbsa/bin/g_mmpbsa -f last_half.xtc -s Comp${state}.tpr -n ../../index.ndx -i mmpbsa.mdp -nomme -pbsa -decomp -pol polar.xvg -apol apolar.xvg"

bsub -n16 -oo g_mmpbsa.log -G compute-bolton -g /bwileytest -q general -M 32G -R "rusage[mem=32GB] " -a "docker(kboltonlab/g_mmpbsa)" /bin/bash -c "export APBS=/opt/apbs/bin/apbs; export OMP_NUM_THREADS=64; echo '2 2' | /opt/g_mmpbsa/bin/g_mmpbsa -f last_half.xtc -s Solv$state.tpr -n ../../index.Kaempferol.ndx -i mmpbsa.mdp -nomme -pbsa -decomp -pol polar.xvg -apol apolar.xvg"
gmx check -f /Volumes/bolton/Active/projects/BWILEYtest/GROMACS/Kaempferol/Solv 

bsub -n16 -oo g_mmpbsa.log -G compute-bolton -g /bwileytest -q general -M 32G -R "rusage[mem=32GB] " -a "docker(kboltonlab/g_mmpbsa)" /bin/bash -c "export APBS=/opt/apbs/bin/apbs; export OMP_NUM_THREADS=64; echo '1 1' | /opt/g_mmpbsa/bin/g_mmpbsa -f last_half.xtc -s Prot${state}.tpr -n index.protein.ndx -i mmpbsa.mdp -nomme -pbsa -decomp -pol polar.xvg -apol apolar.xvg"

bsub -oo brian.log -G compute-bolton -g /bwileytest -q general -M 32G -R "rusage[mem=32GB] " -a "docker(kboltonlab/gromacs:gpu1.3)" /opt/docs/enspara/bin/python3.7 example-fast-script-clean_wiley_220914_TailoredToCHARMMGUI.py


gmx grompp -f Comp${state}.mdp -c ../../../npt_300K.gro -r ../../../npt_300K.gro -t ../../../npt_300K.cpt -o Comp${state}.tpr -p ../../../topol.top -n ../../../index.ndx 
gmx mdrun -nb gpu -v -s Comp${state}.tpr -rerun Comp${state}.xtc -e prot_or_KAE.edr

 -b 0 -e 40000
echo '0 24' | gmx trjconv -f CompE1_V1.xtc -o protein.xtc -s CompE1_V1.tpr -center -pbc mol -ur compact -n protein.ndx
echo '0 24' | gmx trjconv -f CompE1_V1.xtc -o protein.gro -s CompE1_V1.tpr -b 0 -e 1 -center -pbc mol -ur compact -n protein.ndx
gmx grompp -f Comp${state}.mdp -c protein.gro -o protein.tpr -p ../../../protein.test.top
gmx mdrun -v -s protein.tpr -rerun protein.xtc -e protein.edr
gmx energy -f protein.edr -s protein.tpr -o protein.xvg
gmx trjconv -f CompE1_V1.xtc -o complex.xtc -s CompE1_V1.tpr -center -pbc whole -ur compact -dt 10
gmx trjconv -f CompE1_V1.gro -o complex.gro -s CompE1_V1.tpr -center -pbc whole -ur compact

gmx make_ndx -f CompE1_V1.gro -o index.ndx
gmx trjconv -f CompE1_V1.xtc -o complex.xtc -s CompE1_V1.tpr -center -pbc mol -dt 100
gmx trjconv -f CompE1_V1.gro -o complex.pdb -s CompE1_V1.tpr -b 0 -e 2
gmx trjconv -f CompE0_V0.xtc -o complex.xtc -s CompE0_V0.tpr -center -pbc mol -dt 100

gmx trjconv -f ../step7_6.xtc -o step7_6.centered.xtc -s ../step7_6.tpr -center -pbc mol -dt 100 -n index.ndx
gmx trjconv -f ../step7_6.gro -o step7_6.centered.gro -s ../step7_6.tpr -center -pbc mol -n index.ndx
gmx trjconv -f ../step6.2_equilibration.xtc -o step6.2_equilibration.centered.xtc -s ../step6.2_equilibration.tpr -center -pbc mol -dt 100 -n index.ndx
gmx trjconv -f ../step6.2_equilibration.gro -o step6.2_equilibration.centered.gro -s ../step6.2_equilibration.tpr -center -pbc mol -n index.ndx
step6.2_equilibration.gro

gmx trjconv -f md.CompE0.1_V1.xtc -o complex.xtc -s md.CompE0.1_V1.tpr -center -pbc whole -ur compact -dt 100
gmx trjconv -f md.CompE0.1_V1.gro -o system.gro -s md.CompE0.1_V1.tpr -center -pbc whole -ur compact 

gmx energy -f ProtE1_V1.edr -s ProtE1_V1.tpr -o protein.xvg
gmx energy -f last_half.edr -s ProtE0_V0.tpr -o last_half.xvg


-b 5000 -e 10000z

gmx grompp -f UNC49.mdp -c step6.6_equilibration.gro -r step6.6_equilibration.gro -t ../step6.6_equilibration.cpt -o UNC49.tpr -p ../topol.top -n index.ndx
gmx mdrun -v -nb gpu -deffnm UNC49

state=E0_V0
gmx trjconv -f Comp${state}.xtc -o last_half.xtc -s Comp${state}.tpr -center -pbc mol -ur compact -b 5000 -e 10000 -dt 4
gmx trjconv -f Solv${state}.xtc -o last_half.xtc -s Solv${state}.tpr -center -pbc mol -ur compact -b 5000 -e 10000
gmx grompp -f ProtE1_V1.mdp -c ../../npt.protein.gro -r ../../npt.protein.gro -t ../../npt.protein.cpt -o ProtE1_V1.tpr -p ../../topol.protein.top -n index.protein.ndx 
gmx trjconv -f ProtE1_V1.xtc -o last_half.xtc -s ProtE1_V1.tpr -center -pbc mol -ur compact -b 5000 -e 10000
gmx trjconv -f Prot${state}.xtc -o last_half.xtc -s Prot${state}.tpr -center -pbc mol -ur compact -b 5000 -e 10000

gmx eneconv -f Prot${state}.edr -o last_half.edr -b 5000 -e 10000
gmx eneconv -f Comp${state}.edr -o last_half.edr -b 5000 -e 10000 -dt 4

N frames = nsteps * dt / dt * nstenergy
each frame in time = dt * number of steps (nstenergy) = 0.002 * 1000 = 2ps

total 10,000 ps and frame is 2 ps so 5000 steps

nsteps                  = 5000000     ; 2 * 500000 = 1000 ps = 1ns
dt                      = 0.002     ; 1 fs
; Output control
nstenergy               = 1000       ; save energies every 1000 steps
nstlog                  = 1000       ; update log file every 100.0 ps
nstxout-compressed      = 1000       ; save coordinates every 100.0 ps

With -dt you can specify the time difference between extracted frames in picoseconds, while -skip specifies it as difference between frame indices. So -dt 1000 extracts a frame every 1000 ps = 1 ns, and -skip 100 every 100 * timestep * nstxout ps. If you want every 10 ps, it’s simplest to use -dt 10.

