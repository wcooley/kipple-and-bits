#!/usr/bin/perl
#
#    Create Home Directory Webmin Module
#    Copyright (C) 2001 by Wil Cooley <wcooley@nakedape.cc>
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
do './create_home_dir.pl' ;
$|=1;
&init_config();
&ReadParse() ;

%access = &get_module_acl();

## put in ACL checks here if needed


## sanity checks

if ($in{'host'} eq "localhost" and not $access{'create_local'}) {
	&error($text{'err_local_acl'}) ;
} elsif (not $access{'create_remote'}) {
	&error($text{'err_remote_acl'}) ;
} else {
	$ret = &create_home_dir ($in{'username'}, $in{'host'}) ;
}

&header($text{'index_t'}, "", undef, 1, 1, undef, $text{'author'}) ;

# uses the index_title entry from ./lang/en or appropriate

## Insert Output code here
print "<hr>\n" ;

if ($ret) {
	print &text('succ_create_dir', $in{'username'}, $in{'host'}), "\n" ;
} else {
	print $text{'err_generic'} ;
}

print "<hr>\n" ;
&footer("/create_homedir", $text{'index'});
# uses the index entry in /lang/en



## if subroutines are not in an extra file put them here


### END of index.cgi ###.
