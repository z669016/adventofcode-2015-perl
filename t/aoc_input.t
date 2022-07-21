#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Exception;

require './aoc_input.pm';

ok(AOC::Input::must_exist("./aoc_input.pm"), "must_exist");
dies_ok { AOC::Input::must_exist("./aoc_input.q") } "must_exist should die";
ok(AOC::Input::is_txt("./t/t.txt"));
ok(!AOC::Input::is_txt("./t/t.csv"));
ok(!AOC::Input::is_txt("./t/t.reg"));
ok(!AOC::Input::is_txt("./t/t.nop"));
ok(AOC::Input::is_csv("./t/t.csv"));
ok(!AOC::Input::is_csv("./t/t.txt"));
ok(!AOC::Input::is_csv("./t/t.reg"));
ok(!AOC::Input::is_csv("./t/t.nop"));
ok(AOC::Input::is_reg("./t/t.reg"));
ok(!AOC::Input::is_reg("./t/t.txt"));
ok(!AOC::Input::is_reg("./t/t.csv"));
ok(!AOC::Input::is_reg("./t/t.nop"));

is_deeply (AOC::Input::load("./t/t.txt"), ["1,2,3","4,5,6","7,8,9"], "Data loaded from txt file");
is_deeply (AOC::Input::load("./t/t.txt", {slice => [1,2]}), ["4,5,6","7,8,9"], "Data loaded from txt file sliced");

is_deeply (AOC::Input::load("./t/t.csv"), [[1,2,3],[4,5,6],[7,8,9]], "Data loaded from csv file");
is_deeply (AOC::Input::load("./t/t.csv", {slice => [0,2]}), [[1,2,3],[7,8,9]], "Data loaded from csv file sliced");
is_deeply (AOC::Input::load("./t/t.2.csv", {sep_char =>'/'}), [[1,2,3],[4,5,6],[7,8,9]], "Data loaded from csv file with separator");

my $reg = qr(a(\d+)b(\d+)c(\d+)d);
is_deeply (AOC::Input::load("./t/t.reg", {regexp => $reg}), [[1,2,3],[4,5,6],[7,8,9]], "Data loaded from reg file");
is_deeply (${AOC::Input::load("./t/t.reg", { regexp => $reg, slice => [ 2 ] })}, [7,8,9], "Data loaded from reg file sliced");

done_testing();

