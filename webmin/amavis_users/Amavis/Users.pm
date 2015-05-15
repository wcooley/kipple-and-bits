
=head1 NAME

I<Amavis/Users.pm>

=head1 DESCRIPTION

I<Amavis/Users.pm> is a Perl module for handling user
information.

=cut

package Amavis::Users;

use strict;
use diagnostics;
use Amavis::Policy;

my $qry_get = "SELECT id, priority, policy_id, email, fullname "
    . " FROM users WHERE id=?" ;

my $qry_create = "INSERT INTO users (policy_id, priority, email, fullname)"
    . " VALUES (?,?,?,?)" ;

my $qry_update = "UPDATE users SET policy_id=?,priority=?,"
    . "email=?,fullname=? WHERE id=?" ;

my $qry_list = "SELECT id, priority, policy_id, email, fullname"
        . " FROM users ORDER BY email" ;

sub get($) {
    my ($id) = @_ ;
    my $user ;

    $::query->prepare($qry_get) ;

    $::query->execute($id) ;

    $user = $::query->fetchrow_hashref() ;

    return $user ;

}

sub save($$) {
    my ($mode, $u) = @_ ;
    my $qstr ;

    if ($mode eq "create") {
        $::query->prepare($qry_create) ;
        $::query->execute($u->{'policy'},$u->{'priority'},$u->{'email'},
            $u->{'fullname'}) ;
    } elsif ($mode eq "update") {
        $::query->prepare($qry_update) ;
        $::query->execute($u->{'policy'},$u->{'priority'},$u->{'email'},
            $u->{'fullname'}, $u->{'id'}) ;
    } else {
        print STDERR "Unknown mode: $mode\n" ;
    }


}

sub list() {

    #my $utab = "" ;
    my @users = () ;

    $::query->prepare($qry_list) ;

    $::query->execute() ;

    while (my $r = $::query->fetchrow_hashref) {
        my %r = (
            id => "$r->{'id'}",
            priority => "$r->{'priority'}",
            policy_id => "$r->{'policy_id'}",
            email => "$r->{'email'}",
            fullname => "$r->{'fullname'}",
        ) ;
        push (@users, \%r) ;
    }

    return \@users;
}

1;

=head1 CREDITS

This module begun by Wil Cooley <wcooley@nakedape.cc>.  All bug
reports should go to Wil Cooley.

=head1 LICENSE

This file is copyright Wil Cooley <wcooley@nakedape.cc>, under the
GNU General Public License <http://www.gnu.org/licenses/gpl.txt>
or the file B<LICENSE> included with this program.

=cut

