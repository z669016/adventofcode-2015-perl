#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

require "./src/day23.pl";

my @source = (
    "inc a",
    "jio a, +2",
    "tpl a",
    "inc a",
    "inc b",
);

my $program = main::compile(\@source);
my $regs = main::run($program);

foreach (sort keys %$regs) {
    print "$_ = $$regs{$_}\n";
}

done_testing();

