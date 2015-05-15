#!/usr/bin/python2
#
# dfhist.py -- df histogram printer.
# Prints a histogram representing the percentage of used
# space free on the filesystem.
#
# Written by Wil Cooley <wcooley@nakedape.cc>, 18 July 2002
#
# Copyright (C) 2002 Naked Ape Consulting
# Redistribution is permitted under the terms of the GNU
# General Public License: http://www.gnu.org/licenses/gpl.txt
#

import os, string

if __name__ == '__main__':

    hashfmt = '0%% |%s%s| 100%%\n'
    histowidth = 50
    histodiv = 100/histowidth

    df = os.popen('df -kP').readlines()

    print df[0],

    for line in df[1:]:
        (f1, f2, f3, f4, f5, f6) = string.split(line)
        perfree = string.atoi(string.replace(f5, '%', ''))
        hashcnt = perfree / histodiv
        if ((perfree%histodiv) != 0): hashcnt+=1
        print line, 
        print hashfmt % (hashcnt*'#', (histowidth-hashcnt)*' ')
            

