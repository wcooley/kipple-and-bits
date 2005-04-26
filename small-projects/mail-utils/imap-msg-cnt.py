#!/bin/env python2
#
# File:     imap-msg-cnt.py
#
# Author:   Wil Cooley <wcooley@nakedape.cc>
#
# $Id$

"""Counts the number of messages and folders in an IMAP
server."""

import imaplib, string, getopt, sys, readline, os, getpass

def getargs():
    """Processes command-line arguments and returns a tuple of
    hostname, username, password, totalonly"""

    lopts= ["hostname=", "help", "version", "username=", "password=", \
        "total-only"]
    shopts="h:Vu:p:t"
    def_hostname="localhost"
    def_username=os.getlogin()
    hostname=None
    username=None
    password=None
    totalonly=False

    try:
        opts, args = getopt.getopt(sys.argv[1:], shopts, lopts)
    except getopt.GetOptError:
        usage()
        sys.exit(2)

    for o, a in opts:
        if o in ("--help",):
            usage()
            sys.exit(0)
        if o in ("-V", "--version"):
            print "Version 0.1"
            sys.exit(0)
        if o in ("--hostname", "-h"):
            hostname=a
        if o in ("--username", "-u"):
            username=a
        if o in ("--password", "-p"):
            password=a
        if o in ("--total-only", "-t"):
            totalonly=True

    if hostname==None:
        hostname=raw_input("IMAP Host (%s): " % def_hostname)
        if hostname=="":
            hostname=def_hostname
    if username==None:
        username=raw_input("Username (%s): " % def_username)
        if username=="":
            username=def_username 
    if password==None:
        password=getpass.getpass()

    return (hostname, username, password, totalonly)

def usage():
    print "Usage: FOO"

if __name__ == "__main__":

    (hostname, username, password, t) = getargs()

    folder_cnt = 0
    message_cnt = 0
    flist = []

    M = imaplib.IMAP4(hostname)
    M.login(username, password)

    for folder in M.list()[1]:
        f = string.split(folder, None, 2)[2].strip('"')
        flist.append(f)  

    for f in flist:
        try:
            n = int(M.select(f)[1][0])
            folder_cnt += 1
            message_cnt += n
            if not t:
                print "%-45s: %d" % (f, n)
#        except: raise
        except M.readonly:
            print "%-45s: unavailable" % f 


    M.close()

    print "%s messages in %s folders" % (message_cnt,folder_cnt)
