#!/usr/bin/env python
#
#
# MailmanListVisitor
# Maybe this should be an Iterator instead?
#
""" Module implementing a Visitor pattern for walking Mailman mailing lists.
"""

__author__  = 'Wil Cooley <wcooley@nakedape.cc>'
__version__ = '0.1'

import sys
sys.path.append('/usr/lib/mailman')
sys.path.append('/var/lib/mailman')


import Mailman.MailList
import Mailman.Utils


class MailmanListVisitor(object):

    def __init__(self, lock=False):
        self.lock = lock

    def visit(self, listobj):
        pass

    def needs_lock():
        return self.lock

    def visit_lists(self, exclude_lists=[]):
        for listname in Mailman.Utils.list_names():
            if listname in exclude_lists:
                continue

            self.visit( Mailman.MailList.MailList(listname, self.lock) )

class VisitorCollectSiteSubscriberList(MailmanListVisitor):

    def __init__(self):
        MailmanListVisitor.__init__(self)
        self.members = set()

    def visit(self, list):
        self.members.update(list.getMembers())

    def get_size(self):
        return len(self.members)

    def get_members(self):
        return self.members

class VisitorPrintListName(MailmanListVisitor):

    def visit(self, list):
        print list.real_name

class VisitorList(MailmanListVisitor):

    def __init__(self, visitors=[]):
        MailmanListVisitor.__init__(self)
        self.visitors = visitors

    def add_visitor(self, visitor):
        self.visitors.append(visitor)

    def visit(self, listobj):
        for v in self.visitors:
            v.visit(listobj)

class VisitorCheckArchiveStatus(MailmanListVisitor):

    def __init__(self):
        MailmanListVisitor.__init__(self)
        self.archive = 0
        self.archive_private = 0
        self.total_lists = 0

    def visit(self, list):
        self.total_lists += 1
        if list.archive == True or list.archive == 1:
            self.archive += 1
        if list.archive_private == True or list.archive_private == 1:
            self.archive_private += 1

    def get_archive_stats(self):
        return ( self.total_lists,
                self.archive,
                self.archive_private,
                )

if __name__ == '__main__':
#    v = VisitorPrintName()
    v = VisitorCheckArchiveStatus()

    v.visit_lists()

    stats = v.get_archive_stats()

    print "Of %d lists, %d have archives and %d have private archives" % stats

#    print "There are %d unique subscribers" % v.get_size()

#    for member in v.get_members(): print member
