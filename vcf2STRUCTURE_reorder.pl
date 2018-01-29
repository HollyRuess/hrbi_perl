#!/usr/bin/perl 
#####################################################################################################################################################   
###  title          : vcf2STRUCTURE_reorder.pl                                                                                                    ###
###  description    : This perl program converts a vcf file (created by tassel5 and filtered by vcftools) into a Structure                        ###
###                     format (STRUCTURE 2 line format, A=1,C=2,G=3,T=4,missing=-9)                                                              ###
###  author	        : Holly Ruess (Holly.Ruess@ars.usda.gov)                                                                                      ###
###  date           : 01-29-2018                                                                                                                  ###
###  version        : 1                                                                                                                           ###   
###  notes          : vcf can be compressed. <input_order> is optional; format is the list of names (found in the vcf file), reordered            ###
###  usage          : vcf2STRUCTURE.pl input.vcf.gz <input_order> >output.str                                                                     ###
#####################################################################################################################################################
use strict; use warnings;

my ($vcf, $order) = @ARGV;

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
  next if ($lines =~ m/^##/);
  my @col = split (/\t/, $lines);
  if ($lines =~ /#/) {$totalcolumns = scalar @col -1; @hdr=@col}
  next if ($lines =~ m/^#/);
  for my $i (9..$totalcolumns) {
    ($Aallele[$i-9][$nlines], $Ballele[$i-9][$nlines]) = $col[$i] =~ /^([\d.])\/([\d.])/; #Find the alleles for each line
    if ($Aallele[$i-9][$nlines] eq "0") {$Aallele[$i-9][$nlines] = $col[3]} #covert the "01" into ref or alt bases, 1st allele
    elsif ($Aallele[$i-9][$nlines] eq "1") {$Aallele[$i-9][$nlines] = $col[4]} #covert the "01" into ref or alt bases, 1st allele
    if ($Ballele[$i-9][$nlines] eq "0") {$Ballele[$i-9][$nlines] = $col[3]} #covert the "01" into ref or alt bases, 2nd allele
    elsif ($Ballele[$i-9][$nlines] eq "1") {$Ballele[$i-9][$nlines] = $col[4]} #covert the "01" into ref or alt bases, 2nd allele
    if ($Aallele[$i-9][$nlines] eq ".") {$Aallele[$i-9][$nlines] = -9 }
    elsif ($Aallele[$i-9][$nlines] eq "A") {$Aallele[$i-9][$nlines] = 1 }
    elsif ($Aallele[$i-9][$nlines] eq "C") {$Aallele[$i-9][$nlines] = 2 }
    elsif ($Aallele[$i-9][$nlines] eq "G") {$Aallele[$i-9][$nlines] = 3 }
    elsif ($Aallele[$i-9][$nlines] eq "T") {$Aallele[$i-9][$nlines] = 4 }
    if ($Ballele[$i-9][$nlines] eq ".") {$Ballele[$i-9][$nlines] = -9 }
    elsif ($Ballele[$i-9][$nlines] eq "A") {$Ballele[$i-9][$nlines] = 1 }
    elsif ($Ballele[$i-9][$nlines] eq "C") {$Ballele[$i-9][$nlines] = 2 }
    elsif ($Ballele[$i-9][$nlines] eq "G") {$Ballele[$i-9][$nlines] = 3 }
    elsif ($Ballele[$i-9][$nlines] eq "T") {$Ballele[$i-9][$nlines] = 4 }
  }
  $nlines++;
}
close FH;

if (defined $order) {
  if (-e $order) {open(FH2, "$order") or die;} {
  while (<FH2>) {
    chomp;
    my ($lines2) = split (/\n/);
    for my $i (0..$totalcolumns-9) {
      if ($lines2 eq $hdr[$i+9]) {
        print "$hdr[$i+9]\t.\t.\t.\t.\t.\t", join("\t",@{$Aallele[$i]}), "\n";
        print "$hdr[$i+9]\t.\t.\t.\t.\t.\t", join("\t",@{$Ballele[$i]}), "\n";
      }
    }
  }
  close FH2;
  }
} 

else {
  for my $i (0..$totalcolumns-9) {
    print "$hdr[$i+9]\t.\t.\t.\t.\t.\t", join("\t",@{$Aallele[$i]}), "\n";
    print "$hdr[$i+9]\t.\t.\t.\t.\t.\t", join("\t",@{$Ballele[$i]}), "\n";
  }
}

}
