#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

require "./src/day11.pl";

ok(contains_straight("hijklmmn"), "test contains straight works");
ok(contains_straight("abbceffg") == 0, "test contains straight fails");

ok(no_illegal_char("hijklmmn") == 0, "test contains no illegal char fails");
ok(no_illegal_char("abbceffg"), "test contains no illegal char");

ok(non_overlapping_pairs("abbceffg"), "test contains overlapping pairs");
ok(non_overlapping_pairs("abbcegjk") == 0, "test contains overlapping pairs fails");

ok(password("hijklmmn") == 0, "hijklmmn is no valid password");
ok(password("abbceffg") == 0, "abbceffg is no valid password");
ok(password("abbcegjk") == 0, "abbcegjk is no valid password");
ok(password("abcdffaa"), "abcdffaa is a valid password");
ok(password("ghjaabcc"), "ghjaabcc is a valid password");

is(next_password("abcdefgh"), "abcdffaa", 'next password after abcdefgh');
is(next_password("ghijklmn"), "ghjaabcc", 'next password after ghijklmn');

done_testing();

