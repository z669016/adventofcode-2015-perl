#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

require "./src/day24.pl";

my @numbers = (1, 2, 3, 4, 5, 7, 8, 9, 10, 11);
is(main::container_size(\@numbers), 20, "Container size if 3");
is(main::container_size(\@numbers, 4), 15, "Container size if 4");

my $combinations = main::combinations(20, \@numbers);
is(@$combinations, 25, "25 combinations of 20");

is (main::smallest($combinations), 2, "smallest is 2");
is (main::smallest_quantum($combinations), 99, "smallest quantum is 99");

@numbers = (1, 2, 3, 4, 5, 7, 8, 9, 10, 11);
$combinations = main::combinations(60, \@numbers);
is(@$combinations, 1, "1 combinations of 60");

# @numbers = (1, 2, 3, 4, 5, 7, 8, 9, 10, 11);
# $combinations = main::combinations_of_weight(20, \@numbers);
# is(@$combinations, 96, "96 combinations possible");
# is(main::smallest($combinations), 2, "smallest is 2 packages");
# is(main::smallest_quantum($combinations), 99, "smallest quantum is 99");
#
# @numbers = (1, 2, 3, 4, 5, 7, 8, 9, 10, 11);
# $combinations = main::combinations_of_weight(15, \@numbers);
# is(@$combinations, 72, "72 combinations possible");

done_testing();
