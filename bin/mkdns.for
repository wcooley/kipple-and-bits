#!/usr/bin/perl -w
#
# mkdns.for -- This script takes a network address and generates a list of 
#  A records for every host on that network.
#
# Written by W. Reilly Cooley <wcooley@greets.com>
# Begun: 11 Jan 2000
# Last-Modified: 12 Jan 2000
#

use Net::Netmask ;

# Must end with a dot!
$domain = "creative.gemmaster.com." ;
$prefix = "unassigned" ;
$suffix = "" ;
$ttl	= 86400 ;
$mx	= "mail.gemmaster.com." ;
$mx_prio = 10 ;

if ( @ARGV != 1 && @ARGV != 2) {
	print <<EOF ;
	Usage: $0 x.x.x.x
	Where x.x.x.x is a valid IP network number, recognized by
	Net::Netmask.  See 'man Net::Netmask' for more information.
EOF
	exit -1 ;
}

$block = new Net::Netmask ($ARGV[0], $ARGV[1]);

foreach $hostaddr ($block->enumerate()) {
	$hostquad = $hostaddr ;
	$hostquad =~ s#(.*)\.(.*)\.(.*)\.(.*)#$4# ;
	$hostname = $prefix . $hostquad . $suffix ;
	print "$hostname\t$ttl\tIN\tA\t$hostaddr\n" ;
	print "\t\tIN\tMX $mx_prio\t$mx\n" ;
	
}
