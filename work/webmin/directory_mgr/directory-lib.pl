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
$|=1 ;

use strict ;
no strict "vars" ;

&init_config() ;

if ("$config{'directory_type'}" eq "LDAP") {

	# PerlLDAP stuff
	eval {
    	use Mozilla::LDAP::Conn;
    	use Mozilla::LDAP::Utils;
	} ;
	# 'use' caused an error, so the modules probably aren't
	# installed
	if ($@) {
    	&error($text{'ldap_modules_not_installed'},
        	$text{'perl_eval_err'}, $@) ;
	}
 
	require "ldap_users.pl" ;
	require "ldap_groups.pl" ;
	require "ldap_misc.pl" ;

	# Global vars
	$conn = "" ;
}

require "users.pl" ;
require "groups.pl" ;
require "html.pl" ;
