#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

require "./src/day19.pl";

my @data = (
    'H => HO',
    'H => OH',
    'O => HH',
    '',
    'HOH'
);

my $transformations = main::transformations(\@data);
my $molecule = main::molecule(\@data);
is($molecule, "HOH");

my $molecules = main::calibrate($transformations, "HOH");
is(@$molecules, 4, "calibrate HOH");
$molecules = main::calibrate($transformations, "HOHOHO");
is(@$molecules, 7, "calibrate HOHOHO");

done_testing();

