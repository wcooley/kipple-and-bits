
use strict;
no strict 'vars';
use diagnostics;
use warnings;

use Webmin;

package Webmin::Text;

sub new {
    my $class = shift;
    my ($self, $k, $v);

    Webmin::init_config;

    $self = bless {}, $class;

    while (($k, $v) = each %Webmin::text) {
        $self->{$k} = $v;
    }

    return $self; 
}

1;
