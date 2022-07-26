#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use AOC::Input;

sub wrapping {
    my $size = shift;
    my ($length, $width, $height) = sort {$a <=> $b } @$size;
    my @surfaces = sort {$a <=> $b }($length * $width, $length * $height, $width * $height);

    my $paper = 2 * $surfaces[0] + 2 * $surfaces[1] + 2 * $surfaces[2] + $surfaces[0];
    my $ribbon = (2 * $length) + (2 * $width) + ($length * $width * $height);

    ($paper, $ribbon);
}

my $paper = 0;
my $ribbon = 0;
my $input = AOC::Input::load("./resources/input-2.csv", {'sep_char' => 'x'});
foreach (@$input) {
    my ($p,$r) = wrapping($_);
    $paper += $p;
    $ribbon += $r;
}

print "day 2, part 1: square feet of wrapping paper is $paper\n";
print "day 2, part 2: feet of ribbon is $ribbon\n";