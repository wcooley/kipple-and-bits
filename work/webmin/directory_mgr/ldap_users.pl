#!/usr/bin/perl
#
# LDAP Users Admin
# ldap-users.pl $Revision$ $Date$ $Author$
# by Fernando Lozano <fernando@lozano.eti.br> under the GNU GPL (www.gnu.org)
#

sub list_users
{
    # do not filter OU yet
    # should display the OU for each entry
    my ($ou_filter, $sort_by) = @_;

    my ($filter, $entry, $i);
    my (@users);

    $filter = "(objectclass=posixAccount)";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("uid", "uidnumber", "gidnumber", "cn", "title", "organizationname",
        "department", "physicalofficedelyveryname"));

    $i = 0;
    while ($entry) {
        my (%user);

        # This could be done better by changing the filter
        # string
        if ($config{'hide_system_users'} && 
            ($config{'min_uid'} > $entry->{'uidnumber'}[0])) {
            $entry = $conn->nextEntry ();
            next ;
        }

        $user{'dn'} = $entry->getDN() ;
        $user{'uid'} = $entry->{'uid'}[0] ;
        $user{'uidnumber'} = $entry->{'uidnumber'}[0];
        $user{'gidnumber'} = $entry->{'gidnumber'}[0];
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


sub get_user_attr
{
    my ($dn) = @_;

    my ($entry);

    $entry = $conn->browse ($dn);
    return $entry;
}


sub max_uidnumber
{
    my ($filter, $maxuid, $u);

    # ldap should have a way to find this...
    $filter = "(objectclass=posixAccount)";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("uidnumber"));

    $maxuid = 0;
    while ($entry) {
        $u = $entry->{'uidnumber'}[0];
    # skip user "nobody"...
    if ($u != 65534) {
            $maxuid = ($u > $maxuid) ? $u : $maxuid;
    }
        $entry = $conn->nextEntry ();
    }

    return $maxuid;
}


sub is_uid_free
{
    my ($uid) = @_;

    my ($filter);

    $filter = "(&(objectclass=posixAccount)(uid=$uid)";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("objectclass", "uid"));

    return $entry;
}


sub is_uidnumber_free
{
    my ($uidnumber) = @_;

    my ($filter);

    $filter = "(&(objectclass=posixAccount)(uidnumber=$uidnumber)";
    $entry = $conn->search ($config{'base'}, "subtree", $filter, 0,
        ("objectclass", "uidnumber"));

    return $entry;
}


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

create_user ( \%user )

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
    $entry->{'uidnumber'} = [$user->{'uidnumber'}];
    $entry->{'gidnumber'} = [$user->{'gidnumber'}];
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


sub delete_user
{
    my ($dn) = @_;

    $conn->delete ($dn);
    if ($err = $conn->getErrorCode ()) {
        &error ("update ($dn): $err:" . $conn->getErrorString ());
    }
}


sub set_passwd
{
    my ($dn, $passwd, $type) = @_;

    my ($entry, $salt, $ctx);

    $entry = $conn->browse ($dn);
    if ($err = $conn->getErrorCode ()) {
        &error ("update ($dn): $err:" . $conn->getErrorString ());
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
