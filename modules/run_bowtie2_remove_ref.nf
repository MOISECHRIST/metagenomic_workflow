#!/usr/local/bin/nextflow

/*
 Author : MEKA Moise
 Email : moise.meka@students.unibe.ch
 Description : This process takes as input a reference genome indexes (*.bt2 files) and fastq reads. 
 Then using bowtie2 maps reads to the refence and return the unmapped reads
*/

process RUN_BOWTIE2_REMOVE_REF {
    tag "${sample_id}"
    label 'high'

    input:
    tuple val(sample_id), path(reads)
    tuple val(reference_name), path(reference_index)

    output:
    path "${sample_id}/bowtie2/${reference_name}/${sample_id}_clean_reads*.fastq.gz", emit: clean_reads

    script:
    if( reads instanceof List){
        """
        ## Make output directory
        mkdir -p '${sample_id}/bowtie2/${reference_name}'

        ## Run bowtie2 
        bowtie2 -x '${reference_index}' \\
            --threads '${task.cpus}' \\
            -1 '${reads[0]}' -2 '${reads[1]}' \\
            --un-conc-gz '${sample_id}/bowtie2/${reference_name}/${sample_id}_clean_reads.fastq.gz' \\
             > /dev/null
        """
    } else {
        """
        ## Make output directory
        mkdir -p '${sample_id}/bowtie2/${reference_name}'

        ## Run bowtie2
        bowtie2 -x '${reference_index}' \\
            --threads '${task.cpus}' \\
            -U '${reads}' \\
            --un-gz '${sample_id}/bowtie2/${reference_name}/${sample_id}_clean_reads.fastq.gz' \\
             > /dev/null
        """
    }
}
