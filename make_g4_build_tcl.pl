#!/usr/bin/perl
print <<EOM;
#!/usr/bin/expect --
set timeout 60
spawn ./Configure -build
EOM
while (<>) {
    chomp;
    if (/^>/) {
	split />/;
	print "send \"$_[1]\\r\"\n";
    } else {
	s/\[/\\\[/g;
	s/\]/\\\]/g;
	print "expect \"$_\"\n";
    }
}
print "interact\n";
exit;
