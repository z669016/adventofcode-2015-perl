#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Data::Dumper;

require "./src/day14.pl";

my @data = (
    "Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.",
    "Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.",
);
@data = map {main::mapper($_)} @data;

my $result = main::race(\@data, 1);
is($$result{Comet}[2], 14, "Comet after 1 sec");
is($$result{Dancer}[2], 16, "Dancer after 1 sec");
is($$result{Comet}[3], 0, "Comet points after 1 sec");
is($$result{Dancer}[3], 1, "Dancer points after 1 sec");

$result = main::race(\@data, 10);
is($$result{Comet}[2], 140, "Comet after 10 sec");
is($$result{Dancer}[2], 160, "Dancer after 10 sec");

$result = main::race(\@data, 11);
is($$result{Comet}[2], 140, "Comet after 11 sec");
is($$result{Dancer}[2], 176, "Dancer after 11 sec");

$result = main::race(\@data, 1000);
is($$result{Comet}[2], 1120, "Comet after 1000 sec");
is($$result{Dancer}[2], 1056, "Dancer after 1000 sec");
is($$result{Comet}[3], 312, "Comet points after 1000 sec");
is($$result{Dancer}[3], 689, "Dancer points after 1000 sec");

is(main::max_distance($result), 1120, "max distance");

done_testing();

