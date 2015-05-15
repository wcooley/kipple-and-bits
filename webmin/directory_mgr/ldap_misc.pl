#!/usr/bin/perl
#
# ldap_misc.pl -- Miscellaneous LDAP subroutines
#
# $Id$


=head1 NAME

I<ldap_misc.pl>

=head1 DESCRIPTION

I<ldap_misc.pl> contains LDAP routines that are not specific to
any particular object type.

=cut

use strict ;
no strict "vars" ;

use diagnostics ;

sub connect
{
    $conn = new Mozilla::LDAP::Conn ($config{'server'},
        $config{'port'},
        $config{'user'},
        $config{'passwd'});
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


=head2 ldap_diff_entry

SYNOPSIS

C<ldap_diff_entry ( I<$from_entry>, I<$to_entry> )>

DESCRIPTION

Diffs two LDAP Entries and returns a "patch" of the format:

(
[ '[-=]', 'attribute', 'value' ],
[ '[-=]', 'attribute', 'value' ],
...
)

In other words, an array of references to arrays of changes, where the
elments are a '+' or '-' to indicate addition or removal,
the attribute name, and the attribute value.

RETURN VALUE

Returns the array described above.

BUGS

None known.

NOTES

None.

=cut
sub ldap_diff_entry($,$)
{

    my ($from, $to) = @_ ;
    my (@patch, %attrs) ;

    
    push @patch, [ '*', 'none', 'none' ] ;

    foreach $attr (keys %{$from}, keys %{$to}) {
        $attrs{$attr} = 1 ;
    }

    foreach $attr (keys %attrs) {
        if ($from->exists($attr) and not $to->exists($attr)) {
            foreach $val ($from->getValues($attr)) {
                push @patch, ['+', $attr, $val] ;
            }
        } elsif (not $from->exists($attr) and $to->exists($attr)) {
            foreach $val ($to->getValues($attr)) {
                push @patch, ['-', $attr, $val] ;
            }
        } else {
            foreach $val ($from->getValues($attr)) {
                if (not $to->hasValue($attr, $val)) {
                    push @patch, ['+', $attr, $val] ;
                }
            }

            foreach $val ($to->getValues($attr)) {
                if (not $from->hasValue($attr, $val)) {
                    push @patch, ['-', $attr, $val] ;
                }
            }
        }
    }

    push @patch, [ '*', 'none', 'none' ] ;

    return @patch ;

}


=head2 ldap_patch_entry

SYNOPSIS

C<ldap_patch_entry( I<$entry>, I<$option>, I<@patch> )>

DESCRIPTION

Applies a @patch generated by I<ldap_diff_entry> to the
I<$entry>.  Should normally be used on the second operand to
I<ldap_diff_entry>.

I<$option> can be either the string "add-only", which only
adds attributes to the I<$entry> or "remove-only", which
only removes them.

RETURN VALUE

Returns the $entry passed in for convenience.

BUGS

None known.

NOTES

None.

=cut

sub ldap_patch_entry ($$@)
{
    my ($entry, $op, @patch) = @_ ;

    foreach $line (@patch) {
        if (($line->[0] eq '-') and ($op ne "add-only")){
            $entry->removeValue($line->[1], $line->[2]) ;
        } elsif ($line->[0] eq '+' and ($op ne "remove-only")) {
            $entry->addValue($line->[1], $line->[2]) ;
        }
    }

    return $entry ;

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
License <http://www.gnu.org/licenses/gpl.txt> or the file B<LICENSE>
included with this program.

=cut

1;