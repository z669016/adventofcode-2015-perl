#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use List::Util;
use AOC::Input;

sub count {
    my $sum = shift;
    my @numbers = @_;

    return 1 if $sum == 0;

    if (@numbers > 0 && List::Util::sum(@numbers) >= $sum) {
        my $next = shift @numbers;
        my $left = $next <= $sum ? count($sum - $next, @numbers) : 0;
        my $right = count($sum, @numbers);

        return $left + $right;
    }

    0
}

sub count_with_max {
    my $max = shift;
    my $sum = shift;
    my @numbers = @_;

    return 1 if $sum == 0;

    if ($max > 0 && @numbers > 0 && List::Util::sum(@numbers) >= $sum) {
        my $next = shift @numbers;
        my $left = $next <= $sum ? count_with_max($max - 1, $sum - $next, @numbers) : 0;
        my $right = count_with_max($max, $sum, @numbers);

        return $left + $right;
    }

    0
}

sub min_depth {
    my $depth = shift;
    my $sum = shift;
    my @numbers = @_;

    return $depth if $sum == 0;

    if (@numbers > 0 && List::Util::sum(@numbers) >= $sum) {
        my $next = shift @numbers;
        my $left = $next <= $sum ? min_depth($depth + 1, $sum - $next, @numbers) : undef;
        my $right = min_depth($depth, $sum, @numbers);

        return $left if not defined($right);
        return $right if not defined($left);
        return $left < $right ? $left : $right;
    }

    undef
}

unless (caller) {
    my %options = (
        sort => sub {
            my ($first, $second) = @_;
            $second <=> $first;
        }
    );
    my $data = AOC::Input::load("./resources/input-17.txt", \%options);
    print "Day 17 - part 1: Number of combinations is ", count(150, @$data), "\n";

    my $min_depth = min_depth(0, 150, @$data);
     print "Day 17 - part 2: Number of combinations for max $min_depth containers is ", count_with_max($min_depth, 150, @$data), "\n";
}

1;
