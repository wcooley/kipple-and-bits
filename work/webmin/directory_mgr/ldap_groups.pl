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

=head1 NAME

I<ldap_groups.pl>

=head1 DESCRIPTION

I<ldap_groups> contains subroutines related to managing POSIX groups
in LDAP.

=head1 FUNCTIONS

=cut



=head2 search_groups_attr

SYNOPSIS

C<search_group_attr ( I<$attr_string>, I<@attr_array> )>

DESCRIPTION

Searches group objects for matching attributes.  Uses
I<@attr_array> to limit attributes returned.

RETURN VALUE

Returns a reference to an array of hashes with the
attributes requested in I<@attr_array>.  The hash values are
themselves arrays, since LDAP can have multi-valued
attributes.  On error, returns an array with -1 as the first
element and a formatted error string as the second.

BUGS

None known.

NOTES

None.

=cut

sub search_group_attr ($@) {

    my ($attr_filter, @desired_attrs)= @_ ;
    my $filter = "(&(objectClass=posixGroup)($attr_filter))" ;
    my (@groups, $i) ;

    $entry = $conn->search($config{'base'}, "subtree",
        $filter, 0, @desired_attrs) ;

    if ($err = $conn->getErrorCode()) {
        return [ -1, "$err " . $conn->getErrorString() ] ;
    }

    $i = 0 ;
    while ($entry) {
        my (%group) ;

        foreach $attr (@desired_attrs) {
            if ($attr eq "dn") {
                $group{'dn'} = [$entry->getDN()] ;
            } else {
                $group{$attr} = $entry->{$attr} ;
            }
        }

        $groups[$i++] = \%group ;
        $entry = $conn->nextEntry() ;
    }
    return \@groups ;
}


=head2 search_groups

SYNOPSIS

C<search_groups ( I<$search_key>, I<$search_value> )>

DESCRIPTION

This function searches for groups with the attribute given
in the I<$search_key> matching I<$search_string>.

RETURN VALUE

Returns a reference to an array of groups or the return value of
search_group_attr.

BUGS

None known.

NOTES

None.

=cut
sub search_groups ($$)
{

    my ($search_key, $search_value) = @_ ;

    my @attrs = qw( cn dn gidNumber memberUid description ) ;
    my (@groups, $entries, $search, $entry) ;

    if ($search_key eq "groupName") {
        $search = "cn=" . $search_value ;
    } elsif ($search_key eq "groupID") {
        $search = "gidNumber=" . $search_value ;
    } elsif ($search_key eq "groupDescription") {
        $search = "description=" . $search_value ;
    } elsif ($search_key eq "memberUsername") {
        $search = "memberUid=". $search_value ;
    } else {
        return [ -1, &text('err_unknown_group_attr',$search_key) ] ;
    }
    
    $entries = &search_group_attr($search, @attrs) ;

    #print "Found " . scalar(@{$entries}) . " entries" ;

    if ( $entries->[0] == -1 ) {
        return $entries ;
    } else {
        foreach $entry (@{$entries}) {
            push @groups, &group_from_entry($entry) ;
        }
    }

    return \@groups ;
}

=head2 get_group_attr 

SYNOPSIS

C<get_group_attr ( I<$dn> )>

DESCRIPTION

Retrieves a group LDAP object given a distinguished name.

RETURN VALUE

Returns a reference to an LDAP group entry.

BUGS

None known.

NOTES

None.

=cut

sub get_group_attr ($)
{
    my ($dn) = @_ ;
    my $entry ;

    $entry = $conn->browse($dn) ;
    $entry->{'dn'} = [$entry->getDN()] ;
    return $entry ;
}

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

sub is_gid_free ($)
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

sub is_gidNumber_free ($)
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

C<list_groups ( [I<$ou_filter>, [I<$sort_on>]] )>

DESCRIPTION

Lists groups with DN, CN, and gidNumber.

RETURN VALUE

Returns a reference to an array of references to hashes.

BUGS

The I<$ou_filter> an I<$sort_on> are not implemented.

=cut

sub list_groups (:$$)
{
    # do not filter OU yet
    # should display the OU for each entry
    my ($ou_filter, $sort_on) = @_;

    my ($filter, $entry, $i);
    my (@groups);

    $filter = "(objectClass=posixGroup)";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("cn", "gidNumber", "description"));

    $i = 0;
    while ($entry) {
        my (%group);

        if ($config{'hide_system_groups'} &&
            ($config{'min_gid'} > $entry->{'gidNumber'}[0])) {
            $entry = $conn->nextEntry ();
            next ;
        }


        $group{'dn'} = $entry->getDN ();
        $group{'groupName'} = $entry->{'cn'}[0];
        $group{'groupID'} = $entry->{'gidNumber'}[0];
        $group{'groupDescription'} = $entry->{'description'}[0] ;
        $groups[$i++] = \%group;

        $entry = $conn->nextEntry ();
    }

    return \@groups;
}


