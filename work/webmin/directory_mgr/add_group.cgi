#!/usr/bin/perl
#
#    Directory_Mgr Webmin Module
#    Copyright (C) 2002 by Will Cooley
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

=head1 NAME

I<add_group.cgi>

=head1 DESCRIPTION

I<add_group.cgi> is a CGI front-end adding group objects.

=cut

require "directory-lib.pl" ;

%access=&get_module_acl;


&header($text{'index_t'}, "" );
# uses the index_title entry from ./lang/en or appropriate

## Insert Output code here
print "<hr>\n<h2>This feature is not here yet.</h2>\n<hr>" ;

&footer($config{'app_path'}, $text{'index'});
do "footer.pl" ;


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

