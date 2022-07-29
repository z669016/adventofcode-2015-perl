#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

require "./src/day13.pl";

my @lines = (
    "Alice would gain 54 happiness units by sitting next to Bob.",
    "Alice would lose 79 happiness units by sitting next to Carol.",
    "Alice would lose 2 happiness units by sitting next to David.",
    "Bob would gain 83 happiness units by sitting next to Alice.",
    "Bob would lose 7 happiness units by sitting next to Carol.",
    "Bob would lose 63 happiness units by sitting next to David.",
    "Carol would lose 62 happiness units by sitting next to Alice.",
    "Carol would gain 60 happiness units by sitting next to Bob.",
    "Carol would gain 55 happiness units by sitting next to David.",
    "David would gain 46 happiness units by sitting next to Alice.",
    "David would lose 7 happiness units by sitting next to Bob.",
    "David would gain 41 happiness units by sitting next to Carol.",
);

my @happiness = map {&$main::mapper($_)} @lines;

my $guests = main::guests(\@happiness);
my $happiness = main::happiness_hash(\@happiness);

is(main::max_happiness_sum($guests,$happiness), 330, "max happiness sum");

done_testing();

