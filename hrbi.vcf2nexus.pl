#!/usr/bin/perl
###This perl program converts a vcf file (created by tassel5 and filtered by vcftools) into a NEXUS file 
###./vcf2nexus.pl input.vcf >output.nex
###Note1: vcf can be compressed
###Note2: Missing data is coded as "?"; change lines 48 and 54 if you want a different symbol
use strict; use warnings;

my ($vcf) = @ARGV;

my (@col);
my ($totalcolumns);
my (@hdr);
my (@Aallele, @Ballele);
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
    ($Aallele[$i-9][$nlines], $Ballele[$i-9][$nlines]) = $col[$i] =~ /^([\d.])\/([\d.])/; #Find the alleles for each line
    if ($Aallele[$i-9][$nlines] eq "0") {$Aallele[$i-9][$nlines] = $col[3]} #covert the "01" into ref or alt bases, 1st allele
    elsif ($Aallele[$i-9][$nlines] eq "1") {$Aallele[$i-9][$nlines] = $col[4]} #covert the "01" into ref or alt bases, 1st allele
    if ($Ballele[$i-9][$nlines] eq "0") {$Ballele[$i-9][$nlines] = $col[3]} #covert the "01" into ref or alt bases, 2nd allele
    elsif ($Ballele[$i-9][$nlines] eq "1") {$Ballele[$i-9][$nlines] = $col[4]} #covert the "01" into ref or alt bases, 2nd allele
    if (($Aallele[$i-9][$nlines] !~ /[ATCG.]/) or ($Ballele[$i-9][$nlines] !~ /[ATCG.]/)) {die "Bases other than ATCG found in file"}; #check if any other bases are present in file; if so this program will die
    if ($Aallele[$i-9][$nlines] ne $Ballele[$i-9][$nlines]) { #Check for Snps that are heterozygous; next 12 lines change Ambiguity Codes
      if (($Aallele[$i-9][$nlines] eq "A") and ($Ballele[$i-9][$nlines] eq "T")) {$Aallele[$i-9][$nlines] = "W"}
      elsif (($Aallele[$i-9][$nlines] eq "A") and ($Ballele[$i-9][$nlines] eq "G")) {$Aallele[$i-9][$nlines] = "R"}
      elsif (($Aallele[$i-9][$nlines] eq "A") and ($Ballele[$i-9][$nlines] eq "C")) {$Aallele[$i-9][$nlines] = "M"}
      elsif (($Aallele[$i-9][$nlines] eq "T") and ($Ballele[$i-9][$nlines] eq "A")) {$Aallele[$i-9][$nlines] = "W"}
      elsif (($Aallele[$i-9][$nlines] eq "T") and ($Ballele[$i-9][$nlines] eq "G")) {$Aallele[$i-9][$nlines] = "K"}
      elsif (($Aallele[$i-9][$nlines] eq "T") and ($Ballele[$i-9][$nlines] eq "C")) {$Aallele[$i-9][$nlines] = "Y"}
      elsif (($Aallele[$i-9][$nlines] eq "G") and ($Ballele[$i-9][$nlines] eq "A")) {$Aallele[$i-9][$nlines] = "R"}
      elsif (($Aallele[$i-9][$nlines] eq "G") and ($Ballele[$i-9][$nlines] eq "T")) {$Aallele[$i-9][$nlines] = "K"}
      elsif (($Aallele[$i-9][$nlines] eq "G") and ($Ballele[$i-9][$nlines] eq "C")) {$Aallele[$i-9][$nlines] = "S"}
      elsif (($Aallele[$i-9][$nlines] eq "C") and ($Ballele[$i-9][$nlines] eq "A")) {$Aallele[$i-9][$nlines] = "M"}
      elsif (($Aallele[$i-9][$nlines] eq "C") and ($Ballele[$i-9][$nlines] eq "T")) {$Aallele[$i-9][$nlines] = "Y"}
      elsif (($Aallele[$i-9][$nlines] eq "C") and ($Ballele[$i-9][$nlines] eq "G")) {$Aallele[$i-9][$nlines] = "S"}
      else {die "Bases other than ATCG found in file"}; #If something other than the previous 12 lines; program dies
    }
    if (($Aallele[$i-9][$nlines] eq ".") and ($Ballele[$i-9][$nlines] eq ".")) {$Aallele[$i-9][$nlines] = "?"} #convert ./. to "?", missing data in nexus file; change if you want a different character as missing data
}
  $nlines++;
}
close FH;

print "#NEXUS\nBegin data;\nDimensions ntax=".($totalcolumns-8)." nchar=$nlines;\nFormat datatype=dna missing=? gap=-;\nMatrix\n\n"; #Header for NEXUS file; change "?" if you want a different character as missing data
for my $i (0..$totalcolumns-9) {
  print "$hdr[$i+9]     ", join("",@{$Aallele[$i]}), "\n";
}
print ";\nEND;";
}
