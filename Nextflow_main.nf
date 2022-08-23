#!/usr/bin/env nextflow
nextflow.enable.dsl=1

params.input = "/prj/envmic/Matthes_Auswertung/Resistenz-Analyse/Results"
results_path = "${params.input}/SampleResults"
sequences_path = "${params.input}/Sequences/*.fasta"
graph_path = "${params.input}/Sequences/*.gfa"
params.db = "/prj/envmic/Matthes_Auswertung/Resistenz-Analyse/bin/db/silva"

db_name = file(params.db).name

Channel
	.fromPath(sequences_path)
	.map { file -> tuple(file.baseName, file) }
	.into{Sequences_datasets_abr; Sequences_datasets_pla; Species_datasets; Blast_datasets; Sequences_datasets_ncbi; Sequences_datasets_res}
	
Channel
	.fromPath(graph_path)
	.map { file -> tuple(file.baseName, file) }
	.set{graph_datasets}
                

process extract_from_gfa {
	publishDir "$results_path/$datasetID", mode: 'copy'
	
	input:
		tuple val(datasetID), path(datasetFile) from graph_datasets

	output:
		tuple val(datasetID), path("Line_${datasetID}.txt") into Lines
		tuple val(datasetID), path("Path_${datasetID}.txt") into Paths
		tuple val(datasetID), path("AllContigs_${datasetID}.txt") into Contigs
		
	script:
		"""
		#!/usr/bin/env python 
		
		with open("${datasetID}.gfa", 'r') as source:
			with open("Line_${datasetID}.txt", 'w+') as Lines:
				with open("Path_${datasetID}.txt", 'w+') as Paths:
					with open("AllContigs_${datasetID}.txt", 'w+') as Contigs:
						while True:
							l = source.readline()
							if not l:
								break
							if (l.startswith("L")):
								Lines.write(l)
							if (l.startswith("P")):
								Paths.write(l)
							if (l.startswith("S")):
								num = l.partition("edge_")[2]
								num = num.split("\t")[0]
								cov = l.partition("dp:i:")[2]
								Contigs.write("contig_" + num + "\t" + cov)
		"""
}

process abricate_card {
	publishDir "$results_path/$datasetID", mode: 'copy'
	
	input:
		tuple val(datasetID), path(datasetFile) from Sequences_datasets_abr

	output:
		tuple val(datasetID), path("abricate_card_${datasetID}.txt") into abricate_card_results
		
	script:
		"""
		abricate --db card $datasetFile > abricate_card_${datasetID}.txt
		"""
}

process abricate_ncbi {
	publishDir "$results_path/$datasetID", mode: 'copy'
	
	input:
		tuple val(datasetID), path(datasetFile) from Sequences_datasets_ncbi

	output:
		tuple val(datasetID), path("abricate_ncbi_${datasetID}.txt") into abricate_ncbi_results
		
	script:
		"""
		abricate $datasetFile > abricate_ncbi_${datasetID}.txt
		"""
}

process abricate_Res {
	publishDir "$results_path/$datasetID", mode: 'copy'
	
	input:
		tuple val(datasetID), path(datasetFile) from Sequences_datasets_res

	output:
		tuple val(datasetID), path("abricate_res_${datasetID}.txt") into abricate_res_results
		
	script:
		"""
		abricate --db resfinder $datasetFile > abricate_res_${datasetID}.txt
		"""
}

                
process abricate_plasmidfinder {
	publishDir "$results_path/$datasetID", mode: 'copy'
	
	input:
		tuple val(datasetID), path(datasetFile) from Sequences_datasets_pla

	output:
		tuple val(datasetID), path("abricate_plasmidfinder_${datasetID}.txt") into abricate_plasmidfinder_results
		
	script:
		"""
		abricate --db plasmidfinder $datasetFile > abricate_plasmidfinder_${datasetID}.txt
		"""
}

process Species {
	publishDir "$results_path/$datasetID", mode: 'copy'
	
	input:
		tuple val(datasetID), path(datasetFile) from Species_datasets

	output:
		tuple val(datasetID), path("Spezies_${datasetID}.txt") into Species_List
		
	script:
		"""
		python /prj/envmic/bin/species_api_upload.py -f ${datasetFile}| tee -a ${params.input}/Sequences/Spezies.txt Spezies_${datasetID}.txt
		"""
}

process Blast16S {
	publishDir "$results_path/$datasetID", mode: 'copy'
	
	input:
		tuple val(datasetID), path(datasetFile) from Blast_datasets
		path db from params.db

	output:
		tuple val(datasetID), path("Blast16S_${datasetID}.txt") into Blast16S
		
	script:
		"""
		blastn -db $db/$db_name -query "${datasetFile}" -max_target_seqs 10 > Blast16S_${datasetID}.txt
		"""
}

