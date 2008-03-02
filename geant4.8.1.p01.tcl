#!/usr/bin/expect --
set timeout 60
spawn ./Configure -build
expect "\[Type carriage return to continue\]"
sleep 2
send "\r"
expect "\[Type carriage return to continue\]"
sleep 2
send "\r"
expect "\[Type carriage return to continue\]"
sleep 2
send "\r"
expect " for default settings"
sleep 2
send "\r"
expect "Do you expect to run these scripts and binaries on multiple machines"
sleep 2
send "y\r"
expect "Where is Geant4 source installed?"
sleep 2
send "\r"
expect "Specify the path where Geant4 libraries and source files should be"
sleep 2
send "\r"
expect "Do you want to copy all Geant4 headers"
expect "in one directory?"
sleep 2
send "\r"
expect "Please, specify default directory where ALL the Geant4 data is installed"
expect "You will be asked about customizing these next"
sleep 2
send "\r"
expect "doesn\'t exist.  Use that name anyway?"
sleep 2
send "y\r"
expect "Please, specify default directory where the Geant4 data is installed:"
expect "for default settings"
sleep 2
send "\r"
expect "Could not find CLHEP installed on this system"
sleep 2
send "/usr/local/clhep/1.9.3.1\r"
expect "You can customize paths and library name of you CLHEP installation"
expect "for default settings"
sleep 2
send "\r"
expect "Do you want to build \'shared\' (.so) libraries?"
sleep 2
send "no shared libraries\r"
expect "Do you want to build \'global\' compound libraries?"
sleep 2
send "no global\r"
expect "Do you want to compile libraries in DEBUG mode"
sleep 2
send "no debug\r"
expect "G4UI_NONE"
sleep 2
send "no UI none = yes UI\r"
expect "G4UI_BUILD_XAW_SESSION"
expect "G4UI_USE_XAW"
sleep 2
send "no athena\r"
expect "G4UI_BUILD_XM_SESSION"
expect "G4UI_USE_XM"
sleep 2
send "yes motif\r"
expect "Specify the correct path where Xm is installed in your system."
sleep 2
send "\r"
expect "G4VIS_NONE"
sleep 2
send "no vis none = vis yes\r"
expect "G4VIS_BUILD_OPENGLX_DRIVER"
expect "G4VIS_USE_OPENGLX"
sleep 2
send "yes openglx\r"
expect "G4VIS_BUILD_OPENGLXM_DRIVER"
expect "G4VIS_USE_OPENGLXM"
sleep 2
send "yes openglxm\r"
expect "G4VIS_BUILD_DAWN_DRIVER"
expect "G4VIS_USE_DAWN"
sleep 2
send "no dawn\r"
expect "G4VIS_BUILD_OIX_DRIVER"
expect "G4VIS_USE_OIX"
sleep 2
send "no open inventor\r"
expect "G4VIS_BUILD_RAYTRACERX_DRIVER"
expect "G4VIS_USE_RAYTRACERX"
sleep 2
send "yes raytrace\r"
expect "G4VIS_BUILD_VRML_DRIVER"
expect "G4VIS_USE_VRML"
sleep 2
send "yes vrml\r"
expect "OGLHOME/include"
expect "OGLHOME/lib"
expect "Specify the correct path \(OGLHOME\) where OpenGL is installed in your system."
sleep 2
send "\r"
expect "G4LIB_BUILD_G3TOG4"
sleep 2
send "no g3tog4\r"
expect "G4LIB_BUILD_ZLIB"
sleep 2
send "yes zlib\r"
expect "G4ANALYSIS_USE"
sleep 2
send "no analysis\r"
expect "to start installation or use a shell escape to edit config.sh"
interact
