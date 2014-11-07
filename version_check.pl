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

foreach $package (@packages) {
    print "== checking $package ==\n";
    $home_variable = $home_variable{$package};
    $home_value = $ENV{$home_variable};
    $home_value_hash{$package} = $home_value;
    if (-e $home_value) {
	print "$home_variable = $home_value\n";
    } else {
	print "$home_variable not defined\n";
    }
}

foreach $package (@packages) {
    if (-e $home_value_hash{$package}) {
	print "look for prereqs file for $package\n";
	$home_value = $home_value_hash{$package};
	$filename = $home_value . "/" . $package . "_prereqs_version.xml";
	if (-e $filename) {
	    print "found $filename\n";
	} else {
	    print "prerequisite version file $filename not found for $package\n";
	}
    }
}

exit;

$filename = $ARGV[0];
if (!$filename) {
    die 'error: version file name must be supplied as first argument';
}

$ref = XMLin($filename, KeyAttr=>[]);
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
    print_command("${name_in_caps}_VERSION", $version);
    if ($name eq 'cernlib') {
	print_command('CERN', "$gluex_top/cernlib");
	print_command('CERN_LEVEL', $version);
	print_command('CERNLIB_WORD_LENGTH', $d{word_length});
    } else {
	if ($version eq 'latest') {
	    $package_home_dir = "$gluex_top/$name/$name$dir_suffix{$name}";
	} else {
	    $package_home_dir = "$gluex_top/$name/$dir_prefix{$name}$version$dir_suffix{$name}";
	}
	$package_home_var = $home_variable{$name};
	print_command($package_home_var, $package_home_dir);
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
