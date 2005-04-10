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

&ReadParse() ;
&connect() ;

$sort_on = $in{'sort_on'} ;
$dn = $in{'dn'} ;

if ($in{'do'} eq "create") {
    &header($text{'add_group_t'}, '') ;
    $group_info = &group_from_form(\%in) ;

    $ret = &create_group($group_info) ;

    if ($ret->[0] == -1) {
        $whatfailed = "Group Creation" ;
        &error($ret->[1]) ;
    }

} elsif ($in{'do'} eq "modify") {
    &header($text{'group_changed_t'}, '') ;
    $group_info = &group_from_form(\%in) ;
    &update_group($in{'dn'}, $group_info) ;
    print &html_group_form("display", $group_info) ;
    &footer ("index.cgi", $text{"module_title"}) ;

} elsif ($in{'do'} eq "delete") {
    if ($in{'delete_group'}) {
        $ret = &delete_group($in{'dn'}) ;
        if ($ret->[0] != 1) {
            $whatfailed = "Deletion of group $in{'dn'}" ;
            &error ($ret->[1]) ;
        } else {
            &redirect("list_groups.cgi?sort_on=$sort_on") ;
        }
    } else {
        $entry = &get_group_attr ($in{'dn'}) ;
        $group = &group_from_entry ($entry) ;

        &header ($text{'group_delete_t'}, "") ;
        print "<hr noshare size=2>\n" ;
        print &html_group_form("display", $group) ;
        
        print "<h3>\n" ;
        print &text("delete_group_confirm", $group->{'groupName'}) ;
        print "</h3>\n" ;
        print <<EOF ;
    <form method="post" action="save_group.cgi">
    <input type="hidden" name="do" value="delete">
    <input type="hidden" name="dn" value="$in{'dn'}">
    <input type="hidden" name="sort_on" value="$sort_on">
    <input type="submit" name="delete_group" value="$text{'group_delete_t'}">
EOF
    }
}


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
