@packages = (root, clhep, jana, 'sim-recon', hdds, cernlib,
	     'xerces-c', ccdb, geant4, evio, rcdb, hdgeant4,
	     hd_utilities, gluex_root_analysis, amptools);

%home_variable = (root => 'ROOTSYS',
		  clhep => 'CLHEP',
		  jana => 'JANA_HOME',
		  'sim-recon' => 'HALLD_HOME',
		  hdds => 'HDDS_HOME',
		  cernlib => 'CERN',
		  'xerces-c' => 'XERCESCROOT',
		  geant4 => 'G4ROOT',
		  ccdb => 'CCDB_HOME',
		  evio => 'EVIOROOT',
		  rcdb => 'RCDB_HOME',
                  hdgeant4 => 'HDGEANT4_HOME',
                  hd_utilities => 'HD_UTILITIES_HOME',
                  gluex_root_analysis => 'ROOT_ANALYSIS_HOME',
                  amptools => 'AMPTOOLS_HOME');

%dir_prefix = (root => 'root[_-]',
	       clhep => '',
	       jana => 'jana_',
	       'sim-recon' => 'sim-recon-',
	       hdds => 'hdds-',
	       cernlib => 'special case',
	       'xerces-c' => 'xerces-c-',
	       geant4 => 'geant4.',
	       ccdb => 'ccdb_',
	       evio => 'evio-',
	       rcdb => 'rcdb_',
               hdgeant4 => 'hdgeant4-',
               hd_utilities => 'hd_utilities-',
               gluex_root_analysis => 'gluex_root_analysis-',
               amptools => 'AmpTools-');

$unames = `uname -s`;
chomp $unames;
$unamem = `uname -m`;
chomp $unamem;
$evio_suffix = '/' . $unames . '-' . $unamem;
%dir_suffix = (root => '',
	       clhep => '',
	       jana => '/' . $bms_osname,
	       'sim-recon' => '',
	       hdds => '',
	       cernlib => '',
	       'xerces-c' => '',
	       geant4 => '',
	       ccdb => '',
	       evio => $evio_suffix,
	       rcdb => '',
               hdgeant4 => '',
               hd_utilities => '',
               gluex_root_analysis => '',
               amptools => '');
