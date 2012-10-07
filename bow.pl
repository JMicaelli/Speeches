use strict;

my $stop = {};
open STOP_FH, "/Users/pnichols/Desktop/UCSD/Project-Release/transform/topic/stoplists/en.txt" or die;
while (my $s = <STOP_FH>) {
  chomp($s);
  $stop->{$s} = 1;
}
close STOP_FH;

my $words = {};
for my $person (qw(Obama Romney)) {
  for my $f (glob("$person/*.txt")) {
    open FH, $f or die;
    my $d = lc(join("", <FH>));
    close FH;
    for my $w (split(/\W+/, $d)) {
      next if $stop->{$w} or $w =~ /^\d+$/;
      $words->{$person}->{$w} += 1;
    }
  }
  my $n = 0;
  print "\nTop $person words:\n";
  for my $w (sort {$words->{$person}->{$b} <=> $words->{$person}->{$a}} keys(%{$words->{$person}})) {
    print "$w\t$words->{$person}->{$w}\n";
    last if ++$n > 10;
  } 
}


