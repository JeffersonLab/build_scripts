#!/usr/bin/env perl
%rootsys = ('Linux_RHEL5-i686-gcc4.1.2' => '/apps/root/PRO/root',
	 'Linux_Fedora8-i686-gcc4.1.2' => '/apps/root/PRO/root',
	 'Linux_CentOS5-x86_64-gcc4.1.2' => '/apps/root/5.26-00-64bit/root',
	 'Linux_RHEL5-x86_64-gcc4.1.2' => '/apps/root/5.26-00-64bit/root'
	    );
$osrelease = `$ENV{BUILD_SCRIPTS}/osrelease.pl`;
chomp $osrelease;
#print "debug: osrelease = $osrelease\n";
#print "debug: $cern{'Linux_RHEL5-i686-gcc4.1.2'}\n";
$rootsys = $rootsys{$osrelease};
print "$rootsys\n";
exit;
