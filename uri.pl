#!/usr/bin/perl
 
use URI::Escape;
 
my $string = ';[sGueRsr1_Fvc_a[vB/';
   $string = ';\[sGueRsr1_Fvc_a\[vB/';
#              ;[sGueRsr1_Fvc_a[vB/
my $encode = uri_escape($string);
 
print "Original string: $string\n";
print "URL Encoded string: $encode\n";
