#!/usr/bin/perl
#
# directory_type.pl -- Master library file that includes
# the appropriate libraries for the directory type.
#
# Written by Wil Cooley <wcooley@nakedape.cc>
#
# $Id$
#


=head1 NAME

I<directory-lib.pl>

=head1 DESCRIPTION

The I<directory-lib.pl> is the master "header" file for the
.cgi programs.  It selectively includes libraries based on
selected directory type (LDAP-only, at the moment).

=cut

do '../web-lib.pl' ;
$|=1 ;

$debug=0 ;

use strict ;
no strict "vars" ;


&init_config() ;

if ("$config{'directory_type'}" eq "LDAP") {

	# PerlLDAP stuff
	eval {
    	use Mozilla::LDAP::Conn;
    	use Mozilla::LDAP::Utils;
	} ;
    #use MIME::Base64;
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

use diagnostics ;
$diagnostics::PRETTY =1 ;

require "users.pl" ;
require "groups.pl" ;
require "html.pl" ;
require "misc.pl" ;


=head1 NOTES

None at the moment.

=head1 CREDITS

This module begun by Wil Cooley <wcooley@nakedape.cc>.  All bug
reports should go to Wil Cooley.

=head1 LICENSE

This file is copyright Wil Cooley <wcooley@nakedape.cc>, under the
GNU General Public License <http://www.gnu.org/licenses/gpl.txt>
or the file B<LICENSE> included with this program.

=cut

1;
