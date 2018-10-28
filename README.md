# hrbi_perl
Perl programs developed as bioinformatics tools.

# MDtag_parse.pl

Takes the cigar string in a bam file and calculates the mapped read length; keeps only those reads whose mapped length is greater than 50% of read length.

# vcf2nexus.pl

This perl program converts a vcf file (created by tassel5 and filtered by vcftools) into a NEXUS file. The vcf file can be compressed. Missing data is coded as "?".

# SNPfilter4ML.pl

This perl program filters a vcf file of SNPs so that the ascertainment bias of Maximum Likelihood may be applied. The filters are either 1) at least 1 homozygous reference SNP, at least 1 homozygous alternate SNP, and at least and 1 heterozygous SNP, 2) if no heterozygous SNPs, then at least 2 homozygous reference SNPs and 2 homozygous alternate SNPs.

# vcf2STRUCTURE_reorder.pl 
This perl program converts a vcf file (created by tassel5 and filtered by vcftools) into a reordered (optional) Structure format (STRUCTURE 2 line format, A=1,C=2,G=3,T=4,missing=-9). 

# SNPcoverage.pl
This perl program finds the average coverage of the SNPs for each accession (minus missing data) in a vcf file.
VCF file can be compressed or uncompressed.

# haplotype_count.pl
This perl program counts the number of times each haplotype appears in vcf file (per accession). 
Haplotypes are ./., 0/0, 0/1, 1/0, 1/1, or other. VCF file can be compressed or uncompressed.

###
