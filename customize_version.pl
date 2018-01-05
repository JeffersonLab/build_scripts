#!/usr/bin/env perl

use XML::Simple;
use Data::Dumper;
use Getopt::Std;
use File::Slurp;
use XML::Writer;
use IO::File;

# get the file name
getopts("i:o:s:g:4:a:h");
$filename_in = $opt_i;
$filename_out = $opt_o;
$halld_home = $opt_s;
$hdds_home = $opt_g;
$hdgeant4_home = $opt_4;
$gluex_root_analysis_home = $opt_a;

if ($opt_h) {
    print_usage();
    exit;
}
if (!$filename_in || !$filename_out ) {
    print "\nError: required command-line option missing\n\n";
    print_usage();
    exit 1;
}
if (!($halld_home || $hdds_home || $hdgeant4_home || $gluex_root_analysis_home)) {
    print "\nError: no custom home directories specified, no action taken\n\n";
    print_usage();
    exit 2;
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
    if ($name eq "sim-recon" && $halld_home) {
	if (uc($halld_home) ne "NONE") {
	    $writer->emptyTag("package", "name" => "$name", "home" => "$halld_home");
	}
    } elsif ($name eq "hdds" && $hdds_home) {
	if (uc($hdds_home) ne "NONE") {
	    $writer->emptyTag("package", "name" => "$name", "home" => "$hdds_home");
	}
    } elsif ($name eq "hdgeant4" && $hdgeant4_home) {
	if (uc($hdgeant4_home) ne "NONE") {
	    $writer->emptyTag("package", "name" => "$name", "home" => "$hdgeant4_home");
	}
    } elsif ($name eq "gluex_root_analysis" && $gluex_root_analysis_home) {
	if (uc($gluex_root_analysis_home) ne "NONE") {
	    $writer->emptyTag("package", "name" => "$name", "home" => "$gluex_root_analysis_home");
	}
    } else {
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
    }
}

$writer->endTag("gversion");
$writer->end();
$output->close();

print "\nInfo: contents of $filename_out:\n";
print "----------------------------------------\n";
system("cat $filename_out");
print "----------------------------------------\n";

exit;

sub print_usage {
    my $usage = <<'EOM';
custom_sim_recon.pl: creates a version xml file with custom sim-recon home directory.

Options:
    -i <input XML file name> (required)
    -o <output XML file name> (required)
    -s <custom sim-recon home directory> (optional, s for sim-recon)
    -g <custom HDDS home directory> (optional, g for geometry)
    -4 <custom HDGeant4 home directory> (optional, 4 for 4)
    -a <custom gluex_root_analysis home directory> (optional, a for analysis)
    -h print this usage message

Note: if custom home directory name = "none", corresponding package element
will be omitted in output XML file.
EOM

    print $usage;
}
