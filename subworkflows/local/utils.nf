
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

def helpMessage() {
    log.info"""
    ========================================
     ${workflow.manifest.name} v${workflow.manifest.version}
    ========================================
    
    Usage:
      nextflow run main.nf --input samplesheet.csv --outdir results
    
    Required arguments:
      --input               Path to input samplesheet (CSV format)
      --outdir              Output directory
    
    Optional arguments:
      --help                Show this help message and exit
    
    """.stripIndent()
}


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/


workflow PIPELINE_INITIALISATION {

    take:
    input        // string: Path to input file

    main:
    // Validate required parameters
    if (!input) {
        log.error "ERROR: --input parameter is required"
        helpMessage()
        exit 1
    }

    // Check input file exists
    if (!file(input).exists()) {
        log.error "ERROR: Input file does not exist: ${input}"
        exit 1
    }

}

