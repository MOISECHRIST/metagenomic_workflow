#!/usr/local/bin/nextflow

include { RUN_FASTQC as RUN_FASTQC_RAW }   from '../modules/run_fastqc.nf'
include { RUN_FASTQC as RUN_FASTQC_CLEAN } from '../modules/run_fastqc.nf'
include { RUN_FASTP }                      from '../modules/run_fastp.nf'

