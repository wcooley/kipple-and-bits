#!/usr/bin/perl

# groups.pl $Revision$ $Date$ $Author$

=head2 new_group_ok

SYNOPSIS 

new_group_ok ( I<\%group> )

DESCRIPTION

Checks that required attributes are present in group hash.

RETURN VALUE

Returns true is group hash has all required attributes.

=cut

sub new_group_ok
{
	my ($group) = @_ ;
    return
        $group{'gidNumber'} &&
        $group{'cn'};
}


sub changed_group_ok
{
    return new_group_ok;
}


sub group_from_form
{
    my ($in) = @_;

    # posixGroup
    $gidnumber = $in{gidnumber};
    $cn = $in{cn};

    # generate empty fields
}


sub group_from_entry
{
    my ($group) = @_;

    # posixGroup
    $gidnumber = $user->{gidnumber}[0];
    $cn = $user->{cn}[0];
}


sub group_defaults
{
    $gidnumber = &max_gidnumber() + 1;
}


sub entry_from_group
{
    my ($entry) = @_;

    # posixGroup
    $entry->{gidnumber} = [$gidnumber];
    $entry->{cn} = [$cn];
    
    return $entry;
}

sub group_from_form {
	my ($in) = @_ ;
	my (%group) ;

	if ($config{'new_group'}) {
		$group{'groupName'} = $in->{'uid'} ;
		if ($in->{'gid_from'} != "automatic") {
			$group{'gidNumber'} = $in->{'input_gid'} ;
		}
		if ($in->{'uidnumber'}) {
			$group{'memberUid'} = $in->{'uidnumber'} ;
		}
		if ($in->{'groupDescription'}) {
			$group{'description'} = $in->{'groupDescription'} ;
		} else {
			$group{'description'} = &text('group_desc',
				$group{'groupName'}) ;
		}
		if ($in->{'systemUser'}) {
			$group{'systemUser'} = 1 ;
		}
	}

	return \%group ;
}


=head1 NOTES

None at the moment.

=head1 CREDITS

This module begun by Fernando Lozano <fernando@lozano.etc.br>
in his I<ldap-users> module.  Incorporated into I<directory_mgr>
by Wil Cooley <wcooley@nakedape.cc>.  All bug reports should go to
Wil Cooley.

=cut

=head1 LICENSE

This file is copyright Fernando Lozano <frenando@lozano.etc.br>
and Wil Cooley <wcooley@nakedape.cc>, under the GNU General Public
License <http://www.gnu.org/licenses/gpl.txt>.

=cut

1;
