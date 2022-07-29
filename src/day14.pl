#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use AOC::Input;

sub mapper {
    # maps text line into reindeer stats array:
    # [0] reindeer name
    # [1] distance to travel in one second when flying
    # [2] number of second the reindeer can travel before it needs to rest
    # [3] distance to travel in one second when in rest
    # [2] number of second the reindeer must rest after flying

    # "Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds."
    /(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds\./;
    [$1, $2, $3, 0, $4]
}

sub max_distance {
    my $results = shift;

    my $max = 0;
    foreach (values %$results) {
        $max = $_->[2] if $_->[2] > $max;
    }

    $max;
}

sub max_points {
    my $results = shift;

    my $max = 0;
    foreach (values %$results) {
        $max = $_->[3] if $_->[3] > $max;
    }

    $max;
}

sub race {
    my ($stats, $duration) = @_;

    # %results will contain the travel results of the race per reindeer and each result is an array containing:
    # [0] state (flying/resting),
    # [1] seconds to go in this state,
    # [2] total distance travelled,
    # [3] total points collected
    my %results = ();

    foreach (@$stats) {
        $results{$_->[0]} = ["flying", $_->[2], 0, 0];
    }

    while ($duration > 0) {
        $duration--;

        foreach (@$stats) {
            if ($results{$_->[0]}[1] == 0 and $results{$_->[0]}[0] eq "flying") {
                $results{$_->[0]}[0] = "resting";
                $results{$_->[0]}[1] = $_->[4];
            }
            if ($results{$_->[0]}[1] == 0 and $results{$_->[0]}[0] eq "resting") {
                $results{$_->[0]}[0] = "flying";
                $results{$_->[0]}[1] = $_->[2];
            }

            $results{$_->[0]}[2] += $results{$_->[0]}[0] eq "flying" ? $_->[1] : $_->[3];
            $results{$_->[0]}[1] -= 1;
        }

        my $max = max_distance(\%results);
        foreach (@$stats) {
            $results{$_->[0]}[3] += 1 if $results{$_->[0]}[2] == $max;
        }
    }

    \%results;
}

unless (caller) {
    my %options = (
        "map" => \&mapper,
    );
    my $stats = AOC::Input::load("./resources/input-14.txt", \%options);
    my $results = race($stats, 2503);
    my $max_distance = max_distance($results);
    my $max_points = max_points($results);
    print "Day 14 - part 1: the winning reindeer traveled a distance of $max_distance\n";
    print "Day 14 - part 2: the winning reindeer traveled a distance of $max_points\n";
}

1;