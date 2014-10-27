#!/usr/bin/perl

use XML::Simple;
use Data::Dumper;

# define home directory prefix
$gluex_top_default = "/usr/local/gluex";
$bms_osname = `$ENV{BUILD_SCRIPTS}/osrelease.pl`;

%dir_prefix = (root => 'root_',
	       clhep => '',
	       jana => 'jana_',
	       'sim-recon' => 'sim-recon-',
	       hdds => 'hdds-',
	       cernlib => 'special case',
	       'xerces-c' => 'xerces-c-',
	       geant4 => 'geant4.',
	       ccdb => 'ccdb_');

%home_variable = (root => 'ROOTSYS',
		  clhep => 'CLHEP',
		  jana => 'JANA_HOME',
		  'sim-recon' => 'HALLD_HOME',
		  hdds => 'HDDS_HOME',
		  cernlib => 'special case',
		  'xerces-c' => 'XERCESCROOT',
		  geant4 => 'GEANT4_HOME',
		  ccdb => 'CCDB_HOME');

%dir_suffix = (root => '',
		  clhep => '',
		  jana => '/' . $bms_osname,
		  'sim-recon' => '',
		  hdds => '',
		  cernlib => '',
		  'xerces-c' => '',
		  geant4 => '',
		  ccdb => '');

if ($ENV{GLUEX_TOP}) {
    $gluex_top = $ENV{GLUEX_TOP};
} else {
    $gluex_top = $gluex_top_default;
    print "setenv GLUEX_TOP $gluex_top\n";
}

# get the file name
$filename = $ARGV[0];
if (!$filename) {
    die 'error: version file name must be supplied as first argument';
}
# slurp in the xml file
$ref = XMLin($filename, KeyAttr=>[]);
# dump it to the screen for debugging only
#print Dumper($ref);

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
    $name_in_caps = uc($name);
    $name_in_caps =~ s/-/_/g;
    $version = $d{version};
    print "setenv ${name_in_caps}_VERSION $version\n";
    if ($name eq 'cernlib') {
	print "setenv CERN $gluex_top/cernlib\n";
	print "setenv CERN_LEVEL $version\n";
	print "setenv CERNLIB_WORD_LENGTH $d{word_length}\n";
    } else {
	if ($version eq 'latest') {
	    $package_home_dir = "$gluex_top/$name/$name$dir_suffix{$name}";
	} else {
	    $package_home_dir = "$gluex_top/$name/$dir_prefix{$name}$version$dir_suffix{$name}";
	}
	$package_home_var = $home_variable{$name};
	print "setenv $package_home_var $package_home_dir\n";
    }
}

exit;
