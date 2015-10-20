#!/usr/bin/perl

# get the version numbers of prerequisite packages for the requested package from the home directories defined in the environment
# write an xml file with the prerequisite version numbers

use XML::Simple;
use Data::Dumper;
use XML::Writer;
use IO::File;
use File::Slurp;
use File::Basename;
use Cwd 'abs_path';

$package_in = $ARGV[0];
if (! $package_in) {die "must name a package";}

my $output = IO::File->new(">${package_in}_prereqs_version.xml");
my $writer = XML::Writer->new(OUTPUT => $output, NEWLINES => 1);
$writer->startTag("gversion", "version" => "1.0");

$this_file_with_full_path = abs_path(__FILE__);
$build_scripts = dirname($this_file_with_full_path);
$bms_osname = `$build_scripts/osrelease.pl`;
chomp $bms_osname;
$definitions = read_file("$build_scripts/version_defs.pl");
eval $definitions;

%prereqs = (root => ['sim-recon'],
	    clhep => [],
	    jana => ['evio', 'ccdb', 'xerces-c', 'root'],
	    'sim-recon' => ['evio', 'cernlib', 'xerces-c', 'root', 'jana', 'hdds', 'ccdb'],
	    hdds => ['xerces-c'],
	    cernlib => [],
	    'xerces-c' => [],
	    geant4 => ['clhep'],
	    ccdb => []);

@prepackages = @{$prereqs{$package_in}};
$idebug = 0;
foreach $prepackage (@prepackages) {
    $version = '';
    $url = '';
    $dirtag = '';
    $branch = '';
    if ($prepackage eq 'cernlib') {
	$version = $ENV{CERN_LEVEL};
    } else {
	$home_var = $home_variable{$prepackage};
	$home_var_value = $ENV{$home_var};
	$svn_hidden_dir = $home_var_value . "/.svn";
	$git_hidden_dir = $home_var_value . "/.git";
	@token2 = split(/\//, $home_var_value); # split on slash
	$dirname_home = $token2[$#token2]; # last token is directory name
	if (-d $svn_hidden_dir) {
	    $url_raw = `svn info $home_var_value | grep URL: | grep https`;
	    chomp $url_raw;
	    #print "for $home_var = $home_var_value, url_raw = $url_raw\n";
	    @t = split(/URL: /, $url_raw);
	    $url = $t[1];
	    @token3 = split(/^/, $dirname_home); # split on caret
	    if ($#token3 > 0) {$dirtag = $token3[$#token3];}
	} elsif (-d $git_hidden_dir) {
	    $url_raw = `cd $home_var_value ; git remote -v | grep \"\(fetch\)\"`;
	    chomp $url_raw;
	    #print "for $home_var = $home_var_value, url_raw = $url_raw\n";
	    @t = split(/\s+/, $url_raw);
	    $url = $t[1];
	    $branch_raw = `cd $home_var_value ; git status | grep \" On branch \"`;
	    chomp $branch_raw;
	    #print "for $home_var = $home_var_value, branch_raw = $branch_raw\n";
	    @t = split(/\s+/, $branch_raw);
	    $branch = $t[3];
	    @token3 = split(/^/, $dirname_home); # split on caret
	    if ($#token3 > 0) {$dirtag = $token3[$#token3];}
	} else {
	    if ($home_var_value =~ 'ExternalPackages') {adjust_prefix_suffix()}
	    @token0 = split(/$dir_prefix{$prepackage}/, $home_var_value);
	    $home_var_value_tail = $token0[1];
	    if ($dir_suffix{$prepackage}) {
		@token1 = split(/$dir_suffix{$prepackage}/, $home_var_value_tail);
		$version = $token1[0];
	    } else {
		$version = $token0[1];
	    }
	    @token4 = split(/^/, $version);
	    if ($#token4 > 0) {
		$dirtag = $token4[$#token4];
		$dirtag_string = '^' . $dirtag;
		@token5 = split (/$dirtag_string/, $version);
		$version = $token5[0];
	    }
	}
    }
    #print "idebug = $idebug, prepackage = $prepackage, home_var = $home_var, home_var_value = $home_var_value, home_var_value_tail = $home_var_value_tail, dir_prefix{prepackage} = $dir_prefix{$prepackage}, dir_suffix{prepackage} = $dir_suffix{$prepackage}, version = $version\n";
    $write_element_command = "\$writer->emptyTag(\"package\", \"name\" => $prepackage";
    if ($version) {
	$write_element_command .= ", \"version\" => \"$version\"";
    } elsif ($url) {
	$write_element_command .= ", \"url\" => \"$url\"";
    } else {
	print "version_prereqs.pl, warning: for package $prepackage, version or url could not be determined, $home_var = $home_var_value\n";
    }
    if ($branch) {$write_element_command .= ", \"branch\" => \"$branch\"";}
    if ($dirtag) {$write_element_command .= ", \"dirtag\" => \"$dirtag\"";}
    $write_element_command .= ");";
    #print "write_element_command = $write_element_command\n";
    eval $write_element_command;
    $idebug++;
}

$writer->endTag("gversion");
$writer->end();
$output->close();

exit;

sub adjust_prefix_suffix {
    my @token0 = ();
    if ($prepackage eq 'root') {
	$dir_prefix{$prepackage} = '/ROOT/v';
	$dir_suffix{$prepackage} = '/root_';
    }
    if ($prepackage eq 'xerces-c') {
	@token0 = split(/$dir_prefix{$prepackage}/, $home_var_value);
	$home_var_value_tail = $token0[1];
	if ($home_var_value_tail =~ /.Linux/) {
	    $dir_suffix{$prepackage} = '.Linux';
	} elsif ($home_var_value_tail =~ /.Darwin/) {
	    $dir_suffix{$prepackage} = '.Darwin';
	} elsif ($home_var_value_tail =~ /.SunOS/) {
	    $dir_suffix{$prepackage} = '.SunOS';
	}
    }
    return;
}
