#!/usr/bin/python
#
# bayesuck -- Script to feed SpamAssassin's sa-learn from an IMAP mailbox
#
# Written by Wil Cooley <wcooley@nakedape.cc>
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


if __name__ == '__main__':
    if os.access(rcfile, os.R_OK):
        execfile(rcfile)

    mbox = mktemp('bayesuck')

    conn = SimpleIMAP4(imap_server)    
    conn.login(imap_user, imap_passwd)
    cnt = conn.folder_to_mbox(spam_folder, mbox, False)

    os.system('sa-learn --spam --mbox %s' % mbox)

#    os.unlink(mbox)
#    conn.expunge()

    print "Fed %d messages into Bayes" % cnt
