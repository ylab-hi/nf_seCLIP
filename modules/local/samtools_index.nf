process SAMTOOLS_INDEX {
    tag "$sample"
    label 'process_low'

    container "https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/37/37998e74f9455bc772603426441a58036a4d4a6e236cc5c0b80aceab72738bf4/data"

    input:
    tuple val(sample), path(bam), val(condition)

    output:
    tuple val(sample), path(bam), path("${bam}.bai"), val(condition), emit: indexed_bam

    script:
    """
    samtools index -@ 2 ${bam}
    """

    stub:
    """
    touch ${bam}.bai
    """
}