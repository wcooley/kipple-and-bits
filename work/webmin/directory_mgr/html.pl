#!/usr/bin/perl

#
# LDAP Users Admin
# html.pl $Revision$ $Date$ $Author$
# by Fernando Lozano <fernando@lozano.eti.br> under the GNU GPL (www.gnu.org)
#


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
    my ($gidnumber) = @_;
    
    my (@all_groups, @groups); 
    my ($group, $selected);

    @all_groups = &list_groups;
    
    @groups = sort {$a->{cn} cmp $b->{cn}} @all_groups;

    foreach $group (@groups) {
        $selected = ($group->{'gidnumber'} == $gidnumber) ? "selected" : "";
        print "<option value=\"$group->{'gidnumber'}\" $selected>" 
			. "$group->{'cn'} ($group->{'gidnumber'})</option>\n";
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
	my ($gid) = &find_gid ($user->{'gidnumber'}) ;

	my ($row) = "
<tr>
	<td>
		<a href=\"add_user.cgi?sort_on=$sort_on&dn=$user->{'dn'}\">
			$user->{'uid'}</a>
	</td>
	<td>
		$user->{'uidnumber'}
	</td>
	<td>
		$gid
	</td>
	<td>
		$user->{'cn'}
	</td>
	<td>&nbsp;$user->{'department'}
	</td>
</tr>
" ;

#print "<TD>" . $user->{dn};

	return $row ;

}

=head2 html_row_alias

SYNOPSIS

html_row_alias ( I<> )

=cut

sub html_row_alias
{


}


1;
