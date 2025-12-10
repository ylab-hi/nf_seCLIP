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

process UMI_DEDUP {
    tag "$sample"
    cpus 1
    memory 32.GB
    time 16.h

    container "https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/38/38136a834cc8aecb5a477640910df9472eb83e90118059bd1a0459aec685b731/data"

    publishDir "${params.outdir}/dedup_bam", mode: 'copy', pattern: "*.bam"
    publishDir "${params.outdir}/dedup_stats", mode: 'copy', pattern: "*_stats_*"

    input:
    tuple val(sample), path(bam), path(bai), val(condition)

    output:
    tuple val(sample), path("${sample}.dedup.bam"), val(condition), emit: dedup_bam
    path "${sample}_dedup_stats_edit_distance.tsv", emit: stats_edit_distance
    path "${sample}_dedup_stats_per_umi_per_position.tsv", emit: stats_per_umi
    path "${sample}_dedup_stats_per_umi.tsv", emit: stats_umi

    script:
    """
    umi_tools dedup \
        --random-seed 1 \
        -I ${bam} \
        --method unique \
        --output-stats ${sample}_dedup_stats \
        -S ${sample}.dedup.bam
    """

    stub:
    """
    touch ${sample}.dedup.bam
    touch ${sample}_dedup_stats_edit_distance.tsv
    touch ${sample}_dedup_stats_per_umi_per_position.tsv
    touch ${sample}_dedup_stats_per_umi.tsv
    """
}

