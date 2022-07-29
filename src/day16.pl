#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Data::Dumper;
use AOC::Input;

# The template aunt_sue that has send the gift
our Readonly %aunt_sue = (
    children    => 3,
    cats        => 7,
    samoyeds    => 2,
    pomeranians => 3,
    akitas      => 0,
    vizslas     => 0,
    goldfish    => 5,
    trees       => 3,
    cars        => 2,
    perfumes    => 1,
);

sub mapper {
    # Sue 459: goldfish: 7, akitas: 2, cats: 7
    /(Sue \d+): (.+)/;
    my $name = $1;
    my %details = ();

    my @details = split /\, /, $2;
    foreach (@details) {
        /(\w+): (\d+)/;
        $details{$1} = $2;
    }

    $name => \%details
};

sub match_simple {
    my ($aunt, $details) = @_;

    # remove if any of the number of detailed items doest match with the aunt props
    foreach (keys %$details) {
        return 0 if $$aunt{$_} != $$details{$_};
    }

    return 1;
}

sub match_complex {
    my ($aunt, $details) = @_;

    foreach (keys %$details) {
        if ($_ eq "cats" or $_ eq "trees") {
            return 0 if $$details{$_} <= $$aunt{$_} ;
        } elsif ($_ eq "pomeranians" or $_ eq "goldfish"){
            return 0 if $$details{$_} >= $$aunt{$_};
        } else {
            return 0 if $$aunt{$_} != $$details{$_};
        }
    }

    return 1;
}

sub clean {
    my ($data, $aunt, $method) = @_;

    foreach (keys %$data) {
        if (not &$method($aunt, $$data{$_})) {
            delete($$data{$_});
        }
    }

    $data;
}

unless (caller) {
    my %options = (
        'map' => \&mapper,
    );

    my %data = @{AOC::Input::load("./resources/input-16.txt", \%options)};
    clean(\%data, \%aunt_sue, \&match_simple);
    die "Still multiple aunts simple selected ".Dumper(\%data) if scalar keys %data > 1;
    print "Day 16 - part 1: The aunt who gave the present is ", keys %data, "\n";

    %data = @{AOC::Input::load("./resources/input-16.txt", \%options)};
    clean(\%data, \%aunt_sue, \&match_complex);
    die "Still multiple aunts complex selected ".Dumper(\%data) if scalar keys %data > 1;
    print "Day 16 - part 2: The aunt who gave the present is ", keys %data, "\n";
}

1;