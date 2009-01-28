#!/usr/bin/env python
#
# detectTicket.py - X-Chat script to detect references to a request or bug
# number and print for the user the URL to that request, which can then be
# easily reached by right-click.
#
# Written by Wil Cooley <wcooley@nakedape.cc>
# Began 27 Jan 2009
#
# $Id$

# TODO:
#  o Should be able to configure url_sub on a per-channel basis
#  o Should store configuration outside of script

# Change this for your local bug tracker
url_sub = 'https://support.oit.pdx.edu/Ticket/Display.html?id=%s'

from pprint import pformat
import re

try:
    import xchat
except ImportError:
    # Allow for external tests
    pass

__author__              = 'Wil Cooley <wcooley at nakedape.cc>'
__module_name__         = 'detectTicket'
__module_version__      = '0.1'
__module_description__  = 'Prints URLs upon mention of ticket or bug numbers'

# See detectTicket-test.py for samples of what should and should not match.
ticket_re = re.compile(
        r""" 
            (?P<prefix> 
                (?# Non-hash prefixes start on a word boundary)
                    \b
                (?# Match any one of these leading prefixes )
                    (?: rt | bug | bz | tkt | req )
                (?# Followed possibly by space and a '#' )
                    [\s]* [#]?
            |
                (?# If none of the prefixes match, a single '#' is enough.
                    Using \b before the [#] causes this pattern to fail.)
                    [#]
            )
            [\s]*
            (?P<ticketno> [\d]+ )
            \b
        """,
        re.IGNORECASE | re.VERBOSE
    )

# For some events, the text you want might not be in word[1]
EVENTS = [
    ("Channel Message",             1),
    ("Channel Msg Hilight",         1),
    ("Private Message",             1),
    ("Private Message to Dialog",   1),
    ("Your Message",                1),
]


def ticketsub_cb(word, word_eol, userdata):

    ticketno    = None
    event, pos  = userdata
    text        = word[pos]

    matches = ticket_re.finditer(text)

    for match in matches:
        ticketno = match.group('ticketno')
        xchat.prnt("Ticket: " + url_sub % ticketno)
        
    else:
        if ticketno is None:
            xchat.prnt("Did not match: " + text)

    return xchat.EAT_NONE



if __name__ == '__main__':

    for e in EVENTS:
        xchat.hook_print(e[0], ticketsub_cb, e)

    xchat.prnt('%s version %s by %s loaded' % \
                ( __module_name__, __module_version__, __author__,) )
