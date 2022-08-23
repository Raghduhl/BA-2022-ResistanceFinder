if [ ! -d "$2" ]  #returns 'true' if the specified directory does not exist
then
    echo "Parent directory doesn't exist. Creating now"
    mkdir $2 #creates the specified directory
    echo "Parent directory created"
else
    echo "Parent directory exists"
fi

if [ ! -d "$2/Sequences" ]  #returns 'true' if the specified directory does not exist
then
    echo "Sequences directory doesn't exist. Creating now"
    mkdir $2/Sequences #creates the specified directory
    echo "Sequences directory created"
else
    echo "Sequences directory exists"
fi

if [ ! -d "$2/OverallResults" ]  #returns 'true' if the specified directory does not existhe problem ohe problem o
then
    echo "Overall Results directory doesn't exist. Creating now"
    mkdir $2/OverallResults #creates the specified directory
    echo "OverallResults directory created"
else
    echo "OverallResults directory exists"
fi

if [ ! -d "$2/OverallResults/PhylogeneticTree" ]  #returns 'true' if the specified directory does not existhe problem ohe problem o
then
    echo "PhylogeneticTree directory doesn't exist. Creating now"
    mkdir $2/OverallResults/PhylogeneticTree #creates the specified directory
    echo "PhylogeneticTree directory created"
else
    echo "PhylogeneticTree directory exists"
fi

if [ ! -d "$2/OverallResults/PhylogeneticTree/SNP_all" ]  #returns 'true' if the specified directory does not existhe problem ohe problem o
then
    echo "SNP complete directory doesn't exist. Creating now"
    mkdir $2/OverallResults/PhylogeneticTree/SNP_all #creates the specified directory
    echo "SNP complete directory created"
else
    echo "SNP complete directory exists"
fi

if [ ! -d "$2/OverallResults/PhylogeneticTree/SNP_Variicola" ]  #returns 'true' if the specified directory does not existhe problem ohe problem o
then
    echo "SNP Variicola directory doesn't exist. Creating now"
    mkdir $2/OverallResults/PhylogeneticTree/SNP_Variicola #creates the specified directory
    echo "SNP Variicola directory created"
else
    echo "SNP Variicola directory exists"
fi

if [ ! -d "$2/OverallResults/PhylogeneticTree/SNP_Pneumoniae" ]  #returns 'true' if the specified directory does not existhe problem ohe problem o
then
    echo "SNP Pneumoniae directory doesn't exist. Creating now"
    mkdir $2/OverallResults/PhylogeneticTree/SNP_Pneumoniae #creates the specified directory
    echo "SNP Pneumoniae directory created"
else
    echo "SNP Pneumoniae directory exists"
fi

if [ ! -d "$2/SampleResults" ]  #returns 'true' if the specified directory does not exist
then
    echo "SampleResults directory doesn't exist. Creating now"
    mkdir $2/SampleResults #creates the specified directory
    echo "SampleResults directory created"
else
    echo "SampleResults directory exists"
fi

> $2/OverallResults/PlasmidCounts.csv
> $2/OverallResults/Spezies.txt
> $2/OverallResults/Spezies_Count.csv

ls $1
maxcounter=$(ls $1 | wc -l)  #variable for the total amount of folders in the target directory
counter=0
for dir in `ls $1`; #the content of the loop is executed for every directory in the specified path. The directory name is stored in 'dir'
do
	if [ ! -d "$2/SampleResults/$dir" ]  #returns 'true' if the specified directory does not exist
		then
		    echo "Sample directory $dir doesn't exist. Creating now"
		    mkdir $2/SampleResults/$dir #creates the corresponding directory for the results
		    echo "Sample directory $dir created"
		else
		    echo "Target directory $dir exists"
		fi
	
	if [ ! -d "$2/SampleResults/$dir/RefGenDB" ]  #returns 'true' if the specified directory does not exist
		then
		    echo "Database directory $dir doesn't exist. Creating now"
		    mkdir $2/SampleResults/$dir/RefGenDB #creates the corresponding directory for the results
		    echo "Database directory $dir created"
		else
		    echo "Database directory $dir exists"
		fi
	
	> $2/SampleResults/$dir/readlengths_$dir.txt
	cp $1/$dir/assembly-flye/assembly.fasta $2/Sequences/$dir.fasta
	cp $1/$dir/assembly-flye/assembly_graph.gfa $2/Sequences/$dir.gfa
	gunzip -c $1/$dir/ONT.fastq.gz |awk 'NR%4==2{print length($0)}'|uniq -c >> $2/SampleResults/$dir/readlengths_$dir.txt
done

