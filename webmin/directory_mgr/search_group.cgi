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

I<search_group.cgi>

=head1 DESCRIPTION

I<search_group.cgi> is the CGI interface for searching for groups.

=cut

require "directory-lib.pl" ;

&check_setup() ;
&ReadParse() ;

$dn = $in{'dn'} ;

%access=&get_module_acl;

if ($in{'do'} eq "search") {
    &connect() ;
    $groups = &search_groups($in{'search_key'}, $in{'search_value'}) ;

    if ($groups->[0] == -1) {
        $whatfailed = $text{'search_group_t'} ;
        &error($groups->[1]) ;
    } elsif (scalar @{$groups} == 0) {
        &header($text{'search_group_t'}, "") ;
        print "<hr noshade size=2>\n" ;
        print $text{'err_no_group_found'} . "<br>\n" ;
    } elsif (scalar @{$groups} == 1) {
        &header($text{'search_group_t'}, "") ;
        print "<hr noshade size=2>\n" ;
        print "<pre>" . &dump_group($groups->[0]) . "</pre>" ;
        print &html_group_form("modify", $groups->[0]) ;
    } else {
        &header($text{'search_group_t'}, "") ;
        print "<hr noshade size=2>\n" ;
        print "<b>" . &text('search_found_n_groups',
            scalar(@{$groups})) . "</b>\n" ;
        print &html_group_table_header() ;
        foreach $group (@{$groups}) {
            print &html_row_group($group) ;
        }
        print &html_group_table_footer() ;
    }

    &footer($config{'app_path'} . "/search_group.cgi",
        $text{'module_title'} . "::" .  $text{'search_group_t'}) ;

} else {
    &header($text{'search_group_t'}, "") ;
    print "       <hr noshade size=2>\n" ;
    print &html_group_search_form() ;
    &footer($config{'app_path'}, $text{'module_title'});
}

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
