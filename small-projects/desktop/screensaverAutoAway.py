#!/usr/bin/env python
#
# screensaverAutoAway.py - X-Chat script to monitor for the DBUS message
# emitted when the screensaver is activated and de-activated and set the user
# away.
#

# Written by Wil Cooley <wcooley@nakedape.cc>
# Began 26 Aug 2008
#
# $Id$

import dbus
from dbus.mainloop.glib import DBusGMainLoop
import xchat

__module_name__ = 'screensaverAutoAway'
__module_version__ = '0.1'
__module_description__ = 'Sets user away when the GNOME screensaver is activated'
__author__ = 'Wil Cooley <wcooley@nakedape.cc>'

away_msg = 'Auto-away by ' + __module_name__

def screensaver_changed(state):
    ''' Called when screensaver stops or starts 
        state is either:
         - True: Screensaver activated
         - False: Screensaver deactivated
    '''

    if state:
        xchat.prnt("Screensaver activated")
        set_away()
    else:
        xchat.prnt("Screensaver deactivated")
        set_back()

def set_away():
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

setup_session()
xchat.prnt(__module_name__ + ' version ' + __module_version__ + ' loaded ')
