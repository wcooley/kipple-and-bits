=head1 NAME

I<Amavis/Policy.pm>

=head1 DESCRIPTION

I<Amavis/Policy.pm> is a Perl module for handling policy
configurations for Amavis User Admin.

=cut


use strict;
use diagnostics;
use Amavis::Query;

package Amavis::Policy;

my $qry_policy = "SELECT policy_name, id FROM policy ORDER BY id" ;

sub new {
    my ($class) = @_ ;
    my $self;
    my $query = new Amavis::Query ;

    $query->prepare($qry_policy) ;

    $query->execute() ;

    $self = bless {}, $class ;

    while ( my $row = $query->fetchrow_hashref() ) {
        $self->{$row->{'policy_name'}} = $row->{'id'};
        $self->{$row->{'id'}} = $row->{'policy_name'};
    }
    
    return $self ;
}


sub name_by_id ($$) {
    my ($self, $id) = @_ ;
    return $self->{$id} ;
}

sub id_by_name ($) {
    my ($self, $name) = @_ ;
    return $self->{$name} ;
}

sub list ($) {
    my ($self) = @_ ;
    my (@pol, $key) ;

    foreach $key (sort(keys(%{$self}))) {
        if ($key =~ /^[[:digit:]]+$/) {
            my @r = ($key, $self->{$key}) ;
            push (@pol, \@r) ;
        }
    }

    return @pol ;
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

