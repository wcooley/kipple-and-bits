#!/usr/bin/perl

#
# LDAP Users Admin
# edit_user.cgi $Revision$ $Date$ $Author$
# by Fernando Lozano <fernando@lozano.eti.br> under the GNU GPL (www.gnu.org)
#

require "directory-lib.pl" ;

&connect ();
&ReadParse();

$sort_on = $in{'sort_on'};

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

# display current user data

$dn = ($dn) ? $dn : $in{'dn'};
$user = &get_user_attr ($dn);

# this isn't exactly right... should complain why
# the dn (user) wasn't found...

if ($dn && $user) {
    $header = $text{'edit_user'};
    $form_type = "modify" ;
}
else {
    $header = $text{'create_user'};
    $form_type = "create" ;
}

&header ($header, "");

print "<hr noshade size=2>\n";

if ($form_type eq "create") {
    $user = &user_defaults();
} else {
    $user = &user_from_entry ($user);
}

&html_user_form ($form_type, $user) ;

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

