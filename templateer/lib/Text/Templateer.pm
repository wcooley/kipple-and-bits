#
# Text::Templateer - Implementation routines for 'templateer' script.
#
package Text::Templateer;

use 5.008000;
use strict;
use warnings;
use diagnostics;
require Exporter;
use base qw(Exporter);
use Carp;
use English qw( -no_match_vars );

eval q/ use List::MoreUtils qw(uniq); /;

if ($EVAL_ERROR) {
    # Taken from List::MoreUtils; use this definition if the module 
    # cannot be loaded, to prevent excess dependency on YACM.
    # This has to be a string because a block seems to be eval'd earlier (?),
    # resulting in 'Subroutine uniq redefined' messages.
    eval q/
        sub uniq (@) {
            my %h;
            map { $h{$_}++ == 0 ? $_ : () } @_;
        }
    /;
}

our %EXPORT_TAGS = ( 'all' => [ qw(
    set_flag
    clear_flag
    is_flagged
    show_keywords
    show_instance_data
    fill_keywords_from_env
    fill_template_text
    find_keywords_in
    read_template
    write_instance_file
    prompt_for_ok
    prompt_user_for_keys
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();      # Export nothing by default
our $VERSION = '1.000_00';

my %flags = (
    append      => 0,       # Append or overwrite output file
    list_only   => 0,       # List found template vars
    verbose     => 0,       # Be verbose
    prompt      => 0,       # Prompt for confirmation before writing
);

sub set_flag {
    my ($flag) = @_;
    $flags{$flag} = 1;
}

sub clear_flag {
    my ($flag) = @_;
    $flags{$flag} = 0;
}

sub is_flagged {
    my ($flag) = @_;
    return $flags{$flag}    ?   1
                            :   0
                            ;
}

#
# show_keywords - Print a line-separated list of keywords found in template.
#
# Parameters:
#   o Reference to an array of keywords.
#
# Returns nothing.
#
sub show_keywords {
    my ($keywords_ref) = @_;
    for my $key (sort @{$keywords_ref}) {
        print $key, "\n";
    }
}

#
# show_instance_data - Print line-separated list of key/data pairs.
#
# Parameters:
#   o Reference to an instance data hash
#
# Returns nothing.
#
sub show_instance_data {
    my ($instance_data_ref) = @_;

    for my $key (keys %{$instance_data_ref}) {
        print {*STDERR} "$key => $instance_data_ref->{$key}\n";
    }
}

#
# fill_keywords_from_env - Fill in data from the environment.
#
# Parameters:
#   o Reference to an array of keywords
#   o Reference to a hash to contain instance data
#
# Returns:
#   o Array of keywords not found in hash
#
sub fill_keywords_from_env {
    my ($keywords_ref, $instance_data_ref) = @_;
    my @unset_keywords;

    for my $key (@{$keywords_ref}) {
        if (exists $ENV{"TPL_" . $key}) {
            $instance_data_ref->{$key} = $ENV{"TPL_" . $key};
        } 
        else {
            push @unset_keywords, $key;
        }
    }

    return @unset_keywords;
}

# fill_template_text - Fill in template text with template variables and
#                       unquote '@'.
#
# Parameters:
#   o Template text
#   o References to instance data
#
# Returns:
#   o Filled-in template text (instance)
#
sub fill_template_text {
    my ($instance_text, $instance_data_ref) = @_;

    # Unquote '@'
    $instance_text =~ s/([^\\]?)\\\@/$1\@/gxms;

    for my $key (reverse sort keys %{$instance_data_ref}) {
        $instance_text =~  s{\@\@$key\@\@}
                            {$instance_data_ref->{$key}}gxms;
    }

    return $instance_text;
}

# find_keywords_in - Extract the keywords to be substituted from text.
#
# Parameters:
#   o Template text
#
# Returns:
#   o Array of keywords that have been found in text.
#
sub find_keywords_in {
    my ($template_text) = @_;

    my @keywords =
        ($template_text =~ m{
            [^\\]?          (?# Anything other than a backslash )
            @@              (?# Opening '@@' )
            ([^@]+)         (?# Anything other than multiple @ )
            @@              (?# Closing '@@' )
        }gcxms);

    return uniq(@keywords);
}

# read_template - Read in the template file and return contents.
#
# Parameters:
#   o Template file name
#
# Returns:
#   o Content of template file as single string
#
sub read_template {
    my ($template) = @_;
    my ($template_fh, $template_text);

    if ($template and ($template ne '-')) {
        open $template_fh, '<', $template 
            or croak "Couldn't open '$template': $OS_ERROR";
    }
    else {
        $template_fh = \*STDIN;
        $template = "stdin";
    }

    print {*STDERR} "Reading template $template...\n"
        if (is_flagged('verbose'));

    $template_text = do { local $RS; <$template_fh>; };

    close $template_fh
        or croak "Error reading from '$template': $OS_ERROR";

    return $template_text;
}

#
# write_instance_file - Writes text to a file.
#
# Parameters:
#   o Output file name
#   o Text to be written
#
# Returns nothing
#
sub write_instance_file {
    my ($outfile, $text) = @_;
    my $output_fh;

    my $mode = (is_flagged('append'))   ? '>>'    # Append
                                        : '>'     # Overwrite
                                        ;

    if ($outfile and ($outfile ne '-')) {
        open($output_fh, $mode, $outfile) 
            or croak "Couldn't open '$outfile': $OS_ERROR";
    }
    else {
        $output_fh = \*STDOUT;
        $outfile = "stdout";
    }

    print {*STDERR} "Writing to $outfile...\n" 
        if (is_flagged('verbose'));
    
    print $output_fh $text
        or croak "Error writing to '$outfile': $OS_ERROR";
    close $output_fh
        or croak "Error closing '$outfile': $OS_ERROR";
}

#
# prompt_for_ok - Prompts the user for acceptance.
#
# Parameters: None
#
# Returns:
#   1 if given acceptable input
#   undef otherwise
#
sub prompt_for_ok {
    print {*STDERR}  "Okay? (Y/n)";
    chomp (my $response = <STDIN>);
    if ($response =~ m/ (?: ^$ | \A [Yy]* \z )/xms) {
        return 1;
    }
    else {
        return;
    }
}

#
# prompt_user_for_keys - Prompts user for key data.
#
# Parameters:
#   o Reference to an array of keywords
#   o Reference to a hash to store responses
#
# Returns nothing
#
sub prompt_user_for_keys {
    my ($keywords_ref, $instance_data_ref) = @_;

    print {*STDERR}   "Kindly provide the values for "
                    . "the following template variables:\n"
                    ;
   
    # Get the info from the user
    for my $key (@{$keywords_ref}) {
        print {*STDERR} "$key = ";
        chomp (my $inval = <STDIN>);
        $instance_data_ref->{$key} = $inval;
    }
}


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Text::Templateer - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Text::Templateer;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Text::Templateer, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Wil Cooley, E<lt>wcooley@localdomainE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Wil Cooley

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
