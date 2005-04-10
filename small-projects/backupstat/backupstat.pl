#!/usr/bin/perl
#
# $Id$
# Quick script to print stats from backup output
# Just reads stdin and prints on stdout

$totalmb = 0 ;
$totalfs = 0 ;
$total_transfer_rate = 0 ;

sub print_record_stats {
	print "  Level $level: $dev ($fs)\n" ;
	if ($errors) {
		print "        Approximately *${errors}* errors\n" ;
	} else {
		print "        Total $size MB\n" ;
		print "        Rate: $rate KB/s\n" ;
	}

	print "\n" ;
}


print "=================================\n" ;
print "  Dump Statistics\n" ;
print "=================================\n" ;

while (<STDIN>) {

	my $line = $_ ;
	#print "DEBUG: $line" ;

	chomp ($line) ;

	# Line with host name
	if ($line =~ /^Dumping host/) {
		$line =~ s#Dumping host (.+)\.\.\.#$1# ;
		$host = $1 ;
		print "Host: $host\n" ;
		next ;
	}

	# Line with device being dumped
	if ($line =~ /^Dumping/) {
	#if ($line =~ /(^Dumping|Backing up)/) {

		$debug == 1 &&  print "DEBUG:", $line, "\n" ;

		# This always signifies the beginning of a new dump
		# record, so set pre-record variables to null and print
		# previous dump record entry.  Last entry will be handled at 
		# bottom.

		# Only really want this is this script is being run on the 
		# dumping host
		# if ( $host =~ /^$/ ) { 
		# 	$host = `hostname` ;
		# 	print "Host: $host" ;
		# }

		# Skip first time, because nothing will be set
		if ( $dev !~ /^$/ ) {
			print_record_stats() ;
			$dev = $fs = $size = $level = $errors = "" ;
		}

		next ;
	}

	if ($line =~ /(Dumping|Backing up) \/dev\//) {
		# Extract the device being dumped
		$line =~ s#Dumping (/dev/[^ ]+) \((.*)\)#$1# ;
		$dev = $1 ;
		$fs = $2 ;

		$debug && print "DEBUG: dev: $dev\n" ;
		next ;
	}

	# Get the byte count and add to total
	# Solaris ufsdump & Linux dump w/MB patch
	if ($line =~ /\((.+)MB\)/) {
		$size = $1 ;
		$totalmb += $size ;
		next ;
	# Solaris' ufsdump sometimes reports in KB
	} elsif ($line =~ /\((.+)KB\)/) {
		$size = sprintf "%.2f", ($1/1024) ;
		$totalmb += $size ;
		next ;
	# Linux dump w/o MB patch
	} elsif ($line =~ /DUMP: ([0-9]+) tape blocks/) {
		$size = sprintf "%.2f", ($1/1024) ;
		$totalmb += $size ;
		next ;
	}

	# This line has the through-put on it
	if ($line =~ /(Average transfer rate:) (.+) KB/) {
		$rate = $2 ;
		$total_transfer_rate += $rate ;

		# Number of FS needed for the average tranfer rate
		$totalfs++ ;
		$debug && print "DEBUG: Seen fs's: $totalfs\tTotal Xfer Rate: $total_transfer_rate\n" ;
		next ;
	} 

	if ($line =~ /Date of this level (\d*)/) {
		$level = $1 ;
	}

	if ($line =~ /More than (\d*) block read errors/) {
		$errors = $1 ;
	}

	#print "\nDEBUG: " . $line . "\n" ;

}

# One last time for the last record
print_record_stats () ;

print "=================================\n" ;
print "  Total backed up: $totalmb MB\n" ;
print "  Average transfer rate: " ;
printf "%.2f", $total_transfer_rate/$totalfs ;
print " KB/sec" ;
print " for ", $totalfs, " filesystems\n" ;
print "\n" ;
