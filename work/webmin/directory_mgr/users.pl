#!/usr/bin/perl

#
# LDAP Users Admin
# users.pl $Revision$ $Date$ $Author$
#

$debug = 0 ;

=head1 NAME

users.pl

=head1 DESCRIPTION

users.pl contains directory-agnostic subroutines for
managing users.

=head1 FUNCTIONS

=cut

=head2 new_user_ok

SYNOPSIS

C<new_user_ok ( I<\%user> )>

DESCRIPTION

Checks if the supplied user hash has minimum required
attributes.

RETURN VALUE

Returns true if the supplied hash passes.

BUGS

None known.

=cut

sub new_user_ok
{
	my ($user) = @_ ;
    return
        $user->{'loginshell'} &&
		$user->{'gidNumber'} &&
        $user->{'givenname'} &&
        $user->{'sn'} ;
}

=head2 changed_user_ok

SYNOPSIS

C<changed_user_ok ( I<\%user> )>

DESCRIPTION

Checks if the supplied user hash has acceptable attributes.

RETURN VALUE

Returns true if the supplied has passes verification; false
otherwise.

BUGS

None known.

=cut

sub changed_user_ok
{
    my ($user) = @_ ;
    return
        $user->{'uid'} &&
        $user->{'uidNumber'} &&
        $user->{'gidNumber'} &&
        $user->{'homedirectory'} &&
        $user->{'loginshell'} &&
        $user->{'givenname'} &&
        $user->{'sn'};
}

=head2 auto_home_dir

SYNOPSIS

C<auto_home_dir ( I<$username>, I<$homestyle> )>

DESCRIPTION

Creates a home directory path based on I<$homestyle>.

RETURN VALUE

Returns a string with the home directory path.

BUGS

Currently ignores I<$homestyle>.

=cut

sub auto_home_dir {

    my ($username, $homestyle) = @_ ;

    return $config{'homes'} . "/" . $username ;

}

=head2 is_uidNumber_free

SYNOPSIS

C<is_uidNumber_free ( I<$uidNumber> )>

DESCRIPTION

Check if supplied uidNumber is available.

RETURN VALUE

Returns true if the uidNumber is free; false if it isn't.

=cut

sub is_uidNumber_free
{
    my ($uidNumber) = @_;

    if ( &search_users_attr ("uidNumber=$uidNumber", ("uidNumber")) ) {
        return 0 ;
    } else {
        return 1 ;
    }

}                                                                        

=head2 user_from_form

SYNOPSIS 

C<user_from_form ( I<\%in> )>

DESCRIPTION

Takes a CGI input hash and copies user-relevant information
into a user hash.

RETURN VALUE

Returns a reference to a hash containing user attributes.

=cut

sub user_from_form
{
    my ($in) = @_;
	my (%user) ;

    $user{'firstName'} = &remove_whitespace($in->{'firstName'});
    $user{'surName'} = &remove_whitespace($in->{'surName'});
    # Need to make this an array

    for $telnum (split (',', $in->{'telephoneNumber'})) {
        push @{$user{'telephoneNumber'}}, &remove_whitespace($telnum) ;
    }

    # Comma-separated hosts
    for $host (split (',', $in->{'allowedHosts'})) {
        push @{$user{'allowedHosts'}}, &remove_whitespace($host) ;
    }

    if ($in->{'homedirectory'} eq "") {
        $user{'homedirectory'} = &auto_home_dir ($user{'userName'}) ;
    } else {
        $user{'homedirectory'} = &remove_whitespace($in->{'homedirectory'});
    }

    if ($in{'userID'} eq '') {
        $user{'userID'} = &find_free_uid($config{'min_uid'}) ;
    } else {
        $user{'userID'} = &remove_whitespace($in->{'userID'});
    }

    $user{'userName'} = &remove_whitespace($in->{'userName'});

    if ($in->{'groupID'}) {
        $user{'groupID'} = &remove_whitespace($in->{'groupID'}) ;
    }

    $user{'password'} = &remove_whitespace($in->{'password'});

    $user{'loginShell'} = &remove_whitespace($in->{'loginShell'});

    $user{'description'} = &remove_whitespace($in->{'description'});

    $user{'email'} = &remove_whitespace($in->{'email'});

	return \%user ;
}

