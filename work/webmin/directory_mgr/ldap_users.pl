#!/usr/bin/perl
#
# LDAP Users Admin
# ldap-users.pl $Revision$ $Date$ $Author$
# by Fernando Lozano <fernando@lozano.eti.br> under the GNU GPL (www.gnu.org)
#

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

Returns an array of users.

BUGS

Probably should return a reference to an array, since the array will
be quite large on installations with many users.  Does not actually
filter on OU.  Does no actually sort entries.  Should modify filter
string instead of skipping entries when 'hide_system_users' is set.

=cut

sub list_users
{
    # do not filter OU yet
    # should display the OU for each entry
    my ($ou_filter, $sort_by) = @_;

    my ($filter, $entry, $i);
    my (@users);

    $filter = "(objectclass=posixAccount)";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("uid", "uidNumber", "gidNumber", "cn", "title", "organizationname",
        "department", "physicalofficedelyveryname"));

    $i = 0;
    while ($entry) {
        my (%user);

        # This could be done better by changing the filter
        # string
        if ($config{'hide_system_users'} && 
            ($config{'min_uid'} > $entry->{'uidNumber'}[0])) {
            $entry = $conn->nextEntry ();
            next ;
        }

        $user{'dn'} = $entry->getDN() ;
        $user{'uid'} = $entry->{'uid'}[0] ;
        $user{'uidNumber'} = $entry->{'uidNumber'}[0];
        $user{'gidNumber'} = $entry->{'gidNumber'}[0];
        $user{'cn'} = $entry->{'cn'}[0];
        $user{'title'} = $entry->{'title'}[0];
        $user{'organizationname'} = $entry->{'organizationname'}[0];
        $user{'department'} = $entry->{'department'}[0];
        $user{'physicaldeliveryofficename'} = $entry->{'physicaldeliveryofficename'}[0];
        $users[$i++] = \%user;

        $entry = $conn->nextEntry ();
    }

    return @users;
}

=head2 get_user_attr

SYNOPSIS

C<get_user_attr ( I<$dn> )>

DESCRIPTION

Retrieves a user object given a distinguished name.

RETURN VALUE

Returns a reference to an LDAP entry hash.

BUGS

None known.

=cut

