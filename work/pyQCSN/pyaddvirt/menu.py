#!/usr/bin/env python

from snack import *

def get_vhost_info():

	vhostinfo = {}

	myScreen = SnackScreen()

	entryWidth = 48 
	entryX = 0
	labelX = 0

	myGrid = Grid (2, 7)

	myGrid.setField (Label("New Domain Name:"), 0, 0, anchorLeft = 1)
	myGrid.setField (Label("Owner's username:"), 0, 1, anchorLeft = 1)
	myGrid.setField (Label("Owner's real name:"), 0, 2, anchorLeft = 1)
	myGrid.setField (Label("Disk Quota (MB):"), 0, 3, anchorLeft = 1)
	myGrid.setField (Label("Bandwidth Quota (kbps):"), 0, 4, anchorLeft = 1)
	myGrid.setField (Label("Simple bulk hosting:"), 0, 5, anchorLeft = 1)

	vhostEntry = 		Entry(entryWidth, scroll = 1, returnExit = 0)
	usernameEntry = 	Entry(entryWidth, scroll = 1, returnExit = 0)
	realnameEntry = 	Entry(entryWidth, scroll = 1, returnExit = 0)
	diskQuotaEntry = 	Entry(entryWidth, text = "10", scroll = 1, returnExit = 0)
	bandwidthQuotaEntry = Entry(entryWidth, text = "128", scroll = 1, returnExit = 0)
	bulkhostCheckbox =		Checkbox("", isOn=1)

	myGrid.setField (vhostEntry, 		1, 0, (1, 0, 0, 0))
	myGrid.setField (usernameEntry, 	1, 1, (1, 0, 0, 0))
	myGrid.setField (realnameEntry, 	1, 2, (1, 0, 0, 0))
	myGrid.setField (diskQuotaEntry, 	1, 3, (1, 0, 0, 0))
	myGrid.setField (bandwidthQuotaEntry, 	1, 4, (1, 0, 0, 0))
	myGrid.setField (bulkhostCheckbox, 	1, 5, (1, 0, 0, 0), anchorLeft=1)

	buttons = ButtonBar (myScreen, [ "Okay", "Cancel" ])

	gridF = GridForm (myScreen, "Virtual Host Addition Tool", 1, 3)
	gridF.add (myGrid, 0, 0)
	gridF.add (buttons, 0, 1)

	result = gridF.runOnce ()

	myScreen.finish()

	if buttons.buttonPressed(result) == "okay":
		vhostinfo['domain'] = vhostEntry.value()
		vhostinfo['username'] = usernameEntry.value()
		vhostinfo['realname'] = realnameEntry.value()
		vhostinfo['diskquota'] = diskQuotaEntry.value()
		vhostinfo['bandwidthquota'] = bandwidthQuotaEntry.value()
		vhostinfo['bulkhost'] = bulkhostCheckbox.selected()

	return vhostinfo

def show_reminder():

	reminderText = """Don't forget to run addvirt on Polymorph!"""

	myScreen = SnackScreen()

	ButtonChoiceWindow (myScreen, "Reminder", reminderText, 
		buttons = [ 'Ok' ])

	myScreen.finish()

def show_error_box(errormsg):
	
	myScreen = SnackScreen()

	ButtonChoiceWindow (myScreen, "Error!", errormsg,
		buttons = [ 'Exit'])

def show_output(output):

	myScreen = SnackScreen()

	ButtonChoiceWindow (myScreen, "Command Output", output,
		buttons = [ 'Ok' ])

	myScreen.finish()


if __name__ == '__main__':
	print "This is a library module.  You probably don't need to run it.  Going into testing mode."
	vhostinfo = get_vhost_info()

	if len(vhostinfo) == 0:
		print "User cancelled"

	else:
		show_reminder()
		print "Domain: %s" % vhostinfo['domain']
		print "Username: %s" % vhostinfo['username']
		print "Real name: %s" % vhostinfo['realname']
		print "Disk Quota: %s MB" % vhostinfo['diskquota']
		print "Bandwidth Quota: %s kbps" % vhostinfo['bandwidthquota']
		print "Use simple bulk hosting: ",
		if vhostinfo['bulkhost']:
			print "yes"
		else:
			print "no"

