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

    if ($in->{'homedirectory'} eq "") {
        $user{'homedirectory'} = $config{'homes'} .  $user{'uid'} ;
    } else {
        $user{'homedirectory'} = $in->{'homedirectory'};
    }
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

=head2 create_home_dir

SYNOPSIS 

create_home_dir ( $user, $host )

DESCRIPTION

Creates a home directory for $user on (possibly remote) $host.
Remote hosts have to have the 'create_homedir' module installed.

RETURN VALUE

Returns true. ;(

BUGS

Should return something more intresting than true.  Should eval()
remote_foreign_* calls and check exceptions.

=cut


# Creates a home directory
sub create_home_dir {
    local ($user, $host) = @_ ;

    $loghash{'user'} = $user ;
    $loghash{'host'} = $host ;

    $debug && &webmin_log ('call', 'sub', 'create_home_dir');


    # localhost is special -- it creates the home directory
    # locally, so we use 'foreign_*' subs, instead of 'remote_foreign_*'.
    if ($host eq "localhost") {

        $debug && &webmin_log ('call', 'sub', 'make_home_local') ;

        $loghash{'make_home_local'} = &make_home_local($user) ;

    } else {
        # Create the remote directory, by calling itself on
        # the remote host
        $debug && &webmin_log ('call', 'sub', 'remote_foreign_check') ;
        &remote_foreign_check("$host", 'create_homedir') ||
            &error(&text('err_remote_foreign_check', 'create_homedir', $host)) ;

        $debug && &webmin_log ('call', 'sub', 'remote_foreign_require');
        &remote_foreign_require("$host", 'create_homedir',
            'create_home_dir.pl')
            # Jamie says this shouldn't work
            #  ||
            # &error(&text('err_remote_foreign_require', 'create_homedir',
            #   'create_home_dir.pl', $host)) ;

        $debug && &webmin_log ('call', 'sub', 'remote_foreign_call') ;
        $loghash{'make_home_local'} = &remote_foreign_call("$host",
            'create_homedir', 'make_home_local', $user) ;

        $debug && &webmin_log ('call', 'sub', 'remote_finished') ;
        &remote_finished() ;

    }

    &webmin_log('create', 'homedir', '', \%loghash) ;

    $loghash{'make_home_local'} eq "ok" ||
        &error(&text('err_create_dir', "$loghash{'make_home_local'}")) ;

    return 1;

}


=head1 NOTES

None at the moment.

=cut

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

