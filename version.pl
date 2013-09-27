#!/usr/bin/perl

use XML::Simple;
use Data::Dumper;

# get the file name
$filename = $ARGV[0];
if (!$filename) {
    die 'error: version file name must be supplied as first argument';
}
# slurp in the xml file noisily
$ref = XMLin($filename, KeyAttr=>[]);
# dump it to the screen for debugging only
#print Dumper($ref);

$a = $ref->{'package'}; # an array reference;
#print "a = $a\n";
@b = @{$a}; # an array
#print "b = @b\n";
$n = 0;
$nb = $#b + 1;
foreach $href (@b) {
    $c = $href; # a hash reference
    #print "c = $c\n";
    %d = %{$c}; # a hash
    #print "d{name} = $d{name}\n";
    #print "d{version} = $d{version}\n";
    $name = uc($d{name});
    $name =~ s/-/_/g;
    $version = $d{version};
    print "setenv ${name}_VERSION $version";
    if ($name eq 'CERNLIB') {
	print " ; setenv CERNLIB_WORD_LENGTH $d{word_length}";
    }
    $n++;
    if ($n < $nb) {print " ; "}
}
print "\n";

exit;
