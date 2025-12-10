process CUTADAPT_1 {
    tag "$sample"
    label 'process_single'

    container "https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/2e/2ec131de77aafcf8578e3f0013d9a154b29c1b17afcd6b9ff784e16bb917e4ad/data"

    input:
    tuple val(sample), path(read1), val(condition)

    output:
    tuple val(sample), path("${sample}_cutadapt_1.fastq.gz"), val(condition), emit: trimmed_ch
    path "${sample}_cutadapt_1.log", emit: cutadapt_log

    script:
    """
    cutadapt \
        -O 1 \
        --match-read-wildcards \
        --times 1 \
        -e 0.1 \
        --quality-cutoff 6 \
        -m 18 \
        -o ${sample}_cutadapt_1.fastq.gz \
        -a AGATCGGAAGAGCAC \
        -a GATCGGAAGAGCACA \
        -a ATCGGAAGAGCACAC \
        -a TCGGAAGAGCACACG \
        -a CGGAAGAGCACACGT \
        -a GGAAGAGCACACGTC \
        -a GAAGAGCACACGTCT \
        -a AAGAGCACACGTCTG \
        -a AGAGCACACGTCTGA \
        -a GAGCACACGTCTGAA \
        -a AGCACACGTCTGAAC \
        -a GCACACGTCTGAACT \
        -a CACACGTCTGAACTC \
        -a ACACGTCTGAACTCC \
        -a CACGTCTGAACTCCA \
        -a ACGTCTGAACTCCAG \
        -a CGTCTGAACTCCAGT \
        -a GTCTGAACTCCAGTC \
        -a TCTGAACTCCAGTCA \
        -a CTGAACTCCAGTCAC \
        $read1 > ${sample}_cutadapt_1.log
    """

    stub:
    """
    touch ${sample}_cutadapt_1.fastq.gz
    touch ${sample}_cutadapt_1.log
    """
}

process CUTADAPT_2 {
    tag "$sample"
    label 'process_single'

    container "https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/2e/2ec131de77aafcf8578e3f0013d9a154b29c1b17afcd6b9ff784e16bb917e4ad/data"

    publishDir "${params.outdir}/trimmed", mode: 'copy'

    input:
    tuple val(sample), path(read1), val(condition)

    output:
    tuple val(sample), path("${sample}_cutadapt_2.fastq.gz"), val(condition), emit: trimmed_ch
    path "${sample}_cutadapt_2.log", emit: cutadapt_log

    script:
    """
    cutadapt \
        -O 5 \
        --match-read-wildcards \
        --times 1 \
        -e 0.1 \
        --quality-cutoff 6 \
        -m 18 \
        -o ${sample}_cutadapt_2.fastq.gz \
        -a AGATCGGAAGAGCAC \
        -a GATCGGAAGAGCACA \
        -a ATCGGAAGAGCACAC \
        -a TCGGAAGAGCACACG \
        -a CGGAAGAGCACACGT \
        -a GGAAGAGCACACGTC \
        -a GAAGAGCACACGTCT \
        -a AAGAGCACACGTCTG \
        -a AGAGCACACGTCTGA \
        -a GAGCACACGTCTGAA \
        -a AGCACACGTCTGAAC \
        -a GCACACGTCTGAACT \
        -a CACACGTCTGAACTC \
        -a ACACGTCTGAACTCC \
        -a CACGTCTGAACTCCA \
        -a ACGTCTGAACTCCAG \
        -a CGTCTGAACTCCAGT \
        -a GTCTGAACTCCAGTC \
        -a TCTGAACTCCAGTCA \
        -a CTGAACTCCAGTCAC \
        $read1 > ${sample}_cutadapt_2.log
    """

    stub:
    """
    touch ${sample}_cutadapt_2.fastq.gz
    touch ${sample}_cutadapt_2.log
    """
}