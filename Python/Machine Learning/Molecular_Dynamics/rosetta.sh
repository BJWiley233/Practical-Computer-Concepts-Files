
score_jd2.static.linuxgccrelease -s 1QLY.pdb -out:suffix _1QLY_crystal @crystal_score_flags
ROSETTA_BIN=/opt/main/source/bin/
$ROSETTA_BIN/score_jd2.mpi.linuxgccrelease -s SH3_SH2.pdb_2 -out:suffix _SH3_SH2_pred @crystal_score_flags_mpi_SH2_SH3
$ROSETTA_BIN/score_jd2.mpi.linuxgccrelease -s 7N5O.pdb -out:suffix _Kin @crystal_score_flags_mpi_Kin
score_jd2.static.linuxgccrelease -s SH3_SH2.pdb -out:suffix _SH3_SH2_pred @crystal_score_flags_mpi_SH2_SH3

-nstruct 2
-relax:default_repeats 5
-out:path:pdb final_out/SH3_SH2
-out:path:score final_out/SH3_SH2
-overwrite
-jd2:failed_job_exception false
-mpi_tracer_to_file tracer.log


relax.static.linuxgccrelease -s 1QLY.pdb -out:suffix _1QLY_relaxed @general_relax_flags
relax.static.linuxgccrelease -s ${pdb}_m1_noOverlap2.pdb -out:suffix _1QLY_m1_noOverlap2_relaxed @general_relax_flags

mpirun --mca orte_base_help_aggregate 0 -np 8 $ROSETTA_BIN/relax.mpi.linuxgccrelease -s 7N5O_fixed.pdb -out:suffix _Kin @general_relax_flags_mpi_Kin
mpirun --mca orte_base_help_aggregate 0 -np 8 $ROSETTA_BIN/relax.mpi.linuxgccrelease -s SH3_SH2.pdb_2 -out:suffix _SH3_SH2_pred @general_relax_flags_mpi_SH2_SH3

 2GE9.pdb  6W07_nh.pdb
for pdb in 1QLY 2GE9; do
    echo $pdb - SCORE
    score_jd2.static.linuxgccrelease -s ${pdb}_m1_noOverlap2.pdb -out:suffix _${pdb}_crystal @crystal_score_flags
    echo $pdb - RELAX
    relax.static.linuxgccrelease -in:file:s ${pdb}_m1_noOverlap2.pdb -out:suffix _${pdb}_relaxed @flag_input_relax -overwrite --in:file:native ${pdb}_m1_noOverlap2.pdb
    echo
    echo
done

for pdb in 6W07_nh; do
    echo $pdb - SCORE
    score_jd2.static.linuxgccrelease -s ${pdb}_fixed.pdb -out:suffix _${pdb}_crystal @crystal_score_flags
    echo $pdb - RELAX
    relax.static.linuxgccrelease -s ${pdb}_fixed.pdb -out:suffix _${pdb}_relaxed @flag_input_relax --in:file:native ${pdb}_fixed.pdb
    echo
    echo
done

mpirun --mca orte_base_help_aggregate 0 -np 16 $ROSETTA_BIN/docking_prepack_protocol.mpi.linuxgccrelease @flag_ensemble_prepack_mpi_Kin


time docking_protocol.static.linuxgccrelease @flag_ensemble_docking -overwrite

docking_protocol.static.linuxgccrelease -l input_pdbs_low_struct.list @flag_local_refine

IS_B kboltonlab/rosetta
PBS_NTASKS=16
# PBS_NTASKS=2
ROSETTA_BIN=/opt/main/source/bin/
mpirun --mca orte_base_help_aggregate 0 -np $PBS_NTASKS $ROSETTA_BIN/docking_protocol.mpi.linuxgccrelease @flag_ensemble_docking_mpi
mpirun --mca orte_base_help_aggregate 0 -np 16 $ROSETTA_BIN/docking_protocol.mpi.linuxgccrelease @flag_ensemble_docking_mpi_Kin


docking_protocol.static.linuxgccrelease @flag_ensemble_docking_mpi_Kin


