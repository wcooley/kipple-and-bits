#!/usr/bin/perl

#
# LDAP Users Admin
# edit_user.cgi $Revision$ $Date$ $Author$
# by Fernando Lozano <fernando@lozano.eti.br> under the GNU GPL (www.gnu.org)
#

require "directory-lib.pl" ;

&connect ();
&ReadParse();

$sort_on = $in{'sort_on'};

# Configured to remotely create home directories
if ($config{'createhomeremote'}) {
	# Get a list of webmin servers
	if (not &foreign_check("servers")) {
		&error(&text('err_foreign_check', 'servers')) ;
	} else {
		&foreign_require('servers', 'servers-lib.pl') ;
	}   

	@servers = &foreign_call('servers', 'list_servers') ;

	local $localhost; 
	$localhost->{'host'} = "localhost" ; 

	push (@servers, $localhost) ;
}

# display current user data

$dn = ($dn) ? $dn : $in{dn};
$user = &get_user_attr ($dn);

# this isn't exactly right... should complain why
# the dn (user) wasn't found...

if ($dn && $user) {
    $header = $text{'edit_user'};
    $new = 0;
}
else {
    $header = $text{'create_user'};
    $new = 1;
}
if (length ($in{new}) == 0) {
    &header ($header, "");
}
print "<HR noshade size=2>\n";


&user_from_entry ($user);

if ($new) {
    &user_defaults;
}

print "<form method=\"post\"action=\"save_user.cgi\">\n";
print "<td><input type=\"hidden\" name=\"new\" value=\"$new\">\n";
print "<td><input type=\"hidden\" name=\"do\" value=\"create\">\n";
print "<td><input type=\"hidden\" name=\"dn\" value=\"$dn\">\n";
print "<td><input type=\"hidden\" name=\"sort_on\" value=\"$sort_on\">\n";
#print "<td><input type=\"hidden\" name=\"
print "<table border width=100% $cb>\n";
print "<tr><td>\n";
print "<table border=0 cellspacing=0 cellpadding=2 width=100% $cb>\n";

# posixAccount

print "<TR><TD colspan=2 $tb><B>" . $text{'posixAccount'} . "</B> (posixAccount)\n";
print "</TD></TR>";
print "<TR><TD><B>" . $text{'uid'} . "</B> (uid)\n";
print "</TD>";
print "<TD><INPUT name=\"uid\" size=12 value=\"$uid\">\n";
print "</TD></TR>";
print "<TR><TD><B>" . $text {uidnumber} . "</B> (uidnumber)\n";
print "</TD>";
print "<TD><INPUT name=\"uidnumber\" size=5 value=\"$uidnumber\"> (*)\n";
print "</TD></TR>";

print "<tr>\n" ;
if ($config{'new_group'}) {
	print <<EOF ;
	<td>
	<b>$text{'gidnumber'}</b>
	</td>

	<td>
	<input type="radio" name="gid_from" value="automatic" checked>
	$text{'gid_automatic'}
	<input type="radio" name="gid_from" value="input">
	<input type="text" name="input_gid" size=5>
	</td>
EOF

} else {
	print "\n\t<TD>"
		. "<B>" . $text{gidnumber} . "</B> (gidnumber)\n</TD>"
		. "<TD><SELECT name=\"gidnumber\" size=1>\n" ;
	&html_group_options ($gidnumber) ;
	print "</SELECT>\n</TD>";
}
print "</tr>\n" ;

print "<TR><TD>" . $text{gecos} . " (gecos)\n";
print "</TD>";
print "<TD><INPUT name=\"gecos\" size=40 value=\"$gecos\"> (*)\n";
print "</TD></TR>";
print "<TR><TD>" . $text {homedirectory} . " (homedirectory)\n";
print "</TD>";
print "<TD><INPUT name=\"homedirectory\" size=30 value=\"$homedirectory\"> (*)\n";
print "</TD></TR>";
print "<TR><TD><B>" . $text {loginshell} . "</B> (loginshell)\n";
print "</TD>";
#print "<TD><INPUT name=\"loginshell\" size=20 value=\"$loginshell\">\n";
print "<TD><SELECT name=\"loginshell\" size=1>\n";
print &html_shell_options ($loginshell);
print "</SELECT>\n";
print "</TD></TR>";

# address book data (inetOrgPerson, person, etc...)

print "<TR><TD colspan=2 $tb><B>" . $text{addressbook} . "</B>\n";
print "</TD></TR>";

