#!/usr/bin/env python
#
# Mailman.Lists - Collection-oriented interfaces for lists
#

import sys
sys.path.append('/usr/lib/mailman')
sys.path.append('/var/lib/mailman')

from Mailman import MailList
from Mailman import Site

def all_lists(lock=False):
    for listname in Site.get_listnames():
        yield MailList.MailList(listname, lock)

