
use strict;
no strict 'vars';
use diagnostics;
use warnings;

use Webmin;

package Webmin::Config;

sub new {
    my $class = shift;
    my ($self, $k, $v);

    Webmin::init_config;

    $self = bless {}, $class;

    while (($k, $v) = each %Webmin::config) {
        $self->{$k} = $v;
    }

    return $self; 
}

1;
