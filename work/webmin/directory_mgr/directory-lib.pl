#!/usr/bin/perl
#
# directory_type.pl -- Master library file that includes
# the appropriate libraries for the directory type.
#
# Written by Wil Cooley <wcooley@nakedape.cc>
#
# $Id$
#

do '../web-lib.pl' ;
$|=1;

&init_config() ;

if ("$config{'directory_type'}" eq "LDAP") {
	require "ldap_users.pl" ;
	require "ldap_groups.pl" ;
	require "ldap_misc.pl" ;
}

require "users.pl" ;
require "groups.pl" ;
require "html.pl" ;
