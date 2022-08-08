#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use AOC::Input;
use List::Util qw(sum);

sub input {
    my $options = {
        map => sub {
            /To continue, please consult the code grid in the manual.  Enter the code at row (\d+), column (\d+)./;
            ($2, $1)
        }
    };
    my $input = AOC::Input::load("./resources/input-25.txt", $options);

    $input;
}

sub xy_index {
    my ($column, $row) = @_;

    # first row will increase by 2, 3, 4, 5, 6, etc, while first column will increase by 1, 2, 3, 4, 5, etc.
    # This means that row x will start with value sum(1 .. x-1)

    return 1 if $column == 1 and $row == 1;

    my $row_index = sum(1 .. $row - 1);
    return $row_index if $column == 1;

    my $column_inc = $row + 1;
    my $column_index = do {
        my $index = $row_index;
        for (my $i = 1; $i < $column; $i++) {
            $index += $column_inc;
            $column_inc++;
        }

        1 + $index;
    };

    $column_index;
}

sub code {
    my ($column, $row) = @_;
    my $index = xy_index($column, $row);

    my $start = 20151125;
    return $start if $index == 1;

    my $mul = 252533;
    my $div = 33554393;
    my $code = $start;

    for (my $i = 1; $i < $index; $i++) {
        $code = ($code * $mul) % $div;
    }

    $code;
}

unless (caller) {
    my ($column, $row) = @{input()};
    print "Day 25 - part 1: The code for ($column, $row) is ", code($column, $row), "\n";
}

1;
