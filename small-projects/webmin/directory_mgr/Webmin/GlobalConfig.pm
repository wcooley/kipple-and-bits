
use strict;
no strict 'vars';
use diagnostics;
use warnings;

use Webmin;

package Webmin::GlobalConfig;

sub new {
    my $class = shift;
    my ($self, $k, $v);

    $self = bless {}, $class;

    Webmin::init_config;

    while (($k, $v) = each %Webmin::gconfig) {
        $self->{$k} = $v;
    }

    return $self; 
}

1;
