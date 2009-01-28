#!/usr/bin/env python
#
# screensaverAutoAway.py - X-Chat script to monitor for the DBUS message
# emitted when the screensaver is activated and de-activated and set the user
# away.
#

# To install:
#  o Copy this file to your ~/.xchat2/ directory and it will be loaded on startup.
#  o To load without restart, run: /py load screensaverAutoAway.py
#    (If you don't want to put it in your ~/.xchat2, then specify the full path.)
#
# If running the '/py' command above results in a message 'py :Unknown command',
# then you do not have the Python plugin installed.

# Written by Wil Cooley <wcooley@nakedape.cc>
# Began 26 Aug 2008
#
# $Id$

import dbus
from dbus.mainloop.glib import DBusGMainLoop

try:
    import xchat
except ImportError:
    # Allow for external tests
    pass

__author__              = 'Wil Cooley <wcooley at nakedape.cc>'
__module_name__         = 'screensaverAutoAway'
__module_version__      = '0.2'
__module_description__  = 'Sets user away when the GNOME screensaver is activated'


def screensaver_changed(state):
    ''' Called when screensaver stops or starts 
        state is either:
         - True:  Screensaver activated
         - False: Screensaver deactivated
    '''

    if state:
        set_away()
    else:
        set_back()

def set_away():
    away_msg = '%s (Auto-away by %s, version %s)' % \
                    (xchat.get_prefs('away_reason'), 
                            __module_name__ , 
                            __module_version__)
                    
    if xchat.get_info('away') is None:
        xchat.command('away ' + away_msg)

def set_back():
    if xchat.get_info('away') is not None:
        xchat.command('back')

def setup_session():
    DBusGMainLoop(set_as_default=True)
    sesbus = dbus.SessionBus()
    sesbus.add_signal_receiver(screensaver_changed, 
            'SessionIdleChanged', 'org.gnome.ScreenSaver')

if __name__ == '__main__':

    setup_session()
    xchat.prnt('%s version %s by %s loaded' % \
                (__module_name__, __module_version__, __author__) )
