#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

require "./src/day21.pl";

my @lines = (
    "Hit Points: 12", "Damage: 8", "Armor: 2"
);
my ($hitpoints, $damage, $armor) = main::input(\@lines);
is($hitpoints, 12, "input hit points");
is($damage, 8, "input damage");
is($armor, 2, "input armor");

my @player = (8, 5, 5);
my @boss = (12, 7, 2);
is (main::play_game(\@player, \@boss), $main::PLAYER, "The player wins");

my @strategies = main::strategies();
my $size = @strategies;
print "Created $size strategies\n";
foreach my $strategy (@strategies) {
    print "@$strategy\n";
}

done_testing();

