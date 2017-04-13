#!/usr/bin/env perl
#
# delete element from path
#
$pathtype = "PATH";
$shell = "C";
@token = ();
$this = shift;
while ($this) {
    if ($this =~ m/^-/) {
	if ($this eq '-l') {
	    $pathtype = "LD_LIBRARY_PATH";
	} elsif ($this eq '-p') {
	    $pathtype = "PYTHONPATH";
	} elsif ($this eq '-b') {
	    $shell = "Bourne";
	} else {
	    die "bad command option: $this";
	}
    } else {
	#print STDERR "delete $this\n";
	push (@token, ($this));
    }
    $this = shift;
}
$line=$ENV{$pathtype};
#print STDERR "$line\n";
@field = split(/:/,$line);
#print STDERR "number of fields - 1 = $#field\n";
#print STDERR "number of fields to delete - 1 = $#token\n";
if ($#field == -1) {
    if ($shell eq "C") {
	print "unsetenv $pathtype\n";
    } else {
	print "unset $pathtype\n";
    }
} else {
    $newpath = "";
    for ($j = 0; $j <= $#field ; $j++) {
	$path = $field[$j];
	#print STDERR "$j $path\n";
	$keep = 1;
	for($i = 0; $i <= $#token; $i++) {
	    #print "$i $token[$i]\n";
	    if ($path eq $token[$i]) {
		$keep = 0;
	    }
	}
	if ($keep) {
	    #print STDERR "keep it\n";
	    if ($newpath ne "") {$newpath = $newpath . ":"}
	    $newpath = $newpath . $path;
	}
    }
    if ($shell eq "C") {
	print "setenv $pathtype $newpath\n";
    } else {
	print "export $pathtype=$newpath\n";
    }
}
exit
