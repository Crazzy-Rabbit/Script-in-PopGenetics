#! /bin/bash
######### software dir #############
plink2treemixIN="/home/sll/script/treemix/plink2treemixIN.py"
treemix="/home/sll/miniconda3/bin/treemix"
######### args number  #############
if [[$# ne 3]]; then
    echo "err need args!"
    echo "input file is bed format prefix"
    echo "Usage: bash $0 <sample_list> <bed> <outprefix>"
    exit 1
fi
samplelist=$1
bedprefix=$2
outprefix=$3
rootpop=$4
python $plink2treemixIN --sample $samplelist --bed $bedprefix --output $outprefix


for m in {1..5}
do
	for i in {1..5}
	do
	    $treemix -i ${outprefix}.treemix.in.gz -o sample.${m}.${i} -bootstrap 100 -root $rootpop -m ${m} -k 500 -noss
	done
done
