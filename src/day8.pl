#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use AOC::Input;

sub is_hex {
    join('', @_) =~ /[0-9a-f]+/;
}

my $decode = sub {
    my $line = shift;
    my @line = split(//, $line);

    undef($line[0]);
    undef($line[-1]);

    my $i = 1;
    while ($i < $#line) {
        if (defined $line[$i] and $line[$i] eq '\\') {
            if ($i < $#line - 1) {

                if ($line[$i + 1] eq '\\' or $line[$i + 1] eq '"') {
                    undef($line[$i]);

                    $i += 2;
                    next;
                }

                if ($line[$i + 1] eq 'x' and $i < $#line - 3 and is_hex($line[$i + 2], $line[$i + 3])) {
                    $line[$i] = '.';
                    undef($line[$i + 1]);
                    undef($line[$i + 2]);
                    undef($line[$i + 3]);

                    $i += 4;
                    next;
                }
            }
        }

        $i += 1;
    }

    [length($line), scalar grep { defined($_) } @line];
};

my $encode = sub {
    my $line = shift;
    my @line = split(//, $line);

    $line[0] = '"\"';
    $line[-1] = '\""';
    foreach my $i (1..$#line - 1) {
        if ($line[$i] eq '\\') {
            $line[$i] = '\\\\';
        } elsif ($line[$i] eq '"') {
            $line[$i] = '\\"';
        }
    }

    [length($line), length(join('', @line))];
};


sub sum {
    my $counts =  shift;

    my $length;
    my $memory;
    foreach my $count (@$counts) {
        $length += $$count[0];
        $memory += $$count[1];
    }

    [$length, $memory];
}

my $input = AOC::Input::load("./resources/input-8.txt");

my @sizes = map $decode->($_), @$input;
my $sum = sum(\@sizes);
my $saved = $$sum[0] - $$sum[1];
print "Day 8 - part 1: the total number of characters of string code minus the total number of characters in memory for string values is $saved\n";

@sizes = map $encode->($_), @$input;
# my @counts = map $count->($_), @lines;
$sum = sum(\@sizes);
$saved = $$sum[1] - $$sum[0];
print "Day 8 - part 2: the total number of characters of encoded string code minus the total number of characters in the original string values is $saved\n";
