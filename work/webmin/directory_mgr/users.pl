#!/usr/bin/perl

#
# LDAP Users Admin
# users.pl $Revision$ $Date$ $Author$
#

$debug = 0 ;

use strict ;
no strict "vars" ;

use diagnostics ;

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

sub new_user_ok ($)
{
	my ($user) = @_ ;
    if ($user->{'loginShell'} &&
		$user->{'groupID'} &&
        $user->{'firstName'} &&
        $user->{'surName'})
    {
        return 1 ;
    } else {
        return 0 ;
    }
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

sub changed_user_ok ($)
{
    my ($user) = @_ ;
    if ($user->{'userName'} &&
        $user->{'userID'} &&
        $user->{'groupID'} &&
        $user->{'homeDirectory'} &&
        $user->{'loginShell'} &&
        $user->{'firstName'} &&
        $user->{'surName'}) 
    {
        return 1 ;
    } else {
        return 0 ;
    }
}

=head2 auto_home_dir

SYNOPSIS

C<auto_home_dir ( I<$username>, I<$homestyle> )>

DESCRIPTION

Creates a home directory path based on I<$homestyle>.

RETURN VALUE

Returns a string with the home directory path.

BUGS

Currently ignores I<$homestyle>.  Should be more configurable.

=cut

sub auto_home_dir ($:$) {

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

sub is_uidNumber_free ($)
{
    my ($uidNumber) = @_;

    $uids = &search_users_attr ("uidNumber=$uidNumber", ("uidNumber"))  ;
    if (scalar (@{$uids}) > 0) {
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

sub user_from_form ($)
{
    my ($in) = @_;
	my (%user) ;

    $user{'firstName'} = &remove_whitespace($in->{'firstName'});
    $user{'userName'} = &remove_whitespace($in->{'userName'});
    $user{'surName'} = &remove_whitespace($in->{'surName'});

    for $telnum (split (',', $in->{'telephoneNumber'})) {
        push @{$user{'telephoneNumber'}}, &remove_whitespace($telnum) ;
    }

    # Comma-separated hosts
    for $host (split (',', $in->{'allowedHosts'})) {
        push @{$user{'allowedHosts'}}, &remove_whitespace($host) ;
    }

    if ($in->{'homeDirectory'}) {
        $user{'homeDirectory'} = &remove_whitespace($in->{'homeDirectory'});
    } else {
        $user{'homeDirectory'} = &auto_home_dir ($user{'userName'}) ;
    }

    if ($in->{'userID'} eq '') {
        $user{'userID'} = &find_free_userid($config{'min_uid'}) ;
    } else {
        $user{'userID'} = &remove_whitespace($in->{'userID'});
    }


    if ($in->{'groupID'}) {
        $user{'groupID'} = &remove_whitespace($in->{'groupID'}) ;
    }

    $user{'password'} = &remove_whitespace($in->{'password'});

    $user{'loginShell'} = &remove_whitespace($in->{'loginShell'});

    $user{'description'} = &remove_whitespace($in->{'description'});

    if ( $in->{'email'} ) {
        $user{'email'} = &remove_whitespace($in->{'email'});
    } else {
        $user{'email'} = $user{'userName'} . '@' .  $config{'maildomain'} ;
    }

	return \%user ;
}


=head2 user_passwd_from_form

SYNOPSIS

C<user_passwd_from_form ( I<\%in> )>

DESCRIPTION

Changes the password for the user directory object passed in
$in->{'dn'}.

RETURN VALUE

Returns a two-element array consisting of an error flag (1: no
error; -1: error) and either a reference to the new user hash or
a formatted error string.

BUGS

None known.

NOTES

None.

=cut
sub user_passwd_from_form ($) {

    my ($in) = @_ ;

    my $entry = &get_user_attr($in->{'dn'}) ;

    my $user = &user_from_entry($entry) ;

    $user->{'password'} = $in->{'password'} ;

    my $ret = &set_passwd ($user, $in->{'hash'}) ;

    if ($ret->[0] == 1) {
        return [ 1, $user ] ;
    } else {
        return $ret ;
    }

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

sub user_from_entry ($)
{
    my ($entry) = @_;
    my (%user) ;

    $user{'firstName'} = $entry->{'givenName'}[0];
    $user{'surName'} = $entry->{'sn'}[0];
    $user{'fullName'} = $entry->{'cn'}[0] ;
    # Array
    $user{'telephoneNumber'} = $entry->{'telephoneNumber'} ;
    # Array
    $user{'allowedHosts'} = $entry->{'host'} ;

    $user{'homeDirectory'} = $entry->{'homeDirectory'}[0];
    $user{'userID'} = $entry->{'uidNumber'}[0];
    $user{'userName'} = $entry->{'uid'}[0];
    $user{'groupID'} = $entry->{'gidNumber'}[0];
    $user{'password'} = $entry->{'userPassword'}[0];
    $user{'loginShell'} = $entry->{'loginShell'}[0];
    $user{'email'} = $entry->{'mail'}[0];
    $user{'description'} = $entry->{'description'}[0] ;

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
    my (%user) ;

    $user{'userID'} = &find_free_userid($config{'min_uid'}, $config{'max_uid'}) ;
    # should get these defaults fron %config or from a template
    $user{'groupID'} = $config{'gid'};
    $user{'loginShell'} = $config{'shell'};

    return \%user ;
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


=cut

sub entry_from_user ($$)
{
    my ($entry, $user) = @_;

    # DN
    unless ($entry->hasDNValue("uid=$user->{'userName'}" .
        ",ou=People,$config{'base'}")) {
        $entry->setDN("uid=$user->{'userName'},ou=People," .
            "$config{'base'}") ;
    }

    # Add object classes
    unless ($entry->hasValue('objectClass', 'posixAccount')) {
        $entry->addValue("objectClass", "posixAccount") ;
    }

    unless ($entry->hasValue('objectClass', 'inetOrgPerson')) {
        $entry->addValue("objectClass", "inetOrgPerson") ;
    }

    unless ($entry->hasValue('objectClass', 'account')) {
        $entry->addValue("objectClass", "account") ;
    }

    unless ($entry->hasValue('objectClass', 'person')) {
        $entry->addValue("objectClass", "person") ;
    }

    # Start posixAccount attributes

    unless ($entry->hasValue("cn", "$user->{'firstName'} $user->{'surName'}")) {
        $entry->setValues('cn', "$user->{'firstName'} $user->{'surName'}") ;
    }

    unless ($entry->hasValue("homeDirectory", $user->{'homeDirectory'})) {
        $entry->setValues('homeDirectory', $user->{'homeDirectory'}) ;
    }

    unless ($entry->hasValue("uid", $user->{'userName'})) {
        $entry->setValues('uid', $user->{'userName'});
    }

    unless ($entry->hasValue("uidNumber", $user->{'userID'})) {
        $entry->setValues('uidNumber', $user->{'userID'});
    }

    unless ($entry->hasValue("gidNumber", $user->{'groupID'})) {
        $entry->setValues('gidNumber', $user->{'groupID'}) ;
    }
    
    unless ($entry->hasValue("gecos", "$user->{'firstName'} $user->{'surName'},"
            . $user->{'telephoneNumber'}[0])) {
        $entry->setValues('gecos', "$user->{'firstName'} $user->{'surName'},"
            . $user->{'telephoneNumber'}[0]) ;
    }

    # Need to make sure password hash &al takes place
    unless ($entry->hasValue("userPassword", $user->{'password'})) {
        if ($user->{'password'}) {
            $entry->setValues('userPassword', $user->{'password'});
        }
    }

    unless ($entry->hasValue("loginShell", $user->{'loginShell'})) {
        $entry->setValues('loginShell', $user->{'loginShell'});
    }

    unless ($entry->hasValue("description", $user->{'description'})) {
        if ($user->{'description'}) {
            $entry->setValues('description', $user->{'description'}) ;
        }
    }
    # End posixAccount attributes

    # Start account attributes
    if ($user->{'allowedHosts'}) {
        $entry->remove('host') ;
        $entry->setValues('host', @{$user->{'allowedHosts'}}) ;
    }
    # End account attributes

    # Start 'inetOrgPerson' attributes
    unless ($entry->hasValue('sn', $user->{'surName'})) {
        $entry->{'sn'} = [$user->{'surName'}];
    }

    # telephoneNumber is already an array
    if ($user->{'telephoneNumber'}) {
        $entry->remove('telephoneNumber') ;
        $entry->setValues('telephoneNumber',
            @{$user->{'telephoneNumber'}}) ;
    }
    
    unless ($entry->hasValue("givenName", $user->{'firstName'})) {
        $entry->setValues("givenName", $user->{'firstName'}) ;
    }

    unless ($entry->hasValue("mail", $user->{'email'})) {
        if ($user->{'email'}) {
            $entry->setValues('mail', $user->{'email'}) ;
        }
    }
    # End 'inetOrgPergon' attributes

    if ($config{'shadow'}) {
        $entry->addValue("objectclass", "shadowAccount") ;
        # Need to add shadow attributes
    }

    if ($config{'kerberos'}) {
        $entry->addValue("objectclass", "kerberosSecurityObject") ;
        # Need to add Kerberos attributes
    }

    return $entry;
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

sub create_home_dir ($$) {
    my ($user, $host) = @_ ;

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

