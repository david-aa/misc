#!/usr/bin/perl
use strict;
my @input = ("This", "is", "an", "array");
my $max = 4;
for (my $x=0; $x<=$max; $x++) {
    printf("Index: %d // Value: %s\n", $x, $input[$x]);
}
printf "Goodbye, I'm Perl!\n";
