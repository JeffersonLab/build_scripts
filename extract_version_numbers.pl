#!/usr/bin/env perl
$which = $ARGV[0];
$full_version = $ARGV[1];
@field = split(/\./, $full_version);
if ($which eq "major") {
    print $field[0], "\n";
} elsif ($which eq "minor") {
    print $field[1], "\n";
} elsif ($which eq "subminor") {
    print $field[2], "\n";
} else {
    print STDERR "error from extract_version_numbers.pl: ${which} is an undefined version field\n";
}
exit;
