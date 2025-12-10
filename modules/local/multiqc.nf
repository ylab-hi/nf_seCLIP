process MULTIQC {
    label 'process_low'

    container "https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/8c/8c6c120d559d7ee04c7442b61ad7cf5a9e8970be5feefb37d68eeaa60c1034eb/data"

    publishDir "${params.outdir}/multiqc", mode: 'copy'

    input:
    path(fastqc_raw)
    path(fastqc_trimmed)
    path(cutadapt_1_logs)
    path(cutadapt_2_logs)
    path(umi_logs)
    path(star_repeats_logs)
    path(star_genome_logs)
    path(dedup_stats)

    output:
    path "multiqc_report.html", emit: html
    path "multiqc_report_data", emit: data

    script:
    """
    multiqc . \
        --title "eCLIP Pipeline Report" \
        --filename multiqc_report.html \
        --force
    """

    stub:
    """
    mkdir multiqc_report_data
    touch multiqc_report.html
    """
}