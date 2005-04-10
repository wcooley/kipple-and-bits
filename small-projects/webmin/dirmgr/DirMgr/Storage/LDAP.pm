
package DirMgr::LDAP;

use Net::LDAP;
use strict ;
use diagnostics ;

sub connect($) {
    my ($config) = shift ;

    my $conn = new Net::LDAP($config->{'server'}, 
        port => $config->{'port'}) ;

    $conn->bind($config->{'user'}, 
        password => $config->{'password'}) ;

    return $conn ;

}

sub diff($:$) {
    my ($from, $to) = @_ ;
    my (@patch, %attrs, $val, $attr) ;
    
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

sub patch($$@) {
    my ($entry, $op, @patch) = @_ ;

    foreach my $line (@patch) {
        if (($line->[0] eq '-') and ($op ne "add-only")){
            $entry->removeValue($line->[1], $line->[2]) ;
        } elsif ($line->[0] eq '+' and ($op ne "remove-only")) {
            $entry->addValue($line->[1], $line->[2]) ;
        }
    }

    return $entry ;
}

1;
