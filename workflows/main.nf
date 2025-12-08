/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { FASTQC } from '../modules/local/fastqc'
include { UMI_EXTRACT } from '../modules/local/umi_tools'
include { CUTADAPT_1 } from '../modules/local/cutadapt'
include { CUTADAPT_2 } from '../modules/local/cutadapt'


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

    // FastQC on raw reads
    FASTQC(read_ch)

    // Run UMI extraction module
    UMI_EXTRACT(read_ch)

    // Trim adapters with cutadapt
    CUTADAPT_1(UMI_EXTRACT.out.extracted_ch)

    // Trim round 2
    CUTADAPT_2(CUTADAPT_1.out.trimmed_ch)

    // FastQC on trimmed reads
    FASTQC(CUTADAPT_2.out.trimmed_ch)

    // Align reads 


    
    /*
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        COLLECT OUTPUTS
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    */

    // emit:
    // results = EXAMPLE_MODULE.out.results
}