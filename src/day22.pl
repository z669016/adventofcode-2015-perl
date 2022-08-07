#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use AOC::Input;
use List::PriorityQueue;
use Data::Dumper;

our Readonly $PLAYER = 0;
our Readonly $BOSS = 1;

our Readonly $HIT_POINTS = 0;
our Readonly $COST = 0;
our Readonly $DAMAGE = 1;
our Readonly $ARMOR = 2;

our Readonly %SPELL = (
    missile  => {
        name   => "missile",
        cost   => 53,
        turns  => 1,
        damage => 4,
        armor  => 0,
        heal   => 0,
        mana   => 0,
    },
    drain    => {
        name   => "drain",
        cost   => 73,
        turns  => 1,
        damage => 2,
        armor  => 0,
        heal   => 2,
        mana   => 0,
    },
    shield   => {
        name   => "shield",
        cost   => 113,
        turns  => 6,
        damage => 0,
        armor  => 7,
        heal   => 0,
        mana   => 0,
    },
    poison   => {
        name   => "poison",
        cost   => 173,
        turns  => 6,
        damage => 3,
        armor  => 0,
        heal   => 0,
        mana   => 0,
    },
    recharge => {
        name   => "recharge",
        cost   => 229,
        turns  => 5,
        damage => 0,
        armor  => 0,
        heal   => 0,
        mana   => 101,
    },
);

sub new_player {
    my $player = shift;

    # copy player state
    my %new_player = (
        spend         => $$player{spend} // 0,
        mana          => $$player{mana},
        hitpoints     => $$player{hitpoints},
        damage        => 0,
        armor         => 0,
        active_spells => {},
    );

    foreach (keys %{$$player{active_spells}}) {
        $new_player{active_spells}{$_}{name} = $$player{active_spells}{$_}{name};
        $new_player{active_spells}{$_}{turns} = $$player{active_spells}{$_}{turns};
        $new_player{active_spells}{$_}{damage} = $$player{active_spells}{$_}{damage};
        $new_player{active_spells}{$_}{armor} = $$player{active_spells}{$_}{armor};
        $new_player{active_spells}{$_}{heal} = $$player{active_spells}{$_}{heal};
        $new_player{active_spells}{$_}{mana} = $$player{active_spells}{$_}{mana};
    }

    \%new_player;
}

sub new_boss {
    my $boss = shift;

    {hitpoints => $$boss{hitpoints}, damage => $$boss{damage},};
}

sub print_turn {
    my ($who, $player, $boss) = @_;

    print "--$who turn--\n";
    print "Player has $$player{hitpoints} hit points, $$player{armor} armor, $$player{mana} mana\n";
    print "Boss has $$boss{hitpoints} hit points\n";
}

sub add_active_spell {
    my ($active_spells, $next_spell) = @_;

    $$active_spells{$$next_spell{name}} = {
        name   => $$next_spell{name},
        turns  => $$next_spell{turns},
        damage => $$next_spell{damage},
        armor  => $$next_spell{armor},
        heal   => $$next_spell{heal},
        mana   => $$next_spell{mana},
    };
}

sub activate_spells {
    my ($player, $verbose) = @_;
    $verbose //= 0;

    $$player{damage} = 0;
    $$player{armor} = 0;

    # take a turn of each spell and remove the spell if turns equals 0
    foreach (keys %{$$player{active_spells}}) {
        my $spell = $$player{active_spells}{$_};

        print "$$spell{name} deals " if $verbose == 1;
        $$spell{turns} -= 1;

        print "$$spell{damage} damage " if $verbose == 1 and $$spell{damage} > 0;
        $$player{damage} += $$spell{damage};

        print "$$spell{armor} armor " if $verbose == 1 and $$spell{armor} > 0;
        $$player{armor} += $$spell{armor};

        print "$$spell{heal} hit points " if $verbose == 1 and $$spell{heal} > 0;
        $$player{hitpoints} += $$spell{heal};

        print "$$spell{mana} mana " if $verbose == 1 and $$spell{mana} > 0;
        $$player{mana} += $$spell{mana};

        print "; timer is now $$spell{turns}\n" if $verbose == 1;
        delete $$player{active_spells}{$_} if $$spell{turns} == 0;
    }
}

