#!/usr/local/bin/nextflow

/*
## Author : MEKA Moise
## Email : moise.meka@students.unibe.ch
## Description : This process takes as input a fastq file and sampleID and execute fastqc on that fastq file
*/


process RUN_FASTQC{
    tag "${sample_id}"
    label 'low'

    input:
    tuple val(sample_id), path(reads)

    output:
    path "${sample_id}/fastqc", emit: fastqc_results

    script:
    """
    ## Make the output directory
    mkdir -p '${sample_id}/fastqc'
    
    ## Then run fastqc on given fast
    fastqc -t '${task.cpus}' '${reads}' -o '${sample_id}/fastqc'
    """
}