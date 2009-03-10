#!/usr/bin/env python
#
#
# MailmanListVisit
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

    def __init__(self):
        self.lock = False

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

if __name__ == '__main__':
#    v = VisitorPrintName()
    v = VisitorCollectSiteSubscriberList()

    v.visit_lists()

    print "There are %d unique subscribers" % v.get_size()

#    for member in v.get_members(): print member
