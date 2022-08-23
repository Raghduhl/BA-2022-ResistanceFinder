source /prj/envmic/bin/miniconda3/etc/profile.d/conda.sh
conda activate matthes


Rscript Auswertung.R $(ls $2/SampleResults -m | tr -d " \t\n\r") "$2/SampleResults/"

sleep 60
CreateScaffold.sh $1 $2
printf "Sample,ResNum,Type\n" > $2/OverallResults/Plasmid_Resistance_Counts.txt
printf "Sample,Count,Type\n" > $2/OverallResults/PlasmidCounts.csv
printf "Sample,Species,Check" > $2/OverallResults/BlastCheck.txt
printf "Spezies,Count" > $2/OverallResults/Spezies_Count.csv
> $2/OverallResults/Spezies.txt
> $2/OverallResults/ResistancesList_ncbi.txt
> $2/OverallResults/ResistancesList_card.txt
> $2/OverallResults/ResistancesList_res.txt
> $2/OverallResults/SpeciesList.txt

#nextflow run Nextflow_main.nf --input $2

CheckForID_all.sh $2/SampleResults/ $2/..




maxcounter=$(ls $2/SampleResults | wc -l)  #variable for the total amount of folders in the target directory
counter=0
for dir in `ls $2/SampleResults`; #the content of the loop is executed for every directory in the specified path. The directory name is stored in 'dir'
do
	Rscript ListPlasmid.R $2/SampleResults/$dir $dir
	Rscript FindCircular.R $2/SampleResults/$dir $dir
	Rscript FindPseudoCircular.R $2/SampleResults/$dir $dir
	python GetGenome.py $2 $dir
	echo -e $(Rscript ExtractResistances.R "${2}/SampleResults/${dir}" $dir "ncbi") > $2/SampleResults/$dir/Resistances_ncbi_${dir}.txt && cat $2/SampleResults/$dir/Resistances_ncbi_${dir}.txt >> $2/OverallResults/ResistancesList_ncbi.txt &
	echo -e $(Rscript ExtractResistances.R "${2}/SampleResults/${dir}" $dir "card") > $2/SampleResults/$dir/Resistances_card_${dir}.txt && cat $2/SampleResults/$dir/Resistances_card_${dir}.txt >> $2/OverallResults/ResistancesList_card.txt &
	echo -e $(Rscript ExtractResistances.R "${2}/SampleResults/${dir}" $dir "res") > $2/SampleResults/$dir/Resistances_res_${dir}.txt && cat $2/SampleResults/$dir/Resistances_res_${dir}.txt >> $2/OverallResults/ResistancesList_res.txt &
	#blastn -db /vol/biodb/asn1/nt -query $2/SampleResults/$dir/GenomeSequences_$dir.fasta -out $2/SampleResults/$dir/RefGenBlastResults_${dir}.out -outfmt 6 -max_target_seqs 1&
	wait
done

Rscript CheckResByID.R $(ls $2/SampleResults -m | tr -d " \t\n\r") $2/..
#BlastRefGen.sh $1 $2

for dir in `ls $2/SampleResults`; #the content of the loop is executed for every directory in the specified path. The directory name is stored in 'dir'
do
	CheckCoverage.sh $2/SampleResults/$dir/BlastGenomeList_$dir.txt $2/SampleResults/$dir/IdenticalCoverageGenome_$dir.txt $2/SampleResults/$dir/AllContigs_$dir.txt
	python SplitSequences.py $2 $dir
