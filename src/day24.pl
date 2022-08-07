#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use List::Util qw(sum min);
use AOC::Input;

sub combinations {
    my ($weight, $numbers) = @_;

    return [] if @$numbers == 0;
    return [ [ @$numbers ] ] if $weight == sum(@$numbers);

    return [] if @$numbers == 0;

    my $number = shift @$numbers;
    return [ [ $number ] ] if $number == $weight;
    return [] if $number > $weight;
    return [] if @$numbers == 0;

    my @combinations = ();
    my @copy_numbers = @$numbers;
    my $subs = combinations($weight - $number, \@copy_numbers);
    foreach (@$subs) {
        push @combinations, [ $number, @$_ ];
    }

    push @combinations, @{combinations($weight, $numbers)};

    \@combinations;
}

sub container_size {
    my ($list, $count) = @_;
    $count //= 3;

    sum(@$list) / $count;
}

sub combinations_of_weight {
    my ($weight, $numbers) = @_;

    return [ [ @$numbers ] ] if sum(@$numbers) == $weight;
    return [] if sum(@$numbers) < $weight;

    my @copy = @$numbers;
    my @combinations = ();
    my $combinations = combinations($weight, \@copy);
    foreach my $combination (@$combinations) {
        my %seen = map {$_ => 1} @$combination;
        @copy = grep {not $seen{$_}} @$numbers;

        my $sub = combinations_of_weight($weight, \@copy);
        foreach (@$sub) {
            my @sub_combi = @$_;
            push @combinations, [ $combination, ref $$_[0] eq ref "" ? $_ : @$_ ];
        }
    }

    \@combinations;
}

sub smallest {
    my $smallest;

    my $combinations = shift;
    foreach (@$combinations) {
        my $first = $$_[0];

        $smallest //= @$first + 0;
        $smallest = @$first + 0 if $smallest > @$first + 0;
    }

    $smallest;
}

sub quantum {
    my $mul = 1;

    foreach (@_) {
        $mul *= $_;
    }

    $mul;
}

sub smallest_quantum {
    my $combinations = shift;
    my $smallest = smallest $combinations;

    my @first = grep {@$_ == $smallest} map {$$_[0]} @$combinations;
    min(map {quantum @$_} @first)
}

unless (caller) {
    my $numbers = AOC::Input::load("./resources/input-24.txt");
    my $size = container_size($numbers);
    my $combinations = combinations_of_weight($size, $numbers);
    my $smallest_quantum = smallest_quantum($combinations);
    print "Day 24 - part 1: quantum entanglement of the first group of packages is $smallest_quantum\n";
}

1;