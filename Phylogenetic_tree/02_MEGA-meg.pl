# 第一个open里改成自己的genome文件
# 第二个open里改成自己的fam文件
# 第三个open里将>后面的改成输出的文件名.meg
# 在下面的sample_size里，将数量改成自己使用的数量
#!usr/bin/perl
# define array of input and output files
open (AAA,"plink.genome") || die "can't open AAA";
open (BBB," QC.ld.cattle_204_hebing_Chr1_29_genotype.nchr-geno005-maf003-502502.fam") || die "can't open BBB"; 
open (CCC,"> cattle_204_hebing_Chr1_29.meg");
my @aa=<AAA>;
my @bb=<BBB>;
$sample_size=204; ###  涓綋鏁扮洰
print CCC "#mega\n!Title: $sample_size pigs;\n!Format DataType=Distance DataFormat=UpperRight NTaxa=$sample_size;\n\n"; 
foreach ($num1=0;$num1<=$#bb;$num1++){
	chomp $bb[$num1];
	@arraynum1=split(/\s+/,$bb[$num1]);
	print CCC "#$arraynum1[1]\n";       ##涓綋鐨処D鍚嶇О
	}
print CCC "\n";
@array=();
foreach ($num2=1;$num2<=$#aa;$num2++){
	chomp $aa[$num2];
	@arraynum1=split(/\s+/,$aa[$num2]);
	push(@array,1-$arraynum1[12]);
	}
	
@array2=(0);
$i=$sample_size;
while ($i>0){	
	push(@array2,$array2[$#array2]+$i);
	$i=$i-1;
	}
print "@array2";

for ($i=($sample_size-1); $i>=0; $i=$i-1){
	print CCC " " x ($sample_size-($i+1));
	    for ($j=$array2[$sample_size-$i-1]; $j<=$array2[$sample_size-$i]-1; $j++){
		                                                                          print CCC "$array[$j] ";	
			                                                                     }
	    print  CCC "\n";
	}
close AAA;
close BBB;
close CCC;
