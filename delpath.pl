#!/usr/bin/env perl
#
# deleted element from path
#
$pathtype = "PATH";
$shell = "C";
@token = ();
$this = shift;
while ($this) {
    if ($this =~ m/^-/) {
	if ($this eq '-l') {
	    $pathtype = "LD_LIBRARY_PATH";
	} elsif ($this eq '-b') {
	    $shell = "Bourne";
	} else {
	    die 'bad command option';
	}
    } else {
	push (@token, ($this));
    }
    $this = shift;
}
$line=$ENV{$pathtype};
#print "$line\n";
@field = split(/:/,$line);
#print "number of fields $#field\n";
#print "number of fields to delete $#ARGV\n";
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
	#print "$j $path\n";
	$keep = 1;
	for($i = 0; $i <= $#token; $i++) {
	    #print "$i $token[$i]\n";
	    if ($path eq $token[$i]) {
		$keep = 0;
	    }
	}
	if ($keep) {
	    #print "keep it\n";
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
