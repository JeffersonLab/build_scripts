#!/usr/bin/env perl

use XML::Simple;
use Getopt::Std;
use File::Slurp;
use File::Basename;
use Cwd 'abs_path';

$this_file_with_full_path = abs_path(__FILE__);
$build_scripts = dirname($this_file_with_full_path);
$definitions = read_file("$build_scripts/version_defs.pl");
eval $definitions;

$version_hash = ();
foreach $package (@packages) {
    print "== checking $package ==\n";
    $home_variable = $home_variable{$package};
    $home_value = $ENV{$home_variable};
    $home_value_hash{$package} = $home_value;
    if (-e $home_value) {
	print "$home_variable = $home_value\n";
	if ($package eq 'cernlib') {
	    $version_hash{$package} = $ENV{CERN_LEVEL}
	} else {
	    # extract the version
	    print "dir_prefix = $dir_prefix{$package}\n";
	    @token0 = split(/$dir_prefix{$package}/, $home_value);
	    $home_value_tail = $token0[1];
	    print "dir_suffix = $dir_suffix{$package}\n";
	    if ($dir_suffix{$package}) {
		@token1 = split(/$dir_suffix{$package}/, $home_value_tail);
		$version_hash{$package} = $token1[0];
	    } else {
		$version_hash{$package} = $token0[1];
	    }
	}
	print "version = $version_hash{$package}\n";
    } else {
	print "$home_variable not defined\n";
    }
}

foreach $package (@packages) {
    if (-e $home_value_hash{$package}) {
	print "== look for prereqs file for $package ==\n";
	$home_value = $home_value_hash{$package};
	$filename = $home_value . "/" . $package . "_prereqs_version.xml";
	if (-e $filename) {
	    print "found $filename\n";
	    # slurp in the xml file
	    $ref = XMLin($filename, KeyAttr => [], ForceArray => 1);
	    $a = $ref->{'package'}; # an array reference;
	    print "a = $a\n";
	    @b = @{$a}; # an array
	    print "b = @b\n";
	    foreach $href (@b) {
		$c = $href; # a hash reference
		print "c = $c\n";
		%d = %{$c}; # a hash
		print "d{name} = $d{name}\n";
		print "d{version} = $d{version}\n";
		print "stored version = $version_hash{$d{name}}\n";
		if ($version_hash{$d{name}} eq $d{version}) {print "versions match\n";} else {print "version mismatch\n";}
	    }
	} else {
	    print "prerequisite version file $filename not found for $package\n";
	}
    }
}

exit;
