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

I<edit_user.cgi>

=head1 DESCRIPTION

I<edit_user.cgi> is a CGI front-end script for adding and
editing users.

=cut

require '../web-lib.pl';
$|=1;
&init_config();
&ReadParse() ;

use Amavis::Users ;
use Amavis::Html ;
use Amavis::Query ;

my %access=&::get_module_acl;

local $::query = new Amavis::Query ;
my $user ;

## put in ACL checks here if needed

if ($::in{'id'}) {
    $user = Amavis::Users::get($::in{'id'}) ;
}

&header($::text{'index_title'}, "", undef, 1, 1, undef, 
    "<a href=\"$::text{'homepage'}\">$::text{'home'}</a>");

print Amavis::Html::user_form($user) ;

&footer("", $::text{'index_title'});

=head1 CREDITS

This module begun by Wil Cooley <wcooley@nakedape.cc>.  All bug
reports should go to Wil Cooley.

=head1 LICENSE

This file is copyright Wil Cooley <wcooley@nakedape.cc>, under the
GNU General Public License <http://www.gnu.org/licenses/gpl.txt>
or the file B<LICENSE> included with this program.

=cut

