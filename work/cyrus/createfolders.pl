#!/usr/bin/perl -w
#
# Written by Wil Cooley <wcooley@nakedape.cc>, 25 April 2002.
#
# This script is copyright (C) 2002 by Wil Cooley and
# licensed under the GNU GPL <http://www.gnu.org//licenses/gpl.txt>
#
# Usage:    createfolders.pl inputfile
#
# Purpose:  Creates empty Cyrus submailboxes.  Top-level mailboxes must exist.
#
# Input:    Output of bsd2cyrus script.
#
# $Id$
###

use Cyrus::IMAP::Admin ;

$adminuser = "cyrus" ;
$server = "localhost" ;
$inputfile = "$ARGV[0]" ;

unless ($inputfile) { die "Usage: $0 inputfile\n" ; }

open(INFILE, $inputfile) || die "Unable to open $inputfile" ;

$imapcon = Cyrus::IMAP::Admin->new($server) || die "Unable to connect to $server";
$imapcon->authenticate(-user => $adminuser, -mechanism => "LOGIN") ;

die $imapcon->error if ($imapcon->error) ;

while ($line = <INFILE>) {
    ($user, $mailbox, $mbxpath) = split (':', $line) ;

    unless($imapcon->list($mailbox)) {
        $imapcon->create($mailbox) ;
        if ($imapcon->error) {
            print $imapcon->error, "\n" ;
        } else {
            print "Created mailbox $mailbox\n" ;
        }
    } else {
        print "Skipping $mailbox (already exists)\n" ;
    }

}
