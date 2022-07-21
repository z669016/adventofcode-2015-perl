package AOC::Input;

use strict;
use warnings FATAL => 'all';
use feature qw/fc/;

use version;
our $VERSION = version->declare('v0.0.1');

use File::Basename;
use Text::CSV;
use Readonly;

Readonly my $TXT => ".txt";
Readonly my $CSV => ".csv";
Readonly my $REG => ".reg";
Readonly my @SUPPORTED_TYPES => ($TXT, $CSV, $REG);

Readonly my $SLICE => "slice";
Readonly my $REGEXP => "regexp";
Readonly my $SEP_CHAR => "sep_char";

sub must_exist {
    my $path = shift;
    -e $path or die "File '$path' doesn't exist";
}

sub cmp_ext {
    my ($path, $expected) = @_;
    my (undef, undef, $ext) = fileparse($path, @SUPPORTED_TYPES);
    fc($ext) eq fc($expected);
}

sub is_csv {
    my $path = shift;
    cmp_ext($path, $CSV);
}

sub is_txt {
    my $path = shift;
    cmp_ext($path, $TXT);
}

sub is_reg {
    my $path = shift;
    cmp_ext($path, $REG);
}

sub load_text {
    my $fh = shift;
    chomp(my @data = <$fh>);
    return \@data;
}

sub load_csv {
    my ($fh, $options) = @_;
    my @data = ();
    my $sep_char = $$options{$SEP_CHAR} // ',';
    my $csv = Text::CSV->new({ $SEP_CHAR => $sep_char });
    while (<$fh>) {
        chomp;

        if ($csv->parse($_)) {
            push @data, [ $csv->fields() ];
        }
        else {
            warn "Line could not be parsed: $_\n";
        }
    }
    return \@data;
}

sub load_reg {
    my ($fh, $options) = @_;

    unless (defined $$options{$REGEXP}) {
        die "Missing option{regexp} for loading parseable text file.";
    }

    my $data = load_text($fh);
    my $regexp = $$options{$REGEXP};
    foreach (@$data) {
        my @line = $_ =~ /$regexp/;
        $_ = \@line;
    }

    return $data;
}

sub load {
    my ($path, $options) = @_;
    $options //= {};

    must_exist($path);
    open my $fh, "<", $path or die "Couldn't open input file '$path': $!";

    my $data;
    if (is_txt($path)) {
        $data = load_text($fh);
    }
    elsif (is_csv($path)) {
        $data = load_csv($fh, $options);
    }
    elsif (is_reg($path)) {
        $data = load_reg($fh, $options);
    }
    else {
        die "Unknown input file type for '$path'";
    }
    close $fh;

    my $slice = $$options{$SLICE};
    if (defined $slice) {
        if (@$slice == 1) {
            return \(@$data)[@$slice];
        }
        else {
            return [ (@$data)[@$slice] ];
        }
    }

    $data;
}

1;