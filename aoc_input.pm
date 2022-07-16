package AOC::Input;
use strict;
use warnings FATAL => 'all';
use feature qw/fc/;

use File::Basename;
use Text::CSV;

use constant {
    TXT         => ".txt",
    CSV         => ".csv",
};

use constant SUPPORTED_TYPES => (TXT,CSV);

sub must_exist {
    my $path = shift;
    die "File '$path' doesn't exist" if not -e $path;
}

sub cmp_ext {
    my ($path, $expected) = @_;
    my (undef, undef, $ext) = fileparse($path, SUPPORTED_TYPES);
    fc($ext) eq fc($expected);
}

sub is_csv {
    my $path = shift;
    cmp_ext($path, ".csv");
}

sub is_txt {
    my $path = shift;
    cmp_ext($path, ".txt");
}

sub text {
    my $fh = shift;
    chomp(my @data = <$fh>);
    return \@data;
}

sub csv {
    my $fh = shift;
    my @data = ();
    my $csv = Text::CSV->new({ sep_char => ',' });
    while (<$fh>) {
        chomp;

        if ($csv->parse($_)) {
            push @data, $csv->fields();
        } else {
            warn "Line could not be parsed: $_\n";
        }
    }
    return \@data;
}

sub load {
    my ($path, $slice) = @_;
    must_exist($path);
    open my $fh, "<", $path or die "Couldn't open input file '$path': $!";

    my $data;
    if (is_txt($path)) {
        $data = text($fh);
    } elsif (is_csv($path)) {
        $data = csv($fh);
    } else {
        die "Unknown input file type for '$path'";
    }
    close $fh;

    if (defined($slice)) {
        return \@$data[$slice];
    }

    $data;
}

1;