#!/usr/bin/perl
#
# This document is not actual Perl code, just POD markup ;)

=head1 NAME

design.pl

=head1 DESCRIPTION

This document contains descriptions of the objects and
data strucures used in I<Directory_Mgr>.  It's not actual
Perl code, just POD documentation.


=head1 Data Structures

=head2 User Objects

User objects are represented in three ways and data must be able
to transition gracefully between them: CGI input, directory objects
(LDAP currently), and generic "user" objects.

=over 4

=item LDAP Objects

Direcotry_Mgr uses the following LDAP objectClasses and associated
attributes for user data:

=over 4

=item * posixAccount

=over 4

=item * cn I<(required)>

=item * homeDirectory I<(required)>

=item * uid I<(required)>

=item * uidNumber I<(required)>

=item * gidNumber I<(required)>

=item * gecos

=item * userpassword

=item * loginshell

=item * description

=back # end posixAccount

=item * account

=over 4

=item * uid I<(required)>

=item * host I<(important for pam_ldap)>

=back # end account

=item * person

=over 4

=item * cn I<(required)>

=item * sn I<(required)>

=item * telephoneNumber

=back # end person

=item * inetOrgPerson

=over 4

=item * givenName

=item * mail


=back # end inetOrgPerson

=item * top

The I<top> object class is required by RFC 2256, section
5.1.

=back # end LDAP Entries



=item The "user" Hash

The "user" hash is an abstraction of a user account that represents
a user as he may be represented by the back-end directory.  It is
a higher-level representation without the naming differences
back-end directories are subject to.  With LDAP, some elements
may be respented by multiple, or a combination of, attributes,
such as the I<cn (commonName)>, I<sn (surname)>, and I<givenName>
attributes.  The "user" hash abstraction can represent this data
without duplication of data and without introducing idiosyncracies
of the back-end into the representation.

The "user" hash consists of the following keys:

=over 4

=item * firstName

=item * surName

=item * telephoneNumber (an array of telephone numbers)

=item * allowedHosts (an array of host names)

=item * homeDirectory

=item * userID

=item * userName

=item * groupID

=item * password

=item * loginShell

=item * description

=item * email

=back

=item The "in" Hash

The "in" hash is the representation of user data as it is submitted
via HTTP POST.  The "in" hash will be mostly a mirror of the
"user" hash, except where there are naming conflicts or there are
"automatic" settings (for example, a blank userID will be generated).

=back

=head2 Group Objects

Group objects, like user objects, are represented by the
LDAP objectClasses and associated attributes, a "group"
hash, and the CGI input hash.

=over 4

=item LDAP Objects

=over 4

=item * posixGroup

=over 4

=item * cn I<(required)>

=item * gidNumber I<(required)>

=item * memberUid

=item * description

=back

=back

=item The "group" Hash

=over 4

=item * groupName

=item * groupID

=item * groupDescription

=item * memberUsername I<(an array of usernames)>

=back

=item The "in" Hash

The "in" hash for group components uses the same keys as the group
hash, except special handling is required for automatic group ID
creation, such as for user-private-groups.

=back

=head1 CREDITS

This module begun by Wil Cooley <wcooley@nakedape.cc>.  All bug
reports should go to Wil Cooley.

=head1 LICENSE

This file is copyright Wil Cooley <wcooley@nakedape.cc>, under the
GNU General Public License <http://www.gnu.org/licenses/gpl.txt>
or the file B<LICENSE> included with this program.

=cut

1;
