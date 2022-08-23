#!/usr/bin/env nextflow
nextflow.enable.dsl=1

params.input = "/prj/envmic/Matthes_Auswertung/Resistenz-Analyse/Results"
results_path = "${params.input}/SampleResults"
sequences_path = "${params.input}/SampleResults/*/GenomeSequences_*.fasta"

Channel
	.fromPath(sequences_path)
	.map { file -> tuple(file.baseName, file) }
	.set{Sequences}
	

process GetReferenceGenomeandGenomeList {
	publishDir "$results_path/$datasetID", mode: 'copy'
	
	input:
		tuple val(datasetID), path(datasetFile) from Sequences

	output:
		tuple val(datasetID), path("GenomeList_${datasetID}.txt") into GenomeList
		
	script:
		"""
		blastn -db /vol/biodb/asn1/nt -query /prj/envmic/Matthes_Auswertung/Resistenz-Analyse/Results/SampleResults/K-L0012/GenomeSequence_K-L0012.fasta -out results_${datasetID}.out
		Acc=\$(Rscript ExtractAccession.R ${datasetID})
		esearch -db nucleotide -query \$Acc | efetch -format fasta > RefGen_${datasetID}.fasta
		makeblastdb -in "RefGen_${datasetID}.fasta" -dbtype nucl -out "RefGen_${datasetID}_db"
		blastn -query ${params.input}/Sequences/${datasetID}.fasta -db "RefGen_${datasetID}_db" -out "GenomeList_${datasetID}.txt" -outfmt 6
		"""
}

