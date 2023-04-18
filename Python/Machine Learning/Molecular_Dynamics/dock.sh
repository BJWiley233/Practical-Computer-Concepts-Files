#/Volumes/bolton/Active/projects/BWILEYtest/chem430/labs/lab9/KRAS_pocket/Cpd1_scaffold
for dir in $(ls -d */); do
   dir=$(basename $dir)
   cd /Volumes/bolton/Active/projects/BWILEYtest/chem430/labs/lab9/KRAS_pocket/Cpd1_scaffold/$dir
   # echo prepare_ligand -l $dir.mol2 -o $dir.pdbqt -A bonds_hydrogens
   mk_prepare_ligand.py -i $dir.sdf -o $dir.pdbqt --add_index_map
done

cd /Volumes/bolton/Active/projects/BWILEYtest/chem430/labs/lab9/KRAS_pocket/Cpd1_scaffold/$molecule
prepare_ligand -l /Volumes/bolton/Active/projects/BWILEYtest/chem430/labs/lab9/KRAS_pocket/Cpd1_scaffold/$molecule/$molecule.mol2 -o /Volumes/bolton/Active/projects/BWILEYtest/chem430/labs/lab9/KRAS_pocket/Cpd1_scaffold/$molecule/$molecule.2.pdbqt -A bonds_hydrogens -U \""" -C

# chimera
select #0:QWB
measure center sel
(24.10, 1.54, -9.73)

gridBox 60 0.2 '24.10 1.54 -9.73' QWB.CoM.pdb
REMARK    CENTER (X Y Z)   24.100  1.5400  -9.7300

pdbfixer 7A1X.pdb --keep-heterogens none --output 7A1X.fixed.noHets2.pdb

# pdb2pqr30 --ff PARSE 7A1X.fixed.pdb 7A1X.fixed.pdbqt
grep -v HETATM 7A1X.fixed.pdb > 7A1X.fixed.noHets.pdb
# prepare_receptor -r 7A1X.fixed.pdb -o 7A1X.fixed.pdbqt
prepare_receptor -r 7A1X.fixed.noHets.pdb -o 7A1X.fixed.noHets.pdbqt
prepare_receptor -r 7A1X.fixed.noHets.pdb -A checkhydrogens -o 7A1X.fixed.noHets.addH.pdbqt
pythonsh /Users/brian/tools/AutoDock-Vina-1.2.3/example/autodock_scripts/prepare_flexreceptor.py -r 7A1X.fixed.noHets.pdbqt -s LYS5_GLU37_ASP54
/opt/Vina-GPU/Vina-GPU --flex 7A1X.fixed_flex.pdbqt --receptor 7A1X.fixed_rigid.pdbqt --config config.txt --ligand ../KRAS_pocket/Cpd1_scaffold/ZINC000605857744/ZINC000605857744.pdbqt --num_modes 1000 --out ../KRAS_pocket/Cpd1_scaffold/ZINC000605857744/ZINC000605857744_KRAS.pdbqt

bsub -n8 -oo gpu.log -G compute-bolton -g /bwileytest -q general -M 392G -R "gpuhost rusage[mem=392GB] span[hosts=1]" -gpu "num=1:gmodel=TeslaV100_SXM2_32GB" -a "docker(kboltonlab/vina:gpu)" /opt/Vina-GPU/Vina-GPU --flex 7A1X.fixed_flex.pdbqt --receptor 7A1X.fixed_rigid.pdbqt --config config.txt --ligand ../KRAS_pocket/Cpd1_scaffold/ZINC000605857744/ZINC000605857744.pdbqt --out ../KRAS_pocket/Cpd1_scaffold/ZINC000605857744/ZINC000605857744_KRAS.pdbqt

/opt/AutoDock-Vina/build/linux/release/vina --flex 7A1X.fixed.noHets_flex.pdbqt --receptor 7A1X.fixed.noHets_rigid.pdbqt --config config.txt --ligand ../KRAS_pocket/Cpd1_scaffold/ZINC000605857744/ZINC000605857744.pdbqt --out ../KRAS_pocket/Cpd1_scaffold/ZINC000605857744/results/out.pdbqt --exhaustiveness 32 --num_modes 1000 --write_maps ../KRAS_pocket/Cpd1_scaffold/ZINC000605857744/results/ZINC000605857744_map

for molecule in $(ls -d */ | head -n36); do
   molecule=$(basename $molecule)
   cd $PROJECTS/BWILEYtest/chem430/labs/lab9/KRAS_pocket/Cpd1_scaffold/$molecule
   mkdir -p results2
/opt/AutoDock-Vina/build/linux/release/vina \
   --flex $PROJECTS/BWILEYtest/chem430/labs/lab9/Cpd1_scaffold/7A1X.fixed.noHets_flex.pdbqt \
   --receptor $PROJECTS/BWILEYtest/chem430/labs/lab9/Cpd1_scaffold/7A1X.fixed.noHets_rigid.pdbqt \
   --config $PROJECTS/BWILEYtest/chem430/labs/lab9/Cpd1_scaffold/config.txt \
   --ligand $PROJECTS/BWILEYtest/chem430/labs/lab9/KRAS_pocket/Cpd1_scaffold/$molecule/$molecule.pdbqt \
   --out $PROJECTS/BWILEYtest/chem430/labs/lab9/KRAS_pocket/Cpd1_scaffold/$molecule/results2/out.pdbqt \
   --exhaustiveness 32 --num_modes 1000 \
   --write_maps $PROJECTS/BWILEYtest/chem430/labs/lab9/KRAS_pocket/Cpd1_scaffold/$molecule/results2/${molecule}_map
done

vina \
   --flex /Volumes/bolton/Active/projects/BWILEYtest/chem430/labs/lab9/Cpd1_scaffold/7A1X.fixed.noHets_flex.pdbqt \
   --receptor /Volumes/bolton/Active/projects/BWILEYtest/chem430/labs/lab9/Cpd1_scaffold/7A1X.fixed.noHets_rigid.pdbqt \
   --config /Volumes/bolton/Active/projects/BWILEYtest/chem430/labs/lab9/Cpd1_scaffold/config.txt \
   --ligand /Volumes/bolton/Active/projects/BWILEYtest/chem430/labs/lab9/KRAS_pocket/Cpd1_scaffold/$molecule/$molecule.2.pdbqt \
   --out /Volumes/bolton/Active/projects/BWILEYtest/chem430/labs/lab9/KRAS_pocket/Cpd1_scaffold/$molecule/results2/out.pdbqt \
   --exhaustiveness 32 --num_modes 1000 \
   --write_maps /Volumes/bolton/Active/projects/BWILEYtest/chem430/labs/lab9/KRAS_pocket/Cpd1_scaffold/$molecule/results2/${molecule}_map


vina \
--flex /Users/brian/test/lab9/Cpd1_scaffold/7A1X.fixed.noHets_flex.pdbqt \
--receptor /Users/brian/test/lab9/Cpd1_scaffold/7A1X.fixed.noHets_rigid.pdbqt \
--config /Users/brian/test/lab9/Cpd1_scaffold/config.txt \
--ligand /Users/brian/test/lab9/KRAS_pocket/Cpd1_scaffold/$molecule/$molecule.pdbqt \
--out /Users/brian/test/lab9/KRAS_pocket/Cpd1_scaffold/$molecule/results2/out.pdbqt \
--exhaustiveness 32 --num_modes 1000 \
--write_maps /Users/brian/test/lab9/KRAS_pocket/Cpd1_scaffold/$molecule/results2/${molecule}_map

mk_copy_coords.py /Users/brian/test/lab9/KRAS_pocket/Cpd1_scaffold/ZINC000000293947/results2/out.best.test2.pdbqt -o vina_results.sdf

for dir in $(ls -d ../KRAS_pocket/Cpd1_scaffold/*/ | head -n36 | tail -n35); do
   dir=$(echo $dir | cut -d/ -f4)
   echo $dir
   mkdir -p ../KRAS_pocket/Cpd1_scaffold/$dir/results
   /opt/AutoDock-Vina/build/linux/release/vina --flex 7A1X.fixed.noHets_flex.pdbqt --receptor 7A1X.fixed.noHets_rigid.pdbqt --config config.txt --ligand ../KRAS_pocket/Cpd1_scaffold/$dir/$dir.pdbqt --out ../KRAS_pocket/Cpd1_scaffold/$dir/results/out.pdbqt --exhaustiveness 32 --num_modes 1000 --write_maps ../KRAS_pocket/Cpd1_scaffold/$dir/results/${dir}_map
done

molecule=ZINC000002605638
molecule=ZINC000000293947
molecule=ZINC000605857744
for molecule in $(ls -d */ | tail -n+2); do
   molecule=$(basename $molecule)
   cd $PROJECTS/BWILEYtest/chem430/labs/lab9/KRAS_pocket/Cpd1_scaffold/$molecule
   # get top structure and remove flex residues
   my_head=$(grep -n "ENDMDL" results2/out.pdbqt | head -n1 | cut -d: -f1)
   head -n$my_head results2/out.pdbqt > results2/out.best.pdbqt
   grep -v "LYS\|ASP\|GLU" results2/out.best.pdbqt > results2/out.best.ligand_only.pdbqt
   mk_copy_coords.py -o results2/$molecule.best_pose.sdf results2/out.best.ligand_only.pdbqt -i $molecule.sdf
   obabel -isdf -opdb -O results2/$molecule.best_pose.pdb results2/$molecule.best_pose.sdf
   obabel -ipdbqt -opdb -O results2/out.best.pdb results2/out.best.pdbqt

   (head -n55 $PROJECTS/BWILEYtest/chem430/labs/lab9/Cpd1_scaffold/7A1X.fixed.noHets_rigid.pdb; grep LYS results2/out.best.pdb; tail -n+56 $PROJECTS/BWILEYtest/chem430/labs/lab9/Cpd1_scaffold/7A1X.fixed.noHets_rigid.pdb | head -n280; grep GLU results2/out.best.pdb; tail -n+336 $PROJECTS/BWILEYtest/chem430/labs/lab9/Cpd1_scaffold/7A1X.fixed.noHets_rigid.pdb | head -n161; grep ASP results2/out.best.pdb; tail -n+497 $PROJECTS/BWILEYtest/chem430/labs/lab9/Cpd1_scaffold/7A1X.fixed.noHets_rigid.pdb | head -n1159; cat results2/$molecule.best_pose.pdb) > results2/pdb.fixer.in.pdb
   pdbfixer results2/pdb.fixer.in.pdb --output results2/pdb.fixer.out.pdb
done

   (head -n55 $PROJECTS/BWILEYtest/chem430/labs/lab9/Cpd1_scaffold/7A1X.fixed.noHets_rigid.pdb; grep LYS results2/out.best.pdb; tail -n+56 $PROJECTS/BWILEYtest/chem430/labs/lab9/Cpd1_scaffold/7A1X.fixed.noHets_rigid.pdb | head -n280; grep GLU results2/out.best.pdb; tail -n+336 $PROJECTS/BWILEYtest/chem430/labs/lab9/Cpd1_scaffold/7A1X.fixed.noHets_rigid.pdb | head -n161; grep ASP results2/out.best.pdb; tail -n+497 $PROJECTS/BWILEYtest/chem430/labs/lab9/Cpd1_scaffold/7A1X.fixed.noHets_rigid.pdb | head -n1159; cat results2/$molecule.best_pose.pdb) > results2/test.pdb

# conect=$(grep HETATM ../KRAS_pocket/Cpd1_scaffold/$molecule/results/pdb.fixer.out.pdb | head -n1 | awk '{print $2}')
# get last UNL atom or first LYS atom
# lin_num_LYS_conn=$(grep LYS results2/out.best.pdb | head -n1 | awk '{print $2}')
# lin_num_LYS_conn_act=$(grep -n "CONECT   $lin_num_LYS_conn" ../KRAS_pocket/Cpd1_scaffold/$molecule/results/out.best.pdb | cut -d: -f1 | head -n1)
# first_lin=$(egrep -n "CONECT\s+1" ../KRAS_pocket/Cpd1_scaffold/$molecule/results/out.best.pdb | cut -d: -f1 | head -n1)
# tail -n+$first_lin ../KRAS_pocket/Cpd1_scaffold/$molecule/results/out.best.pdb | head -n $(($lin_num_LYS_conn_act-$first_lin))


obabel -ipdbqt -opdb -h -O /Users/brian/test/lab9/KRAS_pocket/Cpd1_scaffold/ZINC000000293947/results2/out.best.test.pdb /Users/brian/test/lab9/KRAS_pocket/Cpd1_scaffold/ZINC000000293947/results2/out.best.test.pdbqt

obabel -ipdbqt -osdf -h -O /Users/brian/test/lab9/KRAS_pocket/Cpd1_scaffold/ZINC000000293947/results2/out.best.test.sdf /Users/brian/test/lab9/KRAS_pocket/Cpd1_scaffold/ZINC000000293947/results2/out.best.test.pdbqt
obabel -isdf -omol2 -h -O /Users/brian/test/lab9/KRAS_pocket/Cpd1_scaffold/ZINC000000293947/results2/out.best.test.mol2 /Users/brian/test/lab9/KRAS_pocket/Cpd1_scaffold/ZINC000000293947/results2/out.best.test.sdf

obabel -ipdb -osdf -h -O /Users/brian/test/lab9/KRAS_pocket/Cpd1_scaffold/ZINC000000293947/results2/out.best.test.sdf /Users/brian/test/lab9/KRAS_pocket/Cpd1_scaffold/ZINC000000293947/results2/out.best.test.pdb


obabel -ipdbqt -opdb -O ../KRAS_pocket/Cpd1_scaffold/$molecule/results/out.best.pdb -h ../KRAS_pocket/Cpd1_scaffold/$molecule/results/out.best.pdbqt
# get last UNL atom or first LYS atom
lin_num_LYS_conn=$(grep LYS ../KRAS_pocket/Cpd1_scaffold/$molecule/results/out.best.pdb | head -n1 | awk '{print $2}')
lin_num_LYS_conn_act=$(grep -n "CONECT   $lin_num_LYS_conn" ../KRAS_pocket/Cpd1_scaffold/$molecule/results/out.best.pdb | cut -d: -f1 | head -n1)
first_lin=$(egrep -n "CONECT\s+1" ../KRAS_pocket/Cpd1_scaffold/$molecule/results/out.best.pdb | cut -d: -f1 | head -n1)
tail -n+$first_lin ../KRAS_pocket/Cpd1_scaffold/$molecule/results/out.best.pdb | head -n $(($lin_num_LYS_conn_act-$first_lin))



(head -n55 7A1X.fixed.noHets_rigid.pdb; grep LYS ../KRAS_pocket/Cpd1_scaffold/$molecule/results/out.best.pdb; tail -n+56 7A1X.fixed.noHets_rigid.pdb | head -n289; grep GLU ../KRAS_pocket/Cpd1_scaffold/$molecule/results/out.best.pdb; tail -n+336 7A1X.fixed.noHets_rigid.pdb | head -n161; grep ASP ../KRAS_pocket/Cpd1_scaffold/$molecule/results/out.best.pdb; tail -n+497 7A1X.fixed.noHets_rigid.pdb | head -n1159; grep UNL ../KRAS_pocket/Cpd1_scaffold/$molecule/results/out.best.pdb;) > ../KRAS_pocket/Cpd1_scaffold/$molecule/results/pdb.fixer.in.pdb
pdbfixer ../KRAS_pocket/Cpd1_scaffold/$molecule/results/pdb.fixer.in.pdb --output ../KRAS_pocket/Cpd1_scaffold/$molecule/results/pdb.fixer.out.pdb
conect=$(grep HETATM ../KRAS_pocket/Cpd1_scaffold/$molecule/results/pdb.fixer.out.pdb | head -n1 | awk '{print $2}')

(cat ../KRAS_pocket/Cpd1_scaffold/$molecule/results/pdb.fixer.out.pdb; tail -n+$first_lin ../KRAS_pocket/Cpd1_scaffold/$molecule/results/out.best.pdb | head -n $(($lin_num_LYS_conn_act-$first_lin)) | CONECT /dev/stdin $(($conect-1))) > ../KRAS_pocket/Cpd1_scaffold/$molecule/results/pdb.fixer2.in.pdb
grep "HETATM\|CONECT" ../KRAS_pocket/Cpd1_scaffold/$molecule/results/pdb.fixer2.in.pdb > ../KRAS_pocket/Cpd1_scaffold/$molecule/results/$molecule.pdb

# pdbfixer ../KRAS_pocket/Cpd1_scaffold/$molecule/results/pdb.fixer2.in.pdb --output ../KRAS_pocket/Cpd1_scaffold/$molecule/results/pdb.fixer2.out.pdb


../KRAS_pocket/Cpd1_scaffold/ZINC000605857744/results/out.pdbqt


pythonsh $TOOLS/mgltools_1.5.7_MacOS-X/MGLToolsPckgs/AutoDockTools/Utilities24/process_VSResults.py -d ../KRAS_pocket/Cpd1_scaffold/ZINC000605857744/results -r 7A1X.fixed.pdbqt -B 

pythonsh /Users/brian/tools/AutoDock-Vina-1.2.3/example/autodock_scripts/prepare_flexreceptor.py -r Q00534_fill.BL00010001_ligand_conect.fixed.out.pdbqt -s LEU152_VAL101
pythonsh /Users/brian/tools/AutoDock-Vina-1.2.3/example/autodock_scripts/prepare_gpf.py -l trilaciclib.pdbqt -r Q00534_fill.BL00010001_ligand_conect.fixed.out_rigid.pdbqt -y -x Q00534_fill.BL00010001_ligand_conect.fixed.out_flex.pdbqt
vina --flex Q00534_fill.BL00010001_ligand_conect.fixed.out_flex.pdbqt --ligand trilaciclib.pdbqt --maps Q00534_fill --scoring vina --exhaustiveness 32 --out Q00534_fill_flex_trilaciclib_vina_out.pdbqt