#!/usr/bin/perl

#
# LDAP Users Admin
# edit_users.cgi $Revision$ $Date$ $Author$ 
# by Fernando Lozano <fsl@centroin.com.br> under the GNU GPL (www.gnu.org)
#

do '../web-lib.pl';
$|=1;

require "directory-lib.pl" ;

&check_setup() ;
&connect () ;
&ReadParse() ;

$sort_on = ($in{sort_on}) ? $in{sort_on} : "uid";

&header ($text{module_title}, "", "intro", 1, 1);
print "<HR noshade size=2>\n";
print "<P><B>$text{index_msg_1} ($text{index_msg_2})</B> -- $text{index_msg_3} ";

@all_users = &list_users ("");
if ($sort_on eq "uidnumber") {
    @users = sort {$a->{$sort_on} <=> $b->{$sort_on}} @all_users;
    print $text{uidnumber} . "\n";
}
elsif ($sort_on eq "uid") {
    @users = sort {$a->{$sort_on} cmp $b->{$sort_on}} @all_users;
    print $text{uid} . "\n";
}
elsif ($sort_on eq "cn") {
    @users = sort {$a->{$sort_on} cmp $b->{$sort_on}} @all_users;
    print $text{cn} . "\n";
}
elsif ($sort_on eq "gidnumber") {
    @users = sort {($a->{$sort_on} . $a->{cn}) cmp
        ($b->{$sort_on} . $b->{cn})} @all_users;
    print $text{gidnumber} . "\n";
}
else {
    @users = sort {($a->{department} . $a->{cn}) cmp
       ($b->{department} . $b->{cn})} @all_users;
    print $text{department} . "\n";
}

print "<p>This is the list of users:<br>\n" ;

print "<TABLE border width=100% $cb>\n";
print "<TR $tb>\n";
print "<TD><B><A href=\"edit_users.cgi?sort_on=uid\">" .
    $text{uid} . "</A></B>\n";
print "<TD><B><A href=\"edit_users.cgi?sort_on=uidnumber\">" .
    $text{uidnumber} . "</A></B>\n";
print "<TD><B><A href=\"edit_users.cgi?sort_on=gidnumber\">" .
    $text{gidnumber} . "</A></B>\n";
print "<TD><B><A href=\"edit_users.cgi?sort_on=cn\">" .
    $text{cn} . "</A></B>\n";
print "<TD><B><A href=\"edit_users.cgi?sort_on=department\">" .
    $text{department} . "</A></B>\n";
# do not show DN until we can select and edit OUs
#print "<TD><B><A href=\"edit_users.cgi?sort_on=dn\">DN</A></B>\n";

if ($#users < 0) {
    print "<TR><TD colspan=4>" . $text{msg_1} . "\n";
}
else {
    $i = 0;
    foreach $user (@users) {
        $dn = $user->{dn};
        print "<TR>";
        print "<TD><A href=\"add_user.cgi?sort_on=$sort_on&dn=$dn\">" .
            $user->{uid} . "</A>";
        print "<TD>" . $user->{uidnumber};
        print "<TD>" . &find_gid ($user->{gidnumber});
        print "<TD>" . $user->{cn};
        print "<TD>&nbsp;" . $user->{department};
        #print "<TD>" . $user->{dn};
        print "\n";
    }
}
print "</TABLE>\n";

print "<BR>\n";
&footer ("/", "index");
do "footer.pl";

