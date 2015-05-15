#!/usr/bin/perl
#
#    Create Home Directory Webmin Module
#    Copyright (C) 2001 by Will Cooley <wcooley@nakedape.cc>
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

$error_msg = '' ;

%access = &get_module_acl();

## put in ACL checks here if needed


## sanity checks

# Check that the foreign_* calls work and get a list of
# users.  This is mostly academic since 'useradmin' is a
# standard module.
if (not &foreign_check("useradmin")) {
	$error_msg = "<b>" . &text('err_foreign_check', 'useradmin') . "</b>\n" ;
} else {
	if (not &foreign_require("useradmin", "user-lib.pl")) {
		$error_msg = "<b>" . &text('err_foreign_require', 'useradmin', 
			'user-lib.pl') .  "</b>\n" ;
	}
}

@users = &foreign_call('useradmin', 'list_users') ;

# Make sure the user list isn't empty
if (not @users) {
	$error_msg = "<br>" . $text{'err_no_users'} . "<br>\n" ;
}

# Get a list of servers
if (not &foreign_check("servers")) {
	$error_msg = "<br>" . &text('err_foreign_check', 'servers') . "</b>\n" ;
} else {
	if (not &foreign_require('servers', 'servers-lib.pl')) {
		$error_msg = "<br>" . &text('err_foreign_require', 'servers',
			'servers-lib.pl') . "</b>\n" ;
	}
}

if ($access{'create_remote'}) {
	@servers = &foreign_call('servers', 'list_servers') ;
}

if ($access{'create_local'}) {
	local $localhost;
	$localhost->{'host'} = "localhost" ;

	push (@servers, $localhost) ;
}


&header($text{'index_t'}, "", undef, 0, 1, undef, $text{'author'}) ;

# uses the index_title entry from ./lang/en or appropriate

## Insert Output code here
if (not $error_msg) {
	print "<hr>\n" ;

	print "<form action=\"create_home_dir.cgi\">\n" ;

	print "Create home directory for user:\n" ;
	print "<br>\n" ;
	print "<select name=\"username\">\n" ;
	foreach $user (@users) {
		print "<option value=\"", $user->{'user'}, "\">" ;
		print $user->{'user'}, "</option>\n" ;
	} 
	print "</select>\n" ;

	print "<br>\n" ;

	print "On host:\n" ;
	print "<br>\n" ;
	print "<select name=\"host\">\n" ;
	foreach $server (@servers) {
		print "<option value=\"", $server->{'host'}, "\">" ;
		print $server->{'host'}, "</option>\n" ;
	}
	print "</select>\n" ;

	print "<br>\n" ;

	print "<input type=\"submit\" value=\"Go\!\">\n" ;
	print "</form>\n" ;


} else {
	print $error_msg ;
}

print "<hr>\n" ;
&footer("/", $text{'index'});
# uses the index entry in /lang/en



## if subroutines are not in an extra file put them here


### END of index.cgi ###.
