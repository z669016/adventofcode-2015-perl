#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use AOC::Input;

our Readonly $PLAYER = 0;
our Readonly $BOSS = 1;

our Readonly $HIT_POINTS = 0;
our Readonly $COST = 0;
our Readonly $DAMAGE = 1;
our Readonly $ARMOR = 2;

our Readonly %WEAPON = (
    dagger     => [ 8, 4, 0 ],
    shortsword => [ 10, 5, 0 ],
    warhammer  => [ 25, 6, 0 ],
    longsword  => [ 40, 7, 0 ],
    greataxe   => [ 74, 8, 0 ]
);

our %ARMOR = (
    leather    => [ 13, 0, 1 ],
    chainmail  => [ 31, 0, 2 ],
    splintmail => [ 53, 0, 3 ],
    bandedmail => [ 75, 0, 4 ],
    platemail  => [ 102, 0, 5 ]
);

our %RINGS = (
    damage_plus_one    => [ 25, 1, 0 ],
    damage_plus_two    => [ 50, 2, 0 ],
    damage_plus_three  => [ 100, 3, 0 ],
    defense_plus_one   => [ 20, 0, 1 ],
    defense_plus_two   => [ 40, 0, 2 ],
    defense_plus_three => [ 80, 0, 3 ]
);

sub add_power {
    my ($weapon, $add) = @_;

    [ $$weapon[$COST] + $$add[$COST], $$weapon[$DAMAGE] + $$add[$DAMAGE], $$weapon[$ARMOR] + $$add[$ARMOR] ]
}

sub uniq (@){
    my %seen = ();
    grep { not $seen{"@$_"}++ } @_;
}

# create all possible strategies based on the weapons, armor and rings available ordered by cost (cheap to expensive)
sub strategies {
    my @strategies = ();

    foreach my $weapon (keys %WEAPON) {
        # only a weapon
        push @strategies, $WEAPON{$weapon};

        foreach my $armor (keys %ARMOR) {
            # a weapon and an armor
            push @strategies, add_power($WEAPON{$weapon}, $ARMOR{$armor});

            foreach my $ring1 (keys %RINGS) {
                # a weapon with one ring
                push @strategies, add_power($WEAPON{$weapon}, $RINGS{$ring1});

                # a weapon, an armor and one ring
                push @strategies, add_power(add_power($WEAPON{$weapon}, $ARMOR{$armor}), $RINGS{$ring1});

                foreach my $ring2 (keys %RINGS) {
                    next if $ring1 eq $ring2;
                    # a weapon with two rings
                    push @strategies, add_power($WEAPON{$weapon}, add_power($RINGS{$ring1}, $RINGS{$ring2}));

                    # a weapon, an armor and two ring
                    push @strategies, add_power(add_power($WEAPON{$weapon}, $ARMOR{$armor}), add_power($RINGS{$ring1}, $RINGS{$ring2}));
                }
            }
        }
    }

    sort {$$a[$COST] <=> $$b[$COST]} @strategies;
    # uniq sort {$$a[$COST] <=> $$b[$COST]} @strategies;
}

sub input {
    my $lines = shift;

    $$lines[$HIT_POINTS] =~ /Hit Points: (\d+)/;
    my $hitpoints = $1;
    $$lines[$DAMAGE] =~ /Damage: (\d+)/;
    my $damage = $1;
    $$lines[$ARMOR] =~ /Armor: (\d+)/;
    my $armor = $1;

    ($hitpoints, $damage, $armor)
}

sub play_game {
    my ($player, $boss, $verbose) = @_;

    while ($$player[$HIT_POINTS] > 0 && $$boss[$HIT_POINTS] > 0) {
        my $hit = $$player[$DAMAGE] - $$boss[$ARMOR];
        $$boss[$HIT_POINTS] -= $hit > 0 ? $hit : 1;
        if (defined $verbose) {
            print "The player deals $$player[$DAMAGE]-$$boss[$ARMOR] = ", $hit, " damage;";
            print "the boss goes down to $$boss[$HIT_POINTS] hit points,\n";
        }

        last if $$boss[$HIT_POINTS] <= 0;

        $hit = $$boss[$DAMAGE] - $$player[$ARMOR];
        $$player[$HIT_POINTS] -= $hit > 0 ? $hit : 1;
        if (defined $verbose) {
            print "The boss deals $$boss[$DAMAGE]-$$player[$ARMOR] = ", $hit, " damage;";
            print "the player  goes down to $$player[$HIT_POINTS] hit points,\n";
        }
    }

    $$boss[$HIT_POINTS] <= 0 ? $PLAYER : $BOSS;
}

unless (caller) {
    my @boss_start = input(AOC::Input::load("./resources/input-21.txt"));

    # find the first strategy the player will win (strategies are ordered by cost)
    my $strategy;
    foreach (strategies) {
        $strategy = $_;
        my @player = (100, $$strategy[$DAMAGE], $$strategy[$ARMOR]);
        my @boss = @boss_start;
        last if play_game(\@player, \@boss) == $PLAYER;
    }
    print "Day 21 - part 1: You can win the game with no less than $$strategy[$COST] of gold\n";

    # find most expensive lost game (you need to check all, for for the same cost you can have different
    # combinations of damage and armour, and those can have different outcome;
    my $max_lose;
    foreach (reverse strategies) {
        $strategy = $_;

        my @player = (100, $$strategy[$DAMAGE], $$strategy[$ARMOR]);
        my @boss = @boss_start;

        if (play_game(\@player, \@boss) == $BOSS) {
            $max_lose //= $$strategy[$COST];
            $max_lose = $$strategy[$COST] if $max_lose < $$strategy[$COST];
        }
        last if defined($max_lose) && $$strategy[$COST] < $max_lose;
    }
    print "Day 21 - part 2: You can lose the game with at most $max_lose of gold\n";
}

1;