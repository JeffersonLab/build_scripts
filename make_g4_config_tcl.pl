#!/usr/bin/perl
print <<EOM;
#!/usr/bin/expect --
set timeout 60
spawn ./Configure -E -build
EOM
while (<>) {
    chomp;
    if (/^>/) {
	@token = split />/;
	print "send \"$token[1]\\r\"\n";
    } else {
	s/\[/\\\[/g;
	s/\]/\\\]/g;
	print "expect \"$_\"\n";
    }
}
print "interact\n";
exit;
