#!/usr/bin/perl
use strict;
use warnings;

my(%genetic_code) = ( #hash file named genetic_code with 'XXX'->keys and 'X'->values.    
    'TCA' => 'S',    # Serine
    'TCC' => 'S',    # Serine
    'TCG' => 'S',    # Serine
    'TCT' => 'S',    # Serine
    'TTC' => 'F',    # Phenylalanine
    'TTT' => 'F',    # Phenylalanine
    'TTA' => 'L',    # Leucine
    'TTG' => 'L',    # Leucine
    'TAC' => 'Y',    # Tyrosine
    'TAT' => 'Y',    # Tyrosine
    'TAA' => '_',    # Stop
    'TAG' => '_',    # Stop
    'TGC' => 'C',    # Cysteine
    'TGT' => 'C',    # Cysteine
    'TGA' => '_',    # Stop
    'TGG' => 'W',    # Tryptophan
    'CTA' => 'L',    # Leucine
    'CTC' => 'L',    # Leucine
    'CTG' => 'L',    # Leucine
    'CTT' => 'L',    # Leucine
    'CCA' => 'P',    # Proline
    'CCC' => 'P',    # Proline
    'CCG' => 'P',    # Proline
    'CCT' => 'P',    # Proline
    'CAC' => 'H',    # Histidine
    'CAT' => 'H',    # Histidine
    'CAA' => 'Q',    # Glutamine
    'CAG' => 'Q',    # Glutamine
    'CGA' => 'R',    # Arginine
    'CGC' => 'R',    # Arginine
    'CGG' => 'R',    # Arginine
    'CGT' => 'R',    # Arginine
    'ATA' => 'I',    # Isoleucine
    'ATC' => 'I',    # Isoleucine
    'ATT' => 'I',    # Isoleucine
    'ATG' => 'M',    # Methionine
    'ACA' => 'T',    # Threonine
    'ACC' => 'T',    # Threonine
    'ACG' => 'T',    # Threonine
    'ACT' => 'T',    # Threonine
    'AAC' => 'N',    # Asparagine
    'AAT' => 'N',    # Asparagine
    'AAA' => 'K',    # Lysine
    'AAG' => 'K',    # Lysine
    'AGC' => 'S',    # Serine
    'AGT' => 'S',    # Serine
    'AGA' => 'R',    # Arginine
    'AGG' => 'R',    # Arginine
    'GTA' => 'V',    # Valine
    'GTC' => 'V',    # Valine
    'GTG' => 'V',    # Valine
    'GTT' => 'V',    # Valine
    'GCA' => 'A',    # Alanine
    'GCC' => 'A',    # Alanine
    'GCG' => 'A',    # Alanine
    'GCT' => 'A',    # Alanine
    'GAC' => 'D',    # Aspartic Acid
    'GAT' => 'D',    # Aspartic Acid
    'GAA' => 'E',    # Glutamic Acid
    'GAG' => 'E',    # Glutamic Acid
    'GGA' => 'G',    # Glycine
    'GGC' => 'G',    # Glycine
    'GGG' => 'G',    # Glycine
    'GGT' => 'G',    # Glycine
    );

my @keys=keys(%genetic_code); #makes an array named keys that has the keys of the genetic_code hash.

open(IN,"<DNA_seq.txt") or die ("Input file not opened");

#declare variables.
my $title=<IN>; #reads the very first line of the text file.
my $protein='';
my $protein1='';
my $protein2='';
my $dna=''; #declare $dna string &empty string to concatenate to later.

# read the whole text and combine all lines together to one sequence.
while (my $seq=<IN>) {
    chomp($seq);
    $dna=$dna.$seq; #combines (.) the $seq lines with the dna ones.
}

#start "translation"   
my $i='';   
for ($i=0;$i<=length($dna)-3;$i=$i+3) { #reads from start/1st nucleotide per 3 nucleotides.
    my $codon='';
    $codon=substr($dna,$i,3);
    if ($codon eq 'TGA' or $codon eq 'TAG' or $codon eq 'TAA') {
        last;
    }
    my $genetic_code=$genetic_code{$codon};
    $protein=$protein.$genetic_code;       
}
for ($i=1;$i<=length($dna)-3;$i=$i+3) { #reads at frame from 2nd nucleotide per 3 nucleotides.
    my $codon1='';
    $codon1=substr($dna,$i,3);
    if ($codon1 eq 'TGA' or $codon1 eq 'TAG' or $codon1 eq 'TAA') {
        last;
    }
    my $genetic_code=$genetic_code{$codon1};
    $protein1=$protein1.$genetic_code;       
}
for ($i=2;$i<=length($dna)-3;$i=$i+3) { #reads at frame from 3rd nucleotide per 3 nucleotides.
    my $codon2='';
    $codon2=substr($dna,$i,3);
    if ($codon2 eq 'TGA' or $codon2 eq 'TAG' or $codon2 eq 'TAA') {
        last;
    }
    my $genetic_code=$genetic_code{$codon2};
    $protein2=$protein2.$genetic_code;       
}
    
print "Protein with reading frame from 1st nucleotide is:\n $protein\n";
print "Protein with reading frame from 2nd nucleotide is:\n $protein1\n";
print "Protein with reading frame from 3rd nucleotide is:\n $protein2\n";

close(IN); #closes the text file.

my $line=<STDIN>; #keeps .exe open til I press enter.



#my @proteins = map { $codes =~ /^.{$_}((?:...)*?)(?=TAA|TAG|TGA|.{0.2}$)/ } 0..2;
#my @proteins = map { $codes =~ /^.{$_}(?:...)*ATG((?:...)*?)(?=TAA|TAG|TGA|.{0.2}$)/ } 0..2;  # should start at ATG (untested)
#s/(...)/$genetic_code{$1}/g for @proteins;  # to fix up codes with values