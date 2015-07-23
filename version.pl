#!/usr/bin/env perl

use XML::Simple;
use Data::Dumper;
use Getopt::Std;
use File::Slurp;
use File::Basename;
use Cwd 'abs_path';
use File::Basename;
 
$ERROR_NO_FILE_ARG = 1;
$ERROR_FILE_DOES_NOT_EXIST = 2;

$shell_type = define_shell_type();

$gluex_top_default = "/home/" . $ENV{USER} . "/gluex_top";

$this_file_with_full_path = abs_path(__FILE__);
$build_scripts = dirname($this_file_with_full_path);
$bms_osname = `$build_scripts/osrelease.pl`;
$definitions = read_file("$build_scripts/version_defs.pl");
eval $definitions;

if ($ENV{GLUEX_TOP}) {
    $gluex_top = $ENV{GLUEX_TOP};
} else {
    $gluex_top = $gluex_top_default;
    print_command('GLUEX_TOP', $gluex_top);
}

# get the file name
$filename = $ARGV[0];
if (!$filename) {
    print "error: version xml file name must be supplied as first argument\n";
    exit $ERROR_NO_FILE_ARG;
}
if (! -e $filename) {
    print "error: input version file \"$filename\" does not exist\n";
    exit $ERROR_FILE_DOES_NOT_EXIST;
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
    $dirtag = $d{dirtag};
    $url = $d{url};
    if ($version) {print_command("${name_in_caps}_VERSION", $version);}
    if ($name eq 'cernlib') {
	print_command('CERN', "$gluex_top/cernlib");
	print_command('CERN_LEVEL', $version);
	print_command('CERNLIB_WORD_LENGTH', $d{word_length});
    } else {
	if ($dirtag) {$sep = '^';} else {$sep = '';}
	if ($url) {
	    $basename = basename($url);
	    $package_home_dir = "$gluex_top/$name/$basename$sep$dirtag$dir_suffix{$name}";
	} else {
	    $package_home_dir = "$gluex_top/$name/$dir_prefix{$name}$version$sep$dirtag$dir_suffix{$name}";
	}
	$package_home_var = $home_variable{$name};
	print_command($package_home_var, $package_home_dir);
	if ($dirtag) {print_command("${name_in_caps}_DIRTAG", $dirtag);}
	if ($url) {print_command("${name_in_caps}_URL", $url);}
    }
}

exit;

sub define_shell_type {
    $opt_s = "";
    getopts('s:');
    $shell = $opt_s;
    my $shell_type = 'undefined';
    if ($shell eq 'sh') {
	$shell_type = 'Bourne';
    } elsif ($shell eq 'bash') {
	$shell_type = 'Bourne';
    } elsif ($shell eq 'csh') {
	$shell_type = 'C';
    } elsif ($shell eq 'tcsh') {
	$shell_type = 'C';
    } elsif ($shell eq '') {
	$shell_type = 'C';
    } else {
	die 'shell not recognized, use bash, sh, csh, or tcsh';
    }
    return $shell_type;
}

sub print_command {
    my ($variable, $definition) = @_;
    if ($shell_type eq 'C') {
	print "setenv $variable $definition;\n";
    } elsif ($shell_type eq 'Bourne') {
	print "export ${variable}=${definition};\n";
    } else {
	die "unrecognized shell type: $shell_type";
    }
}
