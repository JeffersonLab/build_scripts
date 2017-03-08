#!/usr/bin/env perl

use XML::Simple;
use Getopt::Std;
use File::Slurp;
use File::Basename;
use Cwd 'abs_path';

$this_file_with_full_path = abs_path(__FILE__);
$build_scripts = dirname($this_file_with_full_path);
$bms_osname = `$build_scripts/osrelease.pl`;
chomp $bms_osname;
$definitions = read_file("$build_scripts/version_defs.pl");
eval $definitions;

%version_hash = ();
%url_hash = ();
%dirtag_hash = ();

# loop through packages, get value of home variable from environment,
# grab version info from the home directory

foreach $package (@packages) {
    #print "== unpack environment variable for $package ==\n";
    $home_variable = $home_variable{$package};
    $home_value = $ENV{$home_variable};
    #print "$home_variable = $home_value\n";
    $home_value_hash{$package} = $home_value;
    if (-e $home_value) {
	$version = '';
	$url = '';
	$branch = '';
	$dirtag = '';
	if ($package eq 'cernlib') {
	    $version_hash{$package} = $ENV{CERN_LEVEL}
	} else {
	    $svn_hidden_dir = $home_value . "/.svn";
	    $git_hidden_dir = $home_value . "/.git";
	    @token2 = split(/\//, $home_value); # split on slash
	    $dirname_home = $token2[$#token2]; # last token is directory name
	    if (-d $svn_hidden_dir) {
		$url_raw = `svn info $home_value | grep URL:`;
		chomp $url_raw;
		#print "for $home_variable = $home_value, url_raw = $url_raw\n";
		@t = split(/URL: /, $url_raw);
		$url = $t[1];
		@token3 = split(/^/, $dirname_home); # split on caret
		if ($#token3 > 0) {$dirtag = $token3[$#token3];}
	    } elsif (-d $git_hidden_dir) {

		$url_raw = `cd $home_value ; git remote -v | grep \"\(fetch\)\"`;
		chomp $url_raw;
		#print "for $home_variable = $home_value, url_raw = $url_raw\n";
		@t = split(/\s+/, $url_raw);
		$url = $t[1];

		$branch_raw = `cd $home_value ; git status | grep \" On branch \"`;
		chomp $branch_raw;
		#print "for $home_variable = $home_value, branch_raw = $branch_raw\n";
		@t = split(/\s+/, $branch_raw);
		$branch = $t[3];

		@token3 = split(/^/, $dirname_home); # split on caret
		if ($#token3 > 0) {$dirtag = $token3[$#token3];}

	    } else {
		# extract the version
		#print "dir_prefix = $dir_prefix{$package}\n";
		$dir_prefix_escaped = $dir_prefix{$package};
		$dir_prefix_escaped =~ s/\./\\\./g;
		@token0 = split(/$dir_prefix_escaped/, $home_value);
		$home_value_tail = $token0[1];
		#print "dir_suffix = $dir_suffix{$package}\n";
		if ($dir_suffix{$package}) {
		    @token1 = split(/$dir_suffix{$package}/, $home_value_tail);
		    $version_field = $token1[0];
		} else {
		    $version_field = $token0[1];
		}
		#print "version_field = $version_field\n";
		@token4 = split(/\^/, $version_field);
		if ($#token4 > 0) {
		    $dirtag = $token4[$#token4];
		    $dirtag_string = "\\^" . $dirtag;
		    @token5 = split (/$dirtag_string/, $version_field);
		    $version = $token5[0];
		} else {
		    $version = $version_field;
		}
		$version_hash{$package} = $version;
		#print "version from home dir name = $version_hash{$package}\n";
	    }
	}
	if ($dirtag) {
	    #print "dirtag found: \"$dirtag\"\n";
	    $dirtag_hash{$package} = $dirtag;
	}
	if ($url) {
	    #print "url found: \"$url\"\n";
	    $url_hash{$package} = $url;
	}
	if ($branch) {
	    #print "branch found: \"$branch\"\n";
	    $branch_hash{$package} = $branch;
	}
    } else {
	    #print "$home_variable not defined\n";
    }
}

foreach $package (@packages) {
    if (-e $home_value_hash{$package}) {
	#print "== look for prereqs file for $package ==\n";
	$home_value = $home_value_hash{$package};
	$filename = $home_value . "/" . $package . "_prereqs_version.xml";
	if (-e $filename) {
	    $consistent = 1;
	    #print "found $filename\n";
	    # slurp in the xml file
	    $ref = XMLin($filename, KeyAttr => [], ForceArray => 1);
	    $a = $ref->{'package'}; # an array reference;
	    #print "a = $a\n";
	    @b = @{$a}; # an array
	    #print "b = @b\n";
	    foreach $href (@b) {
		$c = $href; # a hash reference
		#print "c = $c\n";
		%d = %{$c}; # a hash
		#print "prerequisite = $d{name}\n";
		if ($d{version}) {
		    #print "version from prereq xml = $d{version}\n";
		    #print "version from home variable = $version_hash{$d{name}}\n";
		    if ($version_hash{$d{name}} eq $d{version}) {
			#print "versions match\n";
		    } else {
			$consistent = 0;
			$message = "======= version mismatch found =======\n";
			$message .= "== package being checked = $package\n";
			$message .= "== prerequisite package = $d{name}\n";
			$message .= "== prerequisite's home directory = $home_value_hash{$d{name}}\n";
			$message .= "== prerequisite version in home directory name = $version_hash{$d{name}}\n";
			$message .= "== ${package}'s prerequisite xml file = $filename\n";
			$message .= "== $d{name} version recorded in prerequisite xml file = $d{version}\n";
			print $message;
		    }
		} elsif ($d{url}) {
		    #print "url from prereq xml = $d{url}\n";
		    #print "url from home directory = $url_hash{$d{name}}\n";
		    if ($url_hash{$d{name}} eq $d{url}) {
			#print "urls match\n";
		    } else {
			$consistent = 0;
			$message = "======= url mismatch found =======\n";
			$message .= "== package being checked = $package\n";
			$message .= "== prerequisite package = $d{name}\n";
			$message .= "== prerequisite's home directory = $home_value_hash{$d{name}}\n";
			$message .= "== url found in home directory = $url_hash{$d{name}}\n";
			$message .= "== ${package}'s prerequisite xml file = $filename\n";
			$message .= "== $d{name} url recorded in prerequisite xml file = $d{url}\n";
			print $message;
		    }
		} else {
		    print "info: no version and no url for prereq $d{name} of $package\n";
		}
		# check branch
		$branch_repo = $branch_hash{$d{name}};
		if ($branch_repo) {
		    if ($d{branch}) { # branch appears in prereq spec
			if ($branch_repo ne $d{branch}) {
			    $consistent = 0;
			    $message = "======= git branch mismatch found =======\n";
			    $message .= "== package being checked = $package\n";
			    $message .= "== prerequisite package = $d{name}\n";
			    $message .= "== prerequisite's home directory = $home_value_hash{$d{name}}\n";
			    $message .= "== branch checked out in home directory name = $branch_repo\n";
			    $message .= "== ${package}'s prerequisite xml file = $filename\n";
			    $message .= "== branch in prerequisite xml file for $d{name} = $d{branch}\n";
			    print $message;
			}
		    } else { # no branch in prereq spec
			if ($branch_repo ne "master") {
			    $consistent = 0;
			    $message = "======= git branch mismatch found =======\n";
			    $message .= "== package being checked = $package\n";
			    $message .= "== prerequisite package = $d{name}\n";
			    $message .= "== prerequisite's home directory = $home_value_hash{$d{name}}\n";
			    $message .= "== branch checked out in home directory name = $branch_repo\n";
			    $message .= "== ${package}'s prerequisite xml file = $filename\n";
			    $message .= "== no branch specified in prerequisite xml file for $d{name}\n";
			    print $message;
			}
		    }
		}
		# check dirtags
		$dirtag_dirname = $dirtag_hash{$d{name}};
		$dirtag_xmlfile = $d{dirtag};
		#print "dirtag_dirname = /$dirtag_dirname/, dirtag_xmlfile = /$dirtag_xmlfile/\n";
		if (! $dirtag_dirname && ! $dirtag_xmlfile) {
		    #print "both dirtags missing: OK, nothing to conflict\n";
		} elsif ($dirtag_dirname && ! $dirtag_xmlfile) {
		    $consistent = 0;
		    $message = "======= directory tag mismatch found =======\n";
		    $message .= "== package being checked = $package\n";
		    $message .= "== prerequisite package = $d{name}\n";
		    $message .= "== prerequisite's home directory = $home_value_hash{$d{name}}\n";
		    $message .= "== directory tag in home directory name = $dirtag_dirname\n";
		    $message .= "== ${package}'s prerequisite xml file = $filename\n";
		    $message .= "== no directory tag in prerequisite xml file for $d{name}\n";
		    print $message;
		} elsif (! $dirtag_dirname && $dirtag_xmlfile) {
		    $consistent = 0;
		    $message = "======= directory tag mismatch found =======\n";
		    $message .= "== package being checked = $package\n";
		    $message .= "== prerequisite package = $d{name}\n";
		    $message .= "== prerequisite's home directory = $home_value_hash{$d{name}}\n";
		    $message .= "== no directory tag in home directory name\n";
		    $message .= "== ${package}'s prerequisite xml file = $filename\n";
		    $message .= "== directory tag for $d{name} in prerequisite xml file = $dirtag_xmlfile\n";
		    print $message;
		} elsif ($dirtag_dirname && $dirtag_xmlfile) {
		    if ($dirtag_dirname eq $dirtag_xmlfile) {
			#print "dirtags agree\n";
		    } else {
			$consistent = 0;
			$message = "======= directory tag mismatch found =======\n";
			$message .= "== package being checked = $package\n";
			$message .= "== prerequisite package = $d{name}\n";
			$message .= "== prerequisite's home directory = $home_value_hash{$d{name}}\n";
			$message .= "== directory tag in home directory name = $dirtag_dirname\n";
			$message .= "== ${package}'s prerequisite xml file = $filename\n";
			$message .= "== directory tag for $d{name} in prerequisite xml file = $dirtag_xmlfile\n";
			print $message;
		    }
		} else {
		    print "major error, this cannot happen\n";
		}
	    }
	    if ($consistent) {
		#print "versions are consistent for $package\n";
	    }
	} else {
	    #print "warning: no prerequisite version file found for $package\n";
	}
    }
}

exit;
