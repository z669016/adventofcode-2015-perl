#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

sub contains_straight {
    my $password = shift;
    my @password_ord = map {ord($_)} split //, $password;

    foreach my $i (0 .. $#password_ord - 2) {
        return 1 if $password_ord[$i] == $password_ord[$i+1] - 1 and $password_ord[$i+1] == $password_ord[$i+2] - 1;
    }

    return 0;
}

sub no_illegal_char {
    my $password = shift;
    not $password =~ /[iol]/
}

sub non_overlapping_pairs {
    my $password = shift;

    my @password = split //, $password;
    my $i = 0;
    my $pairs = "";

    while ($i < $#password) {
        if ($password[$i] eq $password[$i+1] and not $pairs =~ /$password[$i]/) {
            $pairs .= $password[$i];
            $i++;
        }
        $i++;
    }

    length($pairs) > 1;
}

sub password {
    my $password = shift;

    no_illegal_char($password) and contains_straight($password) and non_overlapping_pairs($password);
}

sub next_password {
    my $password = shift;
    my @password = split //, $password;

    while (1) {
        for (my $i = $#password; $i >= 0; $i--) {
            $password[$i] = chr(ord($password[$i]) + 1);
            last if $password[$i] le 'z';
            $password[$i] = 'a';
        }

        $password = join '', @password;
        last if password($password);
    }

    $password;
}

unless (caller) {

        my $password = "vzbxkghb";
    my $next_password = next_password($password);
    print "Day 11 - part 1: Santa's next password after $password is $next_password\n";

    $password = $next_password;
    $next_password = next_password($password);
    print "Day 11 - part 2: Santa's next password after $password is $next_password\n";
}

1;