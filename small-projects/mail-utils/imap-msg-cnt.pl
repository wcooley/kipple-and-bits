#!/usr/bin/perl -w
#
# File:         imap-msg-cnt.pl
#
# Description:  Counts the number of messages and folders in
#               an IMAP server.  Tested with Cyrus IMAP;
#               might work with other IMAP servers.  One day
#               I might implement calculating folder sizes,
#               but it's not as quick an operation (nor is
#               it as easy to implement).
#
# Author:       Wil Cooley <wcooley@nakedape.cc>
#
# $Id$

use strict ;
use vars qw($opt_s $opt_u $opt_p $opt_h) ;
use Mail::IMAPClient;
use Getopt::Std;
use File::Basename;

my ($imap, $tmpuser, $tots, $folder) ;

$tots = list_folders( get_options() ) ;

foreach $folder (sort keys %{$tots}) {
    next if ($folder eq "Total") ;

    print $folder, " has ", $tots->{$folder}, " message" ;
    print $tots->{$folder} == 1 ? "\n" : "s\n" ;

}

print "Total messages: ", $tots->{'Total'}[0], " in ", $tots->{'Total'}[1], 
    " folders\n" ;

sub usage {
    my ($exitval) = @_;

    $exitval = 1 if not defined $exitval;

    print "Usage: ", basename($0), " [ -s imapserver ] "
        . "[ -u username ] [ -p password ]\n"
        . "Tallies IMAP folder and message counts.\n"
        . "\n"
        . "Copyright (C) 2003, Naked Ape Consulting\n"
        . "The script distributed under the GNU GPL.\n" ;

    exit $exitval;
}

sub get_options {
    my %imap ;

    usage(1) if not (getopts('hs:u:p:'));

    usage(0) if ($opt_h);

    if ($opt_s) {
        $imap{'Server'} = $opt_s ;
    } else {
        print STDERR "IMAP Host (localhost): " ;
        chomp ($imap{'Server'} = <STDIN>) ;
        $imap{'Server'} = "localhost" unless ($imap{'Server'}) ;
    }

    if ($opt_u) {
        $imap{'User'} = $opt_u ;
    } else {
        $tmpuser = (getpwuid($<))[0] ; # Default to the current username
        print STDERR "Username ($tmpuser): " ;
        chomp ($imap{'User'} = <STDIN>) ;
        $imap{'User'} = $tmpuser unless ($imap{'User'}) ;
    }

    if ($opt_p) {
        $imap{'Password'} = $opt_p ;
    } else {
        system "stty -echo" ;
        print STDERR "Password: " ;
        chomp ($imap{'Password'} = <STDIN>) ;
        print STDERR "\n" ;
        system "stty echo" ;
    }

    return \%imap ;
}


sub list_folders {
    my $imap = shift ;
    my %folder_totals ;
    my $folder_cnt = 0 ;
    my $total = 0 ;
    my $conn = new Mail::IMAPClient(%{$imap}) ;

    $conn or die "Unable to connect to server: $!" ;

    my @folders = $conn->folders() ;

    foreach my $f (@folders) {
        my $cnt = $conn->message_count($f) ;
        next unless ($cnt) ; # Skip bogus folders
        $total += $cnt ;
        $folder_cnt++ ;
        $folder_totals{$f} = $cnt ;
    }

    # 'Total' is a special key
    $folder_totals{'Total'} = [$total, $folder_cnt] ;

    return \%folder_totals ;
}
