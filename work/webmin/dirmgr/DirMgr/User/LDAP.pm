require DirMgr::User;
require DirMgr::LDAP;
require Mozilla::LDAP::Entry ;

package DirMgr::User::LDAP;
our @ISA = qw(DirMgr::User) ;

require strict;
require diagnostics;

my $attr_map = [
    # User.pm Name      Type    LDAP Name   Type
    [qw(_firstname   $       givenName       $)],
    [qw(_surname     $       sn              $)],
    [qw(_homedir     $       homeDirectory   $)],
    [qw(_userid      $       uidNumber       $)],
    [qw(_username    $       uid             $)],
    [qw(_groupid     $       gidNumber       $)],
    [qw(_shell       $       loginShell      $)],
    [qw(_telephone   @       telephoneNumber @)],
    [qw(_host        @       allowedHosts    @)],
    [qw(_description @       description     @)],
    [qw(_email       @       mail            @)],
] ;

sub new ($:$)
{
    my ($that) = shift ;
    my $class = ref($that) || $that ;
    my $self = bless $that->SUPER::new(), $class ;

    return $self ;
}

sub user_to_ldap($) {
    my ($self) = shift ;

    for my $attr (@{$attr_map}) {
        if ($attr->[1] eq '$') {
            #
        } elsif ($attr->[1] eq '@') {
            #
        }
    }
}


sub ldap_to_user($) {
    my ($self) = shift ;

    for my $attr (@{$attr_map}) {
        if ($attr->[1] eq '$') {
            #
        } elsif ($attr->[1] eq '@') {
            #
        }
    }

}


1;
