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

C<html_shell_options> generates HTML select inputs with a configured
list of shells.  The optional I<$default_shell> selects the shell
to be selected by default.

RETURN VALUE

Returns a formatted HTML string suitable for use in an HTML
<select> tag.

BUGS

None known.

NOTES

None.

=cut

sub html_shell_options (:$)
{
    my ($default_shell) = @_;
    
    my ($shell, $selected, $html);

    $html = "" ;
    $html .= qq(
        <select name="loginShell" size=1>
) ;

    open SHELLS, "</etc/shells";
    while ($shell = <SHELLS>) {
        $shell =~ tr/\n\r\t //d;
        $selected = ($default_shell eq $shell) ? "selected" : "";
        $html .= qq(
            <option value="$shell" $selected>
                $shell
            </option>
) ;
    }

    $html .= qq(
        </select>
) ;

    return $html ;
}


=head2 html_group_options

SYNOPSIS

C<html_group_options ( [I<$default_groupID>] )>

DESCRIPTION

Generates an HTML select list of groups.

RETURN VALUE

Returns an HTML-formatted list of groups.

BUGS

Should be able to configure a multi-value select.

NOTES

None.

=cut

sub html_group_options (:$)
{
    my ($groupID) = @_;
    
    my (@all_groups, @groups); 
    my ($group, $selected, $html);

    $html = "" ;

    $all_groups = &list_groups;
    
    @groups = sort {$a->{'groupName'} cmp $b->{'groupName'}} @{$all_groups};

    foreach $group (@groups) {
        $selected = ($group->{'groupID'} eq $groupID) ? "selected" : "";
        $html .= qq(
        <option value="$group->{'groupID'}" $selected> 
            $group->{'groupName'} ($group->{'groupID'})
        </option>
) ;
    }

    return $html ;
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



=head2 html_group_form

SYNOPSIS

C<html_group_form ( I<$form_type>, I<\%group> )>

DESCRIPTION

Formats the HTML form for group input, display, or
modification.

RETURN VALUE

Returns the HTML form as a string.

BUGS

None known.

NOTES

None.

=cut

sub html_group_form ($:$)
{

    my ($form_type, $group) = @_ ;
    my ($html) ;

    $html .= qq(<table $config{'html_table_options'} $cb>) ;

    if ($form_type ne "display") {
        $html .= qq(
    <form method="post" action="save_group.cgi">
    <input type="hidden" name="do" value="$form_type">
    <input type="hidden" name="dn" value="$group->{'dn'}">
    <input type="hidden" name="sort_on" value="$sort_on">
    ) ;
    }

    if ($form_type eq "modify") {
        $html .= qq(
        <input type="hidden" name="groupName" value="$group->{'groupName'}">
        <input type="hidden" name="groupID" value="$group->{'groupID'}">
    ) ;
    }

    $html .= qq(
    <tr>
    <td colspan=2 $tb>) ;

    if ($form_type eq "display") {
        $html .= qq(<b>$text{'display_group_t'}</b>) ;
    } elsif ($form_type eq "modify") {
        $html .= qq(<b>$text{'edit_group_t'}</b>) ;
    } elsif ($form_type eq "create") {
        $html .= qq(<b>$text{'add_group_t'}</b>) ;
    }

    $html .= qq(
    </td>
    </tr>
    ) ;

    $html .= qq(
    <tr>
    <td><b>$text{'groupName'}</b></td>
    ) ;

    $html .= qq(
    <td>) ;

    # Group name display/input
    if ($form_type eq "display") {
        $html .= $group->{'groupName'} ;
    } elsif ($form_type eq "modify") {
        # Don't allow groupName modification yet
        $html .= $group->{'groupName'} ;
    } elsif ($form_type eq "create") {
        $html .= qq(<input type="text" name="groupName" size=16>) ;
    }

    $html .= "\t</td>\n" ;

    $html .= qq(
    <tr>
    <td>
        <b>$text{'groupID'}</b>
    </td>
    <td>
    ) ;

    # Group ID display/input
    if ($form_type eq "display") {
        $html .= $group->{'groupID'} ;
    } elsif ($form_type eq "modify") {
        # Don't allow groupID modification yet
        $html .= $group->{'groupID'} ;
    } elsif ($form_type eq "create") {
        $html .= qq(<input type="text" name="groupID" size=5>) ;
    }

    $html .= "\t</td>\n" ;

    # FIXME: This really should be a selection list
    $html .= qq(
    <tr>
    <td>
        <b>$text{'memberUsernames'}</b>
    </td>
    <td>
    ) ;

    foreach $username (@{$group->{'memberUsername'}}) {
        $list_of_usernames .= $username . "," ;
    }

    if ($form_type eq "display") {
        $list_of_usernames =~ s/,$// ;
        $html .= qq($list_of_usernames) ;
    } elsif ($form_type eq "modify") {
        $html .= qq(<input type="text" 
            name="memberUsernames" 
            value="$list_of_usernames"
            size=30>\n) ;
    }

    if ($form_type eq "create") {
        $html .= qq(<input type="text" name="memberUsernames" size=30>\n) ;
    }

    $html .= qq{</td>\n};

    $html .= qq(
    <tr>
    <td>
        <b>$text{'description'}</br>
    </td>
    <td>
    ) ;

    if ($form_type eq "display") {
        $html .= qq($group->{'groupDescription'}) ;
    } elsif ($form_type eq "modify") {
        $html .= qq(
    <input 
        type="text"
        name="groupDescription"
        value="$group->{'groupDescription'}"
        size=30
    >
    ) ;
    } elsif ($form_type eq "create") {
        $html .= qq(
    <input 
        type="text"
        name="groupDescription"
        size=30>
    ) ;
    }

    $html .= qq (
    </td>
    ) ;

    if ($form_type ne "display") {
        $html .= qq(
    <tr>
    <td>
        <input type="submit">

        </form>
    </td>
    ) ;
    }
    
    if ($form_type eq "modify") {
        $html .= qq(
    <td>
		<form method="post" action="save_group.cgi">
            <input type="hidden" name="dn" value="$dn">
            <input type="hidden" name="do" value="delete">
            <input type="submit" value="$text{'delete'}">
		</form>
	</td>
    ) ;
    }

    if ($form_type ne "display") {
        $html .= qq(
    </tr>
    ) ;

    }

    $html .= qq(</table>) ;


    return $html ;
}


=head2 html_group_search_form

SYNOPSIS

C<html_group_search_form ( )>

DESCRIPTION

Generates HTML for a group search form.

RETURN VALUE

Returns HTML.

BUGS

None known.

NOTES

None.

=cut
sub html_group_search_form ()
{

    my $html = qq(

        <form method="post" action="search_group.cgi">
        <input type="hidden" name="do" value="search">

        Search for:
        <input type="text" width="30" name="search_value">
        <select name="search_key">
        <option value="groupName">$text{'groupName'}</option>
        <option value="groupID">$text{'groupID'}</option>
        <option value="groupDescription">$text{'groupDescription'}</option>

        </select>

        <input type="submit" value="Search">

        </form>
    ) ;

    return $html ;
}



=head2 html_group_table_header

SYNOPSIS

C<html_group_table_header ( I<param> )>

DESCRIPTION

Generates header HTML for a group table.

RETURN VALUE

Returns HTML.

BUGS

None known.

NOTES

None.

=cut
sub html_group_table_header()
{

    my $html = qq(
    <table $config{'html_table_options'} $cb>
    <tr $tb>
    <td>
        <b>
            $text{'groupName'}
        </b>
    </td>
    <td>
        <b>
            $text{'groupID'}
        </b>
    </td>
    <td>
        <b>$text{'description'}</b>
    </td>

    ) ;

    return $html ;

}


=head2 html_group_table_footer

SYNOPSIS

C<html_group_table_footer ( )>

DESCRIPTION

Generates HTML for a group table footer.

RETURN VALUE

Returns HTML.

BUGS

None known.

NOTES

None.

=cut
sub html_group_table_footer()
{

    my $html = qq(
    </table>
    ) ;

    return $html ;
}


=head2 html_user_table_header

SYNOPSIS

C<html_user_table_header ( )>

DESCRIPTION

Emits HTML for the headers of a table of users.

RETURN VALUE

Returns HTML.

BUGS

None known.

NOTES

None.

=cut
sub html_user_table_header ()
{

    my ($html) ;

    $html = qq(
    <table $config{'html_table_options'} $cb>
        <tr $tb>
        <td><b>$text{'userName'}</b>
        <td><b>$text{'userID'}</b>
        <td><b>$text{'groupID'}</b>
        <td><b>$text{'fullName'}</b>
        <td><b>$text{'telephoneNumber'}</b>
        </tr>
    ) ;

    return $html ;
}


=head2 html_user_table_footer

SYNOPSIS

C<html_user_table_footer ( )>

DESCRIPTION

Emits HTML for the footer of a table of users.

RETURN VALUE

Returns HTML.

BUGS

None known.

NOTES

None.

=cut
sub html_user_table_footer ()
{
    my ($html) ;

    $html = qq(
    </table>
    ) ;

    return $html ;
}


=head2 html_user_form_sect_posix

SYNOPSIS

C<html_user_form_sect_posix ( I<$form_type>, I<\%user> )>

DESCRIPTION

Generates HTML for the POSIX section of the user HTML form.

RETURN VALUE

Returns formatted HTML of POSIX user information.

BUGS

None known.

NOTES

None.

=cut
sub html_user_form_sect_posix ($$)
{

    my ($form_type, $user) = @_ ;

    my $html = "" ;
    
    $html .= qq(
    <tr><td colspan=2 $tb>
        <b>$text{'posixAccount'}</b>
    </td></tr>
    <tr>
    <td>
        <b>$text{'uid'}</b>
    </td>
    <td>
) ;

    if ($form_type eq "display") {
        $html .= qq(        $user->{'userName'}) ;
    } elsif ($form_type eq "modify") {
        $html .= qq(
        $user->{'userName'}
        <input type="hidden" name="userName" value="$user->{'userName'}">
) ;
    } elsif ($form_type eq "create") {
        $html .= qq(
        <input name="userName" size=16 value="$user->{'userName'}">
) ;
    }

    $html .= qq(
    </td>
    </tr>

    <tr>
    <td>
        <b>$text{'userID'}</b>
    </td>
    <td>
) ;

    if ($form_type eq "display") {
        $html .= qq(
        $user->{'userID'}
) ;
    } elsif ($form_type eq "modify") {
        $html .= qq(
        $user->{'userID'}
        <input name="userID" type="hidden" value="$user->{'userID'}">
) ;

    } elsif ($form_type eq "create") {
        $html .= qq(
        <input name="userID" size=5 value="$user->{'userID'}">
) ;
    }

$html .= qq(
    </td>
    </tr>

    <tr>
	<td>
	<b>$text{'groupID'}</b>
	</td>
	<td>
) ;

    if ($form_type eq "display") {
        $html .= qq(
        $user->{'groupID'}
) ;
    } elsif ($form_type eq "modify") {
        $html .= qq(
        $user->{'groupID'}
        <input type="hidden" name="groupID" value="$user->{'groupID'}">
) ;
    } else {

    $html .= qq(
	    <input type="radio" name="gid_from" value="automatic" checked>
	    $text{'gid_automatic'}
	    <input type="radio" name="gid_from" value="input">
	    <input type="text" name="input_gid" size=5>
	    <input type="radio" name="gid_from" value="select">
        <select name="group_select" size=1>
) ;

    $html .= &html_group_options ($user->{'groupID'}) ;
    $html .= qq(
        </select>
) ;
    }

    $html .= qq(
        </td>
    </tr>
) ;

    # Secondary Groups
    $html .= qq(
    <tr>
        <td>
            $text{'sec_group'}
        </td>
        <td>
) ;

    my $groups = "" ;
    foreach $group (@{$user->{'secondaryGroups'}}) {
        $groups .= "$group," ;
    }

    if ($form_type eq "display") {
        $html .= $groups ;
    } else {
        $html .= qq(
        <input name="secondaryGroups" size=30 value="$groups"> 
) ;
    }

    $html .= qq(
        </td>
    </tr>
) ;


    $html .= qq(
    <tr>
    <td>$text{'homeDirectory'}</td>
    <td>
) ;

    if ($form_type eq "display") {
        $html .= qq(    $user->{'homeDirectory'}
) ;
    } else {
        $html .= qq(    <input name="homeDirectory" size=30 value="$user->{'homeDirectory'}">
) ;
    }

    $html .= qq(
    </td>
    </tr>
    
    <tr><td>
        <b>$text{'loginShell'}</b>
    </td>

    <td>
) ;

    if ($form_type eq "display") {
        $html .= qq(
        $user->{'loginShell'}
) ;
    } else {
        $html .= &html_shell_options ($user->{'loginShell'}) ;
    }

    $html .= qq(
    </td></tr>
) ;

    return $html ;
}



=head2 html_user_form_sect_addrbk

SYNOPSIS

C<html_user_form_sect_addrbk ( I<$form_type>, I<\%user> )>

DESCRIPTION

Generates HTML for user addressbook-type information.

RETURN VALUE

Returns a formatted HTML string.

BUGS

None known.

NOTES

None.

=cut
sub html_user_form_sect_addrbk ($$)
{

    my ($form_type, $user) = @_ ;

    my $html = "" ;

    $html .= qq(
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
) ;

    if ($form_type eq "display") {
        $html .= qq(    $user->{'firstName'}
) ;
    } else {
        $html .= qq(    <input name="firstName" size=30 value="$user->{'firstName'}">
) ;
    }

    $html .= qq(
    </td>
    </tr>

    <tr>
    <td>
        <b>$text{'surName'}</b>
    </td>

    <td>
) ;

    if ($form_type eq "display") {
        $html .= qq(
        $user->{'surName'}
) ;
    } else {
        $html .= qq(
        <input name="surName" size=30 value="$user->{'surName'}">
) ;
    }

    $html .= qq(
    </td>
    </tr>

    <tr>
    <td>
        $text{'email'}
    </td>

    <td>
) ;

    if ($form_type eq "display") {
        $html .= qq( 
        $user->{'email'}
) ;
    } else {
        $html .= qq(
        <input name="email" size=30 value="$user->{'email'}">
) ;
    }
    $html .= qq(
    </td>
    </tr>
) ;

    $html .= qq(
    <tr>
    <td>
        $text{'allowedHosts'}
    </td>

    <td>
) ;

    if ($form_type eq "display") {
        foreach $hostname (@{$user->{'allowedHosts'}}) {
            $html .= qq(
            $hostname<br>
) ;
        }
    } else {
        $html .= qq(
            <input name="allowedHosts" size=30 value="" 
) ;
        foreach $hostname (@{$user->{'allowedHosts'}}) {
            $html .= $hostname . "," ;
        }
        $html .= qq(">) ;
    }

    $html .= qq(
    </td>
    </tr>

    <tr>
    <td>
        $text{'telephoneNumber'}
    </td>

    <td>
) ;

    if ($form_type eq "display") {
        foreach $telnum (@{$user->{'telephoneNumber'}}) {
            $html .= qq(
            $telnum<br>
) ;
        }
    } else {
        $html .= qq(
        <input name="telephoneNumber" size=30 value="") ;
        foreach $telnum (@{$user->{'telephoneNumber'}}) {
            $html .= $telnum . "," ;
        }
        $html .= qq(">) ;
    } 

    $html .= qq(
    </td>
    </tr>

    <tr>
    <td>
        $text{'description'}
    </td>
    <td>
) ;

    if ($form_type eq "display") {
        $html .= qq(
        $user->{'description'}
) ;
    } else {
        $html .= qq(
        <input name="description" size=30 value="$user->{'description'}">
) ;
    }

    $html .= qq(
    </td>
    </tr>
) ;
}



=head2 html_user_form_sect_create

SYNOPSIS

C<html_user_form_sect_create ( I<$form_type>, I<\%user> )>

DESCRIPTION

Generates HTML for new-user creation options.

RETURN VALUE

Returns a formatted HTML string.

BUGS

None known.

NOTES

None.

=cut

sub html_user_form_sect_create ($$)
{

    my ($form_type, $user) = @_ ;

    my $html = "" ;

    $create_yes = ($config{'createhome'} eq "1") ? "checked" : "";
    $create_no = ($config{'createhome'} eq "2") ? "checked" : "";

    $html .= qq(

    <tr>
        <td colspan=2 $tb>
            <b>$text{'user_options'}</b>
        </td>
    </tr>
    <tr>
        <td>
            $text{'userpasswd'}
        </td>
        <td>
            <input name="userpassword" size=12> (*)
        </td>
    </tr>
    <tr>
        <td>
            $text{'passwdtype'}
        </td>
        <td>
            <input type="radio" name="hash" value="md5">
                $text{'md5'}
            <input type="radio" name="hash" value="crypt" checked>
                $text{'crypt'}
            <input type="radio" name="hash" value="nome">
                $text{'plaintext'}
        </td>
    </tr>
    <tr>
        <td>
            $text{'create_home'}
        </td>
        <td>
            <input type="radio" name="create" value="1" $create_yes>
                $text{'yes'}
            <input type="radio" name="create" value="0" $create_no>
                $text{'no'}
        </td>
    </tr>
    <tr>
        <td>
            $text{'copy_files'}
        </td>
        <td>
            <input type="radio" name="copy" value="1" $create_yes>
                $text{'yes'}
            <input type="radio" name="copy" value="0" $create_no>
                $text{'no'}
        </td>
    </tr>
) ;

    if ($config{'createhomeremote'}) {

        $html .= qq(
    <tr>
        <td>
            <b>$text{'servers_for_home_dir'}
        </td>
        <td>
            <select name="servers_for_home_dir" multiple size=3>
) ;

        for $server (@servers) {
            $html .= qq(
            <option value="$server->{'host'}">
                $server->{'host'}
            </option>
) ;
        }

        $html .= qq(
            </select>
        </td>
    </tr>
) ;

    }

    return $html ;
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

=item * modify 

Presents current user data to be modified.

=back

=cut

sub html_user_form ($$)
{

    my ($form_type, $user) = @_ ;

    my $html = "" ;

    $html .= "<!-- Begin html_user_form -->\n" ;

    if ($form_type ne "display") {
        $html .= qq(
    <form method="post" action="save_user.cgi">
    <input type="hidden" name="do" value="$form_type">
    <input type="hidden" name="dn" value="$dn">
    <input type="hidden" name="sort_on" value="$sort_on">

) ;
    }

    $html .= qq(
    <table $config{'html_table_options'} width=100% $cb>
) ;

    $html .= &html_user_form_sect_posix($form_type, $user) ;

    $html .= &html_user_form_sect_addrbk($form_type, $user) ;

    if ($form_type eq "create") {
        $html .= &html_user_form_sect_create($form_type, $user) ;
    }

    $html .= qq(
    </table>
    <br>
) ;


    if ($form_type ne "display") {
        # Change label to  Modify or Create
        if ($form_type eq "create") {
            $label = $text{'create'} ;
        } else {
            $label = $text{'modify'} ;
        }

        $html .= qq(
    <table width=100% border=0>
    <tr>
    <td align="left">
    <input type="submit" name="save" value=" $label ">
    </form>
    </td>
) ;

        if ($form_type eq "modify") {
            $html .= qq(
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
) ;
        }
            $html .= qq(
    </tr>
    </table>
) ;
    }

    $html .= "<!-- End html_user_form -->\n" ;

    return $html ;
}


=head2 html_user_search_form

SYNOPSIS

C<html_user_search_form ( )>

DESCRIPTION

Generates HTML for user search form.

RETURN VALUE

Returns generated HTML.

BUGS

None known.

NOTES

None.

=cut
sub html_user_search_form ()
{

    my $html = qq(

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
    ) ;

    return $html ;

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
