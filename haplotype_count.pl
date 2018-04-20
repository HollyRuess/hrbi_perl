#!/usr/bin/perl

###############################################################
###  title    : haplotype_count.pl                          ###
###  author	  : Holly Ruess (Holly.Ruess@ars.usda.gov)      ###
###  date     : 04-20-2018                                  ###
###  version  : 1                                           ###
###  usage    : ./haplotype_count.pl input.vcf >count.txt   ###
###  reference: https://github.com/HollyRuess/              ###
###############################################################

### This perl program counts the number of times each haplotype
###    appears in vcf file (per accession). Haplotypes are ./., 0/0,
###    0/1, 1/0, 1/1, or other.
### VCF file can be compressed or uncompressed.

use strict; use warnings;

my ($vcf) = @ARGV;
my (@col);
my ($totalcolumns);
my (@countmiss, @count00, @count11, @count01, @count10, @countother);
my (@hdr);

{
if ($vcf =~ /.gz$/) {open(FH, "zcat $vcf |") or die;}
else {open(FH,"<","$vcf") or die;}

while (my $lines = <FH>) {
	chomp $lines;
	next if ($lines =~ m/^##/);
	my @col = split (/\t/, $lines);
	if ($lines =~ /#/) {$totalcolumns = scalar @col -1; @hdr=@col}
	next if ($lines =~ m/^##/);
	for my $i (9..$totalcolumns) {
		if ($col[$i] =~ /^\.\/\./) {$countmiss[$i]++;}
		elsif ($col[$i] =~ /^0\/0/) {$count00[$i]++;}
		elsif ($col[$i] =~ /^1\/1/) {$count11[$i]++;}
		elsif ($col[$i] =~ /^0\/1/) {$count01[$i]++;}
		elsif ($col[$i] =~ /^1\/0/) {$count10[$i]++;}
		else {$countother[$i]++};	
	}
}

close FH;

print "PI\t./.\t0/0\t0/1\t1/0\t1/1\tother\n";
for my $i (9..$totalcolumns) {
	print "$hdr[$i]\t".($countmiss[$i]//0)."\t".($count00[$i]//0)."\t".($count01[$i]//0)."\t".($count10[$i]//0)."\t".($count11[$i]//0)."\t".($countother[$i]//0)."\n";
}
}
