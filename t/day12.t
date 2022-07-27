#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

require "./src/day12.pl";

my $elem = 12;
is(main::num_sum($elem), 12, "num_sum integer");
$elem = [1,2,3];
is(main::num_sum($elem), 6, "num_sum array");
$elem = {"a" => 2, "b" => 4};
is(main::num_sum($elem), 6, "num_sum hash");
$elem = [[[3]]];
is(main::num_sum($elem), 3, "num_sum nested array");
$elem = {"a" => {"b" => 4}, "c" => -1};
is(main::num_sum($elem), 3, "num_sum nested hash");
$elem = {"a"=> [-1,1]};
is(main::num_sum($elem), 0, "num_sum nested mixed hash");
$elem = [-1,{"a"=> 1}];
is(main::num_sum($elem), 0, "num_sum nested mixed array");
$elem = [];
is (main::num_sum($elem), 0, "empty array");
$elem = {};
is (main::num_sum($elem), 0, "empty hash");

my $count_red = 0;
$elem = [1,2,3];
is(main::num_sum($elem, $count_red), 6, "no red num_sum array");
$elem = [1,{"c"=>"red","b"=>2},3];
is(main::num_sum($elem, $count_red), 4, "no red num_sum nested mixed array");
$elem = {"d"=>"red","e"=>[1,2,3,4],"f"=>5};
is(main::num_sum($elem, $count_red), 0, "no red num_sum nested mixed hash");
$elem = [1,"red",5];
is(main::num_sum($elem, $count_red), 6, "no red num_sum array 2");

done_testing();

