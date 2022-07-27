#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

sub encode {
    my ($code, $times) = @_;
    $times //= 1;

    my @code = split //, $code;
    while ($times-- > 0) {
        my @encoded;

        my $start = 0;
        my $current = $code[$start];
        my $i = 1;
        while ($i <= $#code) {
            if ($code[$i] != $current) {
                push @encoded, ($i - $start, $current);
                last if $i > $#code + 1;

                $start = $i;
                $current = $code[$start];
            }

            $i++;
        }
        push @encoded, ($i - $start, $current);

        @code = @encoded;
    }

    join '', @code;
}

unless (caller) {
    my $code = "3113322113";

    my $code_after_40 = encode($code, 40);
    print "Day 10 - part 1: the length of the result after 40 encodings is ", length($code_after_40), "\n";

    my $code_after_50 = encode($code_after_40, 10);
    print "Day 10 - part 2: the length of the result after 50 encodings is ", length($code_after_50), "\n";
}

1;