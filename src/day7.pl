#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use AOC::Input;

use constant {
    CONSTANT => 1,
    UNARY    => 2,
    BINARY   => 3,
};

sub parse {
    my $statement = shift;
    die "Invalid statement '$statement'" unless $statement =~ /(.*) -> ([a-z]+)/;
    my $value = $1;
    my $target = $2;
    my $state = CONSTANT;

    if ($value =~ /((\d+|[a-z]+) )?(AND|OR|NOT|LSHIFT|RSHIFT) (\d+|[a-z]+)/) {
        $state = defined $1 ? BINARY : UNARY;
    }

    ($target,
        ($state == CONSTANT) ? ($value) :
            ($state == UNARY) ? ($3, $4) :
                ($2, $3, $4)
    );
}

sub signal {
    my ($wired, $target, $signals) = @_;
    $signals //= {};

    if (not defined $$signals{$target}) {
        $$signals{$target} = execute($wired, $target, $signals);
    }

    $$signals{$target};
}

sub execute {
    my ($wired, $target, $signals) = @_;

    my $value;
    my $instruction = $$wired{$target};
    if (@$instruction == CONSTANT) {
        $value = execute_constant($wired, $signals, $instruction);
    } elsif (@$instruction == UNARY) {
        $value = execute_unary($wired, $signals, $instruction);
    } elsif  (@$instruction == BINARY) {
        $value = execute_binary($wired, $signals, $instruction);
    } else {
        die "Don't know how to execute @$wired{$target} for $target";
    }

    $value & 0xffff;
}

sub is_constant {
    my $value = shift;
    $value =~ /\d+/;
}

sub execute_constant {
    my ($wired, $signals, $instruction) = @_;

    my $source = $$instruction[0];
    is_constant($source) ? $source : signal($wired, $source, $signals);
}

sub execute_unary {
    my ($wired, $signals, $instruction) = @_;
    my ($operator, $source) = @$instruction;

    my $value;
    if ($operator eq "NOT") {
        $value = ~signal($wired, $source, $signals) + 0;
    } else {
        die "Don't know how to handle @_" if $operator ne "NOT";
    }

    $value;
}

sub execute_binary {
    my ($wired, $signals, $instruction) = @_;
    my ($op1, $operator, $op2) = @$instruction;

    unless (is_constant($op1)) {
        $op1 = signal($wired, $op1, $signals);
    }
    unless (is_constant($op2)) {
        $op2 = signal($wired, $op2, $signals);
    }

    my $value;
    if ($operator eq "AND") {
        $value = ($op1 + 0) & ($op2 + 0);
    }
    elsif ($operator eq "OR") {
        $value = ($op1 + 0) | ($op2 + 0);
    }
    elsif ($operator eq "LSHIFT") {
        $value = ($op1 + 0) << ($op2 + 0);
    }
    elsif ($operator eq "RSHIFT") {
        $value = ($op1 + 0) >> ($op2 + 0);
    }
    else {
        die "Don't know how to handle @_";
    }

    $value;
}

my %wired;
foreach my $statement (@{AOC::Input::load("./resources/input-7.txt")}) {
    my @parsed = parse($statement);
    my $target = shift @parsed;

    $wired{$target} = \@parsed;
}

my $signals = {};
my $signal_a = signal(\%wired, 'a', $signals);
print "Day 7 - part 1: The signal on wire 'a' is: $signal_a\n";

$wired{'b'} = [$signal_a];
undef %$signals;

$signal_a = signal(\%wired, 'a', $signals);
print "Day 7 - part 2: The signal on wire 'a' is: $signal_a\n";