$ grep ATOM output_files/col_complex4_ensemble_dock_0499.pdb | sha256sum
cdbd400b58c06cec7238d9269897ed97ab2fd4d73bfd3c42a83c6ed60718b898  -
list=input_pdbs_low_struct.list
list=kin.list
mpirun --mca orte_base_help_aggregate 0 -np 32 $ROSETTA_BIN/docking_protocol.mpi.linuxgccrelease -l $list @flag_local_refine_mpi_Kin
$ grep ATOM output_files/col_complex4_ensemble_dock_0499.pdb | sha256sum

mpirun --mca orte_base_help_aggregate 0 -np $PBS_NTASKS $ROSETTA_BIN/energy_based_clustering.mpi.linuxgccrelease @flag_energy_based_clustering_mpi

energy_based_clustering.static.linuxgccrelease @flag_energy_based_clustering_mpi

-l refined.pdbs.list.txt
-in:file:fullatom
-cluster:energy_based_clustering:cluster_radius 1.0
-cluster:energy_based_clustering:limit_structures_per_cluster 10
-cluster:energy_based_clustering:cluster_by bb_cartesian
-cluster:energy_based_clustering:use_CB false
-cluster:energy_based_clustering:cyclic true
-cluster:energy_based_clustering:cluster_cyclic_permutations true
-out:path:all clustering
-out:suffix _local_refine_cluster

-overwrite
-jd2:failed_job_exception false
-mpi_tracer_to_file tracer_ebc.log


pdb_selchain -A,B 0057_local_refine_0001.pdb | pdb_chain -A | pdb_reres -1 > new.pdb

pdb_selchain -B 0057_local_refine_0001.pdb | pdb_chain -A | pdb_reres -216 > new_A.pdb
pdb_selchain -A 0057_local_refine_0001.pdb | pdb_chain -A | pdb_reres -270 > new_A2.pdb

cat new_A.pdb new_A2.pdb | grep -v 'VAL A 269' > BTK_SH3_SH2_model.pdb

pdb_selchain -A,B test_ensemble_dock_0535_local_refine_0001.pdb | pdb_chain -A | pdb_reres -1 > BTK_SH3_SH2_KIN_model.pdb
$ROSETTA_BIN/loopmodel.mpi.linuxgccrelease @flag_basic_KIC
bsub -n32 -oo loop.log -g /bwileytest -q general -G compute-bolton -n 10 -M 32GB -R "gpuhost rusage[mem=32GB] span[hosts=1]"  -a "docker($ROSE)" /bin/bash -c "mpirun --mca orte_base_help_aggregate 0 -np 32 $ROSETTA_BIN/loopmodel.mpi.linuxgccrelease @flag_basic_KIC_BTK -jd2:failed_job_exception false -mpi_tracer_to_file tracer_ebc.log"

2ge9 270-387 = 118 residues
ATOM      1  N   THR A   1      20.893  -6.987  -9.621  1.00  0.00           N
1qly 216 - 273 but only to 268, so missing 269 Valine
ATOM      1  N   LEU A   1      39.930  49.241 -36.658  1.00  0.00           N

/storage1/fs1/bolton/Active/projects_brian/BWILEYtest/Rosetta/rosetta.binary.ubuntu.release-334/main/tools

export ROSETTA3="/storage1/fs1/bolton/Active/projects_brian/BWILEYtest/Rosetta/rosetta.binary.ubuntu.release-334/main"
export ROSETTA3_DB="~/rosetta_workshop/rosetta/main/database"
export ROSETTA_TOOLS="~/rosetta_workshop/rosetta/tools"
export PATH="~/rosetta_workshop/rosetta/main/source/bin/:$PATH"

ROSETTA_BIN=/opt/main/source/bin
export ROSETTA3=/opt/main
export ROSETTA3_DB=/opt/main/database/
export ROSETTA_TOOLS=/opt/main/tools
export PATH="/opt/main/source/bin:$PATH"

