#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Data::Dumper;
use Scalar::Util qw/reftype/;

use AOC::Input;

sub num_sum {
    my ($elem, $count_red) = @_;
    $count_red //= 1;

    my $sum = 0;

    if (not defined reftype $elem) {
        return $elem =~ /-?\d+/ ? $elem : 0;
    } elsif (reftype $elem eq reftype []) {
        foreach (@$elem) {
            $sum += num_sum($_, $count_red);
        }
        return $sum;
    } elsif (reftype $elem eq reftype {}) {
        if (not $count_red) {
            return 0 if grep /^red$/, values %$elem;
        }
        foreach (values %$elem) {
            $sum += num_sum($_, $count_red);
        }
        return $sum;
    }
    die "Don't know how to handle ref \$elem: ", ref($elem), "\n";
}

unless (caller) {
    my $data = AOC::Input::load("./resources/input-12.json");
    print "Day 12 - part 1: The sum of all numbers is ", num_sum($data), "\n";
    print "Day 12 - part 2: The sum of all numbers ignoring red is ", num_sum($data, 0), "\n";
}

1;
