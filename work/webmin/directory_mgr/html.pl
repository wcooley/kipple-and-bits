#!/usr/bin/perl

#
# LDAP Users Admin
# html.pl $Revision$ $Date$ $Author$
# by Fernando Lozano <fernando@lozano.eti.br> under the GNU GPL (www.gnu.org)
#

use strict ;
no strict "vars" ;

use diagnostics ;


sub html_shell_options
{
    my ($user_shell) = @_;
    
    my ($shell, $selected);

    open SHELLS, "</etc/shells";
    while (<SHELLS>) {
        tr/\n\r\t //d;
        $selected = ($user_shell eq $_) ? "selected" : "";
        print "<option value=\"$_\" $selected>$_\n";
        #print "<option>[$user_shell][$_]"
    }
}



sub html_group_options
{
    my ($gidNumber) = @_;
    
    my (@all_groups, @groups); 
    my ($group, $selected);

    @all_groups = &list_groups;
    
    @groups = sort {$a->{'cn'} cmp $b->{'cn'}} @all_groups;

    foreach $group (@groups) {
        $selected = ($group->{'gidNumber'} == $gidNumber) ? "selected" : "";
        print "<option value=\"$group->{'gidNumber'}\" $selected>" 
			. "$group->{'cn'} ($group->{'gidNumber'})</option>\n";
    }
}

=head2 html_row_user

SYNOPSIS

html_row_user ( I<$user> )

DESCRIPTION

Takes a reference to a hash containing user information and formats
as an HTML row.

RETURN VALUE

Returns a formatted HTML row of user information.

=cut

sub html_row_user {
	my ($user) = @_ ;
	my ($groupName) = &find_gid ($user->{'groupID'}) ;

	my ($row) = "
<tr>
	<td>&nbsp;
		<a href=\"edit_user.cgi?dn=$user->{'dn'}\">
			$user->{'userName'}</a>
	</td>
	<td>
		$user->{'userID'}&nbsp;
	</td>
	<td>
		$groupName ($user->{'groupID'})&nbsp;
	</td>
	<td>
		$user->{'fullName'}&nbsp;
	</td>
	<td>\n" ;

    unless (ref($user->{'telephoneNumber'}) eq "ARRAY") {
        $row .= "&nbsp;" ;
    }
    for $telnum (@{$user->{'telephoneNumber'}}) {
        $row .= $telnum . "<br>" ;    
    }

    $row .= "
	</td>
</tr>
" ;

	return $row ;

}

=head2 html_row_alias

SYNOPSIS

html_row_alias ( I<> )

=cut

sub html_row_alias
{


}

=head2 html_user_form

SYNOPSIS

C<html_user_form ( I<$form_type>, I<\%user> )>

DESCRIPTION

Prints the HTML for a user form.  Form types are:

=over 4

=item * display

Does not use an HTML form, only displays the data in a form.

=item * create

Creates a new user based on configuration data, form
includes appropriate fields.

=item * update

Presents current user data to be updated.

=back

=cut

