#!/usr/bin/perl
#
# LDAP Users Admin
# ldap-users.pl $Revision$ $Date$ $Author$
# by Fernando Lozano <fernando@lozano.eti.br> under the GNU GPL (www.gnu.org)
#

use strict ;
no strict "vars" ;

use diagnostics ;

=head1 NAME

ldap_users.pl

=head1 DESCRIPTION

ldap_users.pl contains directory-specific subroutines for
managing users.

=head1 FUNCTIONS

=cut

=head2 list_users

SYNOPSIS

C<list_users ( I<$ou_filter>, I<$sort_by> )>

DESCRIPTION

Searches for user accounts and extracts relevant
attributes.

RETURN VALUE

Returns a refernce to an array of users.

BUGS

Does not actually filter on OU.  Does no actually sort entries.
Should modify filter string instead of skipping entries when
'hide_system_users' is set.

=cut

sub list_users (:$$)
{
    # do not filter OU yet
    # should display the OU for each entry
    my ($ou_filter, $sort_by) = @_;

    my ($filter, $entry, $i);
    my (@users);

    $filter = "(objectclass=posixAccount)";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("uid", "uidNumber", "gidNumber", "cn", "telephoneNumber" ));

    $i = 0;
    while ($entry) {
        my (%user);

        # This could be done better by changing the filter
        # string (except OpenLDAP doesn't support <= or >=
        # :(
        if ($config{'hide_system_users'} && 
            ($config{'min_uid'} > $entry->{'uidNumber'}[0])) {
            $entry = $conn->nextEntry ();
            next ;
        }

        $user{'dn'} = $entry->getDN() ;
        $user{'userName'} = $entry->{'uid'}[0] ;
        $user{'userID'} = $entry->{'uidNumber'}[0];
        $user{'groupID'} = $entry->{'gidNumber'}[0];
        $user{'fullName'} = $entry->{'cn'}[0];
        $user{'telephoneNumber'} = $entry->{'telephoneNumber'};
        $users[$i++] = \%user;

        $entry = $conn->nextEntry ();
    }

    return \@users;
}

=head2 get_user_attr

SYNOPSIS

C<get_user_attr ( I<$dn> )>

DESCRIPTION

Retrieves a user object given a distinguished name.

RETURN VALUE

Returns a reference to an LDAP user hash.

BUGS

None known.

=cut

sub get_user_attr ($)
{
    my ($dn) = @_;

    my ($entry);

    $entry = $conn->browse ($dn);
    $entry->{'dn'} = [$entry->getDN()] ;
    return $entry;
}

=head2 id_uid_free

SYNOPSIS

C<is_uid_free ( I<$uid> )>

DESCRIPTION

Searches the directory for the given username.

RETURN VALUE

Logic reversed: Returns false (undef) if the uid is not found, true
(entry) if the uid is found.

BUGS

Return value logic backwards.

=cut

sub is_uid_free ($)
{
    my ($uid) = @_;

    my ($filter);

    $filter = "(&(objectclass=posixAccount)(uid=$uid)";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("objectclass", "uid"));

    return $entry;
}

=head2 search_users_attr

SYNOPSIS

C<search_users_attr ( I<$attr_string>, I<@attr_array> )>

DESCRIPTION

Searches user objects for matching attribute.  Uses I<@attr_array>
to limit attributes returned.

RETURN VALUE

Returns reference to an array of hashes with the attributes requested
in I<@attr_array>.  The hash values are themselves arrays, since LDAP
can have multi-valued attributes.  On error, returns an array with
-1 as the first element and a formatted error string as the third.

NOTES

Other directory implementations should take note of the fact that
the attributes are themselves an array.

BUGS

None known.

=cut

sub search_users_attr ($@)
{

    my ($attrfilter, @desired_attrs) = @_ ;
    
    my $filter = "(&(objectClass=posixAccount)($attrfilter))" ;
    my (@users, $i) ;

    $entry = $conn->search ($config{'base'}, "subtree",
        $filter , 0, @desired_attrs) ;

    if ($err = $conn->getErrorCode()) {
        return [ -1, "$err: " . $conn->getErrorString() ] ;
    }

    $i = 0 ;
    while ($entry) {
        my (%user) ;

        for $attr (@desired_attrs) {
            if ($attr eq "dn") {
                $user{'dn'} = [$entry->getDN()] ;
            } else {
                $user{$attr} = $entry->{$attr} ;
            }
        }

        $users[$i++] = \%user ;
        $entry = $conn->nextEntry() ;

    }

    return \@users ;

}


=head2 search_users 

SYNOPSIS

C<function ( I<$search_key>, I<$search_value> )>

DESCRIPTION

This function searches for users with the attribute given in the
I<$search_key> matching I<$search_value>.

RETURN VALUE

Returns a reference to an array of users or the return value of
search_users_attr.

BUGS

None known.

NOTES

None.