=head2 user_from_entry

SYNOPSIS

C<user_from_entry ( I<\%entry> )>

DESCRIPTION

Creates a user hash from a given LDAP entry hash.

RETURN VALUE

Returns a reference to a newly-created user-hash.

BUGS

None known.

=cut

sub user_from_entry
{
    my ($entry) = @_;
    my (%user) ;

    # posixAccount
    $user{'uid'} = $entry->{'uid'}[0];
    $user{'uidNumber'} = $entry->{'uidNumber'}[0];
    $user{'gidNumber'} = $entry->{'gidNumber'}[0];
    $user{'gecos'} = $entry->{'gecos'}[0];
    $user{'homedirectory'} = $entry->{'homedirectory'}[0];
    $user{'loginshell'} = $entry->{'loginshell'}[0];

    # Unimplemented shadow options
    #$user{'shadowAccount'}
    #$user{'shadowexpire'}
    #$user{'shadowflag'}
    #$user{'shadowinactive'}
    #$user{'shadowlastchange'}
    #$user{'shadowmax'}
    #$user{'shadowwarning'}

    #inetOrgPerson
    #top
    #kerberosSecurityObject
    #organizationalPerson
    #person
    #account

    $user{'cn'} = $entry->{'cn'}[0];
    $user{'sn'} = $entry->{'sn'}[0];
    $user{'givenname'} = $entry->{'givenname'}[0];
    $user{'userpassword'} = $entry->{'userpassword'}[0];
    #$user{'krbname'}

    #Unimplemented OutlookExpress options
    #$user{'co'}
    #$user{'homephone'}
    #$user{'homepostaladdress'}
    #$user{'initials'}
    #$user{'ipphone'}
    #$user{'l'}
    #$user{'manager'}
    #$user{'otherfacsimiletelephonenumber'}
    #$user{'postaladdress'}
    #$user{'postalcode'}
    #$user{'reports'}
    #$user{'st'}
    #$user{'url'}

    $user{'comment'} = $entry->{'comment'}[0];
    $user{'department'} = $entry->{'department'}[0];
    $user{'mail'} = $entry->{'mail'}[0];
    $user{'mobile'} = $entry->{'mobile'}[0];
    $user{'officefax'} = $entry->{'officefax'}[0];
    $user{'organizationname'} = $entry->{'organizationname'}[0];
    $user{'pager'} = $entry->{'pager'}[0];
    $user{'physicaldeliveryofficename'} = $entry->{'physicaldeliveryofficename'}[0];
    $user{'telephonenumber'} = $entry->{'telephonenumber'}[0];
    $user{'title'} = $entry->{'title'}[0];

    return \%user ;
}

=head2 user_defaults

SYNOPSIS

C<user_defaults ( )>

DESCRIPTION

Fill in default settings for a new user.

RETURN VALUE

None.

BUGS

'gid' should come from a more reliable source.  This
function doesn't appear to be used currently.

=cut

sub user_defaults
{
    $uidNumber = &find_free_uid($config{'min_uid'}) ;
    # should get these defaults fron %config or from a template
    $gidNumber = $config{'gid'};
    $loginshell = $config{'shell'};
}

=head2 entry_from_user

SYNOPSIS

C<entry_from_user ( I<\%entry>, I<\%user> )>

DESCRIPTION

Creates an LDAP entry from a user hash.  Entry must be
pre-initialized.

RETURN VALUE

Reference to an entry hash.

BUGS

Doesn't work currently, or if it does, uses global variables.
Needs to handle passed-in user hash.

=cut