sub play_turn {
    my ($player, $boss, $next_spell, $hard, $verbose) = @_;
    $hard //= 0;
    $verbose //= 0;

    # copy player state
    my $new_player = new_player($player);
    my $new_boss = new_boss($boss);

    print_turn("player", $new_player, $new_boss) if $verbose == 1;

    if ($hard == 1) {
        $$new_player{hitpoints} -= 1;
        return ($new_player, $new_boss) if $$new_player{hitpoints} <= 0;
    }

    # Cast the new spell
    print "player casts $$next_spell{name}\n" if $verbose == 1;
    $$new_player{mana} -= $$next_spell{cost};
    $$new_player{spend} += $$next_spell{cost};

    # add the spell immediately if active only once
    if ($$next_spell{turns} == 1) {
        add_active_spell($$new_player{active_spells}, $next_spell);
    }

    # Player attacks
    activate_spells($new_player, $verbose);
    $$new_boss{hitpoints} -= $$new_player{damage};

    print_turn("boss", $new_player, $new_boss) if $verbose == 1;

    # Boss attacks
    if ($$next_spell{turns} > 1) {
        add_active_spell($$new_player{active_spells}, $next_spell);
    }
    activate_spells($new_player, $verbose);
    $$new_boss{hitpoints} -= $$new_player{damage};

    # game ends if boss has <= 0 hitpoints;
    return ($new_player, $new_boss) if $$new_boss{hitpoints} <= 0;

    # boss attach after spells
    print "Boss attacks for $$boss{damage} damage\n" if $verbose == 1;
    $$new_player{hitpoints} -= ($$new_boss{damage} - $$new_player{armor}) > 0 ? ($$new_boss{damage} - $$new_player{armor}) : 1;

    ($new_player, $new_boss)
}

sub options {
    my $player = shift;
    my $active_spells = $$player{active_spells};
    map {$SPELL{$_}}
        grep {(not defined($$active_spells{$_}) or $$active_spells{$_}{turns} == 1) and $SPELL{$_}{cost} <= $$player{mana}} keys %SPELL;
}

sub play_game {
    my ($player, $boss, $hard, $verbose) = @_;
    $hard //= 0;
    $verbose //= 0;

    my $prio = List::PriorityQueue->new;
    $prio->insert([ $player, $boss ], 0);

    my $state;
    while ($state = $prio->pop) {
        ($player, $boss) = @$state;

        last if $$boss{hitpoints} <= 0;
        next if $$player{hitpoints} <= 0;

        my @options = options($player);
        foreach (@options) {
            my ($new_player, $new_boss) = play_turn($player, $boss, $_, $hard, $verbose);
            $prio->insert([ $new_player, $new_boss ], $$new_player{spend}) if $$new_player{spend} < 2000;
        }
    }

    defined $state ? @$state : undef;
}

sub input {
    my $lines = shift;

    $$lines[$HIT_POINTS] =~ /Hit Points: (\d+)/;
    my $hitpoints = $1;
    $$lines[$DAMAGE] =~ /Damage: (\d+)/;
    my $damage = $1;

    { hitpoints => $hitpoints, damage => $damage }
}

unless (caller) {
    my $player = {
        hitpoints => 50,
        mana      => 500,
    };
    my $boss = input(AOC::Input::load("./resources/input-22.txt"));
    my $hard = 0;

    ($player, $boss) = play_game($player, $boss, $hard);
    print "Day 22 - part 1: player won spending $$player{spend} mana\n";

    $player = {
        hitpoints => 50,
        mana      => 500,
    };
    $boss = input(AOC::Input::load("./resources/input-22.txt"));
    $hard = 1;
    ($player, $boss) = play_game($player, $boss, $hard);
    print "Day 22 - part 2: player won the hard game spending $$player{spend} mana\n";
}

1;