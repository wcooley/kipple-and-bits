#!/usr/bin/perl

#
# LDAP Users Admin
# edit_users.cgi $Revision$ $Date$ $Author$ 
# by Fernando Lozano <fsl@centroin.com.br> under the GNU GPL (www.gnu.org)
#

require "directory-lib.pl" ;

&check_setup() ;
&connect () ;
&ReadParse() ;

$sort_on = ($in{'sort_on'}) ? $in{'sort_on'} : "userName";

&header ($text{'list_users_t'}, "", "intro", 1, 1);
print "<hr noshade size=2>\n";
print "<p><b>$text{'index_msg_1'} ($text{'index_msg_2'})</b> -- $text{'index_msg_3'} ";

$all_users = &list_users ("");

if ($sort_on eq "userID") {
    @users = sort {$a->{$sort_on} <=> $b->{$sort_on}} @{$all_users};
    print $text{'userID'} . "\n";
}
elsif ($sort_on eq "userName") {
    @users = sort {$a->{$sort_on} cmp $b->{$sort_on}} @{$all_users};
    print $text{'userName'} . "\n";
}
elsif ($sort_on eq "fullName") {
    @users = sort {$a->{$sort_on} cmp $b->{$sort_on}} @{$all_users};
    print $text{'fullName'} . "\n";
}
elsif ($sort_on eq "groupID") {
    @users = sort {($a->{$sort_on} . $a->{'fullName'}) cmp
        ($b->{$sort_on} . $b->{'fullName'})} @{$all_users};
    print $text{'groupID'} . "\n";
}

print "<p>This is the list of users:<br>\n" ;

print "<table border width=100% $cb>\n";
print "<tr $tb>\n";
print "<td><b><a href=\"edit_users.cgi?sort_on=userName\">" .
    $text{'userName'} . "</a></b>\n";
print "<td><b><a href=\"edit_users.cgi?sort_on=userID\">" .
    $text{'userID'} . "</a></b>\n";
print "<td><b><a href=\"edit_users.cgi?sort_on=groupID\">" .
    $text{'groupID'} . "</a></b>\n";
print "<td><b><a href=\"edit_users.cgi?sort_on=fullName\">" .
    $text{'fullName'} . "</a></b>\n";
print "<td><b>" .
    $text{'telephoneNumber'} . "</b>\n";
# do not show DN until we can select and edit OUs
#print "<TD><B><A href=\"edit_users.cgi?sort_on=dn\">DN</A></B>\n";

if ($#users < 0) {
    print "<tr><td colspan=4>" . $text{'msg_1'} . "\n";
}
else {
    $i = 0;
    foreach $user (@users) {
		print &html_row_user($user) ;
    }
}
print "</table>\n";

print "<br>\n";
&footer ($config{'app_path'}, $text{'module_title'});
do "footer.pl";

=head1 NOTES

None at the moment.

=head1 CREDITS

This module begun by Fernando Lozano <fernando@lozano.etc.br>
in his I<ldap-users> module.  Incorporated into I<directory_mgr>
by Wil Cooley <wcooley@nakedape.cc>.  All bug reports should go to
Wil Cooley.

=head1 LICENSE

This file is copyright Fernando Lozano <frenando@lozano.etc.br>
and Wil Cooley <wcooley@nakedape.cc>, under the GNU General Public
License <http://www.gnu.org/licenses/gpl.txt> or the file B<LICENSE>
included with this program.

=cut

