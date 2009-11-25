#!/usr/bin/env perl
%cern = ('Linux_RHEL5-i686-gcc4.1.2' => 'i386_rhel5',
	 'Linux_Fedora8-i686-gcc4.1.2' => 'i386_fc8',,
	 'Linux_CentOS5-x86_64-gcc4.1.2' => 'x86_64_rhel5'
	 );
$osrelease = `$ENV{BUILD_SCRIPTS}/osrelease.pl`;
chomp $osrelease;
#print "debug: osrelease = $osrelease\n";
#print "debug: $cern{'Linux_RHEL5-i686-gcc4.1.2'}\n";
$cern_cue = $cern{$osrelease};
print "$cern_cue\n";
exit;
