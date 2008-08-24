#!/usr/bin/env perl
#
# Written so that:
#
# o it can be put in .cshrc
# o repeated invocations do not add paths that already exist
# o an invocation will not eliminate paths that already exist
# 
# This results in a consistent path, regardless of how far down you are
# in the process stack.
#
$line=$ENV{'PATH'};
#print "$line\n";
@field = split(/:/,$line);
#print "number of fields $#field\n";
#print "number of fields to delete $#ARGV\n";
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
print "setenv PATH $newpath\n";
exit
