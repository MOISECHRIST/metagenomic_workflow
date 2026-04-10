#!/usr/local/bin/nextflow

/*
 Author : MEKA Moise
 Email : moise.meka@students.unibe.ch
 Description : This process takes as input a fastq files and sampleID and execute fastp trimming process on those fastq files
*/

process RUN_FASTP{
    tag "${sample_id}"
    label "low"

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}/fastp/${sample_id}_trimmed*.fastq.gz"), emit: cleaned_reads
    tuple val(sample_id), path("${sample_id}/fastp/${sample_id}_report.fastp.json"), emit: json
    tuple val(sample_id), path("${sample_id}/fastp/${sample_id}_report.fastp.html"), emit: html
    tuple val(sample_id), path("${sample_id}/fastp/${sample_id}_unpaired*.fastq.gz"), emit: unpaired_reads, optional: true

    script:
    if (reads instanceof List){
        """
        ## Make output directory
        mkdir -p '${sample_id}/fastp/'
        
        ## Then run fastp on single end read
        fastp -i '${reads[0]}' -I '${reads[1]}' \\
        -o ${sample_id}/fastp/${sample_id}_trimmed_R1.fastq.gz \\
        -O ${sample_id}/fastp/${sample_id}_trimmed_R2.fastq.gz \\
        --unpaired1 ${sample_id}/fastp/${sample_id}_unpaired_R1.fastq.gz \\
	    --unpaired2 ${sample_id}/fastp/${sample_id}_unpaired_R2.fastq.gz \\
        --json ${reads}_report.fastp.json \\
        --html ${reads}_report.fastp.html \\
        --detect_adapter_for_pe \\
        --thread ${task.cpus} --cut_front --cut_tail
        """
    } else {
        """
        ## Make output directory
        mkdir -p '${sample_id}/fastp/'

        ## Then run fastp on single end read
        fastp -i '${reads}' -o ${sample_id}/fastp/${sample_id}_trimmed.fastq.gz \\
        --json ${reads}_report.fastp.json \\
        --html ${reads}_report.fastp.html \\
        --thread ${task.cpus} --cut_front --cut_tail
        """
    }
}