$ROSETTA_BIN/antibody_graft.mpi.linuxgccrelease $ROSETTA_BIN/antibody.mpi.linuxgccrelease 
$ROSETTA_BIN/antibody.mpi.linuxgccrelease -fasta 4m5y_Fv.fasta \
mpirun --mca orte_base_help_aggregate 0 -np 16 \
    $ROSETTA_BIN/antibody.mpi.linuxgccrelease -fasta 4m5y_Fv.fasta \
    -antibody::grafting_database $ROSETTA3_DB/additional_protocol_data/antibody \
    -antibody::blastp /storage1/fs1/bolton/Active/projects_brian/BWILEYtest/ncbi-blast-2.13.0+/bin/blastp \
    -antibody::n_multi_templates 1 -antibody::exclude_pdbs 4m5y \
    -jd2:failed_job_exception false \
    -mpi_tracer_to_file tracer_ebc.log

mpirun --mca orte_base_help_aggregate 0 -np 16 \
    $ROSETTA_BIN/identify_cdr_clusters.mpi.linuxgccrelease \
    -s grafting/model-0.relaxed.pdb \
    -out:file:score_only output_files/north_clusters.log

bsub -oo anti.log -g /bwileytest -q general -G compute-bolton -n 10 -M 32GB -R "rusage[mem=32GB] span[hosts=1]"  -a "docker($ROSE)" /bin/bash -c "ROSETTA_BIN=/opt/main/source/bin; ROSETTA3=/opt/main; ROSETTA3_DB=/opt/main/database/; mpirun --mca orte_base_help_aggregate 0 -np 10 \
    $ROSETTA_BIN/antibody_H3.mpi.linuxgccrelease @input_files/abH3.flags \
    -s grafting/model-0.pdb -nstruct 10 -auto_generate_h3_kink_constraint \
    -h3_loop_csts_hr -out:file:scorefile H3_modeling_scores.fasc -out:path:pdb H3_modeling/ \
    -jd2:failed_job_exception false \
    -mpi_tracer_to_file tracer_ebc.log"
mpirun --mca orte_base_help_aggregate 0 -np 10 \
    $ROSETTA_BIN/antibody_H3.mpi.linuxgccrelease @input_files/abH3.flags \
    -s grafting/model-0.pdb -nstruct 10 -auto_generate_h3_kink_constraint \
    -h3_loop_csts_hr -out:file:scorefile H3_modeling_scores.fasc -out:path:pdb H3_modeling/ \
    -jd2:failed_job_exception false \
    -mpi_tracer_to_file tracer_ebc.log

cd /storage1/fs1/bolton/Active/projects_brian/BWILEYtest/Rosetta/RosettaAntibody/output_files
python2 ~/rosetta_workshop/rosetta/main/source/scripts/python/public/plot_VL_VH_orientational_coordinates/plot_LHOC.py
python /storage1/fs1/bolton/Active/projects_brian/BWILEYtest/Rosetta/rosetta.binary.ubuntu.release-334/main/source/scripts/python/public/plot_VL_VH_orientational_coordinates/plot_LHOC.py

Rosetta/main/source/scripts/python/public/plot_VL_VH_orientational_coordinates/
rosetta_path = os.path.join(os.path.abspath(__file__), "..", "..", "..", "..", "..", "..", "..")
rosetta.binary.ubuntu.release-334/main/source/scripts/python/public/plot_VL_VH_orientational_coordinates/constants.py

## post clustering
rm energies.txt
for refine in $(tail -n+3 output_files/score.fasc | awk '{print $28}' | tail -n+4); do
    pdbxyz -k tinker3.key output_files/$refine.pdb ALL
    /storage1/fs1/bolton/Active/projects_brian/BWILEYtest/tinker/bin-linux/analyze -k tinker3.key output_files/$refine.xyz E > tmp
    Intermolecular=$(grep Intermolecular tmp | awk '{print $4}')
    Potential=$(grep Potential tmp | awk '{print $5}')
    printf "$refine\t$Intermolecular\t$Potential\n" >> energies.txt
done

for file in $(ls *.pdb); do
    first=$(echo $file | cut -d. -f2)
    second=$(echo $file | cut -d. -f3)
    if [[ $second -eq 1 ]]; then
        #echo yes
        cluster=$(($first-51))
        #echo $cluster
    else
        #echo no
        cluster=$(echo "$first-50.5" | bc)
    fi
    lr=$(basename $(grep custom_string_valued_metric $file | awk '{print $3'}) .pdb)
    printf "%s\t$lr\t$file\n" $cluster
done > clusters.graph.sc