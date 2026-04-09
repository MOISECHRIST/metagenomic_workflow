#!/usr/bin/env/python3

##------------------------------------------------------------------------
## Author : MEKA Moise
## Email : moise.meka@students.unibe.ch
## Description : This script take as input the path to the directory containing sample fastq file and how to recognise pairend reads. 
##              Build a sample sheet in the form (sample_id, path/to/fastq_r1, path/to/fastq_r2(if available), sequencing_technology)
##------------------------------------------------------------------------

import argparse
import pandas as pd
import os 
import pyjokes
from glob import glob
import sys

def check_input_dir(dirname_list):
    res = True
    for dirname in dirname_list:
        if not os.path.exists(dirname) or not os.path.isdir(dirname):
            res = True
            break
    return res

def extract_files(dirname, extension):
    return glob(os.path.join(dirname, f"*{extension}"))

def extract_sampleID(filepath, extension):
    return os.path.basename(filepath).split(extension)[0]

def output_type(output_file):
    ext = None
    if output_file!=None:
        ext = output.split('.')[-1]
    return ext


if __name__ == "__main__":
    description = (
    "This script take as input the path to the directory containing sample fastq file and how to recognise pairend reads."
    "\nBuild a sample sheet in the form (sample_id, path/to/fastq_r1, path/to/fastq_r2(if available))"
    )

    parser = argparse.ArgumentParser(description=description, 
                                    prog="build_sample_sheet.py",
                                    epilog=f"{pyjokes.get_joke()}")

    parser.add_argument("inputdir", nargs="+", 
                        help="List of path to input fastq files (eg : path/to/dir1 path/to/dir2 [...])")
    parser.add_argument("--output", required=False, type=argparse.FileType("w"),
                        help="""Path to the tsv/csv file where the sample sheet will be stored (eg path/to/my_sample_sheet.tsv)\n
                        If not available the file content will be print out on stdout""")
    parser.add_argument("--r1_ext", nargs="+", required=False, default="_R1_001.fastq.gz", 
                        help="List of reads 1 extensions (eg. _R1_001.fastq.gz _R1.fq _1.fastq.gz)")
    parser.add_argument("--r2_ext", nargs="+", required=False, default="_R2_001.fastq.gz",
                        help="List of reads 2 extensions (eg. _R2_001.fastq.gz _R2.fq _2.fastq.gz)")

    args = parser.parse_args()

    input_dir_list = args.inputdir
    output = args.output
    r1_ext = args.r1_ext
    r2_ext = args.r2_ext

    if not check_input_dir(input_dir_list):
        sys.exit("ERROR : one or more input directories do not exist")
    
    out_ext = output_type(output)

    if out_ext not in (None, 'csv', 'tsv'):
        sys.exit("ERROR : output must be a tsv/csv file if specified")

    files_ext1 = []
    for dir_path in input_dir_list:
        for ext in r1_ext:
            files_ext1.extend(extract_files(dir_path, ext))
    
    data_ext1 = []
    for ext in r1_ext:
        tmp = [[extract_sampleID(file_path, ext),file_path]for file_path in files_ext1]
        data_ext1.extend(tmp)
    
    files_ext2 = []
    for dir_path in input_dir_list:
        for ext in r2_ext:
            files_ext2.extend(extract_files(dir_path, ext))
    
    data_ext2 = []
    for ext in r2_ext:
        tmp = [[extract_sampleID(file_path, ext),file_path]for file_path in files_ext2]
        data_ext2.extend(tmp)
    
    data_ext1 = pd.DataFrame(data_ext1, columns=["sampleID", "read1"]).set_index("sampleID")
    data_ext2 = pd.DataFrame(data_ext2, columns=["sampleID", "read1"])

    sample_sheet = pd.concat([data_ext1, data_ext2], axis=1)
    if len(sample_sheet)==0:
        sys.exit("ERROR : There is no file with specified extensions")
    
    if out_ext == 'csv':
        sample_sheet.to_csv(output,sep=",", header=False)
    elif out_ext == 'tsv':
        sample_sheet.to_csv(output,sep="\t", header=False)
    else:
        print(sample_sheet.to_string(header=False,na_rep="", index_names=""))