sub html_user_form {

    my ($form_type, $user) = @_ ;

    if ($form_type ne "display") {
        print <<EOF ;
    <form method="post" action="save_user.cgi">
    <td><input type="hidden" name="do" value="$form_type">
    <td><input type="hidden" name="dn" value="$dn">
    <td><input type="hidden" name="sort_on" value="$sort_on">
EOF
    }

    print <<EOF ;
    <table border width=100% $cb>
    <tr><td>
    <table border=0 cellspacing=0 cellpadding=2 width=100% $cb>
EOF

    print <<EOF ;
    <tr><td colspan=2 $tb>
        <b>$text{'posixAccount'}</b>
    </td></tr>
    <tr>
    <td>
        <b>$text{'uid'}</b>
    </td>
    <td>
EOF

    if ($form_type eq "display") {
        print "    $user->{'userName'}\n" ;
    } elsif ($form_type eq "modify") {
        print "    $user->{'userName'}\n" ;
    } elsif ($form_type eq "create") {
        print "    <input name=\"userName\" size=16 value=\"$user->{'userName'}\">\n" ;
    }

    print <<EOF ;
    </td>
    </tr>

    <tr>
    <td>
        <b>$text{'userID'}</b>
    </td>
    <td>
EOF
    if ($form_type eq "display") {
        print "    $user->{'userID'}\n" ;
    } elsif ($form_type eq "modify") {
        print "    $user->{'userID'}\n" ;
    } elsif ($form_type eq "create") {
        print "    <input name=\"userID\" size=5 value=\"$user->{'userID'}\">\n" ;
    }

    print <<EOF ;
    </td>
    </tr>
EOF

    print <<EOF ;
    <tr>
	<td>
	<b>$text{'groupID'}</b>
	</td>
	<td>
EOF

    if ($form_type eq "display") {
        print "    $user->{'groupID'}\n" ;
    } elsif ($form_type eq "modify") {
        print "    $user->{'groupID'}\n" ;
        #print "    <input type=\"text\" name=\"groupID\" size=5 value=\"$user->{'groupID'}\" >\n" ;
    } else {

            print <<EOF ;
	<input type="radio" name="gid_from" value="automatic" checked>
	$text{'gid_automatic'}
	<input type="radio" name="gid_from" value="input">
	<input type="text" name="input_gid" size=5>
	<input type="radio" name="gid_from" value="select">
    <select name="group_select" size=1>
EOF
    &html_group_options ($user->{'groupID'}) ;
    print "    </select>" ;
    }
	print "    </td>\n" ;
    print "    </tr>\n" ;


    print "    <tr>\n    <td>$text{'homeDirectory'}</td>\n";
    print "    <td>\n" ;

    if ($form_type eq "display") {
        print "    $user->{'homeDirectory'}\n" ;
    } else {
        print "<input name=\"homeDirectory\" size=30 value=\"$user->{'homeDirectory'}\">\n";
    }

    print <<EOF ;
    </td>
    </tr>
    
    <tr><td>
        <b>$text{'loginShell'}</b>
    </td>

    <td>
EOF
    if ($form_type eq "display") {
        print "    $user->{'loginShell'}\n" ; 
    } else {
        print "    <select name=\"loginShell\" size=1>\n" ;
        &html_shell_options ($user->{'loginShell'}) ;
        print "    </select>\n";
    }
    print "     </td></tr>";

    print <<EOF ;
    <tr>
    <td colspan=2 $tb>
        <b>$text{'addressbook'}</b>
    </td>
    </tr>

    <tr>
    <td>
        <b>$text{'givenname'}</b>
    </td>

    <td>
EOF
    if ($form_type eq "display") {
        print "    $user->{'firstName'}\n" ;
    } else {
        print "    <input name=\"firstName\" size=30 value=\"$user->{'firstName'}\">\n";
    }

    print <<EOF ;
    </td>
    </tr>

    <tr>
    <td>
        <b>$text{'surName'}</b>
    </td>

    <td>
EOF
    if ($form_type eq "display") {
        print "    $user->{'surName'}\n" ;
    } else {
        print "    <input name=\"surName\" size=30 value=\"$user->{'surName'}\">\n";
    }

    print <<EOF ;
    </td>
    </tr>

    <tr>
    <td>
        $text{'email'}
    </td>

    <td>
EOF
    if ($form_type eq "display") {
        print "    $user->{'email'}\n" ;
    } else {
        print "    <input name=\"email\" size=30 value=\"$user->{'email'}\">\n";
    }
    print <<EOF ;
    </td>
    </tr>
EOF

    print <<EOF ;
    <tr>
    <td>
        $text{'allowedHosts'}
    </td>

    <td>
EOF

    if ($form_type eq "display") {
        foreach $hostname (@{$user->{'allowedHosts'}}) {
            print "    $hostname<br>\n" ;
        }
    } else {
        print "    <input name=\"allowedHosts\" size=30 value=\"" ;
        foreach $hostname (@{$user->{'allowedHosts'}}) {
            print $hostname, "," ;
        }
        print "\">\n" ;
    }

    print <<EOF ;
    </td>
    </tr>

    <tr>
    <td>
        $text{'telephoneNumber'}
    </td>

    <td>
EOF
    if ($form_type eq "display") {
        foreach $telnum (@{$user->{'telephoneNumber'}}) {
            print "    $telnum<br>\n" ;
        }
    } else {
        print "     <input name=\"telephoneNumber\" size=30"
            . " value=\"" ;
        foreach $telnum (@{$user->{'telephoneNumber'}}) {
            print $telnum, "," ;
        }
        print "\">\n";
    } 
    print <<EOF ;
    </td>
    </tr>

    <tr>
    <td>
        $text{'description'}
    </td>

    <td>
EOF
    if ($form_type eq "display") {
        print "    $user->{'description'}\n" ;
    } else {
        print "    <input name=\"description\" size=30 value="
            . "\"$user->{'description'}\">\n" ;
    }
    print <<EOF ;
    </td>
    </tr>
EOF

# user creation options
if ($form_type eq "create") {
    print "<TR><TD colspan=2 $tb><B>" . $text{'user_options'} . "</B>\n";
    print "</TD></TR>";
    print "<TR><TD>" . $text{'userpasswd'} . "\n";
    print "</TD>";
    print "<TD><INPUT name=\"userpassword\" size=12 > (*)\n";
    print "</TD></TR>";
    print "<TR><TD>" . $text{'passwdtype'} . "\n";
    print "</TD><TD>";
    print "<INPUT type=\"radio\" name=\"hash\" value=\"md5\">" .
        $text{'md5'} . "\n";
    print "<INPUT type=\"radio\" name=\"hash\" value=\"crypt\" checked>" .
        $text{'crypt'} . "\n";
    print "<INPUT type=\"radio\" name=\"hash\" value=\"nome\">" .
        $text {'plaintext'} . "\n";
    print "</TD></TR>";
    print "<TR><TD>" . $text{'create_home'} . "\n";
    print "</TD><TD>";
    $create_yes = ($config{'createhome'} eq "1") ? "checked" : "";
    $create_no = ($config{'createhome'} eq "2") ? "checked" : "";
    print "<INPUT type=\"radio\" name=\"create\" value=\"1\" $create_yes>" .
        $text{'yes'} . "\n";
    print "<INPUT type=\"radio\" name=\"create\" value=\"0\" $create_no>" .
        $text{'no'} . "\n";
    print "</TD></TR>";
    print "<TR><TD>" . $text{'copy_files'} . "\n";
    print "</TD><TD>";
    print "<INPUT type=\"radio\" name=\"copy\" value=\"1\" $create_yes>" .
        $text {'yes'} . "\n";
    print "<INPUT type=\"radio\" name=\"copy\" value=\"0\" $create_no>" .
        $text {'no'} . "\n";
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

    print <<EOF ;
    </td>
    </tr>
    </table>
    </td>
    </tr>
    </table>
    <br>
EOF


    if ($form_type ne "display") {
        # Change label to  Modify or Create
        if ($form_type eq "create") {
            $label = $text{'create'} ;
        } else {
            $label = $text{'modify'} ;
        }

        print <<EOF ;
    <table width=100% border=0>
    <TR>
    <TD align="left">
    <input type="submit" name="save" value=" $label ">
    </form>
    </TD>
EOF

        if ($form_type eq "modify") {
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
        print <<EOF ;
    </tr>
    </table>
EOF
    }

}

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

### END PASTE

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

1;
