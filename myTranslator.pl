#!/usr/bin/perl
use warnings; 
use lib "/Users/Misha/Desktop/SVG-2.64/lib";
use SVG;
#use strict; 

$filename = '/Users/Misha/Desktop/Perlassignment/cells-phones.csv';
 
print <<EOF
<!DOCTYPE html>
<html>
<head>
    <h1>Analysis of Cell Phone Types at 3 Different Universities</h1>
</head>
<body style="background-color:#E9E0D6;">
<table>
EOF
;


open(FILE, $filename) or die "Cannot open $filename";

$_=<FILE>;

@array=split(/,/,$_); #get the table header information
print "<tr>\n";
foreach (@array){ #output table columns
    
    print "<th style='background-color:#EB7260; padding:10px; color:#ffffff;'>$_</th>";
}
 
while (<FILE>){ #read line by line from the file
@array=split(/,/,$_);

next if (length($array[0])<=0); #skip line since there is no info here.
next if($_ =~ m/#/);
chomp($_);

print "<tr>\n";
foreach (@array){ #output table columns
    print "<td style='text-align:center;'>$_</td>";
}
print "</tr>\n";
} #end while loop

#close table and then open another table to contain only the number values in the file
print <<EOF
</table>
<table>
EOF
;

open(FILE, $filename) or die "Cannot open $filename";

$_=<FILE>;


#get the table header information
@array=split(/,/,$_); 
print "<tr>\n";

#prints out the header, number
print "<th style='background-color:#EB7260; padding:10px; color:#ffffff;'>$array[2]</th>";
  
#initializaing the counter variables
$sum = 0;
$counter1 = 0;
$counter2 = 0;
$counter3 = 0;

while (<FILE>){ #read line by line from the file
(@array) = split(/,/,$_);

    next if (length($array[0])<=0); #skip line since there is no info here.
    next if($_ =~ m/#/);
    chomp($_);

    foreach($array){
        $sum = $sum + $array[2];
        
        #represents the number of ios users from all 3 schools
        if($array[1] =~ m/ios/){
            $counter1 = $counter1 + $array[2];
        }
        #represents the number of windows users from all 3 schools
        elsif($array[1] =~ m/windows/){
            $counter2 = $counter2 + $array[2];
        }
        #represents the number of android users from all 3 schools
        else{
            $counter3 = $counter3 + $array[2];
        }
    }
    
    #prints out the number values from the file in a column
    print "<tr>\n";
    print "<td style='text-align:center;'>$array[2]</td>";
    print "</tr>\n";


} #end while loop


print "<tr>\n";
print "<td>Total Number of Users: $sum</td>";
print "</tr>\n";

print "<tr>\n";
print "<td style='color:#354458'>Total Number of iOS Users: $counter1</td>";
print "</tr>\n";


print "<tr>\n";
print "<td style='color:#77C5F7'>Total Number of Windows Users: $counter2</td>";
print "</tr>\n";

print "<tr>\n";
print "<td style='color:#0071BC'>Total Number of Android Users: $counter3</td>";
print "</tr>\n";



print <<EOF
</table>
<table>
EOF
;

# create an SVG object with a size of 400x400 pixels
$svg = SVG->new(width  => 400, height => 400,);

$svg->text(x=>60, y=>40, style=>
  {'font-family'=>'Verdana', 'font-style'=>'bold'})->cdata('iOS Users');
  
$svg->text(x=>160, y=>150, style=>
  {'font-family'=>'Verdana', 'font-style'=>'bold'})->cdata('Windows Users');
  
$svg->text(x=>260, y=>250, style=>
  {'font-family'=>'Verdana', 'font-style'=>'bold'})->cdata('Android Users');

$svg->circle(cx => 100,cy => 100,r => $counter1/2, style => {
        'fill'           => '#354458',
        'stroke'         => '#EB7260',
        'stroke-width'   =>  2,
        'stroke-opacity' =>  1,
        'fill-opacity'   =>  1,});

$svg->circle(cx => 200,cy => 200,r => $counter2/2, style => {
        'fill'           => '#77C5F7',
        'stroke'         => '#EB7260',
        'stroke-width'   =>  2,
        'stroke-opacity' =>  1,
        'fill-opacity'   =>  1,});

$svg->circle(cx => 300,cy => 300,r => $counter3/2, style => {
        'fill'           => '#0071BC',
        'stroke'         => '#EB7260',
        'stroke-width'   =>  2,
        'stroke-opacity' =>  1,
        'fill-opacity'   =>  1,});

# now render the SVG object, implicitly use svg namespace
print $svg->xmlify, "\n";


print <<EOF
</table>
</body>
</html>
EOF
;