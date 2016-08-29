#!/usr/bin/env perl

use XML::Simple;
use Data::Dumper;
use Getopt::Std;
use File::Slurp;
use XML::Writer;

# get the file name
getopts("i:o:d:h");
$filename_in = $opt_i;
$filename_out = $opt_o;
$halld_home = $opt_d;
if ($opt_h) {
    print_usage();
    exit;
}
if (!$filename_in || !$filename_out || !$halld_home) {
    print "\nError: required command-line option missing\n\n";
    print_usage();
    exit 1;
}
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
    #print "package = $name, version = $version\n";
    if ($name ne "sim-recon") {
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
	$write_element_command .= ");";
	#print "write_element_command = $write_element_command\n";
	eval $write_element_command;
    } else {
	$writer->emptyTag("package", "name" => "$name", "home" => "$halld_home");
    }
}

$writer->endTag("gversion");
$writer->end();
$output->close();

exit;

sub print_usage {
    my $usage = <<'EOM';
custom_sim_recon.pl: creates a version xml file with custom sim-recon home directory.

Options, all required:
    -i <input xml file name>
    -o <output xml file name>
    -d <sim-recon home directory>
EOM

    print $usage;
}
