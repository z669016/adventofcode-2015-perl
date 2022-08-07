#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Data::Dumper;

require "./src/day22.pl";

my @lines = (
    "Hit Points: 13",
    "Damage: 8",
);
my $boss = main::input(\@lines);
is($$boss{hitpoints}, 13, "boss 13 hit points");
is($$boss{damage}, 8, "boss 8 damage");


my $player = {
    mana      => 250,
    hitpoints => 10,
};

my $verbose = 0;

my ($new_player, $new_boss) = main::play_turn($player, $boss, $main::SPELL{poison}, $verbose);
($new_player, $new_boss) = main::play_turn($new_player, $new_boss, $main::SPELL{missile}, $verbose);
#print Dumper($new_player, $new_boss);
is($$new_player{mana}, 24, "player mana game 1");
is($$new_player{hitpoints}, 2, "player hit points game 1");
is($$new_player{spend}, 226, "player spend game 1");
is($$new_boss{hitpoints}, 0, "boss hit points game 1");

($new_player, $new_boss) = main::play_game($player, $boss);
is($$new_player{mana}, 24, "player mana game 1");
is($$new_player{hitpoints}, 2, "player hit points game 1");
is($$new_player{spend}, 226, "player spend game 1");
is($$new_boss{hitpoints}, 0, "boss hit points game 1");

$player = {
    mana      => 250,
    hitpoints => 10,
    armor     => 0
};

$boss = {
    hitpoints => 14,
    damage    => 8,
};

($new_player, $new_boss) = main::play_turn($player, $boss, $main::SPELL{recharge}, $verbose);
($new_player, $new_boss) = main::play_turn($new_player, $new_boss, $main::SPELL{shield}, $verbose);
($new_player, $new_boss) = main::play_turn($new_player, $new_boss, $main::SPELL{drain}, $verbose);
($new_player, $new_boss) = main::play_turn($new_player, $new_boss, $main::SPELL{poison}, $verbose);
($new_player, $new_boss) = main::play_turn($new_player, $new_boss, $main::SPELL{missile}, $verbose);
is($$new_player{mana}, 114, "player mana game 2");
is($$new_player{hitpoints}, 1, "player hit points game 2");
is($$new_player{spend}, 641, "player spend game 2");
is($$new_boss{hitpoints}, -1, "boss hit points game 2");

my @options = main::options($new_player);
is(@options, 3, "3 options");
foreach (@options) {
    like($$_{name}, qr/^missile|shield|drain$/, "Options are shield, missile, and drain");
}
# print Dumper($new_player);
# print Dumper(\main::options($new_player));

($new_player, $new_boss) = main::play_game($player, $boss);
is($$new_player{mana}, 114, "player mana game 2");
is($$new_player{hitpoints}, 1, "player hit points game 2");
is($$new_player{spend}, 641, "player spend game 2");
is($$new_boss{hitpoints}, -1, "boss hit points game 2");

done_testing();

