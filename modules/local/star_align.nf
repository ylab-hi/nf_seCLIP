process STAR_REPEATS {
    tag "$sample"

    container "https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/9b/9b8ecb2f9a77b5e7573ef6fae2f4c2e771064f7a129ed1329913c1025c33f365/data"

    publishDir "${params.outdir}/star_repeats/bam", mode: 'symlink', pattern: "*.bam"
    publishDir "${params.outdir}/star_repeats/logs", mode: 'copy', pattern: "*Log*"
    publishDir "${params.outdir}/star_repeats/unmapped", mode: 'symlink', pattern: "*Unmapped*"

    // because the reference is so small
    cpus 8
    memory 12.GB
    time 4.h


    input:
    tuple val(sample), path(read1), val(condition)
    path(star_index)

    output:
    tuple val(sample), path("${sample}Aligned.out.bam"), val(condition), emit: bam
    tuple val(sample), path("${sample}Unmapped.out.mate1"), val(condition), emit: unmapped_reads
    path "${sample}Log.final.out", emit: log_final
    path "${sample}Log.out", emit: log_out
    path "${sample}Log.progress.out", emit: log_progress

    script:
    """
    STAR \
        --runThreadN ${task.cpus} \
        --genomeDir ${star_index} \
        --outFileNamePrefix ${sample} \
        --outFilterMultimapNmax 30 \
        --outFilterMultimapScoreRange 1 \
        --outFilterScoreMin 10 \
        --outFilterType BySJout \
        --outReadsUnmapped Fastx \
        --outSAMattrRGline ID:${sample} \
        --outSAMattributes All \
        --outSAMmode Full \
        --outSAMtype BAM Unsorted \
        --outSAMunmapped Within \
        --outStd Log \
        --readFilesIn ${read1} \
        --readFilesCommand zcat \
        --runMode alignReads
    """

    stub:
    """
    touch ${sample}Aligned.out.bam
    touch ${sample}Unmapped.out.mate1
    touch ${sample}Log.final.out
    touch ${sample}Log.out
    touch ${sample}Log.progress.out
    touch ${sample}SJ.out.tab
    touch ${sample}Chimeric.out.junction
    """
}

process STAR_GENOME {
    tag "$sample"

    cpus 12
    memory 40.GB
    time 4.h

    // temporary remove caching
    // cache false

    container "https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/9b/9b8ecb2f9a77b5e7573ef6fae2f4c2e771064f7a129ed1329913c1025c33f365/data"

    publishDir "${params.outdir}/star_genome/bam", mode: 'copy', pattern: "*.bam"
    publishDir "${params.outdir}/star_genome/logs", mode: 'copy', pattern: "*Log*"



    input:
    tuple val(sample), path(unmapped_reads), val(condition)
    path(genome_index)

    output:
    tuple val(sample), path("${sample}.genome.Aligned.sortedByCoord.out.bam"), val(condition), emit: bam
    tuple val(sample), path("${sample}.genome.Unmapped.out.mate1"), val(condition), emit: unmapped_reads
    path "${sample}.genome.Log.final.out", emit: log_final
    path "${sample}.genome.Log.out", emit: log_out
    path "${sample}.genome.Log.progress.out", emit: log_progress

    script:
    """
    STAR \
        --alignEndsType EndToEnd \
        --genomeDir ${genome_index} \
        --genomeLoad NoSharedMemory \
        --outBAMcompression 10 \
        --outFileNamePrefix ${sample}.genome. \
        --outFilterMultimapNmax 1 \
        --outFilterMultimapScoreRange 1 \
        --outFilterScoreMin 10 \
        --outFilterType BySJout \
        --outReadsUnmapped Fastx \
        --outSAMattrRGline ID:${sample} \
        --outSAMattributes All \
        --outSAMmode Full \
        --outSAMtype BAM SortedByCoordinate \
        --outSAMunmapped Within \
        --outStd Log \
        --readFilesIn ${unmapped_reads} \
        --runMode alignReads \
        --runThreadN ${task.cpus}
    """

    stub:
    """
    touch ${sample}.genome.Aligned.sortedByCoord.out.bam
    touch ${sample}.genome.Unmapped.out.mate1
    touch ${sample}.genome.Log.final.out
    touch ${sample}.genome.Log.out
    touch ${sample}.genome.Log.progress.out
    touch ${sample}.genome.SJ.out.tab
    """
}