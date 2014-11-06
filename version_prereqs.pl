#!/usr/bin/perl

# get the version numbers of prerequisite packages for the requested package from the home directories defined in the environment
# write an xml file with the prerequisite version numbers

use XML::Simple;
use Data::Dumper;
use XML::Writer;
use IO::File;

$package_in = $ARGV[0];
if (! $package_in) {die "must name a package";}

my $output = IO::File->new(">${package_in}_prereqs_version.xml");
my $writer = XML::Writer->new(OUTPUT => $output, NEWLINES => 1);
$writer->startTag("gversion", "version" => "1.0");

%home_variable = (root => 'ROOTSYS',
                  clhep => 'CLHEP',
                  jana => 'JANA_HOME',
                  'sim-recon' => 'HALLD_HOME',
                  hdds => 'HDDS_HOME',
                  cernlib => 'special case',
                  'xerces-c' => 'XERCESCROOT',
                  geant4 => 'GEANT4_HOME',
                  ccdb => 'CCDB_HOME');


%version_prefix = (root => '/root_',
	       clhep => '/clhep/',
	       jana => '/jana_',
	       'sim-recon' => '/sim-recon-',
	       hdds => '/hdds-',
	       cernlib => '',
	       'xerces-c' => '/xerces-c-',
	       geant4 => '/geant4.',
	       ccdb => '/ccdb_');

%version_suffix = (root => '',
		  clhep => '/',
		  jana => '/' . $bms_osname,
		  'sim-recon' => '',
		  hdds => '',
		  cernlib => '',
		  'xerces-c' => '',
		  geant4 => '',
		  ccdb => '');



%prereqs = (root => [],
	    clhep => [],
	    jana => ['ccdb', 'xerces-c'],
	    'sim-recon' => ['cernlib', 'xerces-c', 'jana', 'hdds', 'ccdb'],
	    hdds => ['xerces-c'],
	    cernlib => [],
	    'xerces-c' => [],
	    geant4 => ['clhep'],
	    ccdb => []);

@prepackages = @{$prereqs{$package_in}};
$idebug = 0;
foreach $prepackage (@prepackages) {
    if ($prepackage eq 'cernlib') {
	$version = $ENV{CERN_LEVEL};
    } else {
	$home_var = $home_variable{$prepackage};
	$home_var_value = $ENV{$home_var};
	@token0 = split(/$version_prefix{$prepackage}/, $home_var_value);
	$home_var_value_tail = $token0[1];
	if ($prepackage eq 'xerces-c') {
	    if ($home_var_value_tail =~ /.Linux/) {
		$version_suffix{$prepackage} = '.Linux';
	    } elsif ($home_var_value_tail =~ /.Darwin/) {
		$version_suffix{$prepackage} = '.Darwin';
	    }
	}
	if ($version_suffix{$prepackage}) {
	    @token1 = split(/$version_suffix{$prepackage}/, $home_var_value_tail);
	    $version = $token1[0];
	} else {
	    $version = $token0[1];
	}
    }
#    print "idebug = $idebug, $prepackage, $home_var, $home_var_value, $version_prefix{$prepackage}, $token0[1], $version_suffix{$prepackage}, $version\n";
    $writer->emptyTag("package", "name" => $prepackage, "version" => $version);
    $idebug++;
}

$writer->endTag("gversion");
$writer->end();
$output->close();

exit;
