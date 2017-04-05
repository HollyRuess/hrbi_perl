# hrbi_perl
Perl programs developed as bioinformatics tools.

# MDtag_parse.pl

Takes the cigar string in a bam file and calculates the mapped read length; keeps only those reads whose mapped length is greater than 50% of read length.

# vcf2nexus.pl

This perl program converts a vcf file (created by tassel5 and filtered by vcftools) into a NEXUS file. The vcf file can be compressed. Missing data is coded as "?".
