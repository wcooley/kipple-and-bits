#!/usr/bin/perl
#
# Written by Wil Cooley

if ( ($#ARGV+1) != 2 ) {
	&usage ;
	exit ;
}

# Configure here
my $imap_server = "SERVER" ;
my $imap_user = "USERNAME" ;
my $imap_passwd = "PASSWORD" ;
# my $imap_debug = 1 ; # Define for debugging
# End configure here

use Mail::IMAPClient;

my $imap_folder = $ARGV[1] ;
my $imap_seconds_older = $ARGV[0] * 24 * 3600 ;
my $imap_expire_date = make_imap_search_date ($imap_seconds_older) ;
my $msgs_removed = 0 ;
my $start_message_count = 0 ;
my $end_message_count = 0 ;

my $imap = Mail::IMAPClient->new( Server => $imap_server,
	 User     => $imap_user,
	 Password => $imap_passwd,
);

# Record the number of messages
$start_msg_count = $imap->message_count ($imap_folder) ;

if (defined ($imap_debug)) {
	$imap->Debug(1);
}

# Select folder
$imap->select ($imap_folder) || die "Couldn't select $imap_folder" ;

# Select expired messages
@msgs_expired = $imap->search ("SENTBEFORE $imap_expire_date")  ;


# Remove each message and increment removed counter
foreach $msgid (@msgs_expired) {
	$msgs_removed += $imap->delete_message ($msgid) ;
}


# IMAP requires an EXPUNGE to actually delete message
$imap->EXPUNGE ;

$end_msg_count = $imap->message_count ($imap_folder) ;

print "$imap_folder:\n\tcontained $start_msg_count messages\n\texpired $msgs_removed messages\n\t$end_msg_count messages remaining.\n" ;

# Print usage
sub usage
{
  $name = $0 ;
  print "Usage: $name days folder\n" ;
  print "  Where \"days\" is the age of messages you want to expire,\n" ;
  print "  and \"folder\" is the mail folder from which you wish to expire messages\n" ;
}

# Generate a date given time in seconds since the epoch that can be
#   used with an IMAP search.  Has the form '01-Jan-2000'.
sub make_imap_search_date
{
	my $seconds_ago = shift ;
	my @month = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec) ;

	my $curr_time = time ;
	my $date_past = $curr_time - $seconds_ago ;

	($i,$i,$i, my $mday, my $mon, my $year, $i,$i,$i) = 
		localtime ($date_past) ;
	
	my $imap_date = sprintf("%02s-%s-%s", $mday, $month[$mon], $year+1900); 

	return $imap_date;
}
