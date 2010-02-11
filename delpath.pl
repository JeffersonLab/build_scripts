#!/usr/bin/env perl
#
# deleted element from path
#
if ($ARGV[0] eq '-l') {
    $pathtype = "LD_LIBRARY_PATH";
    shift @ARGV;
} else {
    $pathtype = "PATH";
}
$line=$ENV{$pathtype};
#print "$line\n";
@field = split(/:/,$line);
#print "number of fields $#field\n";
#print "number of fields to delete $#ARGV\n";
if ($#field == 0) {
    print "unsetenv $pathtype\n";
} else {
    $newpath = "";
    for ($j = 0; $j <= $#field ; $j++) {
	$path = $field[$j];
	#print "$j $path\n";
	$keep = 1;
	for($i = 0; $i <= $#ARGV; $i++) {
	    #print "$i $ARGV[$i]\n";
	    if ($path eq $ARGV[$i]) {
		$keep = 0;
	    }
	}
	if ($keep) {
	    #print "keep it\n";
	    if ($newpath ne "") {$newpath = $newpath . ":"}
	    $newpath = $newpath . $path;
	}
    }
    print "setenv $pathtype $newpath\n";
}
exit
