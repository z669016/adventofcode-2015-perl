#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use AOC::Input;

use constant {
    OPEN => "(",
    CLOSE => ")",
};

sub find_floor {
    my ($line, $basement) = @_;

    my $floor = 0;
    my $pos = 1;
    foreach my $char (split //, $line) {
        if ($char eq OPEN) {$floor++}
        elsif ($char eq CLOSE) {$floor--}
        else {
            die "Invalid character '$char' at position $pos\n";
        }

        if (defined($basement)) {
            last if $floor < 0;
        }

        $pos++;
    }

    ($floor, $pos);
}

my $line;
if (@ARGV) {
    $line = $_[0];
} else {
    $line = AOC::Input::load("./resources/input-1.txt", {'slice' => [0]});
}

print "part 1: You end up at floor ", (find_floor($$line))[0], ".\n";
print "part 2: You enter the basement at position ", (find_floor($$line, 1))[1], ".\n";
