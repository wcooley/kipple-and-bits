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

        $user{'dn'} = $entry->getDN (),
        $user{'uid'} = $entry->{'uid'}[0],
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


sub create_user
{
    my ($entry, $dn, $err);

    $entry = $conn->newEntry ();
    $dn = "uid=$uid,ou=People," . $config{'base'};
    $entry->setDN ($dn);

	# Set add object classes
    $entry->{'objectclass'} = ["posixAccount", "person", "inetOrgPerson",
        "organizationalPerson", "account", "top" ];
	$config{'kerberos'} and
		$entry->addValue("objectclass", "kerberosSecurityObject") ;
	$config{'shadow'} and
		$entry->addValue("objectclass", "shadowAccount") ;

	# Create CN if blank
	if (not $in{'cn'}) {
		$in{'cn'} = "$in{'givenname'} $in{'surname'}" ;
	}
    &entry_from_user ($entry);;
    $entry->{'userpassword'} = ["teste"];
    $conn->add ($entry);
    if ($err = $conn->getErrorCode ()) {
        &error ("add ($dn): $err:" . $conn->getErrorString ());
    }
    return $dn;
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
    }
    elsif ($type eq "md5") {
        &error ("Cannot use MD5 passwords yet.");
        #$ctx = Digest::MD5->new;
        #$ctx->add ($passwd);
        #$passwd = "{MD5}" . encode_base64 ($ctx->digest, "");
    }
    $entry->{'userpassword'} = [$passwd];
    $conn->update ($entry);
    if ($err = $conn->getErrorCode ()) {
        &error ("update ($dn): $err:" . $conn->getErrorString ());
    }
}

1;
