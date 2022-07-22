#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

require "./aoc_input.pm";

use List::MoreUtils qw(uniq);
use List::Permutor;

use constant SEPARATOR => '|';

sub cities {
    my $data = shift;
    my @cities = uniq map { $$_[0], $$_[1] } @$data;

    \@cities;
}

sub distances {
    my $data = shift;
    my %distances = map { $$_[0].SEPARATOR.$$_[1] => $$_[2] } @$data;
    \%distances;
}

sub distance {
    my ($distances, $permutation) = @_;
    my $total = 0;

    foreach my $i (0..@$permutation - 2) {
        my $c1 = $$permutation[$i];
        my $c2 = $$permutation[$i+1];
        my $distance = $$distances{$c1.SEPARATOR.$c2} // $$distances{$c2.SEPARATOR.$c1};
        unless (defined $distance) {
            die "No route from '$c1' to '$c2'";
        }
        $total += $distance;
    }

    $total;
}

my $data = AOC::Input::load("./resources/input-9.reg", { regexp => qr/([A-Za-z]+) to ([A-Za-z]+) = (\d+)/ });
my $cities = cities($data);
my $distances = distances($data);

my $min;
my $max;

my $permutor = List::Permutor->new(@$cities);
while ( my @permutation = $permutor->next() ) {
    my $distance = distance($distances, \@permutation);

    $min //= $distance;
    $min = $distance if $distance < $min;

    $max //= $distance;
    $max = $distance if $distance > $max;
}
print "Day 9 - part 1: Shortest distance is $min\n";
print "Day 9 - part 2: Longest distance is $max\n";