#	Rscript ListRes.R $2 $dir
#	Rscript Connect_Res_Seq.R $2 $dir
	cat $2/SampleResults/$dir/Spezies_${dir}.txt >> $2/OverallResults/Spezies.txt
	python CheckSpecies.py $2 $dir
	echo $dir $(python ExtractSpecies.py $2/SampleResults/$dir/Spezies_${dir}.txt) >> $2/OverallResults/SpeciesList.txt
	ln -f $2/Sequences/${dir}.fasta $2/OverallResults/PhylogeneticTree/SNP_all/$(python ExtractSpecies.py $2/SampleResults/$dir/Spezies_${dir}.txt)_$dir.contig
	[[ $(python ExtractSpecies.py $2/SampleResults/$dir/Spezies_${dir}.txt) == "Klebsiella_pneumoniae" ]] && ln -f $2/Sequences/${dir}.fasta $2/OverallResults/PhylogeneticTree/SNP_Pneumoniae/$(python ExtractSpecies.py $2/SampleResults/$dir/Spezies_${dir}.txt)_$dir.contig
	[[ $(python ExtractSpecies.py $2/SampleResults/$dir/Spezies_${dir}.txt) == "Klebsiella_variicola" ]] && ln -f $2/Sequences/${dir}.fasta $2/OverallResults/PhylogeneticTree/SNP_Variicola/$(python ExtractSpecies.py $2/SampleResults/$dir/Spezies_${dir}.txt)_$dir.contig
	sed -i 's/;/\n/g' $2/SampleResults/$dir/Resistances_card_${dir}.txt
	sed -i 's/[[:blank:]]*$//' $2/SampleResults/$dir/Resistances_card_${dir}.txt
	sed -i 's/;/\n/g' $2/SampleResults/$dir/Resistances_ncbi_${dir}.txt
	sed -i 's/[[:blank:]]*$//' $2/SampleResults/$dir/Resistances_ncbi_${dir}.txt
	sed -i 's/;/\n/g' $2/SampleResults/$dir/Resistances_res_${dir}.txt
	sed -i 's/[[:blank:]]*$//' $2/SampleResults/$dir/Resistances_res_${dir}.txt
	sort -u -o $2/SampleResults/$dir/Resistances_ncbi_${dir}.txt $2/SampleResults/$dir/Resistances_ncbi_${dir}.txt
	sort -u -o $2/SampleResults/$dir/Resistances_card_${dir}.txt $2/SampleResults/$dir/Resistances_card_${dir}.txt
	sort -u -o $2/SampleResults/$dir/Resistances_res_${dir}.txt $2/SampleResults/$dir/Resistances_res_${dir}.txt
done

wait
sed -i 's/;/\n/g' $2/OverallResults/ResistancesList_ncbi.txt
sed -i 's/[[:blank:]]*$//' $2/OverallResults/ResistancesList_ncbi.txt
sed -i 's/;/\n/g' $2/OverallResults/ResistancesList_card.txt
sed -i 's/[[:blank:]]*$//' $2/OverallResults/ResistancesList_card.txt
sed -i 's/;/\n/g' $2/OverallResults/ResistancesList_res.txt
sed -i 's/[[:blank:]]*$//' $2/OverallResults/ResistancesList_res.txt
sort -u -o $2/OverallResults/ResistancesList_ncbi.txt $2/OverallResults/ResistancesList_ncbi.txt
sort -u -o $2/OverallResults/ResistancesList_card.txt $2/OverallResults/ResistancesList_card.txt
sort -u -o $2/OverallResults/ResistancesList_res.txt $2/OverallResults/ResistancesList_res.txt

awk '$2 ~ /Klebsiella/ {printf "%s," ,$1}' $2/OverallResults/SpeciesList.txt | Rscript card_analysis.R $2/SampleResults  "card" "FALSE" > $2/OverallResults/CommonResCard.txt
awk '$2 ~ /Klebsiella/ {printf "%s," ,$1}' $2/OverallResults/SpeciesList.txt | Rscript card_analysis.R $2/SampleResults  "ncbi" "FALSE" > $2/OverallResults/CommonResNCBI.txt
awk '$2 ~ /Klebsiella/ {printf "%s," ,$1}' $2/OverallResults/SpeciesList.txt | Rscript card_analysis.R $2/SampleResults "res"  "FALSE" > $2/OverallResults/CommonResRes.txt
#awk '$2 ~ /Klebsiella/ {printf "%s," ,$1}' $2/OverallResults/SpeciesList.txt | Rscript card_analysis.R $2/SampleResults  "card"  "TRUE" > $2/OverallResults/CommonResCard_ref.txt
#awk '$2 ~ /Klebsiella/ {printf "%s," ,$1}' $2/OverallResults/SpeciesList.txt | Rscript card_analysis.R $2/SampleResults  "ncbi" "TRUE" > $2/OverallResults/CommonResNCBI_ref.txt
#awk '$2 ~ /Klebsiella/ {printf "%s," ,$1}' $2/OverallResults/SpeciesList.txt | Rscript card_analysis.R $2/SampleResults "res"  "TRUE" > $2/OverallResults/CommonResRes_ref.txt

Rscript Compare_Res_db.R $(ls $2/SampleResults -m | tr -d " \t\n\r") "$2/SampleResults" "$2/../bin/TranslationDet<->Dat.txt"
Rscript CheckPrediction.R $(ls $2/SampleResults -m | tr -d " \t\n\r") "$2/SampleResults" "$2/../bin/TranslationDet<->Dat.txt"
Rscript ResPlace.R $(ls $2/SampleResults -m | tr -d " \t\n\r") $2
#Rscript Draw_ResBarplot.R $2
python countspecies.py $2/OverallResults 
Rscript PieChart.R $2/OverallResults

