require strict ;
require diagnostics ;

package DirMgr::User;


# Classify into either scalar or array vars
my @scalarvars = qw(firstname surname userid username groupid shell
    homedir otherval) ;

my @arrayvars = qw(telephone host description email) ;

# Dynamically generates subroutines based on template string
# and template name.
sub create_sub ($$$) {
    my ($tmplstr, $tmplname, $tmplvar1, $tmplvar2) = @_ ;
    
    # Check if the subroutine is already defined
    unless (defined (&$tmplname)) {
        $tmplstr =~ s/TMPLNAME/$tmplname/g ;
        $tmplstr =~ s/TMPLVAR1/$tmplvar1/g ;
        $tmplstr =~ s/TMPLVAR2/$tmplvar2/g ;
        eval ($tmplstr) ;
        $@ and print STDERR "Eval err: ", $@, "\n" ;
    }
    
}

# Scalar accessor method template
my $scalartmpl = q(
    sub TMPLNAME ($:$) {
        my $self = shift ;

        @_ ? 
            $self->{'_TMPLVAR1'} = shift :
            $self->{'_TMPLVAR1'} ;
    }
) ;

# Array accessor method template
my $arraytmpl = q(
    sub TMPLNAME ($:$) {
        my $self = shift ;

        if (@_) {
            if (ref($_[0]) eq "ARRAY") {
                my $num ;
                while ($num = shift @{$_[0]}) {
                    push @{$self->{'_TMPLVAR1'}}, $num ;
                }
            } else {
                push @{$self->{'_TMPLVAR1'}}, shift ;
            }
        } else {
            return @{$self->{'_TMPLVAR1'}} ;
        }
    }
) ;

# Array 'has' accsssor method template.
# Answers 3 questions:
# Does user have a specific attribute value?
# Does user have any values of attribute?
# How many values of attribute does the user have?
my $has_arraytmpl = q(
    sub TMPLNAME ($:$) {
        my $self = shift ;

        if (@_) {
            my $tval = shift ;
            for my $val ($self->TMPLVAR1()) {
                if ($val eq $tval) {
                    return $tval ;
                }
            }
            return 0 ;
        } else {
            scalar($self->TMPLVAR1()) ;
        }
    }
) ;

# Array 'replace' accessor method template.

my $replace_arraytmpl = q(
    sub TMPLNAME ($$:$) {
        my $self = shift ;
        my $old = shift ;
        my $len = scalar(@{$self->{'_TMPLVAR1'}}) ;

        if (@_) {
            # Replace $old with $new
            my $new = shift ;
   
            for ( my $i=0; $i < $len; $i++) {
                if ($old eq $self->{'_TMPLVAR1'}[$i]) {
                    $self->{'_TMPLVAR1'}[$i] = $new ;
                    last ;
                }
            }
        } else {
            # Remove $old
            for ( my $i=0; $i < $len; $i++) {
                if ($old eq $self->{'_TMPLVAR1'}[$i]) {
                    @{$self->{'_TMPLVAR1'}} = (@{$self->{'_TMPLVAR1'}}[0..($i-1)],
                        @{$self->{'_TMPLVAR1'}}[($i+1)..($len-1)]) ;
                    last ;
                }
            }
        }
    }
) ;


for my $var (@arrayvars) {
    &create_sub ($arraytmpl, $var, $var) ;
    &create_sub ($has_arraytmpl, "has_" . $var, $var) ;
    &create_sub ($replace_arraytmpl, "replace_" . $var, $var) ;
}

for my $var (@scalarvars) {
    &create_sub ($scalartmpl, $var, $var) ;
}

sub homedir ($:$) {
    my $self = shift ;

    if (@_) { 
        $self->{'_homedir'} = shift ;
        if ($self->{'_homedir'} eq "auto") {
           # FIXME: Do this better.
           $self->{'_homedir'} = "/home/" . $self->username() ; 
        }

    } else {
        $self->{'_homedir'} ;
    }
}

sub dump ($) {
    my ($self) = shift ;

    print
        "Username: ", $self->username(), "\n",
        "Firstname: ", $self->firstname(), "\n",
        "Surname: ", $self->surname(), "\n",
        "User ID: ", $self->userid(), "\n",
        "Group ID: ", $self->groupid(), "\n",
        "Login shell: ", $self->shell(), "\n",
        "Home directory: ", $self->homedir(), "\n" ;

    print "Telephone number" ;
    $self->has_telephone() > 1 ?
        print "s: " : print ": " ;
    for my $num ($self->telephone()) {
        print $num, " " ;
    }
    print "\n" ;

    print "Allowed Host" ;
    $self->has_host() > 1 ?
        print "s: " : print ": " ;
    for my $host ($self->host()) {
        print $host, " " ;
    }
    print "\n" ;

    print "Description" ;
    $self->has_description() > 1 ?
        print "s: " : print ": " ;
    for my $desc ($self->description()) {
        print $desc, " " ;
    }
    print "\n" ;

    print "E-mail address" ;
    $self->has_email() > 1 ?
        print "es: " : print ": " ;
    for my $mail ($self->email()) {
        print $mail, " " ;
    }
    print "\n" ;

}


sub new ($)
{
    my $self = bless {
        _firstname => '',
        _surname => '',
        _userid => '',
        _username => '',
        _groupid => '',
        _shell => '',
        _homedir => '',
        _telephone => [],
        _host => [],
        _description => [],
        _email => []
    }, shift ;

    if (@_) {
        # Handle input hash
        if (ref($_[0]) eq "HASH") {
            my $in = shift ;
            foreach my $var (@scalarvars,@arrayvars) {
                exists($in->{$var}) and
                    $self->$var($in->{$var}) ;
            }
        }
    }

    return $self ;
}

1;
