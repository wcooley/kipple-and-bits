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

I<template.cgi>

=head1 DESCRIPTION

I<template.cgi> is a template for other .cgi and .pl files.

=cut

require "directory-lib.pl" ;

%access=&get_module_acl;

&check_setup();
&connect();
&ReadParse();

$sort_on = ($in{'sort_on'}) ? $in{'sort_on'} : 'groupName' ;

$all_groups = &list_groups() ;

if ($sort_on eq "groupID") {
    @groups = sort {$a->{$sort_on} <=> $b->{$sort_on}} @{$all_groups} ;
} elsif ($sort_on eq "groupName") {
    @groups = sort {$a->{$sort_on} cmp $b->{$sort_on}} @{$all_groups} ;
}

&header($text{'index_t'}, "" );
print "<hr noshade size=2>\n" ;

#print "<b>Found " . $#groups . "</b>\n" ;
print "<i><b>Search found " . scalar(@{$all_groups}) . " groups</b></i><br>\n" ;

print <<EOF ;

    <b>This is the list of groups:</b>

    <table border=1 cellspacing=0 cellpadding=2 width=100% $cb>
    <tr $tr>
    <td>
        <b>
        <a href="list_groups.cgi?sort_on=groupName">
            $text{'groupName'}
        </a>
        </b>
    </td>
    <td>
        <b>
        <a href="list_groups.cgi?sort_on=groupID">
            $text{'groupID'}
        </a>
        </b>
    </td>
    <td>
        <b>$text{'description'}</b>
    </td>

EOF

if ($#groups < 0) {
    print "<tr><td colspan=3>" 
        . $text{'err_no_groups_found'}
        . "</td></tr>\n" ;
} else {
    foreach $group (@groups) {
        print &html_row_group($group) ;
    }
}

print "</table>\n" ;

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

### END of template.cgi ###.
