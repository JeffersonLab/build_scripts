#!/usr/bin/expect --
set timeout 60
spawn ./Configure -d -build
expect "\[Type carriage return to continue\] "
send "\r"
interact
