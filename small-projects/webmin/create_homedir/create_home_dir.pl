#!/usr/bin/perl
#
#    Create Home Directory Webmin Module
#    Copyright (C) 2001 by Wil Cooley <wcooley@nakedape.cc>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    This module inherited from the Webmin Module Template 0.79.1 by tn
#	 Much of this code ripped from the 'useradmin' module by
#	 Jamie Cameron.

do '../web-lib.pl';
&init_config();

$debug = 0 ;

if ($debug) {
	&webmin_log ('require', 'module', 'create_home_dir.pl') ;
}

%access = &get_module_acl();

## put in ACL checks here if needed

# make_home_local(user)
# Makes a home directory, using foreign_* calls to useradmin
sub make_home_local
{
    local ($user) = @_ ;

	local %rconfig = &foreign_config('useradmin') ;

	if (not $access{'create_local'}) {
		&error($text{'err_local_acl'}) ;
	}

	$debug && &webmin_log ('call', 'sub', 'make_home_local') ;

	# Check the foreign stuff works
	if (! &foreign_check('useradmin')) {
		&webmin_log('error', 'foreign_check', 'make_home_local') ;
		return &text('err_foreign_check', 'useradmin') ;
	} elsif (! &foreign_require('useradmin', 'user-lib.pl')) {
		&webmin_log('error', 'foreign_require', 'make_home_local') ;
		return &text('err_foreign_require', 'useradmin', 'user-lib.pl') ;
	}
		
	($user{'user'}, $user{'x'}, $user{'uid'}, $user{'gid'}, $user{'x'}, 
		$user{'x'}, $user{'x'}, $user{'home'}, $user{'x'}, $user{'x'}) =
			&foreign_call("useradmin", "my_getpwnam", "$user") ;

	# Dump the unnecessary stuff so we don't log it
	delete $user{'x'} ; 

	# Make sure we actually found the user
	exists $user{'user'} || return &text('err_no_user', $user) ;

	# Create the directory itself
    &lock_file($user{'home'});
    mkdir($user{'home'}, oct($rconfig{'homedir_perms'})) ||
        return &text('err_mkdir', $!, $user{'home'});
    chmod(oct($rconfig{'homedir_perms'}), $user{'home'}) ||
        return &text('err_chmod', $!);
	chown($user{'uid'}, $user{'gid'}, $user{'home'}) ||
		return &text('err_chown', $!);
    &unlock_file($user{'home'});

	# Create user files, should be configurable?
	local $uf = $rconfig{'user_files'} ;
	$uf =~ s/\$group/$user{'gid'}/g;
	$uf =~ s/\$gid/$user{'gid'}/g;

	# Call the 'copy_skel_files' to actually copy the skel
	# files
	&foreign_call ("useradmin", "copy_skel_files", "$uf",
		"$user{'home'}", "$user{'uid'}", "$user{'gid'}");

	&webmin_log('create', 'homedir', $user{'home'}, \%user) ;

	return "ok" ;

}

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
		eval (&remote_foreign_check("$host", 'create_homedir')) ;
        if ($@) {
            $whatfailed = &text('err_remote_foreign_check', 'create_homedir', $host) ;
			&error($@) ;
        }

		$debug && &webmin_log ('call', 'sub', 'remote_foreign_require');
		eval (&remote_foreign_require("$host", 'create_homedir',
			'create_home_dir.pl')) ;
        if ($@) {
            $whatfailed = &text('err_remote_foreign_require', 'create_homedir', 
                'create_home_dir.pl', $host) ;
            &error($@) ;
        }

		$debug && &webmin_log ('call', 'sub', 'remote_foreign_call') ;
		$loghash{'make_home_local'} = &remote_foreign_call("$host", 
			'create_homedir', 'make_home_local', $user) ;

		$debug && &webmin_log ('call', 'sub', 'remote_finished') ;
		eval (&remote_finished()) ;
        if ($@) {
            $whatfailed = &text('err_remote_finished', 'create_homedir',
                 'create_home_dir.pl', $host);
            &error($@) ;
        }

	}

	&webmin_log('create', 'homedir', '', \%loghash) ;

	$loghash{'make_home_local'} eq "ok" ||
		&error(&text('err_create_dir', "$loghash{'make_home_local'}")) ;

	return 1;

}

1;
