#!/usr/bin/perl
#
# $Id$
# Quick script to print stats from backup output
# Just reads stdin and prints on stdout

$totalmb = 0 ;
$totalfs = 0 ;
$total_transfer_rate = 0 ;

print "=================================\n" ;
print "  Dump Statistics\n" ;
print "=================================\n" ;

while (<STDIN>) {

	my $line = $_ ;
	#print "DEBUG: $line" ;

	chomp ($line) ;

	# Line with host name
	if ($line =~ /^Dumping host/) {
		#print $line, "\n" ;
		$line =~ s#Dumping host (.+)\.\.\.#$1# ;
		$host = $1 ;
		print "Host: $host\n" ;
		next ;
	}

	# Line with device being dumped
	if ($line =~ /(Dumping|Backing up) \/dev\//) {
		$line =~ s#Dumping (/dev/[^ ]+)#$1# ;
		$dev = $1 ;
		print "\tDevice: $dev " ;
		next ;
	}

	# We only want lines that have the size on them
	unless ( $line =~ /(KB|MB|blocks)/ && $line !~ /[Ee]stimated/ ) { 
		next ; 
	}

	# Get the byte count and add to total
	# Solaris ufsdump & Linux dump w/MB patch
	if ($line =~ /\((.+)MB\)/) {
		$total = $1 ;
		print "$total MB\n" ;
		$totalmb += $total ;
		next ;
	# Solaris' ufsdump sometimes reports in KB
	} elsif ($line =~ /\((.+)KB\)/) {
		$total = sprintf "%.2f", ($1/1024) ;
		print "$total MB\n" ;
		$totalmb += $total ;
		next ;
	# Linux dump w/o MB patch
	} elsif ($line =~ /DUMP: ([0-9]+) tape blocks/) {
		$total = sprintf "%.2f", ($1/1024) ;
		print "$total MB\n" ;
		$totalmb += $total ;
		next ;
	}

	# This line has the through-put on it
	if ($line =~ /(throughput| at ) (.+) KB/) {
		$total_transfer_rate += $2 ;

		# Number of FS needed for the average tranfer rate
		$totalfs++ ;
		next ;
	} 

}

print "=================================\n" ;
print "  Total backed up: $totalmb MB\n" ;
print "  Average transfer rate: " ;
printf "%.2f", $total_transfer_rate/$totalfs ;
print " KB/sec" ;
print " for ", $totalfs, " filesystems\n" ;
