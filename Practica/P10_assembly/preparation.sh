#!/usr/bin/bash

if [ ! -e At4.fa.gz ]; then
   if [ ! -e Col-0.q20.bam.bai ]; then
      if [ ! -e Col-0.q20.fastq.gz ]; then
         wget ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR866/ERR8666127/Col-0.q20.fastq.gz
      fi
      if [ ! -e GCF_000001735.4.fna ]; then
         datasets download genome accession GCF_000001735.4
         unzip ncbi_dataset.zip
         rm ncbi_dataset.zip
         rm README.md
         rm md5sum.txt
         mv ncbi_dataset/data/GCF_000001735.4/GCF_000001735.4_TAIR10.1_genomic.fna ./GCF_000001735.4.fna
         rm -r ncbi_dataset
      fi
      if [ ! -e repetitive_k15.txt ]; then
         if [ ! -d merylDB ]; then
            meryl count k=15 output merylDB GCF_000001735.4.fna
         fi
         meryl print greater-than distinct=0.9998 merylDB > repetitive_k15.txt
      fi
      winnowmap -W repetitive_k15.txt -ax map-pb GCF_000001735.4.fna Col-0.q20.fastq.gz > Col-0.q20.sam
      samtools view -u Col-0.q20.sam | samtools sort -o Col-0.q20.bam
      samtools index Col-0.q20.bam
      rm Col-0.q20.sam
   fi
   samtools view -h Col-0.q20.bam NC_003075.7 | gawk '(/^@/){print $0}((/^[^@]/) && (NR % 10 == 0)){print $0}' > At4.10.sam
   samtools fasta At4.10.sam > At4.10.fa
   gzip At4.10.fa
fi
