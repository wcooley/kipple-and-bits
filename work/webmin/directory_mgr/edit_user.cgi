#!/usr/bin/perl
#
# edit_user.cgi $Revision$ $Date$ $Author$
#

=head1 NAME

I<edit_user.cgi>

=head1 DESCRIPTION

I<edit_user.cgi> is a CGI front end to editing a user.

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

# Fetch current user data
$dn = ($dn) ? $dn : $in{'dn'};
$user_entry = &get_user_attr ($dn);
$user = &user_from_entry ($user_entry);

# Display HTML
&header ($text{'edit_user'}, "");

print "<hr noshade size=2>\n";
&html_user_form ("modify", $user) ;

print "<br>\n";
&footer ("$config{'app_path'}/list_users.cgi", "$text{'index_t'}::$text{'list_users_t'}");
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

