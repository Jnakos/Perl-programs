#! usr/bin/perl -w

print "Input name of designated file (but please make sure it's in the same folder as the program...): ";
$file=<>; #String of the given by the user input.
chomp $file;
open (IN, "$file") or die ('Sorry buddy, but you did something wrong with your file!');

$lines=0;
while (<IN>) {
	if ($_=~m/^ATOM\s+\d+\s+(\w+)\s+\w+\s+\w+\s+\d+\s+(\S+)\s+(\S+)\s+(\S+)/){ #how to read pdb file. Space/word/space/word/digit etc till it finds coordinates.
		$xcoord+=$2; #assign value to 1st coord.
		$ycoord+=$3; #assign value to 2nd coord.
		$zcoord+=$4; #assign value to 3rd coord.
		$elemname=$1; #assign name to each element.
		push(@xarray,$2); #array with all x values.
		push(@yarray,$3); #array with all y values.
		push(@zarray,$4); #array with all z values.
		push (@elemname,$1); #array with all elements names.
		$total=$lines++; #adds up so that $total is the total number of lines.	
	}	
}
print "$total";
$xcentre=$xcoord/$total; #xSUM
$ycentre=$ycoord/$total; #ySUM
$zcentre=$zcoord/$total; #zSUM

print "Input desired distance in Angstroms: ";
$distanceinput=<>; #variable at which the distance is assigned by the user.
chomp ($distanceinput);

print "Atoms inside the sphere of $distanceinput Angstroms or outside? Input INSIDE or OUTSIDE: ";
$inout=<>;
chomp $inout;

#calculates the atoms that are outside of the sphere.
if ($inout eq OUTSIDE) { #Atoms outside of the given sphere are selected.
for ($value=0;$value<=$#xarray;$value++){ #conditions: start from 0;read till the last value of array "xarray";read by 1.
	
	$xfinal=($xcentre-$xarray[$value])**2; #calculates (x1-x2)^2.
	$yfinal=($ycentre-$yarray[$value])**2; #calculates (y1-y2)^2.
	$zfinal=($zcentre-$zarray[$value])**2; #calculates (z1-z2)^2.
	$distance=sqrt($xfinal+$yfinal+$zfinal); #calculates final distance.
	
		if($distanceinput<=$distance) {	#condition so that it shows us only the atoms that are in a distance less than the given. 	
		print "$elemname[$value]\n"; #prints the names of the elements that are in a distance smaller than the desired. 
		}
	}
}

#calculates the atoms that are inside of the sphere.
else { #Atoms inside of the given sphere are selected.
for ($value=0;$value<=$#xarray;$value++){ #conditions: start from 0;read till the last value of array "xarray";read by 1.
	
	$xfinal=($xcentre-$xarray[$value])**2; #calculates (x1-x2)^2.
	$yfinal=($ycentre-$yarray[$value])**2; #calculates (y1-y2)^2.
	$zfinal=($zcentre-$zarray[$value])**2; #calculates (z1-z2)^2.
	$distance=sqrt($xfinal+$yfinal+$zfinal); #calculates final distance.
	
		if($distanceinput>=$distance) {	#condition so that it shows us only the atoms that are in a distance less than the given. 	
		print "$elemname[$value]\n"; #prints the names of the elements that are in a distance smaller than the desired. 
		}
	}
}

close IN; #close text file.
$stayopen=<>; #command so that the program remains open 'til the user hit a key.
chomp $stayopen;