print "<TR><TD><B>" . $text{givenname} . "</B> (givenname)\n";
print "</TD>";
print "<TD><INPUT name=\"givenname\" size=20 value=\"$givenname\">\n";
print "</TD></TR>";
print "<TR><TD><B>" . $text{'sn'} . "</B> (sn)\n";
print "</TD>";
print "<TD><INPUT name=\"sn\" size=20 value=\"$sn\">\n";
print "</TD></TR>";
print "<TR><TD>" . $text{'cn'} . $text{'cn_note'} . " (cn)\n";
print "</TD>";
print "<TD><INPUT name=\"cn\" size=40 value=\"$cn\"> (*)\n";
print "</TD></TR>";
print "<TR><TD>" . $text{'mail'} . " (mail)\n";
print "</TD>";
print "<TD><INPUT name=\"mail\" size=30 value=\"$mail\"> (*)\n";
print "</TD></TR>";
if ($config{outlook} eq "1") {
    print "<TR><TD>" . $text{title} . " (title)\n";
    print "</TD>";
    print "<TD><INPUT name=\"title\" size=30 value=\"$title\">\n";
    print "</TD></TR>";
    print "<TR><TD>" . $text{organizationname} . " (organizationname)\n";
    print "</TD>";
    print "<TD><INPUT name=\"organizationname\" size=40 value=\"$organizationname\">\n";
    print "</TD></TR>";
    print "<TR><TD>" . $text {department} ." (department)\n";
    print "</TD>";
    print "<TD><INPUT name=\"department\" size=40 value=\"$department\">\n";
    print "</TD></TR>";
    print "<TR><TD>" . $text{physicaldeliveryofficename} . " (physicaldeliveryofficename)\n";
    print "</TD>";
    print "<TD><INPUT name=\"physicaldeliveryofficename\" size=15 value=\"$physicaldeliveryofficename\">\n";
    print "</TD></TR>";
    print "<TR><TD>" . $text {telephonenumber} . " (tephonenumber)\n";
    print "</TD>";
    print "<TD><INPUT name=\"telephonenumber\" size=20 value=\"$telephonenumber\">\n";
    print "</TD></TR>";
    print "<TR><TD>" . $text{mobile} . " (mobile)\n";
    print "</TD>";
    print "<TD><INPUT name=\"mobile\" size=20 value=\"$mobile\">\n";
    print "</TD></TR>";
    print "<TR><TD>" . $text{pager} . " (pager)\n";
    print "</TD>";
    print "<TD><INPUT name=\"pager\" size=20 value=\"$pager\">\n";
    print "</TD></TR>";
    print "<TR><TD>" . $text{officefax} . " (officefax)\n";
    print "</TD>";
    print "<TD><INPUT name=\"officefax\" size=20 value=\"$officefax\">\n";
    print "</TD></TR>";
    print "<TR><TD>" . $text{comment} . " (comment)\n";
    print "</TD>";
    print "<TD><TEXTAREA name=\"comment\" cols=50 rows=5>$comment</TEXTAREA>\n";
    print "</TD></TR>";
}

# user creation options
if ($new) {
    print "<TR><TD colspan=2 $tb><B>" . $text{user_options} . "</B>\n";
    print "</TD></TR>";
    print "<TR><TD>" . $text{userpasswd} . "\n";
    print "</TD>";
    print "<TD><INPUT name=\"userpassword\" size=12 value=\"$userpassword\"> (*)\n";
    print "</TD></TR>";
    print "<TR><TD>" . $text{passwdtype} . "\n";
    print "</TD><TD>";
    print "<INPUT type=\"radio\" name=\"hash\" value=\"md5\">" .
        $text{md5} . "\n";
    print "<INPUT type=\"radio\" name=\"hash\" value=\"crypt\" checked>" .
        $text{crypt} . "\n";
    print "<INPUT type=\"radio\" name=\"hash\" value=\"nome\">" .
        $text {plaintext} . "\n";
    print "</TD></TR>";
    print "<TR><TD>" . $text{create_home} . "\n";
    print "</TD><TD>";
    $create_yes = ($config{createhome} eq "1") ? "checked" : "";
    $create_no = ($config{createhome} eq "2") ? "checked" : "";
    print "<INPUT type=\"radio\" name=\"create\" value=\"1\" $create_yes>" .
        $text{yes} . "\n";
    print "<INPUT type=\"radio\" name=\"create\" value=\"0\" $create_no>" .
        $text{no} . "\n";
    print "</TD></TR>";
    print "<TR><TD>" . $text{copy_files} . "\n";
    print "</TD><TD>";
    print "<INPUT type=\"radio\" name=\"copy\" value=\"1\" $create_yes>" .
        $text {yes} . "\n";
    print "<INPUT type=\"radio\" name=\"copy\" value=\"0\" $create_no>" .
        $text {no} . "\n";
    print "</TD></TR>";
}

if ($config{'createhomeremote'}) {

	print "<tr>\n<td><b>" . $text{'servers_for_home_dir'} . "</td>\n" ;
	print "<td>\n" ;

	print "<select name=\"servers_for_home_dir\" multiple size=3>\n" ;
	for $server (@servers) {
		print "<option value=\"$server->{'host'}\">" .
				"$server->{'host'}</option>\n" ;
	}
	print "</select>\n" ;
	print "</td>\n</tr>\n" ;

}

print "<TD colspan=2><HR>(*) " . $text{'field_obs'};
print "</TD></TR>";
print "</TABLE>\n";
print "</TD></TR>";
print "</TABLE><BR>\n";
# Change label to  Modify or Create
$label = ($new) ? $text{'create'} : $text{'modify'};
print "<TABLE width=100% border=0><TR><TD align=\"left\">\n";
print "<INPUT type=\"submit\" name=\"save\" value=\" $label \">\n"; 
# that's bad HTML, but Webmin uses this on standard users module...
print "</FORM></TD>\n";
if (! $new) {
	print <<EOF ;
	<td align="center">
		<form method="post" action="set_passwd.cgi">
		<input type="hidden" name="dn" value="$dn">
		<input type="hidden" name="sort_on" value="$sort_on">
		<input type="submit" value="$text{'set_passwd'}">
		</form>
	</td>
	<td align="right">
		<form method="post" action="save_user.cgi">
		<input type="hidden" name="dn" value="$dn">
		<input type="hidden" name="sort_on" value="$sort_on">
		<input type="hidden" name="do" value="delete">
		<input type="submit" value="$text{'delete'}">
		</form>
	</td>
EOF
}
print "</TR></TABLE>\n";

print "<BR>\n";
&footer ("index.cgi?sort_on=$sort_on", "$text{'index_t'}");
do "footer.pl";

