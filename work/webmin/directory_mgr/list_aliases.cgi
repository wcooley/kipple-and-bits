#!/usr/bin/perl
#
#    LDAP Manager Webmin Module
#    Copyright (C) 2001 by Will Cooley
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    This module inherited from the Webmin Module Template 0.79.1 by tn

do '../web-lib.pl';
$|=1;
&init_config();

%access=&get_module_acl;

## put in ACL checks here if needed


## sanity checks



&header($text{'index_t'}, "" );
# uses the index_title entry from ./lang/en or appropriate

## Insert Output code here
print "<hr>\n<h2>This feature is not here yet.</h2>\n<hr>" ;

&footer($config{'app_path'}, $text{'index'});
do "footer.pl" ;
# uses the index entry in /lang/en


## if subroutines are not in an extra file put them here


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

### END of template.cgi ###.
