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
#


=head1 NAME

I<search_user.cgi>

=head1 DESCRIPTION

I<search_user.cgi> HTML front end to searching for users.

=cut

require "directory-lib.pl" ;

&check_setup() ;
&ReadParse() ;

%access=&get_module_acl;

## put in ACL checks here if needed


## sanity checks

# uses the index_title entry from ./lang/en or appropriate

## Insert Output code here

if ($in{'do'} eq "search") {

    &connect() ;
    $users = &search_users($in{'search_key'}, $in{'search_value'}) ;

    if ($users->[0] == -1) {
        $whatfailed = $users->[1] ;
        &error() ;
    } elsif (scalar @{$users} == 0) {
        &header($text{'search_user_t'}, "" );
        print "<hr noshade size=2>\n" ;
        print $text{'err_no_user_found'} ;
    } elsif (scalar @{$users} == 1) {
        &header($text{'search_user_t'}, "" );
        print "<hr noshade size=2>\n" ;
        &html_user_form("modify", $users->[0]) ;
    } else {
        &header($text{'search_user_t'}, "" );
        print "<hr noshade size=2>\n" ;
        print "<b>" . scalar(@{$users}) . " users found</b>\n" ;
        print "<table border width=100% $cb>\n";
        print "<tr $tb>\n";
        print "<td><b>" . $text{'userName'} . "</a></b>\n";
        print "<td><b>" . $text{'userID'} . "</a></b>\n";
        print "<td><b>" . $text{'groupID'} . "</a></b>\n";
        print "<td><b>" . $text{'fullName'} . "</a></b>\n";
        print "<td><b>" . $text{'telephoneNumber'} . "</b>\n";

        for $user (@{$users}) {
            print "<!-- User ". $user->{'userName'} . " -->\n" ;
            print &html_row_user($user) ;
        }

        print "</table>\n" ;
    }

    &footer($config{'app_path'} . "/search_user.cgi", 
        $text{'module_title'} . "::" . $text{'search_user_t'});

} else {
    &header($text{'search_user_t'}, "" );

print <<EOF ;

<hr noshade size=2>

<form method="post" action="search_user.cgi">
<input type="hidden" name="do" value="search">

Search for:
<input type="text" width="30" name="search_value">
<select name="search_key">
<option value="firstName">$text{'firstName'}</option>
<option value="surName">$text{'surName'}</option>
<option value="fullName">$text{'fullName'}</option>
<option value="userName">$text{'userName'}</option>
<option value="userID">$text{'userID'}</option>
<option value="groupID">$text{'groupID'}</option>

</select>

<input type="submit" value="Search">

</form>

EOF

    &footer($config{'app_path'}, $text{'module_title'});

}


do "footer.pl" ;
# uses the index entry in /lang/en


## if subroutines are not in an extra file put them here


=head1 NOTES

None at the moment.

=head1 CREDITS

This module begun by by Wil Cooley <wcooley@nakedape.cc> for
I<directory_mgr>.  All bug reports should go to Wil Cooley.

=head1 LICENSE

This file is copyright Wil Cooley <wcooley@nakedape.cc>, under the
GNU General Public License <http://www.gnu.org/licenses/gpl.txt>
or the file B<LICENSE> included with this program.

=cut

