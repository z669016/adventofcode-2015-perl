#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use List::Util qw(sum);
use AOC::Input;

my Readonly $INGREDIENTS = 5;

sub mapper {
    # maps text line into ingredients stats array:
    # [0] ingredient name
    # [1] capacity
    # [2] durability
    # [3] flavor
    # [4] texture
    # [5] calories

    # "Frosting: capacity 4, durability -2, flavor 0, texture 0, calories 5"
    /(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/;
    [$1, $2, $3, $4, $5, $6]
}

sub score {
    my ($ingredients, $combination) = @_;

    die "Size of tea spoons must match size of ingredients" if $#$ingredients != $#$combination;
    die "Combination doesn't add up to 100 tea spoons" if sum(@$combination) != 100;

    my @scores = ();
    foreach my $i (1..$INGREDIENTS) {
        my $sum = 0;
        foreach (0 .. $#$ingredients) {
            $sum += $$combination[$_] * $$ingredients[$_][$i];
        }

        push @scores, $sum;
    }

    my $mul = 1;
    foreach (0..$#scores -1) {
        $mul *= $scores[$_] >= 0 ? $scores[$_] : 0;
    }

    ($mul, $scores[-1]);
}

sub highest_score {
    my ($ingredients, $c, $cal_max) = @_;
    $c //= [];

    my $max = 0;
    my $max_cal = 0;

    if ($#$c < $#$ingredients - 1) {
        for (my $i = 100 - (@$c ? sum(@$c) : 0); $i >= 0; $i--) {
            my @c_copy = @$c;
            push @c_copy, $i;

            my ($score, $cal) = highest_score($ingredients, \@c_copy, $cal_max);
            if (defined($cal_max)) {
                if ($score > $max and $cal == $cal_max) {
                    $max = $score;
                    $max_cal = $cal;
                }
            } else {
                if ($score > $max) {
                    $max = $score;
                    $max_cal = $cal;
                }
            }
        }
    } else {
        my @c_copy = @$c;
        push @c_copy, 100 - sum(@$c);

        return score($ingredients, \@c_copy);
    }

    ($max, $max_cal);
}

unless (caller) {
    my %options = (
        "map" => \&mapper,
    );
    my $data = AOC::Input::load("./resources/input-15.txt", \%options);
    my ($score, $cal) = highest_score($data);
    print "Day 15 -part 1: Highest score is $score with $cal calories\n";

    ($score, $cal) = highest_score($data, [], 500);
    print "Day 15 -part 2: Highest score wihth max 500 calories is $score\n";
}

1;