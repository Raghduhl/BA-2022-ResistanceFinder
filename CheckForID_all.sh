Translation_path=$2/Klinik-Daten/Translation.txt

echo "ID,EvKB,Klinikum,Lippe" > $2/Klinik-Daten/IDCheckList_all.txt
> $2/Klinik-Daten/ABList_all.txt
> $2/Klinik-Daten/ABListResistant_all.txt
for dir in `ls $1`; 
do
	List_path=$1/$dir/DetResList_$dir.txt
	> $1/$dir/DetResList_$dir.txt
	out=$(Rscript CheckFiles_all.R $dir $2)
	echo $out >> $2/Klinik-Daten/IDCheckList_all.txt
	sort -u -o $1/$dir/DetResList_$dir.txt $1/$dir/DetResList_$dir.txt
	[ -s $List_path ] && Rscript ReplaceTranslation.R $Translation_path $List_path remove | echo "$dir Resistances added" || echo "$dir not tested for resistances"
done

Rscript ReplaceTranslation.R $Translation_path $2/Klinik-Daten/ABList_all.txt not_remove
sort -u -o $2/Klinik-Daten/ABList_all.txt $2/Klinik-Daten/ABList_all.txt

Rscript ReplaceTranslation.R $Translation_path $2/Klinik-Daten/ABListResistant_all.txt not_remove
sort -u -o $2/Klinik-Daten/ABListResistant_all.txt $2/Klinik-Daten/ABListResistant_all.txt
