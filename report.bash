#!/bin/bash 

#### Para creación de reporte.
###
##  Datos de entrada:



##  activación de el ambiente en conda.
 source $HOME/miniconda3/etc/profile.d/conda.sh 2>/dev/null
 source /opt/mambaforge/etc/profile.d/conda.sh 2>/dev/null
 source /opt/miniconda3/etc/profile.d/conda.sh 2>/dev/null
 source $HOME/mambaforge/etc/profile.d/conda.sh 2>/dev/null

 conda activate bdye_report

#### declaración de variables
	TEXT_INPUT=${1:-"analysis_summary.txt"}
	IMAGE_INPUT=${2:-"results_plot.png"}
	REPORT_NAME=${3:-"reporte_biodiversidad"}
### preajuste para los datos en "analysis_summary.txt"
TABLE_CONTENT=$(awk -F: 'NF > 1 { 
    gsub("_", "\\_", $1); 
    gsub("_", "\\_", $2); 
    printf "%s & %s \\\\ \n", $1, $2 
}' "$TEXT_INPUT")

#### codigo de latex

cat <<EOF > "${REPORT_NAME}.tex"
\documentclass[11pt]{article}
\usepackage[utf8]{inputenc}
\usepackage[margin=2cm]{geometry}
\usepackage{graphicx}
\usepackage{booktabs} % para mejores tablas
\usepackage{listings} % For mostrar secuencias
\usepackage{xcolor}
\usepackage[T1]{fontenc} %% para manejo de las variables
\usepackage{amsmath} %% para matematicas


\title{\textbf{Analisis de biodiversidad y evolución de la vida marina}}
\author{Reporte generado con el pipeline para el analisis de la biodiversidad y biota marina}
\date{\today}

\begin{document}
\maketitle

\section{Resumen del análisis}
La información presentada es el resultado de la implementación de un poipeline
para el manejo de datos de secuenciación masiva aplicados a la biodiversidad y 
evolución

\begin{quote}
\textit{Source file: \detokenize{$TEXT_INPUT}}
\end{quote}

% para leer el archivo de texto y hacerlo tabla
\begin{center}
\begin{tabular}{ll}
\toprule
\textbf{Metrica} & \textbf{Valor} \\\ \midrule
$TABLE_CONTENT
\bottomrule
\end{tabular}
\end{center}

\section{Gráficos}
Gráfico generado apartir de los resultados

\begin{figure}[h]
    \centering
    $( [[ -f "$IMAGE_INPUT" ]] && echo "\includegraphics[width=0.8\textwidth]{$IMAGE_INPUT}" || echo "Warning: $IMAGE_INPUT not found.")
    \caption{Data visualization for \detokenize{$REPORT_NAME}.}
\end{figure}

\section{Calculos}
ejemplos
\[ \text{Confidence Score} = \frac{\sum \text{Correct Reads}}{\text{Total Reads}} \times 100 \]

\end{document}
EOF

#### final de sección 
#### para guardar el reporte 

tectonic "${REPORT_NAME}.tex" > /dev/null

