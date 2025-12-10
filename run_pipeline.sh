module load nextflow/25.04.0

nextflow run main.nf \
    -resume \
    --input samplesheet.csv \
    --star_index_repeats /home/jfp0082/ylab/jfp0082/ref/star_index_trna_rrna \
    --star_index_genome /home/jfp0082/ylab/jfp0082/ref/star_index \
    --outdir results