sub entry_from_user
{
    my ($entry, $user) = @_;

   # Set add object classes
    $entry->{'objectclass'} = ["posixAccount", "person", "inetOrgPerson",
        "organizationalPerson", "account", "top", "pilotPerson" ];

    # Start posixAccount attributes
    # Create empty fields
    if ($user->{'cn'}) {
        $entry->{'cn'} = [$user->{'cn'}] ;
    } else {
        $entry->{'cn'} = ["$user->{'givenname'} $user->{'surname'}"] ;
    }

    # This should be more automatic, like in the useradmin module
    if ($user->{'homedirectory'}) {
        $entry{'homedirectory'} = [$user->{'homedirectory'}] ;
    } else {
        $entry{'homedirectory'} = [$config{'homes'} . "/$uid"] ;
    }
    
    if ($user->{'gecos'}) {
        $entry{'gecos'} = [$user->{'gecos'}] ;
    } else {
        $entry{'gecos'} = ["$user->{'givenname'} $user->{'sn'}"] ;
    }

    $entry->{'uid'} = [$user->{'uid'}];
    $entry->{'uidNumber'} = [$user->{'uidNumber'}];
    $entry->{'gidNumber'} = [$user->{'gidNumber'}];
    $entry->{'userpassword'} = ["*"];
    $entry->{'loginshell'} = [$user->{'loginshell'}];
    $entry->{'description'} = [$user->{'description'}] ;
    # End posixAccount attributes

    # Start 'person' attributes
    $entry->{'sn'} = [$user->{'sn'}];
    $entry->{'telephonenumber'} = [$user->{'telephonenumber'}];
    # End 'person' attributes
    
    # Start 'inetOrgPerson' attributes
    $entry->{'givenname'} = [$user->{'givenname'}];
    if ($user->{'mail'}) {
        $entry{'mail'} = [$user->{'mail'}] ;
    } else {
        $entry{'mail'} = [$uid . "@" . $config{'maildomain'}] ;
    }
    # End 'inetOrgPergon' attributes

    # Start 'organizationalPerson' attributes
    $entry->{'title'} = [$user->{'title'}];
    $entry->{'physicaldeliveryofficename'} = [$user->{'physicaldeliveryofficename'}];
    # End 'organizationalPerson' attributes

    # Start 'account' attributes
    $entry->{'userid'} = [$user->{'uid'}];
    $entry->{'organizationname'} = [$user->{'organizationname'}];
    $entry->{'host'} = $user->{'host'} ; # 'host' should be an array already
    # End 'account' attributes

    # Start 'pilotPerson' attributes
    # End 'pilotPerson' attributes

    if ($config{'outlook'}) {
        $entry->{'department'} = [$user->{'department'}];
        # Pilot person?
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


    return \%entry;
}

=head2 create_home_dir

SYNOPSIS 

C<create_home_dir ( I<$user>, I<$host> )>

DESCRIPTION

Creates a home directory for $user on (possibly remote) $host.
Remote hosts have to have the 'create_homedir' module installed.

RETURN VALUE

Returns true. ;(

BUGS

Should return something more interesting than true.  Should pass
eval() exceptions back to calling function, instead of calling
&error() directly.

=cut

sub create_home_dir {
    local ($user, $host) = @_ ;

    $loghash{'user'} = $user ;
    $loghash{'host'} = $host ;

    $debug && &webmin_log ('call', 'sub', 'users.pl:create_home_dir');


    # Create the remote directory, by calling itself on
    # the remote host
    $debug && &webmin_log ('call', 'sub', 'users.pl:foreign_check') ;
    eval ( &foreign_check('create_homedir') ) ;
    if ($@) {
        $whatfailed = &text('err_foreign_check', 'create_homedir', $host) ;
        &error($@) ;
    }


    $debug && &webmin_log ('call', 'sub', 'users.pl:foreign_require');
    eval ( &foreign_require('create_homedir', 'create_home_dir.pl') ) ;
    if ($@) {
        $whatfailed = &text('err_foreign_require', 'create_homedir', 
            'create_home_dir.pl', $host)
        &error($@) ;
    }

    $debug && &webmin_log ('call', 'sub', 'users.pl:foreign_call') ;

    eval ( $loghash{'make_home_local'} = &foreign_call( 'create_homedir', 
        'make_home_local', $user) ) ;
    if ($@) {
        $whatfailed = &text('err_foreign_call', 'create_homedir', 
            'make_home_local', $host, $@)
        &error($@) ;
    }

    &webmin_log('create', 'homedir', 'users.pl: loghash', \%loghash) ;

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

