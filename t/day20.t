#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

require "./src/day20.pl";

is_deeply(main::factors(18), [1, 2, 3, 6, 9, 18], "factors");
is(main::presents(10, factors(18)), 390, "house numer 18 gets 390 presents");

done_testing();

