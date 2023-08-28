#!/usr/bin/perl

die "Usage:perl $0 <genome file> <fam file> <outprefix>\n" unless (@ARGV == 3);
=pod
This script used to change genome file to MEGA infile ! 
=cut

open (AAA,"$ARGV[0]") || die "genome file required!\n";
open (BBB,"$ARGV[1]") || die "fam file required!\n"; 
open (CCC,">$ARGV[2]");
my @aa = <AAA>;
my @bb = <BBB>;
my $sample_size = scalar(@bb); ### sample size from fam file

print CCC "#mega\n!Title: $sample_size pigs;\n!Format DataType=Distance DataFormat=UpperRight NTaxa=$sample_size;\n\n"; 

foreach ($num1=0;$num1<=$#bb;$num1++){
	chomp $bb[$num1];
	@arraynum1=split(/\s+/,$bb[$num1]);
	print CCC "#$arraynum1[1]\n";
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
