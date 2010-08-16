#!/usr/bin/python
#
# bayesuck -- Script to feed SpamAssassin's sa-learn from an IMAP mailbox
#
# Written by Wil Cooley <wcooley@nakedape.cc>
#
# Requires simaplib.py from mail-utils
#

import os, os.path
from tempfile import mktemp
from simaplib import SimpleIMAP4

# Set these here or in the rc file
rcfile          = os.path.join(os.environ['HOME'], '.bayesuckrc')
imap_server     = None
imap_user       = None
imap_passwd     = None
spam_folder     = None
ham_folder      = None


if __name__ == '__main__':
    if sys.argv[1] == '-q':
        quiet = True 
    else
        quiet = False

    if os.access(rcfile, os.R_OK):
        execfile(rcfile)

    mbox = mktemp('bayesuck')

    conn = SimpleIMAP4(imap_server)    
    conn.login(imap_user, imap_passwd)

    if spam_folder is not None:
        spam_cnt = conn.folder_to_mbox(spam_folder, mbox, False)
        os.system('sa-learn --spam --mbox %s' % mbox)

    if ham_folder is not None:
        ham_cnt = conn.folder_to_mbox(ham_folder, mbox, False)
        os.system('sa-learn --ham --mbox %s' % mbox)

    os.unlink(mbox)
    conn.expunge()

    if not quiet:
        print "Fed %d spam and %d ham messages into Bayes" % ( spam_cnt, ham_cnt )