=cut

sub search_users ($$) {

    my ($search_key, $search_string) = @_ ;

    my @attrs = qw( uid uidNumber 
        gidNumber cn dn telephoneNumber homeDirectory hosts
        description shell sn givenName) ;
    my (@users, $entries) ;

    if ($search_key eq "userName") {
        $search = "uid=" . $search_string ;
    } elsif ($search_key eq "userID") {
        $search = "uidNumber=" . $search_string ;
    } elsif ($search_key eq "fullName") {
        $search = "cn=" . $search_string ;
    } elsif ($search_key eq "surName") {
        $search = "sn=" . $search_string ;
    } elsif ($search_key eq "firstName") {
        $search = "givenName=" . $search_string ;
    } elsif ($search_key eq "groupID") {
        $search = "gidNumber=" . $search_string ;
    } else {
        return [ -1, &text('err_unknown_user_attr', $search_key) ] ;
    }

    $entries = &search_users_attr ($search,@attrs) ;

    if ( $entries->[0] == -1 ) {
        return $entries ;
    } else {
        foreach $entry (@{$entries}) {
            push @users, &user_from_entry($entry) ;
        }
    }
        

    return \@users ;

}

=head2 find_free_userid

SYNOPSIS

C<find_free_userid ( I<$minUid>, I<$maxUid> )>

DESCRIPTION

Finds the next available uidNumber, starting at I<minUid> but not
going over I<maxUid>.

RETURN VALUE

Returns the next available UID or -1 if an available UID isn't found.

BUGS

Calls &is_uidNumber_free() repeatedly, which can cause lots of
queries to server.  Fix by doing a single query and examining
results.

=cut

sub find_free_userid ($:$)
{   
    
    my ($minUid, $maxUid) = @_ ;

    $minUid = 0 unless $minUid ;
    $maxUid = $config{'max_uid'} unless $maxUid ;

    my $free_uid = -1 ;

    while ($minUid <= $maxUid) {
        if ( &is_uidNumber_free($minUid)) {
            $free_uid = $minUid ;
            last ;
        }
        $minUid++ ;
    }

    return $free_uid ;
}

=head2 is_mail_free

SYNOPSIS

C<is_mail_free ( I<$mail> )>

DESCRIPTION

Searches the directory for the supplied e-mail address to
verify that it is not yet in use.

RETURN VALUE

Returns true if the e-mail address is free; false if it
isn't.

=cut

sub is_mail_free ($)
{
    my ($mail) = @_;

    if ( &search_user_attr("mail=$mail", ("mail")) ) {
        return 0 ;
    } else {
        return 1 ;
    }

}

=head2 create_user

SYNOPSIS

C<create_user ( \%user )>

DESCRIPTION

Creates a user in the LDAP directory based on attributes in
user hash.

RETURN VALUE

Returns an array containing, in the case of success, the
uidNumber and DN of the user (2-element array).

In the case of failure, returns a 2-element array of -1 and
a formatted error string.

BUGS

OU for users is not configurable.  Attributes for Kerberos and
posixShadow accounts are not implemented.

=cut

sub create_user ($)
{
    my ($user) = @_ ;
    my ($entry, $dn, $err);

    $entry = $conn->newEntry ();
    $dn = "uid=" . $user->{'uid'} . ",ou=People," . $config{'base'};
    $entry->setDN ($dn);
    
    $entry = &entry_from_user($entry, $user) ;
    
    $conn->add ($entry);
    if ($err = $conn->getErrorCode ()) {
        return [ -1, "user add ($dn): $err: " . $conn->getErrorString () ];
    } else {
        return [ $entry->{'uidNumber'}, $dn ] ;
    }
}

=head2 update_user

SYNOPSIS

C<update_user ( I<$dn>, I<\%user> )>

DESCRIPTION

Updates a directory entry based on a user hash.  Selects the
directory entry for the passed-in distinguised name and copies
attributes from user hash into it, and commits back to
directory.

RETURN VALUE

None.

BUGS

Doesn't return error codes; instead, calls &error()
directly.  Does not allow for DN/uid changes.

=cut

sub update_user ($$)
{
    my ($dn, $user) = @_;

    my ($entry);

    # Make a copy of this so we don't lose it
    $user->{'modSecondaryGroups'} = $user->{'secondaryGroups'} ;

    # assume the uid (or the DN) was not changed
    $entry = $conn->browse ($dn);
    if ($err = $conn->getErrorCode ()) {
        &error ("browse ($dn): $err:" . $conn->getErrorString ());
    }
    $entry = &entry_from_user ($entry, $user);
    $conn->update ($entry);
    if ($err = $conn->getErrorCode ()) {
        &error ("update ($dn): $err:" . $conn->getErrorString ());
    }
}

=head2 delete_user

SYNOPSIS

C<delete_user ( I<$dn> )>

DESCRIPTION

Deletes a given distinguished name from the directory.

