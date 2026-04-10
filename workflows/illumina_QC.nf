#!/usr/local/bin/nextflow

include { RUN_FASTQC as FASTQC_RAW }                        from '../modules/run_fastqc.nf'
include { RUN_FASTQC as FASTQC_CLEAN }                      from '../modules/run_fastqc.nf'
include { RUN_FASTP as FASTP}                               from '../modules/run_fastp.nf'
include { RUN_BOWTIE2_BUILD_INDEX as BUILD_PHIX_INDEXES }   from '../modules/run_bowtie2_build_index.nf'
include { RUN_BOWTIE2_REMOVE_REF as BOWTIE2_PHIX }          from '../modules/run_bowtie2_remove_ref.nf'
include { RUN_BOWTIE2_BUILD_INDEX as BUILD_REF_INDEXES }    from '../modules/run_bowtie2_build_index.nf'
include { RUN_BOWTIE2_REMOVE_REF as BOWTIE2_REF }           from '../modules/run_bowtie2_remove_ref.nf'