=head2 group_from_entry 

SYNOPSIS

C<group_from_entry ( I<\%group_entry> )>

DESCRIPTION

Creates a group hash from a given LDAP entry hash.

RETURN VALUE

Returns a reference to a newly-created group hash.

BUGS

None known.

NOTES

None.

=cut

sub group_from_entry ($)
{
    my ($entry) = @_ ;
    my (%group) ;

    $group{'dn'} = $entry->{'dn'}[0] ;
    $group{'groupName'} = $entry->{'cn'}[0] ;
    $group{'groupID'} = $entry->{'gidNumber'}[0] ;
    $group{'groupDescription'} = $entry->{'description'}[0] ;
    # Array
    $group{'memberUsername'} = $entry->{'memberUid'} ;

    return \%group ;
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

sub find_gid ($)
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

sub group_entry_add_username ($$) 
{

    my ($entry, $inuser) = @_ ;

    if ($entry->hasValue('memberUid', $inuser)) {
        return 0;
    } else {
        $entry->addValue('memberUid', $inuser) ;
        return 1;
    }
}


=head2 group_entry_del_username

SYNOPSIS

C<group_entry_del_username ( I<\%entry>, I<$username> )>

DESCRIPTION

This function deletes a username from a group entry.
Requires a pre-initialized entry.

RETURN VALUE

Returns true if the username was found and removed; false if
the username didn't exist.

BUGS

None known.

NOTES

None.

=cut

sub group_entry_del_username ($$)
{
    my ($entry, $user) = @_ ;

    if ($entry->hasValue('memberUid', $user)) {
        $entry->removeValue('memberUid', $user) ;
        return 1 ;
    } else {
        return 0 ;
    }
}

=head2 group_list_users 

SYNOPSIS

C<group_list_users ( I<$groupName> )>

DESCRIPTION

Lists users associated with a group given a group name

RETURN VALUE

Returns a reference to array of usernames.

BUGS

None known.

NOTES

None.

=cut

sub group_list_users ($) {

    my ($groupName) = @_ ;
    my ($group, $users) ;

    $group = &search_group_attr("cn=$groupName", "memberUid") ;

    $users = \@{$group->{'memberUid'}} ;
    
    return $users ;

}


=head2 delete_group

SYNOPSIS

C<delete_group ( I<$dn> )>

DESCRIPTION

Deletes a given DN from the directory.

RETURN VALUE

Returns a two-element array; in the case of success, the
first element is 1 and the second the deleted DN.  In the
case of failure, -1 and a formatted error string.

BUGS

None known.

NOTES

None.

=cut

sub delete_group ($)
{
    my ($dn) = @_ ;

    $conn->delete($dn) ;
    if ($err = $conn->getErrorCode()) {
        return [ -1, "delete ($dn): $err: " . $conn->getErrorString()] ;
    } else {
        return [ 1, $dn ];
    }
}


=head2 update_group

SYNOPSIS

C<update_group ( I<$dn>, I<\%group> )>

DESCRIPTION

Updates a group entry based on a group hash.

RETURN VALUE

Returns a two-element array; in the case of success, the first
element is 1 and the second the modified DN.  In the case of failure,
-1 and a formatted error string.

BUGS

None known.

NOTES

None.

=cut
sub update_group ($$)
{
    my ($dn, $group) = @_ ;
    my ($entry) ;

    print STDERR "Entering update_group\n" ;

    $entry = $conn->browse($dn) ;
    if ($err = $conn->getErrorCode()) {
        return [ -1, "update_group browse ($dn): $err: " .
            $conn->getErrorString() ] ;
    }

    print STDERR "Calling entry_from_group\n" ;
    $entry = &entry_from_group($entry, $group) ;

    print STDERR "Calling \$conn-update\n" ;
    $conn->update($entry) ;
    print STDERR "Back from \$conn-update\n" ;

    if ($err = $conn->getErrorCode()) {
        return [ -1, "update_group update ($dn): $err: " .
            $conn->getErrorString() ] ;
    }

    print STDERR "Returning 1, $dn\n" ;
    return [ 1, $dn ] ;

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
