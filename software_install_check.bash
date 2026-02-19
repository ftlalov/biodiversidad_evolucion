#!/bin/bash

eval "$(conda software_install_check.bash hook)"

####
###  Script para verificar el software necesario
##   Este script analizará si estan instaladas las paqueterias necesarias
#    Usa conda para crear los ambientes de trabajo
#
#


echo "Verificando los programas y los ambientes, favor de esperar"

## Por si existe una instalación en home sin añadir al path 
for i in 1 2 3; do PATH="$HOME/miniconda"$i"/bin:$PATH" ;done

## declarar funcion para: Para ver si existe un comando

check_dependency() {
    if ! whereis "$1" >/dev/null 2>&1; then
        echo "Error: El comando '$1' no está instalado. Instalar comando para continuar" >&2
        exit 1
        else
        echo "$1 Instalado"
    fi
}

### declarar función para ver si existe conda

check_conda() {
    a=$(conda --version 2>&1 )
    if [[ $a == *"not found"* ]]; then
    echo "Conda no es accesible"
    install_anaconda

    else
        echo "Conda está instalado y accesible."
        echo "$a" # Show the actual version
    fi
}


### declarar función para instalar anaconda

install_anaconda() {
    read -r -p "¿Desea instalar el anaconda? (S/N): " RESPUESTA
     case "${RESPUESTA,,}" in
        s*|y*) 
            echo "Instalando miniconda"
            
            MINICONDA_INSTALLER_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
            INSTALLER_SCRIPT="Miniconda_Installer.sh"
            INSTALL_PATH="$HOME/miniconda3"
            echo "Descargando conda"
            wget -O $INSTALLER_SCRIPT $MINICONDA_INSTALLER_URL
            
            bash "$INSTALLER_SCRIPT" -b -p "$INSTALL_PATH"

            echo "Instalación completa"

            rm "$INSTALLER_SCRIPT"

            echo "Configurando Conda..."
            
            if [ -f "$INSTALL_PATH/bin/conda" ]; then
                 "$INSTALL_PATH/bin/conda" init bash
                echo "¡Instalación y configuración completada!"
                echo "Es necesario Cerrar el programa y volver a iniciar"
                exit 1
            else
            echo "Error: La instalación de Conda falló." >&2
            fi    

         ;;    
        *)
            echo "No se ha iniciado la isntalación, saliendo del programa"
            exit 1
          ;;    
    esac      
}

#### Función para instalar ambientes de trabajo en conda
###   con la paqueteria necesaria para el analisis de biodiversidad
##    

conda_envs_creation_tool() {
    local ENV_NAME="$1"

    if [[ "$ENV_NAME" == "bdye_assembly_tools" ]]; then
        
      
        if conda env list | grep -q -w "$ENV_NAME"; then
            echo "El ambiente '$ENV_NAME' existe. Activando..."
            source $HOME/miniconda3/etc/profile.d/conda.sh
            conda activate "$ENV_NAME"
            check_comando fastqc
            check_comando trim_galore
            check_comando metaspades
            check_comando megahit
            check_comando kaiju
            check_comando kraken
            

        else
            echo "El entorno '$ENV_NAME' no existe."
            read -r -p "¿Desea instalar el ambiente en conda? (S/N): " RESPUESTA
            case "${RESPUESTA,,}" in
                s*|y*)  
                    echo "Instalando ambiente $ENV_NAME..."
                    conda create --yes -n "$ENV_NAME" -c bioconda fastqc trim-galore spades megahit kaiju kraken2
                    echo "Ambiente creado. Activando..."
                    source $HOME/miniconda3/etc/profile.d/conda.sh
                    conda activate "$ENV_NAME"
                    check_comando fastqc
                    check_comando trim_galore
                    check_comando metaspades
                    check_comando megahit
                    check_comando kaiju
                    check_comando kraken2

                ;;      
                *)
                    echo "No se ha iniciado la instalación, saliendo del programa."
                    exit 1
                ;;      
            esac
        fi

    elif [[ "$ENV_NAME" == "bdye_qiime" ]]; then
        
        if conda env list | grep -q -w "$ENV_NAME"; then
            echo "El ambiente '$ENV_NAME' existe. Activando..."
            source $HOME/miniconda3/etc/profile.d/conda.sh
            conda activate "$ENV_NAME"
                    check_comando qiime
                    check_comando R
        else
            echo "El entorno '$ENV_NAME' no existe. Se requiere instalar QIIME2."
            read -r -p "¿Desea instalar el ambiente en conda? (S/N): " RESPUESTA
            case "${RESPUESTA,,}" in
                s*|y*)  
                    echo "Instalando ambiente $ENV_NAME..."
                    wget -O qiime2.yml  https://raw.githubusercontent.com/qiime2/distributions/refs/heads/dev/2025.7/amplicon/released/qiime2-amplicon-ubuntu-latest-conda.yml
                    conda env create --yes -n $ENV_NAME prueba --file qiime2.yml
                    echo "Ambiente creado. Activando..."
                    source $HOME/miniconda3/etc/profile.d/conda.sh
                    conda activate "$ENV_NAME"
                    check_comando qiime
                    check_comando R
                    rm  qiime2.yml
                ;;      
                *)
                    echo "No se ha iniciado la instalación, saliendo del programa."
                    exit 1
                ;;      
            esac
        fi
    elif [[ "$ENV_NAME" == "bdye_report" ]]; then
        
      
        if conda env list | grep -q -w "$ENV_NAME"; then
            echo "El ambiente '$ENV_NAME' existe. Activando..."
            source $HOME/miniconda3/etc/profile.d/conda.sh
            conda activate "$ENV_NAME"
            check_comando pdflatex
            

        else
            echo "El entorno '$ENV_NAME' no existe."
            read -r -p "¿Desea instalar el ambiente en conda? (S/N): " RESPUESTA
            case "${RESPUESTA,,}" in
                s*|y*)  
                    echo "Instalando ambiente $ENV_NAME..."
                    conda create --yes -n "$ENV_NAME" anaconda::texlive-core
                    echo "Ambiente creado. Activando..."
                    source $HOME/miniconda3/etc/profile.d/conda.sh
                    conda activate "$ENV_NAME"
                    check_comando pdflatex 

                ;;      
                *)
                    echo "No se ha iniciado la instalación, saliendo del programa."
                    exit 1
                ;;      
            esac
        fi


    fi
}

check_dependency wget
check_conda
conda_envs_creation_tool bdye_assembly_tools
conda_envs_creation_tool bdye_qiime
conda_envs_creation_tool bdye_report

