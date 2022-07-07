#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Digest::MD5 qw/md5_hex/;

my $secret = "bgvyzdsv";

sub lowest_decimal {
    my ($start_code, $decimal) = @_;
    my $size = length($start_code);

    $decimal //= 0;
    while (1) {
        my $digest = md5_hex($secret . $decimal);
        last if (substr($digest, 0, $size) eq $start_code);
        $decimal++;
    }

    $decimal;
}

print "Day 4 - part 1: The lowest decimal is ", lowest_decimal("0" x 5), "\n";
print "Day 4 - part 2: The lowest decimal is ", lowest_decimal("0" x 6), "\n";