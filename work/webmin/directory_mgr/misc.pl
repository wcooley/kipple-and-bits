#!/usr/bin/perl

$debug = 0 ;

=head1 NAME

misc.pl

=head1 DESCRIPTION

Miscellaneous functions that are not data-type, HTML or directory
oriented.

=head1 FUNCTIONS

=cut

=head2 remove_whitespace

SYNOPSIS

C<remove_whitespace ( I<$string> )>

DESCRIPTION

Removes whitespace from passed-in string.

RETURN VALUE

Returns passed-in string without whitespace.

=cut

sub remove_whitespace {

    my ($string) = @_ ;

    #$string =~ s/\s+//g ;

    return $string ;
}

=head1 NOTES

None at the moment.                                                       
                                                                          
=head1 CREDITS

This file written by Wil Cooley <wcooley@nakedape.cc>.

=head1 LICENSE

This module is copyright <C> 2002 by Wil Cooley
<wcooley@nakedape.cc>, under the GNU General Public License
<http://www.gnu.org/licenses/gpl.txt> or the file B<LICENSE>
included with this program.

=cut

1;
