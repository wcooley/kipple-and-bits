
use Webmin;
use strict;

package DirMgr::TestUtil;

sub dump_html {
    shift;
    Webmin::header;
    print "<pre>\n";
    print $_, "\n" for @_;
    print "</pre>\n";
    Webmin::footer;
}

1;
