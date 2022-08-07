#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use AOC::Input;

sub compile_statement {
    my $line = shift;

    # jio a, +8
    $line =~ /(\w+) (a|b|(-|\+)?\d+)(, ((-|\+)?\d+))?/;
    die "could not match '$line'" if not defined $0;

    if ($1 eq "hlf") {
        my $reg = $2;
        return sub {
            my $regs = shift;
            $$regs{$reg} //= 0;
            $$regs{$reg} /= 2;
            1;
        }
    }

    if ($1 eq "tpl") {
        my $reg = $2;
        return sub {
            my $regs = shift;
            $$regs{$reg} //= 0;
            $$regs{$reg} *= 3;
            1;
        }
    }

    if ($1 eq "inc") {
        my $reg = $2;
        return sub {
            my $regs = shift;
            $$regs{$reg} //= 0;
            $$regs{$reg}++;
            1;
        }
    }

    if ($1 eq "jmp") {
        my $offset = substr($2, 0, 1) eq "+" ? substr($2, 1) : $2;
        return sub {
            my $regs = shift;
            $offset;
        }
    }

    if ($1 eq "jie") {
        my $reg = $2;
        my $offset = substr($5, 0, 1) eq "+" ? substr($5, 1) : $5;
        return sub {
            my $regs = shift;
            $$regs{$reg} //= 0;
            $$regs{$reg} % 2 == 0 ? $offset : 1;
        }
    }

    if ($1 eq "jio") {
        my $reg = $2;
        my $offset = substr($5, 0, 1) eq "+" ? substr($5, 1) : $5;
        return sub {
            my $regs = shift;
            $$regs{$reg} //= 0;
            $$regs{$reg} == 1 ? $offset : 1;
        }
    }

    die "Unknown instruction '$line'";
}

sub compile {
    my $source = shift;
    [ map {compile_statement($_)} @$source ];
}

sub run {
    my ($program, $regs) = @_;
    $regs //= {};
    my $ip = 0;

    while ($ip >= 0 && $ip <= $#$program) {
        $ip += $$program[$ip]($regs);
    }

    $regs;
}

unless (caller) {
    my $program = main::compile(AOC::Input::load("./resources/input-23.txt"));

    my $regs = main::run($program);
    print "Day 23 - part 1: The value of register b after running the program is $$regs{b}\n";

    $regs = main::run($program, {a => 1});
    print "Day 24 - part 2: The value of register b after running the program with register a set to 1 is $$regs{b}\n";
}

1;