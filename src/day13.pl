#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use List::MoreUtils qw(uniq);
use List::Permutor;
use AOC::Input;

sub mapper {
    /(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)\./;
    [ $1, $4, ($2 eq 'lose' ? -1 : 1) * $3 ];
};

sub guests {
    my $happiness = shift;

    my @guests = uniq map { $$_[0] } @$happiness;
    \@guests;
}

sub happiness_hash {
    my $happiness = shift;

    my %happiness;
    foreach (@$happiness) {
        $happiness{$$_[0]} //= {};
        $happiness{$$_[0]}->{$$_[1]} = $$_[2];
    }

    \%happiness;
}

sub happiness_sum {
    my ($guests, $happiness) = @_;

    unshift @$guests, $$guests[-1];
    push @$guests, $$guests[1];

    my $sum = 0;
    foreach (1 .. @$guests - 2) {
        $sum += $happiness->{$$guests[$_]}{$$guests[$_ - 1]};
        $sum += $happiness->{$$guests[$_]}{$$guests[$_ + 1]};
    }

    $sum;
}

sub max_happiness_sum {
    my ($guests, $happiness) = @_;

    my $max = 0;
    my $permutor = List::Permutor->new(@$guests);
    while ( my @permutation = $permutor->next() ) {
        my $sum = main::happiness_sum(\@permutation, $happiness);
        $max = $sum if $sum > $max;
    }

    $max;
}

unless (caller) {
    my %options = (
        map => \&mapper,
    );
    my $data = AOC::Input::load("./resources/input-13.txt", \%options);

    my $guests= guests($data);
    my $happiness = happiness_hash($data);
    my $max = max_happiness_sum($guests,$happiness);
    print "Day 13 - part 1: Max happiness value is $max\n";

    foreach (@$guests) {
        push @$data, ["me", $_, 0];
        push @$data, [$_, "me", 0];
    }

    $guests = guests($data);
    $happiness = happiness_hash($data);
    $max = max_happiness_sum($guests,$happiness);
    print "Day 13 - part 2: Max happiness value is $max\n";
}

1;