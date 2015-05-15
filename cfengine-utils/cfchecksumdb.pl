#!/usr/bin/perl
# cfchecksumdb.pl - Dump cfengine's checksum database (conveniently
#   formatted for 'md5sum -c' input).
# Written by Wil Cooley <wcooley@nakedape.cc>

use strict;
use warnings;
use DB_File;
my %hash;
my $db = $ARGV[0] || "/var/cfengine/checksum.db";

tie %hash, 'DB_File', $db, O_RDONLY, 0666, $DB_BTREE or die "Cannot open $db";

foreach my $key (keys %hash) { 
    my $val = join('', map { sprintf "%02x", $_ } unpack("C36", $hash{$key}));
    $key =~ s/\0//;
    print "$val  $key\n"
}
#EOF
