#!/bin/bash -l
#SBATCH --account=b1042
##SBTACH --account=b1171
#SBATCH --partition=genomics
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=8G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=fryxx094@umn.edu
#SBATCH --output=/home/jfp0082/slurm_out/%x.%j.out


bash run_pipeline.sh