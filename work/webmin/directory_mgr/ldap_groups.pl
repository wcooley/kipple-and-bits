#!/usr/bin/perl
#
# LDAP Users Admin
# ldap-groups.pl $Revision$ $Date$ $Author$
# by Fernando Lozano <fernando@lozano.eti.br> under the GNU GPL (www.gnu.org)
#

# must be included (required) after ldap-users.pl

=head1 NAME

ldap_groups.pl

=head1 DESCRIPTION

ldap_groups contains subroutines related to managing POSIX groups
in LDAP.

=head1 FUNCTIONS

=cut




=head2 max_gidnumber

SYNOPSIS

max_gidnumber ( )

DESCRIPTION

Finds the maximum used gidNumber.

RETURN VALUE

Returns the maximum used gidNumber.

NOTES

What is this function useful for?  I think it was intended to create
new groups, but it doesn't take into account minimum group IDs (to
distinguish system and normal users) and holes in list of group IDs.
It is, however, faster than 'find_next_gid' because it makes only
one query.

=cut

sub max_gidnumber
{
    my ($filter, $maxgid, $u);

    # ldap should have a way to find this...
    $filter = "(objectclass=posixGroup)";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("gidnumber"));

    $maxgid = 0;
    while ($entry) {
        $u = $entry->{'gidnumber'}[0];
	# is there a group "nobody"...
	#if ($u != 65534) {
            $maxgid = ($u > $maxgid) ? $u : $maxgid;
	#}
        $entry = $conn->nextEntry ();
    }

    return $maxgid;
}


=head2 is_gid_free

SYNOPSIS

is_gid_free ( I<$gid> )

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

    return $entry;
}

=head2 is_gidnumber_free

SYNOPSIS

is_gidnumber_free ( I<$gidNumber> )

DESCRIPTION

Check if supplied gidNumber is available.

RETURN VALUE

Returns the directory entry from the corresponding gidNumber
if available, which is undef if there is no entry.

BUGS

The logic here is backwards.  Returns data if gidNumber IS NOT free
(true); returns undef (false) if the number IS free.

=cut

sub is_gidnumber_free
{
    my ($gidnumber) = @_;

    my ($filter);

    $filter = "(&(objectclass=posixGroup)(gidnumber=$gidnumber)";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("objectclass", "gidnumber"));

    return $entry;
}

=head2 list_groups

SYNOPSIS

list_groups ( I<$ou_filter> )

DESCRIPTION

Lists groups with DN, CN, and gidNumber.

RETURN VALUE

Returns an array of references to hashes, where each hash
has keys 'dn', 'cn' and 'gidnumber'.

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
        ("cn", "gidnumber"));

    $i = 0;
    while ($entry) {
        my (%group);

        $group{dn} = $entry->getDN (),
        $group{cn} = $entry->{cn}[0],
        $group{gidnumber} = $entry->{gidnumber}[0];
        $groups[$i++] = \%group;

        $entry = $conn->nextEntry ();
    }

    return @groups;
}

=head2 list_groups_by_gid

SYNOPSIS

list_groups_by_gid ( I<$ou_filter> )

DESCRIPTION

Lists CNs of groups indexed by gidNumber.

RETURN VALUE

Returns a reference to a hash containing the CNs of the
groups, keyed by gidNumber.

BUGS

The I<$ou_filter> is not implemented.

=cut

sub list_groups_by_gid
{
    # do not filter OU yet
    # should display the OU for each entry
    my ($ou_filter) = @_;

    my ($filter, $entry, $i);
    my (%groups);

    $filter = "(objectclass=posixGroup)";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("cn", "gidnumber"));

    while ($entry) {
        $groups{$gidnumber} = $entry->{'cn'}[0];
        $entry = $conn->nextEntry ();
    }

    return \%groups;
}

=head2 find_gid

SYNOPSIS

find_gid ( I<$gidNumber> )

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

    $filter = "(&(objectclass=posixGroup)(gidnumber=$gid))";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("cn", "gidnumber"));

    if ($entry) {
        return $entry->{'cn'}[0];
    }
    else {
        return -1 ;
    }
}

=head2 find_next_gid

SYNOPSIS

find_next_gid ( [I<$minGid>] )

DESCRIPTION

Finds the next available gidNumber, starting at I<minGid>.

RETURN VALUE

Returns the next available GID or -1 if an available GID isn't found.

BUGS

Calls &is_gidnumber_free() repeatedly, which can cause lots of
queries to server.  Fix by doing a single query and examining
results.

=cut

sub find_next_gid
{

	my ($minGid) = @_ ;

	$minGid = 0 unless $minGid ;

	for ( $i = $minGid; not &is_gidnumber_free($i); $i++ ) { 
		if ( $i > $config->{'max_gid'} ) {
			$i = -1 ;
			last ;
		}
	}

	return $i ;
}


=head2 create_group

SYNOPSIS

create_group( I<\%group> )

DESCRIPTION

Creates a group in the LDAP tree based on keys in the
aliased hash I<\%group>.  


REQUIRED HASH KEYS: 

=over 

=item * I<groupName> The name of the group.

=back


OPTIONAL HASH KEYS:


=over

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

Returns an array containing, in the case of success, the
gidNumber used (1-element array).

In the case of an LDAP error, returns a 2-element array of -1 and
a formatted error string.

In the case of a system error, returns a 2-element array of -1 and
a formatted error string.

=cut

sub create_group {

	my ($group) = @_ ;

	if ( $group->{'gidNumber'} ) {
		unless (&is_gidnumber_free($group->{'gidNumber'})) {
			return [ -1, $text{'gidnumber_is_taken'} ] ;
		}
	} else {
		if ($group->{'systemUser'}) {
			$min_gid = 0 ;
		} else {
			$min_gid = $config->{'min_gid'} ;
		}

		$group->{'gidNumber'} = &find_next_gid($config->{'min_gid'}); 

		if ( $group->{'gidNumber'} == -1 ) {
			return [ -1, $text{'err_no_free_gid'} ] ;
		}
	}

	$entry = $conn->newEntry() ;
	$dn = "gid=" . $group->{'groupName'} . "ou=Groups," . $config{'base'} ;
	$entry->setDN($dn) ;

	$entry->{'objectClass'} = [ "posixGroup", "top" ];
	$entry->{'cn'} = [$group->{'groupName'}] ;
	$entry->{'gidNumber'} = [$group->{'gidNumber'}] ;

	if ( $group->{'memberUid'} ) {
		$entry->{'memberUid'} = [$group->{'memberUid'}] ;
	}

	if ( $group->{'description'} ) {
		$entry->{'description'} = [$group->{'description'}] ;
	}

	if ($group->{'userPassword'}) {
		$entry->{'userPassword'} = [$group->{'userPassword'}] ;
	} else {
		$entry->{'userPassword'} = ['{crypt}x'] ;
	}

	$conn->add($entry) ;
	if ($err = $conn->getErrorCode()) {
		return [ -1, "group add ($dn): $err " . $conn->getErrorString()] ;
	} else {
		return [$entry{'gidNumber'}] ;
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
