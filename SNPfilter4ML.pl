#!/usr/bin/perl 
#####################################################################################################################################################   
###  title          : SNPfilter4ML.pl                                                                                                             ###
###  description    : This perl program filters a vcf file of SNPs so that the ascertainment bias of Maximum Likelihood may be applied.           ###
###                   The filters are either 1) at least 1 homozygous reference SNP, at least 1 homozygous alternate SNP, and at least and 1      ###
###                   heterozygous SNP, 2) if no heterozygous SNPs, then at least 2 homozygous reference SNPs and 2 homozygous alternate SNPs.    ###
###  author	        : Holly Ruess (Holly.Ruess@ars.usda.gov)                                                                                      ###
###  date           : 06-16-2017                                                                                                                  ###
###  version        : 1                                                                                                                           ###   
###  notes          : vcf can be compressed.                                                                                                      ###
###  usage          : ./SNPfilter4ML.pl input.vcf >output.vcf or ./SNPfilter4ML.pl input.vcf.gz | bgzip >output.vcf.gz                            ###
#####################################################################################################################################################
use strict; use warnings;

my ($vcf) = @ARGV;

{
if ($vcf =~ /.gz$/) {open(FH, "zcat $vcf |") or die;}
else {open(FH,"<","$vcf") or die;}

while (my $lines = <FH>) {
  chomp $lines;
  if ($lines =~ /^#/) {print "$lines\n";} #print header of vcf file
  elsif ($lines !~ /^#/) { #for all other lines; do the following
    if (($lines =~ /0\/1/) and ($lines =~ /0\/0/) and ($lines =~ /1\/1/)) {print "$lines\n";} #print lines that contain heterozygous SNPs and atleast 1 reference and alternate allele
    if (($lines !~ /0\/1/) and ($lines =~ /0\/0.*0\/0/) and ($lines =~ /1\/1.*1\/1/)) {print "$lines\n";} #if no heterozygous SNPs, print lines that contain at least 2 "0/0" or "1/1"
  }
}
close FH;
}
