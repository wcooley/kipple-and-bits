#!/usr/bin/perl
#
# list_imap_folder.pl - List the contents of an IMAP folder
#
# Written by Wil Cooley <wcooley@nakedape.cc>
#

use strict;
use warnings;
use AppConfig;
use English             qw( -no_match_var );
use File::Basename      qw( basename );
use Mail::IMAPClient;

my $config = AppConfig->new(
    qw(
        imap_server|server|h=s 
        imap_user|user|u=s 
        imap_passwd|imap_password|passwd|password|p=s
        imap_folder|folder|F=s
        imap_debug|debug|d!
    )
);

$config->getopt();

unless ($config->imap_server()
        and $config->imap_user()
        and $config->imap_passwd()
        and $config->imap_folder()) {
    die "Missing something.  Run me as: ",
        basename($PROGRAM_NAME), 
        " -h server -u user -p pass -F folder",;
}

my $imap = Mail::IMAPClient->new(
    Server      => $config->imap_server(),
    User        => $config->imap_user(),
    Password    => $config->imap_passwd(),
) or die "Error creating Mail::IMAPClient object: '$EVAL_ERROR'";

$imap->Debug(1) if ($config->imap_debug());

$imap->select($config->imap_folder())
    or die "Error selecting folder '$config->imap_folder()': '$EVAL_ERROR'";

my $msg_ids_ref = $imap->search('ALL')
    or die "Error listing messages: '$EVAL_ERROR'";

for my $msg_id (@{ $msg_ids_ref }) {
    my $header_ref  = $imap->parse_headers($msg_id, "Subject", "From");
    my $subject     = $header_ref->{'Subject'}[0]   || q{};
    my $from        = $header_ref->{'From'}[0]      || q{};
    print sprintf "%-40s: %s\n", $from, $subject;
}

