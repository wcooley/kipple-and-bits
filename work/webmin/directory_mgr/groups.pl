#!/usr/bin/perl

#
# LDAP Users Admin
# groups.pl $Revision$ $Date$ $Author$
# by Fernando Lozano <fernando@lozano.eti.br> under the GNU GPL (www.gnu.org)
#

# have a lot of global variables for user attributes


sub new_group_ok
{
    return
        $gidnumber &&
        $cn;
}


sub changed_group_ok
{
    return new_group_ok;
}


sub group_from_form
{
    my ($in) = @_;

    # posixGroup
    $gidnumber = $in{gidnumber};
    $cn = $in{cn};

    # generate empty fields
}


sub group_from_entry
{
    my ($group) = @_;

    # posixGroup
    $gidnumber = $user->{gidnumber}[0];
    $cn = $user->{cn}[0];
}


sub group_defaults
{
    $gidnumber = &max_gidnumber() + 1;
}


sub entry_from_group
{
    my ($entry) = @_;

    # posixGroup
    $entry->{gidnumber} = [$gidnumber];
    $entry->{cn} = [$cn];
    
    return $entry;
}


1;
