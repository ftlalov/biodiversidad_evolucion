#!/bin/bash

# Script para analizar las lecturas 
# --------------------------------------------------------------------
#   Este script analiza el metagenoma con 16s y quiime
#   se ingresan los archivos de la carpeta /temp 
#   provenientes del script reads_preprocess.bash 
#   y se usa la configuración de lecturas del main
# ----------------------------------------------------------------------
###exportar conda por si no esta en el path 
export PATH="$HOME/miniconda1/bin:$PATH"
export PATH="$HOME/miniconda2/bin:$PATH"
export PATH="$HOME/miniconda3/bin:$PATH"
export PATH="$HOME/anaconda1/bin:$PATH"
export PATH="$HOME/anaconda2/bin:$PATH"
export PATH="$HOME/anaconda3/bin:$PATH"
##############################

##variables
config_seq=$1
archivo_muestras=$(cat "temp/new_samplefile.txt") ## archivo generado en reads_preprocess.bash
declare -A arreglo_fastq
declare -A array_conting

echo "$archivo_muestras"

 source $HOME/miniconda3/etc/profile.d/conda.sh 2>/dev/null
 source /opt/mambaforge/etc/profile.d/conda.sh 2>/dev/null
 source /opt/miniconda3/etc/profile.d/conda.sh 2>/dev/null
 source $HOME/mambaforge/etc/profile.d/conda.sh 2>/dev/null

conda activate bdye_assembly_tools 
