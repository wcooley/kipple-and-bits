#!/usr/bin/perl
#
# This document is not actual Perl code, just POD markup ;)

=head1 Data Structures

=head2 User Objects

User objects are represented in three ways and data must be able
to transition gracefully between them: CGI input, directory objects
(LDAP currently), and generic "user" objects.

=over 4

=item LDAP entries

Direcotry_Mgr uses the following LDAP objectClasses and associated
attributes for user data:

=over 4

=item * posixAccount

=over 4

=item * cn I<(required)>

=item * homedirectory I<(required)>

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

=item * inetOrgPerson

=over 4

=item * cn I<(required, inherited from 'person' object class)>

=item * sn I<(required, inherited from 'person' object class)>

=item * givenName

=item * mail

=item * telephoneNumber I<(inherited from 'person' object class)>

=back # end inetOrgPerson

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

=cut

1;
