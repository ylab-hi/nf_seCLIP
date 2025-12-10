process DEEPTOOLS_BW {
    tag "$sample"
    label 'process_low'

    container "https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/71/71cb8c54b8e03d4d8bb1b2b1b61c436940f30f0bf28b605c13e8165f17170056/data"

    publishDir "${params.outdir}/bigwig", mode: 'copy', pattern: "*.bw"

    input:
    tuple val(sample), path(bam), path(bai), val(condition)

    output:
    tuple val(sample), path("${sample}.bw"), val(condition), emit: bigwig

    script:
    """
    bamCoverage -b ${bam} -o ${sample}.bw \
        --binSize 10 \
        --normalizeUsing CPM \
        --numberOfProcessors ${task.cpus} \
        --effectiveGenomeSize 2913022398
    """

    stub:
    """
    touch ${sample}.bw 
    """
}