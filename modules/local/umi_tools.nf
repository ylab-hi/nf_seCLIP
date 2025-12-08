process UMI_EXTRACT {
    tag "$sample"
   label 'process_single'

    container "https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/38/38136a834cc8aecb5a477640910df9472eb83e90118059bd1a0459aec685b731/data"


    input:
    tuple val(sample), path(read1), val(condition)

    output:
    tuple val(sample), path("${sample}_umi.fastq.gz"), val(condition), emit: extracted_ch
    path "${sample}_umi_tools.log", emit: log

    script:
    """
    umi_tools extract \
        --random-seed 1 \
        --bc-pattern NNNNNNNNNN \
        --stdin ${read1} \
        --stdout ${sample}_umi.fastq.gz \
        --log ${sample}_umi_tools.log
    """

    stub:
    """
    touch ${sample}_umi_tools.log
    touch ${sample}_umi.fastq.gz
    """
}