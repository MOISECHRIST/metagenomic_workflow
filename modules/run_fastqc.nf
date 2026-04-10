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
    tuple val(sample_id), path(fastq_r1), path(fastq_r2)

    output:
    path "${sample_id}/fastqc", emit: fastqc_results

    script:
    """
    ## Make the output directory
    mkdir -p '${sample_id}/fastqc'

    ## If fastq_r2 exist
    if [ -f '${fastq_r2}' ]; then 
        ## Run fastqc on 2 fastq files
        fastqc -t '${task.cpus}' '${fastq_r1}' '${fastq_r2}' -o '${sample_id}/fastqc'
    else
        ## Run fastqc on one fastq files
        fastqc -t '${task.cpus}' '${fastq_r1}' -o '${sample_id}/fastqc'
    fi
    """
}