#!/usr/bin/perl
#
# ldap_misc.pl -- Miscellaneous LDAP subroutines
#
# $Id$

sub connect
{
    $conn = new Mozilla::LDAP::Conn ($config{server},
		$config{port},
        $config{user},
		$config{passwd});
    if (! $conn) {
        &error(&text("err_conn",
			$config{'directory_type'},
			$config{'server'}));
        &webmin_log("connect", 
			$config{'directory_type'},
            $config{'server'}, \%in)
    }
}

# Checks if the module has actually been set up
sub check_setup {

	if ("$config{'base'}" eq "dc=company") {
		&error("$text{'first_time'}") ;
	}
}

1;
