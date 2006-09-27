#!/usr/bin/perl
#
# expire_imap.pl - Script to expire messages from an IMAP folder
#
# Written by Wil Cooley
#
# $Id$

use strict;
use warnings;
use AppConfig;
use English             qw( -no_match_var );
use File::Basename      qw( basename );
use Mail::IMAPClient;
use POSIX               qw( strftime );

my $config = AppConfig->new(
    {
#        ERROR => \&usage,
    },
    qw(
        imap_server|server=s 
        imap_user|user=s 
        imap_passwd|imap_password|passwd|password=s
        expire_days|days|D=i
        expire_folder|folder|F=s
        verbose|v!
        imap_debug|debug|d!
    )
);

$config->file(glob '~/etc/imap_expirerc');
$config->getopt();

unless ($config->expire_days()
    and $config->expire_folder()) {
    print {*STDERR} "Missing something\n";
    usage();
}

my $expire_secs         = $config->expire_days() * 24 * 60 * 60;
my $imap_expire_date    = strftime("%d-%b-%Y",localtime(time - $expire_secs));

my %count_of_msgs = (
    expired             => 0,
    before_expiration   => 0,
    after_expiration    => 0,
);

my $imap = Mail::IMAPClient->new(
    Server   => $config->imap_server(),
    User     => $config->imap_user(),
    Password => $config->imap_passwd(),
);

# Record the number of messages
$count_of_msgs{'before_expiration'} 
    = $imap->message_count($config->expire_folder());

$imap->Debug(1) if ($config->imap_debug());

# Select folder
$imap->select($config->expire_folder()) 
    or die "Error selecting folder '$config->expire_folder()': '$EVAL_ERROR'";

# Select expired messages
my @msgs_expired = $imap->search("SENTBEFORE $imap_expire_date");

# Remove each message and increment removed counter
for my $msgid (@msgs_expired) {
    print "Deleting message ID $msgid\n"
        if ($config->verbose());

    $imap->delete_message($msgid)
        or warn "Error deleting message '$msgid': '$EVAL_ERROR'";

    $count_of_msgs{'expired'} += 1;
}

$imap->expunge();

$count_of_msgs{'after_expiration'} 
    = $imap->message_count($config->expire_folder());

printf "%-40s %6d / %6d / %6d\n", 
    $config->expire_folder(), 
    $count_of_msgs{'before_expiration'},
    $count_of_msgs{'expired'},
    $count_of_msgs{'after_expiration'};

# Print usage
sub usage {
    my $name = basename($PROGRAM_NAME);

    print <<"EOF";
Usage: $name --days <days> --folder <folder>
Where 'days' is the age of messages to expire and 'folder' is the IMAP
folder from which to expire messages.

EOF

    exit 1;
}

