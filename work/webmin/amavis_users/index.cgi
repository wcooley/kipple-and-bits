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

I<index.cgi>

=head1 DESCRIPTION

I<index.cgi> is a CGI front-end script for listing users.

=cut

require '../web-lib.pl';
$|=1;
&init_config();

use strict ;
use diagnostics ;
use Amavis::Users ;
use Amavis::Query ;
use Amavis::Html ;


unless ($::config{'dbtype'}) {
    redirect("/config.cgi?amavis_users") ;
}

local $::query = new Amavis::Query() ;

%::access=&get_module_acl;


my $ulist = Amavis::Users::list() ;
my $html = Amavis::Html::user_table($ulist) ;


&header($::text{'index_title'}, "", undef, 1, 1, undef, 
    "<a href=\"http://nakedape.cc/projects/amavis_users\">$::text{'home'}</a>");

print $html ;


&footer("/", $::text{'index'});

=head1 CREDITS

This module begun by Wil Cooley <wcooley@nakedape.cc>.  All bug
reports should go to Wil Cooley.

=head1 LICENSE

This file is copyright Wil Cooley <wcooley@nakedape.cc>, under the
GNU General Public License <http://www.gnu.org/licenses/gpl.txt>
or the file B<LICENSE> included with this program.

=cut

