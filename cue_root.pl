#!/usr/bin/env perl
%rootsys = ('Linux_RHEL5-i686-gcc4.1.2' => '/apps/root/PRO/root',
	 'Linux_Fedora8-i686-gcc4.1.2' => '/apps/root/PRO/root',
	 'Linux_CentOS5-x86_64-gcc4.1.2' => '/site/root/5.24/Linux_CentOS5.3-x86_64-gcc4.1.2'
	    );
$osrelease = `$ENV{BUILD_SCRIPTS}/osrelease.pl`;
chomp $osrelease;
#print "debug: osrelease = $osrelease\n";
#print "debug: $cern{'Linux_RHEL5-i686-gcc4.1.2'}\n";
$rootsys = $rootsys{$osrelease};
print "$rootsys\n";
exit;