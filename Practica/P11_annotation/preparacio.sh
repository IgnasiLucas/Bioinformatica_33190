#!/bin/bash

# apt install augustus

## Following https://darencard.net/blog/2022-10-13-install-repeat-modeler-masker
# apt install python3-h5py
## Installed TRF: https://github.com/Benson-Genomics-Lab/TRF#instructions-for-compiling
## Installed RECON: http://eddylab.org/software/recon/RECON1.05.tar.gz
## Installed RepeatScout: https://github.com/Dfam-consortium/RepeatScout/archive/refs/tags/v1.0.7.tar.gz
## Installed RMBlast: https://www.repeatmasker.org/rmblast/rmblast-2.14.1+-x64-linux.tar.gz
## Installed GenomeTools (version 1.6.2): https://genometools.org/pub/genometools-1.6.2.tar.gz
##    make errorcheck=no
##    He instal·lat també la versió 1.6.6, per si de cas.
## RepeatMasker-4.2.3: https://www.repeatmasker.org/RepeatMasker/RepeatMasker-4.2.3.tar.gz
##    Incloent les llibreries dfam39_full.0.h5 i dfam39_full.5.h5,
##    de https://www.dfam.org/releases/current/families/FamDB
## RepeatAfterMe-0.0.7: https://github.com/Dfam-consortium/RepeatAfterMe

BuildDatabase -name At4 ../../data/At4.fa
RepeatModeler -database At4 -threads 6 >& run.log
RepeatMasker -lib At4-families.fa -dir RM01 -gtf ../../data/At4.fa

## Descarreguem les proteïnes del cromosoma 4 d'Arabidopsis thaliana: https://rest.uniprot.org/uniprotkb/stream?format=fasta&query=%28%28proteome%3AUP000006548%29+AND+%28proteomecomponent%3A%22Chromosome+4%22%29%29
##  en un arxiu "../../data/proteinas.fasta", descomprimit.

gawk '(/^>/){
   split($1, A, /\|/)
   print ">" A[2]
}(/^[^>]/){
   print $0
}' ../../data/proteinas.fasta > proteinas.fasta

## Executem GALBA

GALBA=/home/joiglu/bin/GALBA/scripts/galba.pl
export TSEBRA_PATH=/home/joiglu/bin/TSEBRA/bin/
export MINIPROTHINT_PATH=/home/joiglu/bin/miniprothint/

$GALBA --species="Arabidopsis thaliana" \
       --genome=../P10_assembly/asm1/At4.fa \
       --prot_seq=proteinas.fasta \
