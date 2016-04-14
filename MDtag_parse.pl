#!/usr/bin/perl
use strict; use warnings;
#parse bam file based on MD tag length/read length should be >50%
###USAGE
### samtools view -H bamfile.bam >header.sam
### samtools view bamfile.bam | perl MDtag_parse.pl | cat header.sam -  | samtools view -Sb - >newbamfile.bam


while (my $lines = <>) {
    if ($lines =~ m/^@/)                    {print "$lines"};
    next if ($lines =~ m/^@/);
    my @col = split (/\t/, $lines);
    my ($seq_length) = length($col[9]);
    next if ($col[5] =~ m/X/);
    my $aligned_length = 0;
    if ($col[5] =~ m/=/)                    {$aligned_length = $seq_length;}
    while ($col[5] =~ m/(\d+)[MI]/g)        {$aligned_length += $1;}
    if ($aligned_length/$seq_length >= 0.5) {print "$lines";}
}
