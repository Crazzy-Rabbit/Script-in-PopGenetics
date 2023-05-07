#!/usr/bin/perl
use strict;
die "Usage:perl $0 <chr fai> <normalized XPEHH> <window size> <step size> <output>\n" unless @ARGV == 5;
=pod
norm --xpehh --files *xpehh.out
=cut
open (IN1, "$ARGV[0]") or die "chromosome fai file required!\n";
open (IN2, "$ARGV[1]") or die "norm XPEHH file required!\n";
open (OUT, ">$ARGV[4]") or die "permission denied!\n";
my %chrsize;
while(<IN1>){
	chomp;
	my @tmp = split/\s+/;
	$chrsize{$tmp[0]} = $tmp[1];
}
close IN1;
my %XEPHH;
while(<IN2>){
	chomp;
	next if /^pos/;
	my @tmp = split/\s+/;
	my ($chr, $pos) = split/:/, $tmp[0];
	$XEPHH{$chr}{$pos} = $tmp[-2];
}
close IN2;
my $window_size = $ARGV[2];
my $step_length = $ARGV[3];
foreach my $chr (sort keys %chrsize){
	my $last = $chrsize{$chr}-$step_length+1 > 0 ? $chrsize{$chr} : 1;
	my ($tmp_start, $tmp_end);
	for ($tmp_start = 1; $tmp_start <= $last; $tmp_start += $step_length){
		my $site = 0;
		my @normalized_XPEHH;
		$tmp_end = $tmp_start + $window_size - 1;
		foreach my $locus (grep {$_ >= $tmp_start and $_ <= $tmp_end} keys %{$XEPHH{$chr}}){
			$site++;
			push @normalized_XPEHH, $XEPHH{$chr}{$locus};
		}
		my $window_XPEHH = &get_average(@normalized_XPEHH);
		print OUT $chr,"\t",$tmp_start,"\t",$tmp_end,"\t",$site,"\t",$window_XPEHH,"\n";
	}
}
close OUT;
sub get_average {
	my @array = @_;
	my $sum;
	for my $value (@array) {
		$sum += $value;
	}
	my $average = @array > 0 ? $sum/@array : 0;
	return sprintf "%.2f",$average;
}
sub get_sd {
	my @array = @_;
	my $sum;
	for my $value (@array) {
		$sum += $value;
	}
	my $average = @array > 0 ? $sum/@array : 0;
	$sum = 0;
	for my $value (@array) {
		$sum += ($value-$average)**2;
	}
	my $sd = @array > 1 ? sqrt($sum/(@array-1)) : 0;
	return sprintf "%.2f",$sd;
}
