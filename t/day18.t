#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

require "./src/day18.pl";

my @lines = (
    ".#.#.#",
    "...##.",
    "#....#",
    "..#...",
    "#.#..#",
    "####..",
);

my @lines_broken = (
    "##.#.#",
    "...##.",
    "#....#",
    "..#...",
    "#.#..#",
    "####.#",
);
my @data = map {main::mapper($_)} @lines;
my $data = \@data;
foreach (1..4) {
    $data = main::step($data, \&main::strategy1);
}
is(main::count_lights($data), 4, "4 lights after 4 turns");

@data = map {main::mapper($_)} @lines_broken;
$data = \@data;
foreach my $i (1..5) {
    $data = main::step($data, \&main::strategy2);
}
is(main::count_lights($data), 17, "17 lights after 5 turns with broken board strategy");

done_testing();

