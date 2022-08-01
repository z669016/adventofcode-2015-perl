#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use List::MoreUtils qw(uniq);
use AOC::Input;

sub transformations {
    my $data = shift;

    my @transformations = map { /(\w+) => (\w+)/} grep {/(\w+) => (\w+)/} @$data;
    \@transformations;
}

sub molecule {
    my $data = shift;

    my @molecules = grep {/^(\w+)$/} @$data;
    $molecules[0];
}

sub calibrate {
    my ($transformations, $molecule) = @_;
    my @molecules = ();

    for (my $i = 0; $i < $#$transformations; $i += 2) {
        my $offset = 0;
        while ((my $index = index($molecule, $$transformations[$i], $offset)) != -1) {
            my $new_molecule = $molecule;
            substr($new_molecule, $index, length($$transformations[$i])) = $$transformations[$i+1];
            push @molecules, $new_molecule;
            $offset = $index + length($$transformations[$i]);
        }
    }

    @molecules = uniq @molecules;
    \@molecules;
}

unless (caller) {
    my $data = AOC::Input::load("./resources/input-19.txt");

    my $transformations = transformations($data);
    my $molecule = molecule($data);

    my $molecules = calibrate($transformations, $molecule);
    print "Day 19 - part 1: Calibration gives ", $#$molecules + 1, " molecules\n";

    # SImple undo of all transformations doesn;t guarantee a solution,
    # as some transformations have multiple options. It proofed to work about 1 in 8 times.
    #
    # See https://www.reddit.com/r/adventofcode/comments/3xflz8/day_19_solutions/
    # Solution by askalski
    #
    # Rn is (
    # Ar is )
    # Y = ,
    #
    # each transformation adds 1 elemen, unless the transformation contains a comma,
    # then with each comma it adds an additioal element;
    #
    # count all tokens (start with a capital letter)
    # subtract numer of comma's (they introduced an additional element)
    # subtract 1 (the numer of transformations is number of elements - 1 as you start with an e)
    $molecule = molecule($data);
    $molecule =~ s/Rn/\(/g;
    $molecule =~ s/Ar/\)/g;
    $molecule =~ s/Y/,/g;

    my @tokens = $molecule =~ /([A-Z])/g;
    my @comma = $molecule =~ /(,)/g;
    my $steps = @tokens - @comma - 1;
    print "Day 19 - part 2: Made the required molecule in $steps steps.\n";
}

1;