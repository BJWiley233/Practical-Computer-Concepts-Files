# Set the AlphaFold base directory
export ALPHAFOLD_BASE_DIR=/app/alphafold

# Use the scratch file system for temp space
export SCRATCH1=/scratch1/fs1/bolton

# Use your Active storage for input and output data
export STORAGE1=/storage1/fs1/bolton/Active

# Mount scratch, Active storage, home directory and AlphaFold database reference files
export LSF_DOCKER_VOLUMES="/scratch1/fs1/ris/references/alphafold_db:/scratch1/fs1/ris/references/alphafold_db $LSF_DOCKER_VOLUMES"

# Update $PATH with folders containing AlphaFold, CUDA, and conda executables
export PATH="/usr/local/cuda/bin/:/opt/conda/bin:/app/alphafold:$PATH"

# Use the debug flag when trying to figure out why your job failed to launch on the cluster
#export LSF_DOCKER_RUN_LOGLEVEL=DEBUG



bsub -Is -g /bwileytest -q general-interactive -G compute-bolton -n 8 -M 64GB -R "gpuhost rusage[mem=64GB] span[hosts=1]" -gpu 'num=1:gmodel=TeslaV100_SXM2_32GB:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gvendor=nvidia' -a "docker(gcr.io/ris-registry-shared/alphafold:2.2.0)" /bin/bash

python3 /app/alphafold/run_alphafold.py --output_dir ASXL1 --model_preset monomer --fasta_paths asxl1_646fs.fasta --max_template_date 2021-08-18 --db_preset reduced_dbs --use_gpu_relax
python3 /app/alphafold/run_alphafold.py --output_dir alphafold --model_preset monomer --fasta_paths RAF_gap.fasta --max_template_date 2001-08-18 --use_gpu_relax
bsub -oo BTK2.2.log -g /bwileytest -q general -G compute-bolton -n 8 -M 64GB -R "gpuhost rusage[mem=64GB] span[hosts=1]" -gpu 'num=1:gmodel=TeslaV100_SXM2_32GB:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gvendor=nvidia' -a "docker(gcr.io/ris-registry-shared/alphafold:2.2.0)" /bin/bash -c  "export MAX_CPUS=32; python3 /app/alphafold/run_alphafold.py --output_dir BTK2 --model_preset monomer --fasta_paths Q06187.fasta --max_template_date 2001-08-18 --use_gpu_relax --uniclust30_database_path /storage1/fs1/bolton/Active/projects_brian/BWILEYtest/RosettaFold/RoseTTAFold/UniRef30_2020_06/UniRef30_2020_06 --pdb70_database_path /storage1/fs1/bolton/Active/projects_brian/BWILEYtest/RosettaFold/RoseTTAFold/pdb100_2021Mar03/pdb100_2021Mar03"

bsub -q general -n 8 -M 8GB -R "gpuhost rusage[mem=8GB] span[hosts=1]" -gpu 'num=1' -a "docker(gcr.io/ris-registry-shared/alphafold:2.2.0)" python3 /app/alphafold/run_alphafold.py --output_dir /path/to/output/folder --model_preset monomer --fasta_paths /path/to/input/protein_sequence.fa --max_template_date 2021-08-18 --db_preset reduced_dbs


bsub -oo long.log -g /bwileytest -q general -G compute-bolton -n 4 -M 16GB -R "gpuhost rusage[mem=16GB] span[hosts=1]" -gpu 'num=1:gmodel=TeslaV100_SXM2_32GB:mode=shared:mps=no:j_exclusive=no:gmem=2048.00:gvendor=nvidia' -a "docker($GROMACS)" gmx mdrun -cpi state -g md -s md -o md -c after_md -v -x frame0 -nb gpu -pin auto