#!/usr/bin/perl
#
# ldap_misc.pl -- Miscellaneous LDAP subroutines
#
# $Id$


=head1 NAME

I<ldap_misc.pl>

=head1 DESCRIPTION

I<ldap_misc.pl> contains LDAP routines that are not specific to
any particular object type.

=cut

use strict ;
no strict "vars" ;

use diagnostics ;

sub connect
{
    $conn = new Mozilla::LDAP::Conn ($config{'server'},
        $config{'port'},
        $config{'user'},
        $config{'passwd'});
    if (! $conn) {
        &error(&text("err_conn",
            $config{'directory_type'},
            $config{'server'}));
        &webmin_log("connect", 
            $config{'directory_type'},
            $config{'server'}, \%in)
    }
}

# Checks if the module has actually been set up
sub check_setup {

	if ("$config{'base'}" eq "dc=company") {
		&error("$text{'first_time'}") ;
	}
}

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

1;
