#!/usr/bin/perl -w

use strict ;
require Mail::IMAPClient;

my $imap = {
    Server => 'localhost',
    User => 'wcooley',
    Password =>  'UnV3r$'
} ;

my $conn = new Mail::IMAPClient(%{$imap}) ;

$conn or die "Unable to connect to server: $!" ;

my @folders = $conn->folders() ;
my $fcnt = 0 ;
my $total = 0 ;

foreach my $f (@folders) {
    my $cnt = $conn->message_count($f) ;
    next unless ($cnt) ; # Skip bogus folders
    $total += $cnt ;
    $fcnt++ ;
    print $f, " has ", $cnt, " message" ;
    print $cnt == 1 ? "\n" : "s\n" ;
}

print "Total messages: ", $total, " in ", $fcnt, " folders\n" ;
