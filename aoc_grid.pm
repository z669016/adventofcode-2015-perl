package AOC::Grid;

use strict;
use warnings FATAL => 'all';

use version;
our $VERSION = version->declare('v0.0.1');

use Readonly;
use Scalar::Util qw(reftype);

Readonly our $north => "north";
Readonly our $east => "east";
Readonly our $south => "south";
Readonly our $west => "west";

Readonly our %directions => (
    "^" => $north,
    ">" => $east,
    "v" => $south,
    "<" => $west
);

Readonly our %moves => (
    $north => [0,1],
    $east => [-1, 0],
    $south => [0, -1],
    $west => [1, 0]
);

sub move_for_direction {
    my ($direction, $the_directions) = @_;
    $the_directions //= \%directions;

    my $move = $moves{$direction} // $moves{$$the_directions{$direction}};
    die "Invalid direction for move '$direction'" if not defined $move;

    @$move;
}

sub move {
    my ($x, $y, $direction, $the_directions) = @_;

    my @the_direction;
    if (reftype($direction) and reftype($direction) eq reftype []) {
        @the_direction = @$direction;
    } else {
        @the_direction = move_for_direction($direction, $the_directions);
    }

    ($x + $the_direction[0], $y + $the_direction[1]);
}

1;