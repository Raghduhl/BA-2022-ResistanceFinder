
Arr=()
Path=$(dirname "$(realpath $0)")
for dir in `ls $2/SampleResults`; #the content of the loop is executed for every directory in the specified path. The directory name is stored in 'dir'
do
	Arr[${#Arr[@]}]=$(Rscript ExtractAccession.R $2/SampleResults/$dir $dir)
done
echo "Created Array"
i=0
for dir in `ls $2/SampleResults`; #the content of the loop is executed for every directory in the specified path. The directory name is stored in 'dir'
do
	Acc=${Arr[$i]}
	echo $Acc
	echo $i
	cd $2/SampleResults/$dir/RefGenDB
	(esearch -db nucleotide -query $Acc | efetch -format fasta > $2/SampleResults/$dir/RefGenDB/RefGen_${dir}_db.fasta && makeblastdb -in RefGen_${dir}_db.fasta -dbtype nucl -hash_index>/dev/null && blastn -query ${2}/Sequences/${dir}.fasta -db RefGen_${dir}_db.fasta -out $2/SampleResults/$dir/BlastGenomeList_${dir}.txt -outfmt 6 && Rscript $Path/ExtractBlastGen.R $2/SampleResults/$dir $dir)&
	echo "$dir started"
	sleep 2s
	let i=$i+1
done

cd $2
cd ../bin

