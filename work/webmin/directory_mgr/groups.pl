#!/usr/bin/perl

# groups.pl $Revision$ $Date$ $Author$

=head2 new_group_ok

SYNOPSIS 

C<new_group_ok ( I<\%group> )>

DESCRIPTION

Checks that required attributes are present in group hash;
false otherwise.

RETURN VALUE

Returns true if group hash has all required attributes;
false otherwise.

=cut

sub new_group_ok ($)
{
	my ($group) = @_ ;
    if ($group->{'groupID'} && $group->{'groupName'}) {
        return 1;
    } else {
        return 0;
    }
}


=head 2 changed_group_ok

SYNOPSIS

C<changed_group_ok ( I<\%group> )>

DESCRIPTION

Validates a changed group hash for attribute requirements.

RETURN VALUE

Returns true if group hash has all required attributes;
false otherwise.

BUGS

None known.

NOTES

None.

=cut
sub changed_group_ok ($)
{
    my ($group) = @_ ;
    return &new_group_ok ($group);
}



=head 2 group_from_entry

SYNOPSIS

C<group_from_entry ( I<\%entry> )>

DESCRIPTION

Creates a group hash from a given directory entry.

RETURN VALUE

Returns a reference to a newly-created group hash.

BUGS

None known.

NOTES

None.

=cut

sub group_from_entry ($)
{
    my ($entry) = @_;
    my (%group) ;

    # posixGroup
    $group{'groupID'} = $entry->{'gidNumber'}[0];
    $group{'groupName'} = $entry->{'cn'}[0];
    $group{'groupDescription'} = $entry->{'description'}[0] ;
    $group{'memberUsername'} = $entry->{'memberUid'} ;
    
    return \%group ;
}



=head 2 group_defaults

SYNOPSIS

C<group_defaults ( I<\%group> )>

DESCRIPTION

Sets defaults for a new group hash.

RETURN VALUE

Returns a reference to the passed-in group hash.

BUGS

None known.

NOTES

None.

=cut
sub group_defaults ($)
{
    my ($group) = @_ ;

    $group->{'groupID'} = &find_free_groupid($config{'min_gid'},
        $config{'max_gid'}) ;

    return $group ;
}

=head 2 entry_from_group 

SYNOPSIS

C<entry_from_group ( I<\%entry>, I<\%group> )>

DESCRIPTION

This function creates an LDAP group entry from a group hash.

RETURN VALUE

Return a 2-element array with 1 as the first element on success
and the DN of the entry as the second.  On failure, returns -1
in the first element and a formatted error string as the second.
Entry must already exist.

BUGS

None known.

NOTES

None.

=cut

sub entry_from_group ($$)
{
    my ($entry, $group) = @_;

    # Add the requisite object classes
    unless ($entry->hasValue('objectClass', 'top')) {
        $entry->addValue('objectClass', 'top') ;
    }
    unless ($entry->hasValue('objectClass', 'posixGroup')) {
        $entry->addValue('objectClass', 'posixGroup') ;
    }

    # Add the group ID
    unless ($entry->hasValue('gidNumber', $group->{'groupID'})) {
        $entry->setValues('gidNumber', $group->{'groupID'});
    }

    # Add the group name
    unless ($entry->hasValue('cn', $group->{'groupName'})) {
        $entry->setValues('cn', $group->{'groupName'});
    }

    # Add the group description, if any
    unless ($entry->hasValue('description', $group->{'groupDescription'})) {
        if ($group->{'groupDescription'}) {
            $entry->setValues('description', $group->{'groupDescription'}) ;
        }
    }
    # Add member users
    for $username (@{$group->{'memberUsernames'}}) {
        &group_entry_add_user ($entry, $username) ;
    }
    
    return $entry;
}


=head 2 group_from_form

SYNOPSIS

C<group_from_from ( I<$in> )>

DESCRIPTION

This function processes form input and copies input data
into the group hash.

RETURN VALUE

Returns a two-element array with 1 as the first element and a
reference to the new group hash as the second.  On error, it returns
-1 as the first element and a formatted error string as the second.

BUGS

None known.

NOTES

Special care must be taken since this function must handle not
only group creation through the group forms but also group creation
through the user forms.

=cut

sub group_from_form ($) {
	my ($in) = @_ ;
	my (%group) ;

    if ($in->{'groupName'}) {
    } else {
        $group{'groupName'} = $in->{'userName'} ;
    }

    if ($in->{'gid_from'} eq "automatic") {
        unless ($in->{'groupDescription'}) {
            $group{'groupDescription'} = &text('group_desc', $group{'groupName'}) ;
        }
    } elsif ($in->{'gid_from'} eq "input") {
        $group{'groupID'} = $in->{'groupID'} ;
    } elsif ($in->{'gid_from'} eq "select") {
        $group{'groupID'} = $in->{'groupID'} ;
    }

    if ($in->{'groupDescription'}) {
        $group{'groupDescription'} = $in->{'groupDescription'} ;
    } else {
        $group{'groupDescription'} = &text('group_desc', $group{'groupName'}) ;
    }

	return \%group ;
}


=head 2 group_add_username

SYNOPSIS

C<group_add_user ( I<$group>, I<$userName> )>

DESCRIPTION

Adds a userName to a group hash.

RETURN VALUE

Returns true if it added the username; false if the username
already exists.

BUGS

None known.

NOTES

None.

=cut

sub group_add_username ($$) {
    my ($group, $inuser) = @_ ;

    for $user (@{$group{'memberUsername'}}) {
        if ($user eq $inuser) {
            return 0 ;
        }
    }

    push @{$group{'memberUsername'}}, $user ;

    return 1 ;

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
