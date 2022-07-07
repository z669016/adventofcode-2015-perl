#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

sub nice {
    my ($word) = @_;

    foreach (qw/ab cd pq xy/) {
        return 0 if index($word, $_) >= 0;
    }

    my ($vowels, $doubles, $prev) = (0, 0, '');
    foreach my $char (split //, $word) {
        $vowels++ if index("aeiou", $char) != -1;
        $doubles++ if $char eq $prev;
        $prev = $char;
    }

    $vowels >= 3 && $doubles > 0;
}

sub nicer {
    my ($word) = @_;

    my ($doubles, $separated) = (0, 0);
    for my $i (0 .. length($word) - 2) {
        my $pair = substr($word, $i, 2);
        $doubles++ if index($word, $pair, $i + 2) != -1;

        my $current = substr($word, $i, 1);
        my $next = substr($word, $i + 1, 1);
        my $target = substr($word, $i + 2, 1);
        $separated++ if $current eq $target && $current ne $next;
    }

    $doubles > 0 && $separated > 0;
}

my $file_name = "./resources/input-5.txt";
my $nice = 0;
my $nicer = 0;
open STDIN, "<", $file_name or die "Could not open $file_name: $!";
while (<STDIN>) {
    chomp;
    $nice++ if nice($_);
    $nicer++ if nicer($_);
}

print "Day 5 - part 1: Found $nice nice words.\n";
print "Day 5 - part 2: Found $nicer nicer words.\n";