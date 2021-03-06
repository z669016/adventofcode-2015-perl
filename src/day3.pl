#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use feature qw/switch/;
no warnings 'experimental';

use AOC::Input;
use AOC::Point;

my $input = AOC::Input::load("./resources/input-3.txt", {'slice' => [0]});

my %visited;
my @current = (0, 0);
$visited{"@current"} = 1;
foreach my $direction (split //, $$input) {
    @current = AOC::Point::move(@current, $direction);
    $visited{"@current"} += 1;
}
my $size = keys %visited;
print "day 3, part 1: Houses visited is $size\n";

undef %visited;

my @current_santa = (0, 0);
my @current_robo = (0, 0);
$visited{"@current_santa"} = 1;
my $santa = 1;
foreach my $direction (split //, $$input) {
    if ($santa == 1) {
        @current_santa = AOC::Point::move(@current_santa, $direction);
        $visited{"@current_santa"} += 1;
        $santa = 0;
    } else {
        @current_robo = AOC::Point::move(@current_robo, $direction);
        $visited{"@current_robo"} += 1;
        $santa = 1;
    }
}

$size = keys %visited;
print "day 3, part 2: Houses visited is $size\n";
