#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use feature 'state';

sub elves {
    my $num = shift;

    my $inc = $num % 2 == 0 ? 1 : 2;
    my @elves = ();
    my $max = int(sqrt($num));
    for (my $i = 1; $i <= $max; $i += $inc) {
        if ($num % $i == 0) {
            push @elves, $i, int($num / $i) if $i != $num / $i;
        }
    }

    # @factors = sort { $a <=> $b} @factors;
    \@elves;
}

sub presents_infinite {
    my $elves = shift;

    my $presents = 0;
    foreach (@$elves) {
        $presents += $_;
    }

    $presents * 10;
}

sub presents_finite {
    my ($house, $elves) = @_;

    my $presents = 0;
    foreach (@$elves) {
        $presents += $_ if $_ * 50 >= $house;
    }

    $presents * 11;
}

unless (caller) {
    # foreach (1 .. 19) {
    #     my $number = $_;
    #     my $elves = factors($number);
    #     my $presents = presents(10, $elves);
    #     print "$number: @$elves deliver $presents presents\n";
    # }

    my $input = 36000000;
    my $house = 0;
    my $presents = 0;
    while ($presents <= $input) {
        $house++;
        $presents = presents_infinite(elves($house));
    }
    print "\n";
    print "Day 20 - part 1: the first house receiving at least $input presents with infinite delivery is $house\n";

    # Don't reset house number, as the finite case will be higher for sure
    $presents = 0;
    while ($presents <= $input) {
        $house++;
        $presents = presents_finite($house, elves($house));
    }
    print "Day 20 - part 2: the first house receiving at least $input presents with finite delivery is $house\n";
}

1;