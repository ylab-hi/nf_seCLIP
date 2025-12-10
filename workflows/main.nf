/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { FASTQC as FASTQC_RAW } from '../modules/local/fastqc'
include { FASTQC as FASTQC_TRIMMED} from '../modules/local/fastqc'
include { UMI_EXTRACT } from '../modules/local/umi_tools'
include { CUTADAPT_1 } from '../modules/local/cutadapt'
include { CUTADAPT_2 } from '../modules/local/cutadapt'
include { STAR_REPEATS } from '../modules/local/star_align'
include { STAR_GENOME } from '../modules/local/star_align'
include { UMI_DEDUP } from '../modules/local/umi_tools'
include { SAMTOOLS_INDEX } from '../modules/local/samtools_index'
include { SAMTOOLS_INDEX as SAMTOOLS_INDEX_GENOME } from '../modules/local/samtools_index'
include { MULTIQC } from '../modules/local/multiqc'
include { DEEPTOOLS_BW } from '../modules/local/deeptools'


workflow MAIN {
    

    main:

    /*
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        MAIN WORKFLOW LOGIC
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    */
    
    // create input channels from samplesheet
    read_ch = channel.fromPath(params.input)
        .splitCsv(header:true)
        .map { row -> [row.sample_id, file(row.fastq_1), row.condition]}
    
    // create channels for STAR indices
    star_index_repeats_ch = channel.value(file(params.star_index_repeats))
    star_index_genome_ch = channel.value(file(params.star_index_genome))

    // FastQC on raw reads
    FASTQC_RAW(read_ch)

    // Run UMI extraction module
    UMI_EXTRACT(read_ch)

    // Trim adapters with cutadapt
    CUTADAPT_1(UMI_EXTRACT.out.extracted_ch)

    // Trim round 2
    CUTADAPT_2(CUTADAPT_1.out.trimmed_ch)

    // FastQC on trimmed reads
    FASTQC_TRIMMED(CUTADAPT_2.out.trimmed_ch)

    // Align reads
    STAR_REPEATS(CUTADAPT_2.out.trimmed_ch, star_index_repeats_ch)

    // Align reads to genome
    STAR_GENOME(STAR_REPEATS.out.unmapped_reads, star_index_genome_ch)

    // Index
    SAMTOOLS_INDEX(STAR_GENOME.out.bam)

    // Deduplicate aligned reads
    UMI_DEDUP(SAMTOOLS_INDEX.out.indexed_bam)

    // Collect all QC outputs for MultiQC
    MULTIQC(
        FASTQC_RAW.out.zip.collect(),
        FASTQC_TRIMMED.out.zip.collect(),
        CUTADAPT_1.out.cutadapt_log.collect(),
        CUTADAPT_2.out.cutadapt_log.collect(),
        UMI_EXTRACT.out.log.collect(),
        STAR_REPEATS.out.log_final.collect(),
        STAR_GENOME.out.log_final.collect(),
        UMI_DEDUP.out.stats_edit_distance.collect()
            .mix(UMI_DEDUP.out.stats_per_umi.collect())
            .mix(UMI_DEDUP.out.stats_umi.collect())
    )

    SAMTOOLS_INDEX_GENOME(UMI_DEDUP.out.dedup_bam)

    DEEPTOOLS_BW(SAMTOOLS_INDEX_GENOME.out.indexed_bam)

    
    /*
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        COLLECT OUTPUTS
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    */

    // emit:
    // results = EXAMPLE_MODULE.out.results
}