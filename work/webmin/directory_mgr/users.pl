#!/usr/bin/perl

#
# LDAP Users Admin
# users.pl $Revision$ $Date$ $Author$
# by Fernando Lozano <fernando@lozano.eti.br> under the GNU GPL (www.gnu.org)
#

# have a lot of global variables for user attributes


sub new_user_ok
{
    return
        $loginshell &&
        $givenname &&
        $sn;
}


sub changed_user_ok
{
    return
        $uid &&
        $uidnumber &&
        $gidnumber &&
        $homedirectory &&
        $loginshell &&
        $givenname &&
        $sn;
}


sub user_from_form
{
    my ($in) = @_;

    # posixAccount
    $user{'uid'} = $in->{'uid'};
    $user{'uidnumber'} = $in->{'uidnumber'};
    #$user{'gidnumber'} = $in->{'gidnumber'};
    $user{'gecos'} = $in->{'gecos'};
    $user{'homedirectory'} = $in->{'homedirectory'};
    $user{'loginshell'} = $in->{'loginshell'};

    # address book data
    $user{'cn'} = $in->{'cn'};
    $user{'sn'} = $in->{'sn'};
    $user{'givenname'} = $in->{'givenname'};
    $user{'title'} = $in->{'title'};
    $user{'organizationname'} = $in->{'organizationname'};
    $user{'department'} = $in->{'department'};
    $user{'physicaldeliveryofficename'} = $in->{'physicaldeliveryofficename'};
    $user{'mail'} = $in->{'mail'};
    $user{'telephonenumber'} = $in->{'telephonenumber'};
    $user{'mobile'} = $in->{'mobile'};
    $user{'pager'} = $in->{'pager'};
    $user{'officefax'} = $in->{'officefax'};
    $user{'comment'} = $in->{'comment'};
    $user{'userpassword'} = $in->{'userpassword'};

    # generate empty fields
    $user{'gecos'} = "$givenname $sn" unless $gecos;
    $user{'cn'} = "$givenname $sn" unless $cn;
    $user{'mail'} = "$uid@" . $config{'maildomain'} unless $mail;
    $user{'homedirectory'} = $config{'homes'} . "/$uid" unless $homedirectory;
    $user{'userpassword'} = $uid unless $userpassword;
    #$userpassword = &generate_passwd ($userpassword);

	return \%user ;
}


sub user_from_entry
{
    my ($user) = @_;

    # posixAccount
    $uid = $user->{'uid'}[0];
    $uidnumber = $user->{'uidnumber'}[0];
    $gidnumber = $user->{'gidnumber'}[0];
    $gecos = $user->{'gecos'}[0];
    $homedirectory = $user->{'homedirectory'}[0];
    $loginshell = $user->{'loginshell'}[0];

    #shadowAccount
    #$shadowexpire
    #$shadowflag
    #$shadowinactive
    #$shadowlastchange
    #$shadowmax
    #$shadowwarning

    #inetOrgPerson
    #top
    #kerberosSecurityObject
    #organizationalPerson
    #person
    #account

    #don't know
    $cn = $user->{'cn'}[0];
    $sn = $user->{'sn'}[0];
    $givenname = $user->{'givenname'}[0];
    $userpassword = $user->{'userpassword'}[0];
    #$krbname

    #OutlookExpress
    #$co
    $comment = $user->{'comment'}[0];
    $department = $user->{'department'}[0];
    #$homephone
    #$homepostaladdress
    #$initials
    #$ipphone
    #$l
    $mail = $user->{'mail'}[0];
    #$manager
    $mobile = $user->{'mobile'}[0];
    $officefax = $user->{'officefax'}[0];
    $organizationname = $user->{'organizationname'}[0];
    #$otherfacsimiletelephonenumber
    $pager = $user->{'pager'}[0];
    $physicaldeliveryofficename = $user->{'physicaldeliveryofficename'}[0];
    #$postaladdress
    #$postalcode
    #$reports
    #$st
    $telephonenumber = $user->{'telephonenumber'}[0];
    $title = $user->{'title'}[0];
    #$url
}


sub user_defaults
{
    $uidnumber = &max_uidnumber() + 1;
    # should get these defaults fron %config or from a template
    $gidnumber = $config{'gid'};
    $loginshell = $config{'shell'};
}


sub entry_from_user
{
    my ($entry) = @_;

    # posixAccount
    $entry->{'uid'} = [$uid];
    $entry->{'uidnumber'} = [$uidnumber];
    $entry->{'gidnumber'} = [$gidnumber];
    $entry->{'gecos'} = [$gecos];
    $entry->{'homedirectory'} = [$homedirectory];
    $entry->{'loginshell'} = [$loginshell];

    # address book data
    # should identify the correct objectClass for each attribute and configure this way

    $entry->{'sn'} = [$sn];
    $entry->{'cn'} = [$cn];
    $entry->{'mail'} = [$mail];

    if ($config{'outlook'} eq "1") {
        $entry->{'givenname'} = [$givenname];
        $entry->{'title'} = [$title];
        $entry->{'organizationname'} = [$organizationname];
        $entry->{'department'} = [$department];
        $entry->{'physicaldeliveryofficename'} = [$physicaldeliveryofficename];
        $entry->{'telephonenumber'} = [$telephonenumber];
        $entry->{'mobile'} = [$mobile];
        $entry->{'pager'} = [$pager];
        $entry->{'officefax'} = [$officefax];
        $entry->{'comment'} = [$comment];
    }

	if ($config{'shadow'}) {
	}

	if ($config{'kerberos'}) {
	}
    
    return $entry;
}

1;
