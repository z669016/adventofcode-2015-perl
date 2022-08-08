#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

require "./src/day25.pl";

is_deeply(main::input(), [3029, 2947], "read input");
is(main::xy_index(2, 4), 12, "Index of (2, 4) is 12");
is(main::xy_index(5, 2), 20, "Index is (5, 2) is 20");
is(main::xy_index(4, 3), 19, "Index is (4, 3) is 19");

done_testing();

