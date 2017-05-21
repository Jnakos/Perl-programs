#!/usr/bin/perl

use strict;
use warnings;

# Hydrophobicity table based on Doolittle.
my %hydro = ('A' =>  "1.800",
             'C' =>  "2.500",
             'D' => "-3.500",
             'E' => "-3.500",
             'F' =>  "2.800",
	     	 'G' => "-0.400",
             'H' => "-3.200",
             'I' =>  "4.500",
             'K' => "-3.900",
             'L' =>  "3.800",
	     	 'M' =>  "1.900",
             'N' => "-3.500",
             'P' => "-1.600",
             'Q' => "-3.500",
             'R' => "-4.500",
	     	 'S' => "-0.800",
             'T' => "-0.700",
             'V' =>  "4.200",
             'W' => "-0.900",
             'Y' => "-1.300"
	     );


open (IN, "<p07550.txt") or die ($!);
open (OUT, ">TMCompare.txt") or die ($!);

# IDENTIFYING THE PROTEIN SEQUENCE FROM UNIPROT FILE.
my $proteinseq;

while (<IN>) {
    if (m/^ID\s+(\S+)/g) {
	print OUT "ID: $1\n";
    }
}
close (IN);

open (IN, "<p07550.txt") or die ($!);

while (<IN>) {
    if (/^SQ /) { 		# pattern match to recognise when the part of sequence starts. Since $_ reads per line all this line is skipped.
        last; 
    }
}
while (<IN>) {
    if (m/^\/\//) { 		# pattern matching to scan for the last line of the file that contains //. File is what remained from the precious while loop.
        last;
    }
    my @aminoacids = split ( /\s+/, $_ ); 		# splits the text where if finds more more than 0 spaces and inputs into an array.
    my $seq = join ( '' , @aminoacids ); 		# Joins the separate strings of LIST into $seq with fields separated with non-width character ('').
    $proteinseq .= $seq; 				# adds together all characters of $seq into a new string named $protein.    
}
print OUT "$proteinseq :SEQUENCE. Length: ";
print OUT length($proteinseq);
print OUT "\n";

close (IN);

#IDENTIFYING TRANSMEMBRANE PARTS FROM UNIPROT FILE.

open (IN, "p07550.txt") or die ($!);
open (OUT, ">>TMCompare.txt") or die ($!);

my @transitions;

while (<IN>) {
    if (m/^FT\s{3}TRANSMEM\s+(\d+)\s+(\d+)\s/) { 	# pattern matching so that it "saves" the residues at which the protein goes in and goes out of the membrane, based on uniprot file syntax.
        push @transitions, [$1, $2];			# makes an anonymous pair array with arrays as values. Each one containing the places where the protein goes IN the membrane and comes OUT of it. 
    }
}

close (IN);

#INCLUDING FIRST AND LAST AMINOACIDS THAT ARE SKIPPED DUE TO PROCESSES OF PREDICTION.

my @proteinpred;

for (my $aastart = 0 ; $aastart <= 11 ; $aastart++)
{
	$proteinpred[$aastart] = '-';
}
for (my $aaend = (length($proteinseq)-1) ; $aaend >= ((length($proteinseq)-1)-12) ; $aaend--)
{
	$proteinpred[$aaend] = '-';
}

#CALCULATING AVERAGE HYDROPHOBICITY.

my $sum = 0;

for ( my $i=0; $i <= length($proteinseq)-25; $i++) {
    my $seqparts = substr ($proteinseq, $i, 25); 	# reads smaller parts of each protein, each 25 aa long. substr (expr/of what is it a substr, starts from, length of substr).
    my @ protparts = split '', $seqparts; 		# makes array that contains all protein sequence in 25-aminoacid parts.
    
    for ( my $k=0; $k <= $#protparts; $k++) { 		# runs/reads the whole @seqparts array.
	my $aminoacids = $protparts[$k]; 		# asigns $aminoacids to @seqparts values.
	my $hydrovalue = $hydro {$aminoacids}; 		# asigns the hydrophibicity value of each aminoacid (keys of hash).
	$sum = $sum + $hydrovalue; 			# sums up all values of hydrophobocity of each 25aminoacid long area.
    }
    
    my $average = $sum/25;				#average score of hydophobicity of each 25 aminoacid long "tamplate"/"window".
    $sum = 0;						#returns sum to original value, so that the result doesn't add up.
    
#PREDICTION OF TRANSMEMBRANE PARTS OF THE PROTEIN.

    if ($average > 1){				# Hydrophobes since average of hydophobicity>1 according to the board.
	$proteinpred[$i+12] = 'M';
    }

    elsif ($average <= 1){			# Non-hydrophobes since average of hydophobicity<=1 according to the board.
	$proteinpred[$i+12] = '-';
    }
}
my $count=@proteinpred;				# Saves number of indexes of @proteinpred in a value. 
print OUT @proteinpred;				# Prints out the prediction on transmembrane parts.
print OUT " :PREDICTED. Length: ";
print OUT "$count";
print OUT "\n";

#OBSERVED TRANSMEMBRANE PARTS.

my $column = 1;					# Declare $column outside of loop, so that it doesn't start from '1' inside the loop, and maintain its final value after the loop ends.
for my $transition (@transitions) {		# Assigns each pair of values of @transitions to $transitions. 
    my ($in, $out) = @$transition;		# Takes $transition and transforms it to an array (@transition) and asigns values to $in and $out.
    $out++;

    print OUT '-' x ($in - $column), 'M' x ($out - $in);	# x makes the string repeat itself. So for every ($in-$column) it asigns '-' and for ($out - $in) 'M'. 
    $column = $out;						# Asigns $column to $out so that $column gradually changes, for the array to be read. 
}

print OUT '-' x (length($proteinseq) + 1 - $column);		# For the rest of the length of the protein it prints "-". +1 because of the change in $out for the first index of @transitions
print OUT " :OBSERVED. Length: ";
print OUT "$count";
