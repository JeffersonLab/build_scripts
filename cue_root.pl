#!/usr/bin/env perl

#%rootsys = ('Linux_RHEL5-i686-gcc4.1.2' => '/apps/root/5.26-00/root',
#	 'Linux_Fedora8-i686-gcc4.1.2' => '/apps/root/PRO/root',
#	 'Linux_CentOS5-x86_64-gcc4.1.2' => '/apps/root/5.26-00-64bit/root',
#	 'Linux_RHEL5-x86_64-gcc4.1.2' => '/apps/root/5.26-00-64bit/root',
#	 'Linux_RHEL6-x86_64-gcc4.4.5' => '/apps/root/5.30.00/root',
#	 'Linux_RHEL6-x86_64-gcc4.4.6' => '/apps/root/5.30.00/root'
#	    );

%rootsys = (
  'Linux_Fedora8-i686-gcc4.1.2'   => '/apps/root/PRO/root',
  'Linux_RHEL6-x86_64-gcc4.4.5'   => '/apps/root/5.30.00/root',

  'Linux_RHEL5-i686-gcc4.1.2'     => '/group/halld/Software/ExternalPackages/ROOT/v5.34.01/root_Linux_RHEL5-i686-gcc4.1.2',
  'Linux_CentOS5-i686-gcc4.1.2'   => '/group/halld/Software/ExternalPackages/ROOT/v5.34.01/root_Linux_RHEL5-i686-gcc4.1.2',

  'Linux_RHEL5-x86_64-gcc4.1.2'   => '/group/halld/Software/ExternalPackages/ROOT/v5.34.01/root_Linux_CentOS5-x86_64-gcc4.1.2',
  'Linux_CentOS5-x86_64-gcc4.1.2' => '/group/halld/Software/ExternalPackages/ROOT/v5.34.01/root_Linux_CentOS5-x86_64-gcc4.1.2',

  'Linux_RHEL6-x86_64-gcc4.4.6'   => '/group/halld/Software/ExternalPackages/ROOT/v5.34.01/root_Linux_CentOS6-x86_64-gcc4.4.6',
  'Linux_RHEL6-i686-gcc4.4.7'     => '/apps/root/5.34.02/root',
  'Linux_RHEL6-x86_64-gcc4.4.7'   => '/group/halld/Software/ExternalPackages/ROOT/v5.34.01/root_Linux_CentOS6-x86_64-gcc4.4.6',
  'Linux_CentOS6-x86_64-gcc4.4.6' => '/group/halld/Software/builds/Linux_CentOS6-x86_64-gcc4.4.6/root/root_5.34.26',
  'Linux_CentOS6-x86_64-gcc4.4.7' => '/group/halld/Software/builds/Linux_CentOS6-x86_64-gcc4.4.7/root/root_5.34.26',
  'Linux_CentOS6-x86_64-clang3.2' => '/group/halld/Software/ExternalPackages/ROOT/v5.34.01/root_Linux_CentOS6-x86_64-clang3.2',
  'Linux_RHEL7-x86_64-gcc4.8.3'   => '/group/halld/Software/builds/Linux_RHEL7-x86_64-gcc4.8.3/root/root_5.34.26'
 	    );

$osrelease = `$ENV{BUILD_SCRIPTS}/osrelease.pl`;
chomp $osrelease;
#print "debug: osrelease = $osrelease\n";
#print "debug: $cern{'Linux_RHEL5-i686-gcc4.1.2'}\n";
$rootsys = $rootsys{$osrelease};
print "$rootsys\n";
exit;
