#!/usr/bin/perl
#
# save_user.cgi -- Save user information from adding or
# modifying a user account
#
# Written by Wil Cooley <wcooley@nakedape.cc>
# 
# $Id$
#

=head1 NAME

I<save_user.cgi>

=head1 DESCRIPTION

I<save_user.cgi> processes submissions from I<add_user.cgi>
and I<edit_user.cgi> forms.

=cut

$debug = 1 ;
require "directory-lib.pl" ;

&ReadParse() ;
&connect() ;

$sort_on = $in{'sort_on'} ;

if ($in{'do'} eq "create") {
	$user_info = &user_from_form(\%in) ;
	$group_info = &group_from_form(\%in) ;

	$ret = &set_passwd ($user_info, $in{'hash'});
    if ( $ret->[0] == -1 ) {
        &error($ret->[1]) ;
    }

	# Create group before user, so if we're using
	# user-private-groups we can get a free gidNumber.
    $user_info->{'groupID'} = $group_info->{'groupID'} ;

    &group_add_username($group_info, $user_info->{'userName'}) ;

    # Create the group
	$ret = &create_group($group_info) ;

    # Report any errors
	if ( $ret->[0] == -1 ) {
		&error($ret->[1]) ;
	}

    # Check user_info
	unless ( &new_user_ok ($user_info) ) {
		&error ($text{'err_user_incomplete'});
	}

    # Create the user
	$ret = &create_user ($user_info) ;

    # Report any errors
    if ( $ret->[0] == -1 ) {
        &error($ret->[1]) ;
    }


    # Create home directory

    if ($config{'createhome'}) {

        if ($config{'createhomeremote'}) {
            @remote_home_hosts =  split(/\0/, $in{'servers_for_home_dir'}) ;
            foreach $home_host (@remote_home_hosts) {
                &create_home_dir ($user_info{'uid'}, $home_host) ;
            }
        } else {
	        mkdir $user_info{'homeDirectory'}, 0700;
	        if ($in{'copy'}) {
		        system "cp -rf /etc/skel/* $user_info{'homeDirectory'}";
		        system "cp -rf /etc/skel/.[^.]+ $user_info{'homeDirectory'}";
	        }
	        system "chown -R $user_info{'userID'}.$user_info{'groupID'} "
                . "$user_info{'homeDirectory'}";
        }
    }

	&header ($text{'created_user'}, "");

} elsif ($in{'do'} eq "modify") {
	$user = &user_from_form(\%in) ;
	unless (&changed_user_ok($user)) {
		&error ($text{'error_2'});
	}
	&header ($text{'header_2'}, "");
    print "<!-- Running update_user -->\n" ;
	&update_user ($in{'dn'}, $user);
    print "<!-- Running user_set_sec_grps -->\n" ;
    &user_set_sec_grps($user) ;
    print "<!-- Running html_user_from -->\n" ;
    print &html_user_form("display", $user) ;
	&footer ("index.cgi", $text{'module_title'});
	do "footer.pl";

} elsif ($in{'do'} eq "delete") {

	if ($in{'delete_user'}) {
    	$ret = &delete_user ($in{'dn'});
        if ($ret->[0] != 1) {
            $whatfailed = "Deletion of user $in{'dn'}" ;
            &error($ret->[1]) ;
        } else {
            &redirect ("list_users.cgi?sort_on=$sort_on");
        }
	} elsif ($in{'delete_home'}) {
        # This needs to be reworked.
    	$entry = &get_user_attr ($in{'dn'});
    	$home = $entry->{'homeDirectory'}[0];
    	$owner = ((stat($home))[4]);
    	if ($owner == $entry->{'uidNumber'}[0]) {
        	system "rm -rf $home";
    	} else {
        	&error (&text ("error_1", $entry->{'uid'}[0] , $home));
    	}
    	&delete_user ($in{'dn'});
    	&redirect ("list_users.cgi?sort_on=$sort_on");
	} else {

        # display current user data
        $dn = $in{'dn'};
        $entry = &get_user_attr ($dn);
        $user = &user_from_entry ($entry);

        &header ($text{'header_6'}, "");
        print "<HR noshade size=2>\n";
        print &html_user_form("display", $user) ;

        print "<h3>\n" ;
        print &text ("delete_user_confirm", $user->{'firstName'} 
            . " " . $user->{'surName'}, $user->{'userName'}) ;
        print "</h3>\n";
        print <<EOF ;
	<form method="post" action="save_user.cgi">
	<input type="hidden" name="do" value="delete">
	<input type="hidden" name="dn" value="$in{'dn'}">
	<input type="hidden" name="sort_on" value="$sort_on">
	<input type="submit" name="delete_user" value="$text{'just_user'}">
    <!-- We don't have homedir management yet
	<input type="submit" name="delete_home" value="$text{'user_and_home'}">
    -->

	<p>
EOF
	&footer ("index.cgi?sort_on=$sort_on", $text{'module_title'});
	do "footer.pl";

    }

} elsif ($in{'do'} eq "passwd") {

    $ret = &user_passwd_from_form(\%in) ;
    if ( $ret->[0] == -1 ) {
        $whatfailed = $ret->[1] ;
        &error($text{'set_passwd'}) ;
    } else {
        &header($text{'set_passwd'}, '') ;
        &update_user($in{'dn'}, $ret->[1]) ;
	    &footer ("index.cgi", $text{'module_title'});
	    do "footer.pl";
    }


} else {
	&header ('"do" not set', "");
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
License <http://www.gnu.org/licenses/gpl.txt>.

=cut

