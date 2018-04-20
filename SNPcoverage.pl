#!/usr/bin/perl
###############################################################
###  title    : SNPcoverage.pl                              ###
###  author	  : Holly Ruess (Holly.Ruess@ars.usda.gov)      ###
###  date     : 04-20-2018                                  ###
###  version  : 1                                           ###
###  usage    : ./SNPcoverage.pl input.vcf >SNPcoverage.txt ###
###  reference: https://github.com/HollyRuess/              ###
###############################################################

### This perl program finds the average coverage of the SNPs for
###     each accession (minus missing data) in a vcf file
### VCF file can be compressed or uncompressed.

use strict; use warnings;
use Statistics::Lite qw(:all);

my ($vcf) = @ARGV;

my (@col);
my ($totalcolumns, $min, $max, $mean, $meanround, $median, $count);
my (@hdr);
my (@Aallele, @Ballele, @depth);
my $nlines = 0;

{
if ($vcf =~ /.gz$/) {open(FH, "zcat $vcf |") or die;}
else {open(FH,"<","$vcf") or die;}

while (my $lines = <FH>) {
    chomp $lines;
    next if ($lines =~ m/^##/); #Skip header lines with 2 "#"
    my @col = split (/\t/, $lines); #Split the rest of the lines by tab
    if ($lines =~ /#/) {$totalcolumns = scalar @col -1; @hdr=@col} #Count the number of samples and store their names
    next if ($lines =~ m/^#/); #Skip the header line with the sample names (after counting)
    for my $i (9..$totalcolumns) { #Go through each sample 1 by 1
        ($Aallele[$i-9][$nlines], $Ballele[$i-9][$nlines]) = $col[$i] =~ /^([\d.])\/([\d.])/; #Find the alleles for each line; ./., 0/0, 0/1, 1/1
        if (($Aallele[$i-9][$nlines] ne ".") and ($Ballele[$i-9][$nlines] ne ".")) {  #Skip SNPs that are missing
            ($depth[$i-9][$nlines]) = $col[$i] =~ /[^:]*:[^:]*:([^:]*):[^:]*:[^:]*/; #GT:PL:DP:SP:GQ, find the depth of non-missing SNPs
        }
    }
  $nlines++;
}
close FH;

print "Name\tMin\tMax\tAverage\tMedian\tCount\n"; #Header for file
for my $i (0..$totalcolumns-9) {
    $min = min @{$depth[$i]};
    $max = max @{$depth[$i]};
    $mean = mean @{$depth[$i]};
    $meanround = sprintf("%.2f",$mean);
    $median = median @{$depth[$i]};
    $count = count @{$depth[$i]};
    print "$hdr[$i+9]\t$min\t$max\t$meanround\t$median\t$count\n";
}
}
