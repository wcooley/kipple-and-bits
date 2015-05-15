#!/usr/bin/env python
#
# detectTicket-test.py - Test script for testing detectTicket.py
#
# Written by Wil Cooley <wcooley@nakedape.cc>
# Began 27 Jan 2009
#
# $Id$

from pprint import pprint as pp
from pprint import pformat
import re
import sys

from detectTicket import ticket_re

if '-v' in sys.argv:
    debug = True
else:
    debug = False

def test_regex(regex, string):
    match = regex.search(string)

    if debug:
        sys.stderr.write("Searching '%s'\n" % string)

    if match:
        if debug:
            sys.stderr.write("These were the matched groups:\n")
            sys.stderr.write("\t" + pformat( match.groups() ) + "\n" )
            sys.stderr.write("\t" + pformat( match.groupdict() ) + "\n")

        return True
    else:
        if debug: sys.stderr.write("No matches!\n")
        return False

def mytest(str): return test_regex(ticket_re, str)

def testRE(self):
    """
    >>> mytest("abc 7890")
    False
    >>> mytest("abc 7890")
    False
    >>> mytest("abc1234")
    False
    >>> mytest("rt123r")
    False
    >>> mytest("part123")
    False

    >>> mytest("rt1234")
    True
    >>> mytest("part#1234")
    True
    >>> mytest("foo#1234")
    True
    >>> mytest("rt1234")
    True
    >>> mytest("rt#1234")
    True
    >>> mytest("rt#    1234")
    True
    >>> mytest("rt    #    1234")
    True
    >>> mytest("#1234")
    True
    >>> mytest("  #1234")
    True
    >>> mytest("bug 23432")
    True
    >>> mytest("bug #23432")
    True
"""

def _test():
    import doctest
    doctest.testmod()

if __name__ == '__main__':
    _test()
