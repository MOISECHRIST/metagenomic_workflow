#!/usr/local/bin/nextflow

/*
 Author : MEKA Moise
 Email : moise.meka@students.unibe.ch
 Description : This process takes as input a reference genome (fasta file) and builds indexes for bowtie2
*/

process RUN_BOWTIE2_BUILD_INDEX {
    tag "${reference_name}"
    label 'high'

    input:
    tuple val(reference_name), path(reference_path)

    output:
    path "reference/bowtie2/${reference_name}", emit: bowtie2_index
    path "reference/bowtie2/${reference_name}.log", emit: bowtie2_index_log

    script:
    """
    ## Make results directory and copy the reference in the results directory
    mkdir -p reference/bowtie2/
    cp '${reference_path}' reference/bowtie2/'${reference_name}.fasta'.

    ## Build bowtie2 indexes
    bowtie2-build -f reference/bowtie2/'${reference_name}.fasta' reference/bowtie2/'${reference_name}' \\
     --threads '${task.cpus}' 2>&1 reference/bowtie2/'${reference_name}'.log
    """
}