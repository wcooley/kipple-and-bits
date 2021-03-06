#!/usr/bin/perl

#
# LDAP Users Admin
# edit_user.cgi $Revision$ $Date$ $Author$
# by Fernando Lozano <fernando@lozano.eti.br> under the GNU GPL (www.gnu.org)
#

=head1 NAME

I<add_user.cgi>

=head1 DESCRIPTION

I<add_user.cgi> is a CGI front-end to add a user object.

=cut

require "directory-lib.pl" ;

&connect ();
&ReadParse();

# Configured to remotely create home directories
if ($config{'createhomeremote'}) {
	# Get a list of webmin servers
	if (not &foreign_check("servers")) {
		&error(&text('err_foreign_check', 'servers')) ;
	} else {
		&foreign_require('servers', 'servers-lib.pl') ;
	}   

	@servers = &foreign_call('servers', 'list_servers') ;

	local $localhost; 
	$localhost->{'host'} = "localhost" ; 

	push (@servers, $localhost) ;
}

# Get user defaults
$user = &user_defaults();

# Display HTML
&header ($text{'create_user'}, "");
print "<hr noshade size=2>\n";
print &html_user_form ("create", $user) ;

print "<BR>\n";
&footer ($config{'app_path'}, "$text{'index_t'}");
do "footer.pl";

=head1 NOTES

None at the moment.

=head1 CREDITS

This module begun by Fernando Lozano <fernando@lozano.etc.br>
in his I<ldap-users> module.  Incorporated into I<directory_mgr>
by Wil Cooley <wcooley@nakedape.cc>.  All bug reports should go to
Wil Cooley.

=head1 LICENSE

This file is copyright Fernando Lozano <frenando@lozano.etc.br>
and Wil Cooley <wcooley@nakedape.cc>, under the GNU General Public
License <http://www.gnu.org/licenses/gpl.txt> or the file B<LICENSE>
included with this program.

=cut

