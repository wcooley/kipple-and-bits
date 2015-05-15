=head1 NAME

I<Amavis/Query.pm>

=head1 DESCRIPTION

I<Amavis/Query.pm> is a Perl module for handling database
queries.  It's a thin layer on top of DBI.pm.

=cut

package Amavis::Query;

use DBI;
use strict;
use diagnostics;

my $dbh ;

sub dump {
    my ($self) = @_ ;

    print STDERR "Dumping $self data\n" ;
    foreach my $key (keys %{$self}) {
        print STDERR "\t$key: $self->{$key}\n" ;
    }
}

sub new {
    my ($self) = @_ ;

    $dbh = DBI->connect("DBI:$::config{'dbtype'}:$::config{'dbname'}"
        . ":$::config{'dbhost'}", $::config{'dbuser'}, $::config{'dbpasswd'}) ;

    return bless {
        _dbh => $dbh,
        _sth => ""
    }, $self ;

}

sub prepare {
    my ($self, $qstr) = @_ ;

    $self->{'_sth'} = $self->{'_dbh'}->prepare($qstr) ;

}

sub execute {
    my ($self, @args) = @_ ;

    return $self->{'_sth'}->execute(@args) ;
}

sub fetchrow_hashref {
    my ($self) = @_ ;

    return $self->{'_sth'}->fetchrow_hashref() ;
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

