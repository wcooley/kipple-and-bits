use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'suck-ftp',
    AUTHOR              => 'Wil Cooley <wcooley@nakedape.cc>',
    VERSION_FROM        => 'bin/suck-ftp',
    ABSTRACT_FROM       => 'bin/suck-ftp',
    EXE_FILES           => [ 'bin/suck-ftp' ],
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'        => 0,
        'Net::FTP::Simple'  => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'suck-ftp-*' },
);
