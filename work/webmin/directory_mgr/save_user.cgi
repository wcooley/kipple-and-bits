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
	&user_from_form() ;

	if (! &new_user_ok) {
		&error ($text{'err_user_incomplete'});
	}
	&header ($text{'created_user'}, "");
	$uidnumber = ($uidnumber) ? $uidnumber : &max_uidnumber;
	$dn = &create_user ;
	&set_passwd ($dn, $userpassword, $in{'hash'});
	if ($in{'create'}) {
		# Create the group if configured to create a new
		# group for a user
		if ($config{'new_group'}) {
			$group{'groupName'} = $in{'uid'} ;
			if ($in{'gid_from'} != "automatic") {
				$group{'gidNumber'} = $in{'input_gid'} ;
			}
			if ($in{'uidnumber'}) {
				$group{'memberUid'} = $uidnumber ;
			}
			if ($in{'groupDescription'}) {
				$group{'description'} = $in{'groupDescription'} ;
			} else {
				$group{'description'} = &text('group_desc', 
					$group{'groupName'}) ;
			}
			if ($in{'systemUser'}) {
				$group{'systemUser'} = 1 ;
			}

			$ret = &create_group(\%group) ;

			if ( $ret->[0] == -1 ) {
				&error($ret->[1]) ;
			}
		}

		# Fix this here -- this should be done with my
		# create_homedir module
		mkdir $homedirectory, 0700;
		if ($in{'copy'}) {
			system "cp -rf /etc/skel/* $homedirectory";
			system "cp -rf /etc/skel/.[^.]+ $homedirectory";
		}
		system "chown -R $uidnumber.$gidnumber $homedirectory";
	}
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

