#!/usr/bin/perl

#
# LDAP Users Admin
# users.pl $Revision$ $Date$ $Author$
#

# have a lot of global variables for user attributes

=head1 NAME

users.pl

=head1 DESCRIPTION

users.pl contains directory-agnostic subroutines for
managing users.

=head1 FUNCTIONS

=cut

=head2 new_user_ok

SYNOPSIS

new_user_ok ( \%user )

DESCRIPTION

Checks if the supplied user hash has minimum required
attributes.

RETURN VALUE

Returns true if the supplied hash passes.

=cut

sub new_user_ok
{
	my ($user) = @_ ;
    return
        $user->{'loginshell'} &&
		$user->{'gidnumber'} &&
        $user->{'givenname'} &&
        $user->{'sn'} ;
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

=head2 user_from_form

SYNOPSIS 

user_from_form ( \%in )

DESCRIPTION

Takes a CGI input hash and copies user-relevant information
into a user has.

RETURN VALUE

Returns a reference to a hash containing user attributes.

=cut

sub user_from_form
{
    my ($in) = @_;
	my (%user) ;

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



1;

