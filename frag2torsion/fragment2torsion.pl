#!/usr/bin/perl -w
use POSIX;
#use strict;
#use warnings;
use Carp;
use Cwd 'abs_path';
#use File::Basename;
#use Getopt::Long;
if (@ARGV != 4 ) {
  print "Usage: <input> <output>\n";
  exit;
}

my $frag = $ARGV[0];
my $fragment_file = $ARGV[1]; # fragment file # /storage/htc/bdm/Collaboration/jh7x3/Abinitio_casp13/Fragsion/input/Fragment/
my $torsion_file_out = $ARGV[2]; # initial torsion file # /storage/htc/bdm/Collaboration/jh7x3/Abinitio_casp13/Fragsion/input/Torsion/
my $torsion_file_new = $ARGV[3]; # initial torsion file # /storage/htc/bdm/Collaboration/jh7x3/Abinitio_casp13/Fragsion/input/Torsion/
#my $N = $ARGV[3]; # initial torsion file # /storage/htc/bdm/Collaboration/jh7x3/Abinitio_casp13/Fragsion/input/Torsion/

####################################################################################################
`perl random_select.pl $frag $fragment_file`;

my $N;
#$n=5; # neighbor number

####### fragment to torsion #############33
open(IN,"$fragment_file") || die "Failed to open file $fragment_file\n"; # opining the fragment file
  @content = <IN>;
  close IN;

foreach $line (@content){ # finding the corresponding fragment
      $line =~ s/^\s+|\s+$//g;
			if($line){
       @string=split(/\s+/,$line);
       if($string[0] eq "position:"){
         $N = $string[1];
         print "N:$N\n";
       }
       if($string[0] eq "xxxx"){
				  $var=$string[3]." ".$string[5]." ".$string[6];
				  push(@table, "$var");
			   }
      }
		}
####### update torsion #############33
open(OUT1,">$torsion_file_new")or die "Couldn't write torsion file file, $!"; # opening the output file
open(IN1,"<$torsion_file_out") || die "Failed to open file $fragment_file\n"; # opining the fragment file
  #@content1 = <IN1>;

  $count=1;
  $ref=$N+9;# position plus 9 since fragment is 10 residues long
  while(<IN1>){ # print from first line to start position of fragment
  print OUT1 "$_";
  $count=$count+1;
  #print "count $count\n";
  last if $count== $N;
  }
  print OUT1 join("\n",@table),"\n"; # print the new lines
 $count1=0;
 print "ref $ref\n";
close IN1;
open(IN2,"<$torsion_file_out") || die "Failed to open file $fragment_file\n"; # opining the fragment file

while(<IN2>){ # print the remaining lines
  $count1=$count1+1;
  #print "count1 $count1\n";
  if($count1<=$ref){
    next;
  }else{
    print OUT1 "$_";
   }

  }
 close IN2;
 close OUT1;
#
