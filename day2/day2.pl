#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

sub wrapping {
    my ($length, $width, $height) = sort {$a <=> $b } @_;
    my @surfaces = sort {$a <=> $b }($length * $width, $length * $height, $width * $height);

    my $paper = 2 * $surfaces[0] + 2 * $surfaces[1] + 2 * $surfaces[2] + $surfaces[0];
    my $ribbon = (2 * $length) + (2 * $width) + ($length * $width * $height);

    ($paper, $ribbon);
}

my $file_name = "input-2.txt";
my $paper = 0;
my $ribbon = 0;
open STDIN, "<", $file_name or die "Could not open $file_name: $!";
while (<STDIN>) {
    chomp;
    my @size = split /x/;
    my ($p,$r) = wrapping(@size);
    $paper += $p;
    $ribbon += $r;
}

print "day 2, part 1: square feet of wrapping paper is $paper\n";
print "day 2, part 2: feet of ribbon is $ribbon\n";