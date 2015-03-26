#!/usr/bin/env perl
%cern = (
  'Linux_Fedora8-i686-gcc4.1.2'   => '/apps/cernlib/i386_fc8',
  
  'Linux_RHEL5-i686-gcc4.1.2'     => '/group/halld/Software/ExternalPackages/cernlib/Linux_RHEL5-i686-gcc4.1.2',
  'Linux_CentOS5-i686-gcc4.1.2'   => '/group/halld/Software/ExternalPackages/cernlib/Linux_RHEL5-i686-gcc4.1.2',

  'Linux_RHEL5-x86_64-gcc4.1.2'   => '/group/halld/Software/ExternalPackages/cernlib/Linux_CentOS5-x86_64-gcc4.1.2',
  'Linux_CentOS5-x86_64-gcc4.1.2' => '/group/halld/Software/ExternalPackages/cernlib/Linux_CentOS5-x86_64-gcc4.1.2',
   'Linux_RHEL6-x86_64-gcc4.4.6'   => '/group/halld/Software/ExternalPackages/cernlib/Linux_CentOS6-x86_64-gcc4.4.6',
  'Linux_RHEL6-x86_64-gcc4.4.7'   => '/group/halld/Software/ExternalPackages/cernlib/Linux_CentOS6-x86_64-gcc4.4.6',
  'Linux_CentOS6-x86_64-gcc4.4.6' => '/group/halld/Software/ExternalPackages/cernlib/Linux_CentOS6-x86_64-gcc4.4.6',
  'Linux_CentOS6-x86_64-clang3.2' => '/group/halld/Software/ExternalPackages/cernlib/Linux_CentOS6-x86_64-gcc4.4.6',
  'Linux_CentOS6-x86_64-gcc4.4.7' => '/group/halld/Software/ExternalPackages/cernlib/Linux_CentOS6-x86_64-gcc4.4.6',
  'Linux_RHEL6-i686-gcc4.4.7' => '/apps/cernlib/i386_rhel6',
  'Linux_RHEL7-x86_64-gcc4.8.3' => '/group/halld/Software/builds/Linux_RHEL7-x86_64-gcc4.8.3/cernlib'
 	 );
$osrelease = `$ENV{BUILD_SCRIPTS}/osrelease.pl`;
chomp $osrelease;
#print "debug: osrelease = $osrelease\n";
$cern_cue = $cern{$osrelease};
print "$cern_cue\n";
exit;
