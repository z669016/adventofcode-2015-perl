#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Readonly;
use AOC::Input;

Readonly our $ON => "#";
Readonly our $OFF => ".";

sub mapper {
    [split //, shift]
}

sub neighbours {
    my ($grid, $x, $y) = @_;
    my $count = 0;

    my $max = $#$grid;

    $count++ if $x > 0 && $$grid[$y][$x-1] eq $ON;
    $count++ if $x > 0 && $y > 0 && $$grid[$y-1][$x-1] eq $ON;
    $count++ if $y > 0 && $$grid[$y-1][$x] eq $ON;
    $count++ if $x < $max && $y > 0 && $$grid[$y-1][$x+1] eq $ON;
    $count++ if $x < $max && $$grid[$y][$x+1] eq $ON;
    $count++ if $x < $max && $y < $max && $$grid[$y+1][$x+1] eq $ON;

    print "($x,$y)\n" if $y < $max && not defined $$grid[$y+1][$x];

    $count++ if $y < $max && $$grid[$y+1][$x] eq $ON;
    $count++ if $x > 0 && $y < $max && $$grid[$y+1][$x-1] eq $ON;

    $count
}

sub strategy1 {
    my (undef, undef, undef, $state, $neigboughs) = @_;

    if ($state eq $ON) {
        return $neigboughs == 2 || $neigboughs == 3 ? $ON : $OFF;
    }

    $neigboughs == 3 ? $ON : $OFF
}

sub strategy2 {
    my ($x, $y, $size, $state, $neigboughs) = @_;

    return $ON if ($x == 0 && $y == 0);
    return $ON if ($x == 0 && $y == $size);
    return $ON if ($x == $size && $y == $size);
    return $ON if ($x == $size && $y == 0);

    strategy1($x, $y, $size, $state, $neigboughs);
}

sub step {
    my $grid = shift;
    my $strategy = shift;

    my $size = $#$grid;
    my @copy = ();
    foreach my $i (0 .. $size) {
        my $line = $$grid[$i];
        push @copy, [@$line];
    }

    foreach my $y (0 .. $size) {
        foreach my $x (0 .. $size) {
            $copy[$y][$x] = &$strategy($x, $y, $size, $$grid[$y][$x], neighbours($grid, $x, $y));
        }
    }

    \@copy;
}

sub print_grid {
    my $data = shift;

    foreach (@$data) {
        print join('', @$_), "\n";
    }
    print "\n";
}

sub count_lights {
    my $grid = shift;
    my $count = 0;

    my $size = $#$grid;

    foreach my $y (0 .. $size) {
        foreach my $x (0 .. $size) {
            $count++ if $$grid[$y][$x] eq $ON;
        }
    }

    $count;
}

unless (caller) {
    my %options = (
        map => \&mapper,
    );

    my $data = AOC::Input::load("./resources/input-18.txt", \%options);
    foreach (1..100) {
        $data = step($data, \&strategy1);
    }
    print "Day 18 - part 1: after 100 steps ", count_lights($data), " lights are on\n";

    $data = AOC::Input::load("./resources/input-18.txt", \%options);
    foreach (1..100) {
        $data = step($data, \&strategy2);
    }
    print "Day 18 - part 2: after 100 steps with broken board ", count_lights($data), " lights are on\n";
}

1;