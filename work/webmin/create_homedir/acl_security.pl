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

do '../web-lib.pl' ;
&init_config() ;

sub acl_security_form {
	my ($acl) = @_ ;

	print "<tr>\n" ;
	print "<td valign=\"top\">\n" ;
	print "<b>", $text{'acl_create_local'}, "</b>\n" ;
	print "</td>\n" ;

	print "<td colspan=3>\n" ;
	print "<input type=\"checkbox\" name=\"create_local\" value=1" ;
	print $acl->{'create_local'} == 1 ? " checked " : " " ;
	print ">\n" ;
	print "</td>\n" ;

	print "<tr>\n" ;
	print "<td valign=\"top\">\n" ;
	print "<b>", $text{'acl_create_remote'}, "</b>\n" ;
	print "</td>\n" ;

	print "<td colspan=3>\n" ;
	print "<input type=\"checkbox\" name=\"create_remote\" value=1" ;
	print $acl->{'create_remote'} == 1 ? " checked " : " " ;
	print ">\n" ;
	print "</td>\n" ;

}

sub acl_security_save {

	$_[0]->{'create_local'} = $in{'create_local'} ;
	$_[0]->{'create_remote'} = $in{'create_remote'} ;
}
