#!/usr/bin/perl
#
# LDAP Users Admin
# ldap-groups.pl $Revision$ $Date$ $Author$
# by Fernando Lozano <fernando@lozano.eti.br> under the GNU GPL (www.gnu.org)
#

# must be included (required) after ldap-users.pl

use strict ;
no strict "vars" ;

use diagnostics ;
$diagnostics::PRETTY =1 ;

=head1 NAME

ldap_groups.pl

=head1 DESCRIPTION

ldap_groups contains subroutines related to managing POSIX groups
in LDAP.

=head1 FUNCTIONS

=cut



=head2 is_gid_free

SYNOPSIS

C<is_gid_free ( I<$gid> )>

DESCRIPTION

Checks if a supplied group name is available.

RETURN VALUE

Returns the entry matching the supplied group name, which is
undefined if there is no entry.

BUGS

Check that the returned $entry is indeed undef if search finds
no entries.

=cut

sub is_gid_free
{
    my ($gid) = @_;

    my ($filter);

    $filter = "(&(objectclass=posixGroup)(cn=$gid)";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("objectclass", "cn"));

    if ($entry) {
        return 0 ;
    } else {
        return 1 ;
    }
}

=head2 is_gidNumber_free

SYNOPSIS

C<is_gidNumber_free ( I<$gidNumber> )>

DESCRIPTION

Check if supplied gidNumber is available.

RETURN VALUE

Returns true if the gidNumber is free; false if it isn't.

=cut

sub is_gidNumber_free
{
    my ($gidNumber) = @_;

    my ($filter);

    $filter = "(&(objectclass=posixGroup)(gidNumber=$gidNumber))";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("objectclass", "gidNumber"));

    if ($entry) {
        return 0;
    } else {
        return 1;
    }
}

=head2 list_groups

SYNOPSIS

C<list_groups ( I<$ou_filter> )>

DESCRIPTION

Lists groups with DN, CN, and gidNumber.

RETURN VALUE

Returns an array of references to hashes, where each hash
has keys 'dn', 'cn' and 'gidNumber'.

BUGS

The I<ou_filter> is not implemented.  Returns an array
instead of a reference to an array.

=cut

sub list_groups
{
    # do not filter OU yet
    # should display the OU for each entry
    my ($ou_filter) = @_;

    my ($filter, $entry, $i);
    my (@groups);

    $filter = "(objectclass=posixGroup)";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("cn", "gidNumber"));

    $i = 0;
    while ($entry) {
        my (%group);

        # This could be done better by changing the filter
        # string
        if ($config{'hide_system_groups'} &&
            ($config{'min_gid'} > $entry->{'gidNumber'}[0])) {
            $entry = $conn->nextEntry ();
            next ;
        }


        $group{'dn'} = $entry->getDN (),
        $group{'cn'} = $entry->{'cn'}[0],
        $group{'gidNumber'} = $entry->{'gidNumber'}[0];
        $groups[$i++] = \%group;

        $entry = $conn->nextEntry ();
    }

    return @groups;
}

=head2 find_gid

SYNOPSIS

C<find_gid ( I<$gidNumber> )>

DESCRIPTION

Searches for group by gidNumber. 

RETURN VALUE

Returns the first CN associated with the number or -1 if the
gidNumber isn't found.

=cut

sub find_gid
{
    my ($gid) = @_;

    my ($filter, $entry);

    $filter = "(&(objectclass=posixGroup)(gidNumber=$gid))";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("cn", "gidNumber"));

    if ($entry) {
        return $entry->{'cn'}[0];
    }
    else {
        return -1 ;
    }
}

=head2 find_free_groupid

SYNOPSIS

C<find_free_groupid ( [I<$minGid>], [I<$maxGid>] )>

DESCRIPTION

Finds the free available gidNumber, starting at I<minGid> but not
over I<maxGid>.

RETURN VALUE

Returns the free available GID or -1 if an available GID isn't found.

BUGS

Calls &is_gidNumber_free() repeatedly, which can cause lots of
queries to server.  Fix by doing a single query and examining
results.

=cut

sub find_free_groupid ($:$)
{

	my ($minGid, $maxGid) = @_ ;

	$minGid = 0 unless $minGid ;
    $maxGid = $config{'max_gid'} unless $maxGid ;

    my $free_gid = -1 ;

    while ($minGid <= $maxGid) {
        if (&is_gidNumber_free($minGid)) {
            $free_gid = $minGid ;
            last ;
        }
        $minGid++ ;
    }

	return $free_gid ;
}


=head2 create_group

SYNOPSIS

C<create_group( I<\%group> )>

DESCRIPTION

Creates a group in the LDAP tree based on keys in the
aliased hash I<\%group>.  


REQUIRED HASH KEYS: 

=over 4

=item * I<groupName> The name of the group.

=back


OPTIONAL HASH KEYS:


=over 4

=item * I<gidNumber> The gidNumber attribute; if not set, a new
	gidNumber is automatically chosen.


=item * I<memberUid> The first username to be added to the group.
	Often used.

=item * I<description> A description for the group.  Not used with
	POSIX accounts, but may be useful for tracking groups.

=item * I<userPassword> A password for the group.  Normally not used.

=item * I<systemUser> If set to true, creates a "system" user instead
	of a normal user.

=back

RETURN VALUE

Returns a 2-element array containing, in the case of success,
1 and the DN.

In the case of an error, returns an array of -1 and a formatted
error string.

BUGS

OU for groups is not configurable.

=cut

sub create_group ($)
{

	my ($group) = @_ ;
	my ($entry, $dn, $err) ;

	$entry = $conn->newEntry() ;
	$dn = "cn=" . $group->{'groupName'} . ",ou=Group," . $config{'base'} ;
	$entry->setDN($dn) ;
    $entry = &entry_from_group($entry, $group) ;

	$conn->add($entry) ;

	if ($err = $conn->getErrorCode()) {
		return [ -1, "group add ($dn): $err " . $conn->getErrorString()] ;
	} else {
		return [ 1, $dn] ;
	}

}


=head2 group_entry_add_username

SYNOPSIS

C<group_entry_add_username ( I<\%entry>, I<$username> )>

DESCRIPTION

This function adds a username to a group LDAP entry.
Requires a pre-initialized entry.

RETURN VALUE

Returns true if the username was added; false if the
username already existed.

BUGS

None known.

NOTES

None.

=cut

sub group_entry_add_username ($$) {

    my ($entry, $inuser) ;

    if ($entry->hasValue('memberUid', $inuser)) {
        return 0;
    } else {
        $entry->addValue('memberUid', $inuser) ;
        return 1;
    }
}

=head1 NOTES

A subroutine in this library file MUST NOT call &error or otherwise
display an error message.  In the case of error, it SHOULD return -1
or another value readily distinguishable from a valid return value,
and optionally an error string which may be displayed by the caller.
The function MUST document what values indicate errors.

=head1 CREDITS

This module begun by Fernando Lozano <fernando@lozano.etc.br>
in his I<ldap-users> module.  Incorporated into I<directory_mgr>
by Wil Cooley <wcooley@nakedape.cc>.  All bug reports should go to
Wil Cooley.

=cut

1;
