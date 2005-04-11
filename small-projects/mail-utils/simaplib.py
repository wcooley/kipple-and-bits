#!/usr/bin/python
#
# simaplib - Simplified IMAP library.
#
# Written by Wil Cooley <wcooley@nakedape.cc>
#   2004-11-06
#

import imaplib, string, mailbox, email

class SimpleIMAP4(imaplib.IMAP4):
    def list_sub_folders(self, directory='""', pattern='*'):
        """
        list_sub_folders - A simplified wrapper around imaplib.lsub().

        Returns just an list of strings of folder names.  Note that
        the folder names may have spaces in them and the folder paths are
        separated with whatever the IMAP server uses by default.

        Arguments:
            directory, pattern - Args for lsub()

        """
        folders = []

        for f in self.lsub(directory, pattern)[1:][0]:
            folders.append(string.split(f, None, 2)[2].strip('"'))

        return folders

    def _sanitize_msg(self, msg):
        msg = msg.replace('\r', '')
        return email.message_from_string(msg).as_string(True)

    def list_msgs_by_uid(self):
        return self.uid('SEARCH', 'ALL')[1][0].split()

    def get_flags_by_uid(self, uid):
        (f,x) = self.uid('FETCH', uid, '(FLAGS)'[1][0])
        return imaplib.ParseFlags(f)

    def get_msg_by_seq(self, seq):
        (m,x) = self.fetch(seq, '(RFC822)')[1:][0]
        return self._sanitize_msg(m[1])
        
    def get_msg_by_uid(self, uid):
        (m,x) = self.uid('FETCH', uid, '(RFC822)')[1:][0]
        return self._sanitize_msg(m[1])

    def delete_by_seq(self, seq):
        self.store(seq, '+FLAGS.SILENT', r'(\Deleted)')

    def delete_by_uid(self, uid):
        self.uid('STORE', uid, '+FLAGS.SILENT', r'(\Deleted)')

    def folder_to_mbox(self, folder, mboxfile, delete=False):
        """
        folder_to_mbox - Reads messages from an IMAP folder and writes 
            them to an mbox file.  Optionally flags messages as deleted after
            extracting them.  It does not expunge so messages are preserved in
            case of error later.

        Arguments:
            folder - String of IMAP folder name.
            mboxfile - String of mbox file name.
        """

        mbox = file(mboxfile, 'w')
        self.select(folder)

        ids = self.list_msgs_by_uid()

        for id in ids:
            mbox.write(self.get_msg_by_uid(id))
            if delete: self.delete_by_uid(id)

        mbox.close()

        return len(ids)

# EOF simaplib.py
if __name__ == '__main__':
    import getpass,sys
    conn = SimpleIMAP4()
    sys.stdout=sys.__stderr__
    conn.login(getpass.getuser(), getpass.getpass())
    sys.stdout=sys.__stdout__

    conn.select('user.spamtrap')

    conn.folder_to_mbox('user.spamtrap', '/tmp/mboxtest')
