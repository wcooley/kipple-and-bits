#!/usr/bin/perl
#
# save_user.cgi -- Save user information from adding or
# modifying a user account
#
# Written by Wil Cooley <wcooley@nakedape.cc>
# 
# $Id$
#

require "directory-lib.pl" ;

&ReadParse() ;
&connect() ;

$sort_on = $in{'sort_on'} ;

if ($in{'do'} eq "create") {
	$user_info = &user_from_form(\%in) ;
	$group_info = &group_from_form(\%in) ;

	# Create group before user, so if we're using
	# user-private-groups we can get a free gidNumber.
	$ret = &create_group($group_info) ;

	if ( $ret->[0] == -1 ) {
		&error($ret->[1]) ;
	} else {
		$user_info{'gidnumber'} = $ret->[0] ;
	}

	if (! &new_user_ok ($user_info) ) {
		&error ($text{'err_user_incomplete'});
	}
	$uidnumber = ($uidnumber) ? $uidnumber : &max_uidnumber;
	$dn = &create_user ($in{'uid'}) ;

	&set_passwd ($dn, $userpassword, $in{'hash'});


	# Fix this here -- this should be done with my
	# create_homedir module
	mkdir $homedirectory, 0700;
	if ($in{'copy'}) {
		system "cp -rf /etc/skel/* $homedirectory";
		system "cp -rf /etc/skel/.[^.]+ $homedirectory";
	}
	system "chown -R $uidnumber.$gidnumber $homedirectory";

	&header ($text{'created_user'}, "");
} elsif ($in{'do'} eq "modify") {
	&user_from_form() ;
	if (! &changed_user_ok()) {
		&error ($text{'error_2'});
	}

	&header ($text{'header_2'}, "");
	&update_user ($in{'dn'});

} elsif ($in{'do'} eq "delete") {

	if ($in{'delete_user'}) {
    	&delete_user ($in{'dn'});
    	&redirect ("index.cgi?sort_on=$sort_on");
    	exit (0);
	}
	if ($in{'delete_home'}) {
    	$entry = &get_user_attr ($in{'dn'});
    	$home = $entry->{'homedirectory'}[0];
    	$owner = ((stat($home))[4]);
    	if ($owner == $entry->{'uidnumber'}[0]) {
        	system "rm -rf $home";
    	} else {
        	&error (&text ("error_1", $entry->{'uid'}[0] , $home));
    	}
    	&delete_user ($in{'dn'});
    	&redirect ("index.cgi?sort_on=$sort_on");
    	exit (0);
	}

	# display current user data
	$dn = $in{'dn'};
	$entry = &get_user_attr ($dn);
	&user_from_entry ($entry);

	&header ($text{'header_6'}, "");
	print "<HR noshade size=2>\n";

	print "<H3>".&text ("msg_3", $cn, $uid)."</H3>\n";
	print <<EOF ;
	<form method="post" action="save_user.cgi">
	<input type="hidden" name="do" value="delete">
	<input type="hidden" name="dn" value="$dn">
	<input type="hidden" name="sort_on" value="$sort_on">
	<input type="submit" name="delete_user" value="$text{'just_user'}">
	<input type="submit" name="delete_home" value="$text{'user_and_home'}">

	<p>
EOF
	&footer ("index.cgi?sort_on=$sort_on", $text{'module_title'});
	do "footer.pl";

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

