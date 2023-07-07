#!/usr/bin/perl -w
use strict;
use warnings;

die("perl $0 input relation output") if @ARGV !=3;

my %hash;
open REL,$ARGV[1];
while(<REL>){
    chomp;
    my @arr=split /\s+/,$_;
    $hash{$arr[0]}=$arr[1];
}
close REL;

open IN,$ARGV[0];
open OUT,">$ARGV[2]";
while(<IN>){
    chomp;
    if($_=~/^#/){
        print OUT "$_\n";
        next;
    }
    my @arr=split /\s+/,$_;
    if(exists $hash{$arr[0]}){
        $arr[0]=$hash{$arr[0]};
        print OUT join("\t",@arr),"\n";
    }
}
close IN;
close OUT;
`wc -l $ARGV[0]`;
`wc -l $ARGV[2]`;
