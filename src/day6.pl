#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Benchmark;

use AOC::Input;

my $GRID_SIZE = 999;

sub empty_grid {
    my @grid = ();
    for my $y (0 .. $GRID_SIZE) {
        for my $x (0 .. $GRID_SIZE) {
            $grid[$y][$x] = 0;
        }
    }

    \@grid;
}

sub instructions {
    sub parse_line {
        my %command = (
            "turn on", 0,
            "turn off", 1,
            "toggle", 2,
        );

        my ($line) = @_;

        $line =~ /(turn (on|off)|toggle) (\d+),(\d+) through (\d+),(\d+)/;
        #print "\$1: $1, \$3: $3, \$4: $4, \$5: $5, \$6:$6\n";
        [$command{$1}, [$3,$4], [$5,$6]];
    }

    if ($_[0]) {
        parse_line($_[0]);
    } else {
        my $lines = AOC::Input::load("./resources/input-6.txt");
        my $instructions = [];
        foreach(@$lines) {
            push(@$instructions, parse_line($_));
        }

        $instructions;
    }
}

sub simple_instruction {
    my ($command, $value_ref) = @_;

    if ($command == 0 ) { #turn on
        $$value_ref = 1;
    } elsif ($command == 1) { #turn off
        $$value_ref = 0;
    } elsif ($command == 2) { # toggle
        $$value_ref = $$value_ref ? 0 : 1;
    } else {
        die "Invalid command for simple instruction";
    }
}

sub complex_instruction {
    my ($command, $value_ref) = @_;

    if ($command == 0 ) { #turn on
        $$value_ref += 1;
    } elsif ($command == 1) { #turn off
        $$value_ref -= 1 if $$value_ref > 0;
    } elsif ($command == 2) { # toggle
        $$value_ref += 2;
    } else {
        die "Invalid command for complex instruction";
    }
}

sub process_instruction_list {
    sub minmax {
        $_[0] < $_[1] ? ($_[0], $_[1]) : ($_[1], $_[0])
    }

    my ($grid, $instruction, $method) = @_;
    my ($command, $from, $to) = @$instruction;

    my ($min_x, $max_x) = minmax($$from[0], $$to[0]);
    my ($min_y, $max_y) = minmax($$from[1], $$to[1]);

    for my $y ($min_y .. $max_y) {
        for my $x ($min_x .. $max_x) {
            &$method($command, \$$grid[$y][$x]);
        }
    }
}

sub count_light {
    my ($grid) = @_;
    my $count = 0;

    for my $y (0..$GRID_SIZE) {
        for my $x (0 .. $GRID_SIZE) {
            $count += $$grid[$y][$x];
        }
    }

    $count;
}

my $start = Benchmark->new;
my $grid = empty_grid;
my $instructions = instructions();
foreach my $instruction (@$instructions) {
    process_instruction_list($grid, $instruction,\&simple_instruction);
}
my $count = count_light($grid);
my $perf = timestr(timediff(Benchmark->new, $start));

print "Day 6 - part 1: number of lights on after parsing all instructions is $count ($perf)\n";

$start = Benchmark->new;
$grid = empty_grid();
foreach my $instruction (@$instructions) {
    process_instruction_list($grid, $instruction, \&complex_instruction);
}
$count = count_light($grid);
$perf = timestr(timediff(Benchmark->new, $start));

print "Day 6 - part 2: total brightness after parsing all instructions is $count ($perf)\n";