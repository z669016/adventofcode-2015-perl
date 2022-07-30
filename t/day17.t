#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

require "./src/day17.pl";

my @data = (20, 15, 10, 5, 5);
is(main::count(25, @data), 4, "count");
is(main::min_depth(0, 25, @data), 2, "min_depth");
is(main::count_with_max(2, 25, @data), 3, "count_with_max");

done_testing();

