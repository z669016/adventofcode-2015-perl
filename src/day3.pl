#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use feature qw/switch/;
no warnings 'experimental';

sub move {
    my ($x, $y, $direction) = @_;

    given($direction) {
        when("^") { return ($x, $y+1); }
        when(">") { return ($x+1, $y); }
        when("v") { return ($x, $y-1); }
        when("<") { return ($x-1, $y); }
        default { die "Invalid direction '$direction'"; }
    }
}

my $file_name = "./resources/input-3.txt";
open STDIN, "<", $file_name or die "Could not open $file_name: $!";
chomp(my $input = <STDIN>);

my %visited;
my @current = (0, 0);
$visited{"@current"} = 1;
foreach my $direction (split //, $input) {
    @current = move(@current, $direction);
    $visited{"@current"} += 1;
}
my $size = keys %visited;
print "day 3, part 1: Houses visited is $size\n";

undef %visited;

my @current_santa = (0, 0);
my @current_robo = (0, 0);
$visited{"@current_santa"} = 1;
my $santa = 1;
foreach my $direction (split //, $input) {
    if ($santa) {
        @current_santa = move(@current_santa, $direction);
        $visited{"@current_santa"} += 1;
        $santa = 0;
    } else {
        @current_robo = move(@current_robo, $direction);
        $visited{"@current_robo"} += 1;
        $santa = 1;
    }
}

$size = keys %visited;
print "day 3, part 2: Houses visited is $size\n";
