#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Exception;

use Data::Dumper;

require "./src/day15.pl";

my @data = (
    "Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8",
    "Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3",
);
@data = map {main::mapper($_)} @data;

my @combination = (1, 2);
dies_ok {main::scores(\@data, \@combination)} "must add up to 100 tea spoons";
is((main::score(\@data, [44, 56]))[0], 62842880, "scores");
is((main::highest_score(\@data))[0], 62842880, "highest score");
is((main::highest_score(\@data, [], 500))[0], 57600000, "highest score with max 500 calories");

done_testing();