RETURN VALUE

Returns a two-element array; in the case of success, the
first element is 1 and the second the deleted DN.  In the
case of failure, -1 and a formatted error string.

=cut

sub delete_user ($)
{
    my ($dn) = @_;

    $conn->delete ($dn);
    if ($err = $conn->getErrorCode ()) {
        return [ -1, "delete ($dn): $err:" . $conn->getErrorString () ] ;
    } else {
        return [ 1, $dn ] ;
    }
}

=head2 set_passwd

SYNOPSIS

C<set_passwd ( I<\%user>, I<$type> )>

DESCRIPTION

Updates user's password.

BUGS

Not tested; might not work.  Doesn't return error status; instead,
calls &error() directly.

=cut

sub set_passwd ($$)
{
    my ($user, $type) = @_ ;

    my $salt = join '', ('.', '/', 0..9, 'A'..'Z', 'a'..'z') [rand 64, rand 64];
    my $tmppass ;

    if ($type eq "crypt") {
        $user->{'password'} = "{CRYPT}" . crypt ($user->{'password'}, $salt);
    } elsif ($type =~ "md5") {
        eval {
            require Digest::MD5 ;
        } ;
        if ($@) {
            return [ -1, "unable to load Digest::MD5 or MIME::Base64: $@" ] ;
        }

        my $md5 = Digest::MD5->new;
        $md5->add($user->{'password'});

        if ($type eq "md5") {
            $tmppass = encode_base64 ($md5->digest(), '');
            chomp($tmppass) ;
            $user->{'password'} = "{MD5}" . $tmppass ; 

        } elsif ($type eq "smd5") {
            $md5->add($salt) ;
            $tmppass = encode_base64 ($md5->digest() . $salt, '');
            chomp($tmppass) ;
            $user->{'password'} = "{SMD5}" . $tmppass ;

        } else {
            return [ -1, "unrecognized password hash type &quot;$type&quot;" ] ;
        }

    } elsif ($type =~ "sha") {
        eval {
            require Digest::SHA1 ;
        } ;
        if ($@) {
            return [ -1, "unable to load Digest::SHA1 or MIME::Base64: $@" ] ;
        }

        my $sha = Digest::SHA1->new ;
        $sha->add($user->{'password'}) ;

        if ($type eq "sha") {
            $tmppass = encode_base64($sha->digest(), "") ;
            chomp ($tmppass) ;
            $user->{'password'} = "{SHA}" . $tmppass ;

        } elsif ($type eq "ssha") {
            $sha->add($salt) ;
            $tmppass = encode_base64 ($sha->digest() . $salt, "");
            chmod ($tmppass) ;
            $user->{'password'} = "{SSHA}" . $tmppass ;
        } else {
            return [ -1, "unrecognized password hash type &quot;$type&quot;" ] ;
        }

    } else {
        return [ -1, "unrecognized password hash type &quot;$type&quot;" ] ;
    }

    return [ 1, $user ] ;
}


=head2 function

SYNOPSIS

C<function ( I<param> )>

DESCRIPTION

description

RETURN VALUE

True

BUGS

None known.

NOTES

None.

=cut
sub user_set_sec_grps ($)
{

    my ($user) = @_ ;
    my ($found, $ret) ;

    # Handle secondary groups
    #  o Search for the groups with userName in memberUsername
    #  o Check if user has group in secondary groups
    #  o If not, remove user from group
    #  o Commit group

    print STDERR "Entering user_set_sec_grps\n" ;

    my $groups = &search_groups('memberUsername', $user->{'userName'}) ;

    if ( $groups->[0] == -1 ) {
        print STDERR "Error returned from search_groups\n" ;
        #&error("Error searching for $user->{'userName'}: $groups->[1]") ;
    } else {
        foreach $group (@{$groups}) {
            print STDERR "Checking group $group->{'groupName'}\n" ;
            $found = 0 ;
            foreach $secgroup (@{$user->{'modSecondaryGroups'}}) { 
                if ($secgroup eq $group->{'groupName'}) {
                    $found = 1 ;
                }
            }

            if ($found != 1) {
                # Create a new array w/o the old user
                @members = () ;
                print STDERR "Adding members to group $group->{'groupName'}:" ;
                foreach $memberUser (@{$group->{'memberUsername'}}) {
                    if ($memberUser ne $user->{'userName'}) {
                        push @members, $memberUser ;
                        print STDERR " o $memberUser " ;
                    } else {
                        print STDERR " x $memberUser " ;
                    }
                }
                $group->{'memberUsername'} = @members ;
                print STDERR "Calling update_group\n" ;
                $ret = &update_group($group->{'dn'}, $group) ;
                if ( $ret->[0] == -1 ) {
                    print STDERR "update_group error: $ret->[1]\n" ;
                } else {
                    print STDERR "update_group was successful\n" ;
                }
            }
        }
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
