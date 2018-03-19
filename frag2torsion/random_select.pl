use strict;
use warnings;

my $input_file= shift; #"/home/siva/Documents/programs/DeepCov/result.txt";
my $output_file = shift; #"/home/siva/Documents/programs/DeepCov/result_precision.txt";
my $start=" position";
my $postion = int(rand(124));
print "random_postion:".$postion, "\n";;
my $model_20 = int(rand(20));
print "random_model:".$model_20, "\n";;
my $fnd = 0;
my $i =0;
open OUT, '>', $output_file or die "Failed to write $output_file\n";
open IN, '<', $input_file or die "Failed to read $input_file\n";
while(<IN>){
  my $current_line = $_;
  if($fnd == 1){
    if ($current_line =~ /^$/){
      $i = $i+1;
    }
    if($i == $model_20){
      print "$model_20\n";
      for( my $a = 0; $a < 10; $a = $a + 1 ) {
         my $next_line =<IN>;
         print OUT $next_line;
      }
      $fnd=0;
      last;
    }
  }
  else{
    if($current_line =~ /^$start/){
      $current_line =~ s/^\s+|\s+$//g;
      my @pos_info = split /\s+/, $current_line;
      my $pos = $pos_info[1];
      print "$pos\n";
      if($pos_info[1] == $postion){
        print OUT $current_line."\n";
        print OUT "\n";
        $fnd =1;
      }
    }
  }
}

close OUT;
close IN;