sub get_user_attr
{
    my ($dn) = @_;

    my ($entry);

    $entry = $conn->browse ($dn);
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

sub is_uid_free
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
in I<@attr_array>.  The hash values are themselves arrays, since
LDAP can have multi-valued attributes.  On error, returns an array
with -1 as the first element, the LDAP error code as the second,
and the LDAP error string as the third.

NOTES

Other directory implementations should take note of the fact that
the attributes are themselves an array.

BUGS

None known.

=cut

sub search_users_attr
{

    my ($attrfilter, @desired_attrs) = @_ ;
    
    my $filter = "(&(objectClass=*)($attrfilter))" ;
    my (@users, $i) ;

    $entry = $conn->search ($config{'base'}, "subtree",
        $filter , 0, @desired_attrs) ;

    if ($err = $conn->getErrorCode()) {
        return [ -1, $err, $conn->getErrorString() ] ;
    }

    $i = 0 ;
    while ($entry) {
        my (%user) ;

        for $attr (@desired_attrs) {
            if ($attr =~ /^dn$/i) {
                $user{$attr} = [$entry->getDN()] ;
            } else {
                $user{$attr} = $entry->{$attr} ;
            }
        }

        $users[$i++] = \%user ;
        $entry = $conn->nextEntry() ;

    }

    return \@users ;

}

=head2 find_free_uid

SYNOPSIS

C<find_free_uid ( I<$minUid>, I<$maxUid> )>

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

sub find_free_uid
{   
    
    my ($minUid, $maxUid) = @_ ;

    $minUid = 0 unless $minUid ;
    $maxUid = $config{'max_uid'} unless $maxUid ;

    my $free_uid = -1 ;

    while ($minUid <= $maxUid) {
        if (&is_uidNumber_free($minUid)) {
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

Logic reversed: Returns false (undef) if the entry is not
found; true (reference to entry hash) if it is found.

BUGS

Return value logic backwards.

=cut

sub is_mail_free
{
    my ($mail) = @_;

    my ($filter);

    $filter = "(&(objectclass=posixAccount)(mail=$mail)";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("mail"));

    return $entry;
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

sub create_user
{
    my ($user) = @_ ;
    my ($entry, $dn, $err);

    $entry = $conn->newEntry ();
    $dn = "uid=" . $user->{'uid'} . ",ou=People," . $config{'base'};
    $entry->setDN ($dn);

    # Set add object classes
    $entry->{'objectclass'} = ["posixAccount", "person", "inetOrgPerson",
        "organizationalPerson", "account", "top" ];

    # Create empty fields
    if ($user->{'cn'}) {
        $entry->{'cn'} = [$user->{'cn'}] ;
    } else {
        $entry->{'cn'} = ["$user->{'givenname'} $user->{'surname'}"] ;
    }

    if ($user->{'gecos'}) {
        $entry{'gecos'} = [$user->{'gecos'}] ;
    } else {
        $entry{'gecos'} = ["$user->{'givenname'} $user->{'sn'}"] ;
    }
    
    if ($user->{'mail'}) {
        $entry{'mail'} = [$user->{'mail'}] ;    
    } else {
        $entry{'mail'} = [$uid . "@" . $config{'maildomain'}] ;
    }

    # This should be more automatic, like in the useradmin module
    if ($user->{'homedirectory'}) {
        $entry{'homedirectory'} = [$user->{'homedirectory'}] ;
    } else {
        $entry{'homedirectory'} = [$config{'homes'} . "/$uid"] ;
    }
    # posixAccount
    $entry->{'uid'} = [$user->{'uid'}];
    $entry->{'uidNumber'} = [$user->{'uidNumber'}];
    $entry->{'gidNumber'} = [$user->{'gidNumber'}];
    $entry->{'homedirectory'} = [$user->{'homedirectory'}];
    $entry->{'loginshell'} = [$user->{'loginshell'}];
    $entry->{'sn'} = [$user->{'sn'}];

    if ($config{'outlook'}) {
        $entry->{'givenname'} = [$user->{'givenname'}];
        $entry->{'title'} = [$user->{'title'}];
        $entry->{'organizationname'} = [$user->{'organizationname'}];
        $entry->{'department'} = [$user->{'department'}];
        $entry->{'physicaldeliveryofficename'} = [$user->{'physicaldeliveryofficename'}];
        $entry->{'telephonenumber'} = [$user->{'telephonenumber'}];
        $entry->{'mobile'} = [$user->{'mobile'}];
        $entry->{'pager'} = [$user->{'pager'}];
        $entry->{'officefax'} = [$user->{'officefax'}];
        $entry->{'comment'} = [$user->{'comment'}];
    }

    if ($config{'shadow'}) {
        $entry->addValue("objectclass", "shadowAccount") ;
        # Need to add shadow attributes
    }

    if ($config{'kerberos'}) { 
        $entry->addValue("objectclass", "kerberosSecurityObject") ;
        # Need to add Kerberos attributes
    }

    $entry->{'userpassword'} = ["*"];
    $conn->add ($entry);
    if ($err = $conn->getErrorCode ()) {
        return [ -1, "user add ($dn): $err: " . $conn->getErrorString () ];
    } else {
        return [ $entry->{'uidNumber'}, $dn ] ;
    }
}

=head2 update_user

SYNOPSIS

C<update_user ( I<$dn> )>

DESCRIPTION

Updates a directory entry based on a user hash.  Selects the
directory entry for the passed-in distinguised name and copies
attributes from user hash into it, and commits back to
directory.

RETURN VALUE

None.

BUGS

Doesn't work: Uses global user hash, which no longer exists.
Doesn't return error codes; instead, calls &error()
directly.  Does not allow for DN/uid changes.

=cut

sub update_user
{
    my ($dn) = @_;

    my ($entry);

    # assume the uid (or the DN) was not changed
    $entry = $conn->browse ($dn);
    if ($err = $conn->getErrorCode ()) {
        &error ("browse ($dn): $err:" . $conn->getErrorString ());
    }
    &entry_from_user ($entry);
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

None.

BUGS

Doesn't return error status; instead, calls &error()
directory.

=cut

sub delete_user
{
    my ($dn) = @_;

    $conn->delete ($dn);
    if ($err = $conn->getErrorCode ()) {
        &error ("update ($dn): $err:" . $conn->getErrorString ());
    }
}

=head2 set_passwd

SYNOPSIS

C<set_passwd ( I<$dn>, I<$password>, I<$password_type>)>

DESCRIPTION

Updates users' password.

BUGS

Not tested; might not work.  Doesn't return error status; instead,
calls &error() directly.

=cut

sub set_passwd
{
    my ($dn, $passwd, $type) = @_;

    my ($entry, $salt, $ctx);

    $entry = $conn->browse ($dn);
    if ($err = $conn->getErrorCode ()) {
        &error ("set_passwd ($dn): $err:" . $conn->getErrorString ());
    }
    if ($type eq "crypt") {
        $salt = join '', ('.', '/', 0..9, 'A'..'Z', 'a'..'z')
            [rand 64, rand 64];
        $passwd = "{CRYPT}" . crypt ($passwd, $salt);
    } elsif ($type eq "md5") {
        $ctx = Digest::MD5->new;
           $ctx->add ($passwd);
        $passwd = "{MD5}" . encode_base64 ($ctx->digest, "");
    } elsif ($type eq "sha") {
        
    }
    $entry->{'userpassword'} = [$passwd];
    $conn->update ($entry);
    if ($err = $conn->getErrorCode ()) {
        &error ("update ($dn): $err:" . $conn->getErrorString ());
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
