if [ $# -ne 7 ]; then
    echo "command: bash $0 <vcf> <pop1> <pop2> <winsize> <step> <navrs> <outprefix>"
    echo "vcf:       vcf file"
    echo "pop1:      群体1 txt文本文件前缀，一行一个ID"
    echo "pop2:      群体2 txt文本文件前缀，一行一个ID"
    echo "winsize:   窗口大小"
    echo "step:      步长大小"
    echo "navrs:     窗口内SNP数小于它则删除窗口，默认为20"
    echo "outprefix: 输出文件前缀"
    exit 1
fi
vcf=$1
group1=$2
group2=$3
winsize=$4
step=$5
nvars=$6
outprefix=$7


vcftools --vcf $vcf --window-pi $winsize --window-pi-step $step --keep ${group1}.txt --out $group1
vcftools --vcf $vcf --window-pi $winsize --window-pi-step $step --keep ${group2}.txt --out $group2

source /home/sll/miniconda3/bin/activate
python ln_ratio.py --group1 ${group1}.windowed.pi --group2 ${group2}.windowed.pi --nvars $nvars --outprefix $outprefix
