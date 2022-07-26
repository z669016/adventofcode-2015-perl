#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

require "./src/day10.pl";

is(main::encode("1"), "11");
is(main::encode("11"), "21");
is(main::encode("21"), "1211");
is(main::encode("1211"), "111221");
is(main::encode("111221"), "312211");

is(main::encode("1", 5), "312211");

done_testing();

