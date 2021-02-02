#!/usr/bin/env perl

use XML::Simple;
use Data::Dumper;
use Getopt::Std;
use File::Slurp;
use XML::Writer;
use IO::File;

$repo = $ARGV[0];
$branch_to_test = $ARGV[1];
$bms_osname = $ARGV[2];
$date = `date +%F`;
chomp $date;

$filename_in = "/u/scratch/gluex/nightly/$date/$bms_osname/version_$date.xml";
$filename_out = "version_${repo}_${branch_to_test}.xml";

# slurp in the xml file
$ref = XMLin($filename_in, KeyAttr=>[]);
# dump it to the screen for debugging only
#print Dumper($ref);

my $output = IO::File->new(">$filename_out");
my $writer = XML::Writer->new(OUTPUT => $output, NEWLINES => 1);
$writer->startTag("gversion", "version" => "1.0");

$a = $ref->{'package'}; # an array reference;
#print "a = $a\n";
@b = @{$a}; # an array
#print "b = @b\n";
foreach $href (@b) {
    $c = $href; # a hash reference
    #print "c = $c\n";
    %d = %{$c}; # a hash
    #print "d{name} = $d{name}\n";
    #print "d{version} = $d{version}\n";
    $name = $d{name};
    $version = $d{version};
    $dirtag = $d{dirtag};
    $url = $d{url};
    $branch = $d{branch};
    $home = $d{home};
    $hash = $d{hash};
    $debug_level = $d{debug_level};
    #print "package = $name, version = $version\n";
    if ($name eq $repo) {
	$version = '';
	$dirtag = $branch_to_test;
	$url = '';
	$branch = $branch_to_test;
	$home = "/work/halld/pull_request_test/$repo^$branch_to_test";
	$debug_level = '';
    }
    $write_element_command = "\$writer->emptyTag(\"package\", \"name\" => \"$name\"";
    if ($version) {
	$write_element_command .= ", \"version\" => \"$version\"";
    }
    if ($dirtag) {
	$write_element_command .= ", \"dirtag\" => \"$dirtag\"";
    }
    if ($url) {
	$write_element_command .= ", \"url\" => \"$url\"";
    }
    if ($branch) {
	$write_element_command .= ", \"branch\" => \"$branch\"";
    }
    if ($home) {
	$write_element_command .= ", \"home\" => \"$home\"";
    }
    if ($debug_level ne '') {
	$write_element_command .= ", \"debug_level\" => \"$debug_level\"";
    }
    $write_element_command .= ");";
    #print "write_element_command = $write_element_command\n";
    eval $write_element_command;
}

$writer->endTag("gversion");
$writer->end();
$output->close();

exit;
