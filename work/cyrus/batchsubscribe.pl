#!/usr/bin/perl -w
#
# Written by Wil Cooley <wcooley@nakedape.cc>, 25 April 2002.
#
# This script is copyright (C) 2002 by Wil Cooley and
# licensed under the GNU GPL <http://www.gnu.org//licenses/gpl.txt>
#
# Usage:    batchsubscribe.pl inputfile
#
# Purpose:  Subscribes users to their mail folders.
#
# Input:    Output of bsd2cyrus script.
#
# Notes:    Cyrus seems to want the list of mailboxes
#           sorted, so pipe the output of bsd2cyrus through 'sort'
#           first.
#
# $Id$
###

$inputfile = "$ARGV[0]" ;
$imapuserpath = "/var/imap/user" ;

unless ($inputfile) { die "Usage: $0 inputfile\n" ; }

open(INFILE, $inputfile) || die "Unable to open $inputfile" ;

foreach $line (<INFILE>) {

    ($user, $mailbox, $oldmailbox) = split(/:/, $line) ;

    $fl = substr($user, 0, 1) ;

    $subfile = $imapuserpath . "/" . $fl . "/" . $user .  ".sub" ;

    print ("Adding $mailbox to $subfile\n") ;

    open (SUBFILE, ">>$subfile") || die "Unable to open $subfile" ;

    print SUBFILE $mailbox, "\n" ;

    close (SUBFILE) ;


}


