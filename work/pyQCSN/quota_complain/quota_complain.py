#!/usr/bin/python

import os.path, os, re


cfg_files = [ '/etc/quota_complain.conf',
              '/usr/local/etc/quota_complain.conf',
              'quota_complain.conf' ]

if __name__ == '__main__':

    """ Read in config files """
    for cfg in cfg_files:
        if os.path.exists(cfg):
            execfile(cfg)

    for fs in filesystems.keys():
        fh = os.popen ("%s %s" % (repquota, fs['fs_partition']), "r")
        report = fh.read()
