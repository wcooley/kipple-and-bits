#!/usr/bin/perl
#
# Directory_Mgr
# html.pl $Revision$ $Date$ $Author$
#

=head1 NAME

I<html.pl>

=head1 DESCRIPTION

I<html.pl> contains subroutines for emitting commonly-used HTML.

=cut

use strict ;
no strict "vars" ;

use diagnostics ;



=head2 html_passwd_rows

SYNOPSIS

C<html_passwd_rows ( I<\%user> )>

DESCRIPTION

C<html_passwd_rows> formats HTML tables rows suitable for
inclusion in a 2 column table.

RETURN VALUE

Returns the HTML string to be printed.

BUGS

None known.

NOTES

None.

=cut

sub html_passwd_rows ()
{

    my $rows = "" ;

    $rows = "\t<tr>\n\t\t<td>$text{'new_passwd'}</td>\n" ;

    $rows .= "\t\t<td><input type=\"text\" name=\"password\"></td>" ;

    $rows .= "\t<tr>\n\t\t<td>$text{'passwdtype'}</td>\n" ;
    $rows .= "\t\t<td>\n" ;
    $rows .= "\t\t\t<input type=\"radio\" name=\"hash\" value=\"ssha\" checked>" 
        . $text{'ssha'} . "\n" ;
    $rows .= "\t\t\t<input type=\"radio\" name=\"hash\" value=\"sha\">" 
        . $text{'sha'} . "\n" ;
    $rows .= "\t\t\t<input type=\"radio\" name=\"hash\" value=\"smd5\">" 
        . $text{'smd5'} . "\n" ;
    $rows .= "\t\t\t<input type=\"radio\" name=\"hash\" value=\"md5\">" 
        . $text{'md5'} . "\n" ;
    $rows .= "\t\t\t<input type=\"radio\" name=\"hash\" value=\"crypt\">" 
        . $text{'crypt'} . "\n" ;
    $rows .= "\t\t\t</td>\n" ;

    $rows .= "\t\t<tr>\t\t\t<td><input type=\"submit\" value=\"Submit\"></td>\n\t\t</tr>\n" ;

    return $rows ;

}

=head2 html_shell_options

SYNOPSIS

C<html_shell_options ( [I<$default_shell>] )>

DESCRIPTION

C<html_shell_options> emits HTML select inputs with a configured
list of shells.  The optional I<$default_shell> selects the
shell to be selected by default.

RETURN VALUE

True

BUGS

Probably should return a string of HTML instead of printing it
directly.

NOTES

None.

=cut

sub html_shell_options (:$)
{
    my ($default_shell) = @_;
    
    my ($shell, $selected);

    open SHELLS, "</etc/shells";
    while (<SHELLS>) {
        tr/\n\r\t //d;
        $selected = ($default_shell eq $_) ? "selected" : "";
        print "<option value=\"$_\" $selected>$_\n";
    }

    return 1;
}


=head2 html_group_options

SYNOPSIS

C<html_group_options ( [I<$default_groupID>] )>

DESCRIPTION

Emits an HTML select list of groups.

RETURN VALUE

True

BUGS

Probably should return a string instead of printing directly.
Should be able to configure a multi-value select.

NOTES

None.

=cut

sub html_group_options (:$)
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

    return 1;
}


=head2 html_row_group

SYNOPSIS

C<html_row_group ( I<\%group> )>

DESCRIPTION

Takes a reference to a hash containing group information and
formats as an HTML row.

RETURN VALUE

Returns a formatted HTML row of group information.

BUGS

None known.

NOTES

None.

=cut

sub html_row_group ($)
{

    my ($group) = @_ ;

    # Add a non-breaking space if groupDescription is empty
    unless ($group->{'groupDescription'}) {
        $desc_space = "&nbsp;" ;
    }

    my $row = "
<tr>
    <td>&nbsp;
        <a href=\"edit_group.cgi?dn=$group->{'dn'}\">
            $group->{'groupName'}</a>
    </td>
    <td>
        $group->{'groupID'}
    </td>
    <td>
        $group->{'groupDescription'}$desc_space
    </td>

" ;

    return $row ;
}

=head2 html_row_user

SYNOPSIS

html_row_user ( I<\%user> )

DESCRIPTION

Takes a reference to a hash containing user information and formats
as an HTML row.

RETURN VALUE

Returns a formatted HTML row of user information.

=cut

sub html_row_user ($)
{
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

sub html_user_form ($$)
{

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
        print "    <input type=\"hidden\" name=\"userName\" value=\"$user->{'userName'}\">\n" ;
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
        print "    <input name=\"userID\" type=\"hidden\" value=\"$user->{'userID'}\">\n" ;
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
        print "    <input type=\"hidden\" name=\"groupID\" value=\"$user->{'groupID'}\" >\n" ;
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
		<form method="post" action="edit_user.cgi">
		<input type="hidden" name="dn" value="$dn">
		<input type="hidden" name="do" value="set_passwd">
		<input type="submit" value="$text{'set_passwd'}">
		</form>
	</td>
	<td align="right">
		<form method="post" action="save_user.cgi">
		<input type="hidden" name="dn" value="$dn">
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

1;
