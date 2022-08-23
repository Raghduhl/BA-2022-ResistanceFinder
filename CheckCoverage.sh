> $2
input=$1
while IFS= read -r line
do
	echo $(Rscript CheckCoverage.R $line $3)>> $2
done < "$input"
