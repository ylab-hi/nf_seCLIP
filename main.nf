#!/usr/bin/env nextflow

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    TEMPLATE NEXTFLOW PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Description: [ADD PIPELINE DESCRIPTION HERE]
    Author: [YOUR NAME]
    Contact: [YOUR EMAIL]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

nextflow.enable.dsl = 2

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    PARAMETER DEFAULTS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

params.input = 'samplesheet.csv'
params.outdir = 'results'
params.star_index_repeats = '/path/to/star/index'
params.star_index_genome = '/path/to/star/genome/index'
params.help = false

// Tool-specific parameters (customize for your pipeline)
params.example_tool_param = 'default_value'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { PIPELINE_INITIALISATION } from './subworkflows/local/utils'
include { MAIN                    } from './workflows/main'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {

        // Log pipeline start
    log.info """
    ========================================
     Pipeline Started Successfully
    ========================================
     Input: ${params.input}
     Output: ${params.outdir}
     Nextflow: ${workflow.nextflow.version}
     Pipeline: ${workflow.manifest.name} ${workflow.manifest.version}
    ========================================
    """.stripIndent()
    
    // Initialize pipeline
    PIPELINE_INITIALISATION(
        params.input,
    )
    
    // Run main workflow
    MAIN()
    
    workflow.onComplete = {
        println ""
        println "Pipeline execution summary:"
        println "=========================="
        println "Completed at: ${workflow.complete}"
        println "Duration    : ${workflow.duration}"
        println "Success     : ${workflow.success}"
        println "workDir     : ${workflow.workDir}"
        println "exit status : ${workflow.exitStatus}"
        println ""

        if (workflow.success) {
            println "✅ Pipeline completed successfully!"
        } else {
            println "❌ Pipeline failed!"
            println "Error: ${workflow.errorMessage}"
        }
    }
}
