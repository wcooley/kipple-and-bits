#!/usr/bin/perl
#
#    LDAP Manager Webmin Module
#    Copyright (C) 2001 by Will Cooley <wcooley@nakedape.cc> and others
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

&init_config() ;
&header($text{"index_t"}, "", undef, 1, 1) ;
print "<hr>\n" ;

%access = &get_module_acl();

@wlinks = () ;
@wtitles = () ;
@wicons = () ;

if ($config{'enable_user_mgmt'}) {
	push @wlinks, 
		( "edit_users.cgi", "add_user.cgi", "search_user.cgi" ) ;

	push @wtitles,
		($text{'edit_users_t'},$text{'add_user_t'},$text{'search_user_t'}) ;

	push @wicons,
		("images/edit_users.gif", "images/add_user.gif", 
		"images/search_user.gif") ;
}

if ($config{'enable_group_mgmt'}) {
	push @wlinks, 
		( "edit_groups.cgi", "add_group.cgi", "search_group.cgi" ) ;

	push @wtitles,
		($text{'edit_groups_t'},$text{'add_group_t'},
			$text{'search_group_t'}) ;

	push @wicons,
		("images/edit_groups.gif", "images/add_group.gif", 
			"images/search_group.gif") ;
}

if ($config{'enable_host_mgmt'}) {
	push @wlinks, 
		( "edit_hosts.cgi", "add_host.cgi", "search_host.cgi" ) ;

	push @wtitles,
		($text{'edit_hosts_t'},$text{'add_host_t'},$text{'search_host_t'}) ;

	push @wicons,
		("images/edit_hosts.gif", "images/add_host.gif", 
			"images/search_host.gif") ;
}

if ($config{'enable_alias_mgmt'}) {
	push @wlinks, 
		( "edit_aliases.cgi", "add_alias.cgi", "search_alias.cgi" );

	push @wtitles,
		($text{'edit_aliases_t'},$text{'add_alias_t'},
			$text{'search_alias_t'}) ;

	push @wicons,
		("images/edit_aliases.gif", "images/add_user.gif", 
			"images/search_user.gif") ;
}

&icons_table (\@wlinks, \@wtitles, \@wicons, 3) ;

print "<hr>\n" ;

&footer ("/", $text{'index'}) ;
