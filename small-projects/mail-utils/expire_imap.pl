#!/usr/bin/perl
#
# expire_imap.pl - Script to expire messages from an IMAP folder
#
# Written by Wil Cooley
#
# $Id$

use strict;
use warnings;
use English             qw( -no_match_var );
use File::Basename      qw( basename );
use Mail::IMAPClient;
use POSIX               qw( strftime );

if ( ( $#ARGV + 1 ) != 2 ) {
    &usage;
    exit;
}

# Configure here
my $imap_server = "SERVER";
my $imap_user   = "USERNAME";
my $imap_passwd = "PASSWORD";
my $imap_debug  = undef ; # Define for debugging
# End configure here

my $imap_folder         = $ARGV[1];
my $imap_seconds_older  = $ARGV[0] * 24 * 3600;
my $imap_expire_date    = make_imap_search_date($imap_seconds_older);
my $msgs_removed        = 0;
my $start_msg_count     = 0;
my $end_msg_count       = 0;

print "$imap_expire_date\n";

my $imap = Mail::IMAPClient->new(
    Server   => $imap_server,
    User     => $imap_user,
    Password => $imap_passwd,
);

# Record the number of messages
$start_msg_count = $imap->message_count($imap_folder);

$imap->Debug(1) if ($imap_debug);

# Select folder
$imap->select($imap_folder) 
    or die "Error selecting folder '$imap_folder': '$EVAL_ERROR'";

# Select expired messages
my @msgs_expired = $imap->search("SENTBEFORE $imap_expire_date");

# Remove each message and increment removed counter
for my $msgid (@msgs_expired) {
    $imap->delete_message($msgid)
        or warn "Error deleting message '$msgid': '$EVAL_ERROR'";

    $msgs_removed += 1;
}

# IMAP requires an EXPUNGE to actually delete message
$imap->expunge();

$end_msg_count = $imap->message_count($imap_folder);

printf "%-40s %6d / %6d / %6d\n", $imap_folder, $start_msg_count,
    $msgs_removed, $end_msg_count;

# Print usage
sub usage {
    my $name = basename($PROGRAM_NAME);
    print <<"EOF";
Usage: $name days folder
Where 'days' is the age of messages to expire and 'folder' is the IMAP
folder from which to expire messages.
EOF
}

# Generate a date given time in seconds since the epoch that can be
#   used with an IMAP search.  Has the form '01-Jan-2000'.
sub make_imap_search_date {
    my ($seconds_ago) = @_;
    return strftime("%d-%b-%Y", localtime(time - $seconds_ago));
}
