#!/usr/bin/perl -w
#
# Written by Wil Cooley <wcooley@nakedape.cc>, 25 April 2002.
#
# This script is copyright (C) 2002 by Wil Cooley and
# licensed under the GNU GPL <http://www.gnu.org//licenses/gpl.txt>
#
# Usage:    migrate-pw-to-cyrus2.pl
#
# Purpose:  Creates empty Cyrus mailboxes.
#
# Input:    None.
#
# Notes:    Set the default quota below.  I used a default
#           of 100MB more as a failsafe than a restriction.
#
# $Id$
###
my $adminuser = "cyrus" ;
my $server = "localhost" ;
my $quota = 100*1024 ; # 100MB
my $user_uid_start = 500 ;
my $err = 0 ;
my ($user,$p,$uid) ;

use Cyrus::IMAP::Admin;

$imapcon = Cyrus::IMAP::Admin->new($server) || die "Unable to connect to $server";

unless ($imapcon) {
    die "Error creating IMAP connection object\n" ;
}

$imapcon->authenticate(-user => $adminuser, -mechanism => "LOGIN") ;

if ($imapcon->error) {
    die $imapcon->error ;
}

print "\n" ;


setpwent() ;

while (($user,$p,$uid) = getpwent) {
    if ($uid >= $user_uid_start) {
        unless ($imapcon->list("user.$user")) {
            $imapcon->create("user.$user") ;
            if ($imapcon->error) { 
                print "ERROR: ", $imapcon->error, "\n" ; 
                next; 
            } ;
            $imapcon->setquota("user.$user", "STORAGE", $quota) ;
            if ($imapcon->error) { 
                print "ERROR: ", $imapcon->error, "\n"; 
                next; 
            } ;
            print "Created mailbox user.$user [$uid]\n" ;
        }
    }
}

endpwent() ;

