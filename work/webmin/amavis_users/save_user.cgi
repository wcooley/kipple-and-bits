#!/usr/bin/perl
#
#    Amavis User Admin Webmin Module
#    Copyright (C) 2002 by Wil Cooley <wcooley@nakedape.cc>
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

=head1 NAME

I<save_user.cgi>

=head1 DESCRIPTION

I<save_user.cgi> is CGI script for saving user information.

=cut


require '../web-lib.pl';
$|=1;
&init_config();
&ReadParse() ;

use Amavis::Users ;
use Amavis::Query ;

my $modetext ;

local $query = new Amavis::Query ;

%access=&get_module_acl;

## put in ACL checks here if needed
if ($::in{'do'} eq "create") {
    $modetext = $::text{'modecreate'} ;
    Amavis::Users::save($::in{'do'}, \%::in) ;
} elsif ($::in{'do'} eq "update") {
    $modetext = $::text{'modeupdate'} ;
    Amavis::Users::save($::in{'do'}, \%::in) ;
} else {
    $modetext = "unmodified; unknown mode given." ;
}

## sanity checks

&header($text{'index_title'}, "", undef, 1, 1, undef, 
    "<a href=\"http://nakedape.cc/projects/amavis_users\">$text{'home'}</a>");

print "<br>User <b>$::in{'email'}</b> $modetext.<br><br>\n" ;


&footer("", $::text{'index_title'});

=head1 CREDITS

This module begun by Wil Cooley <wcooley@nakedape.cc>.  All bug
reports should go to Wil Cooley.

=head1 LICENSE

This file is copyright Wil Cooley <wcooley@nakedape.cc>, under the
GNU General Public License <http://www.gnu.org/licenses/gpl.txt>
or the file B<LICENSE> included with this program.

=cut

