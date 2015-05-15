#!/usr/bin/python

import os

pin = os.popen("cat /etc/motd", "r")

print pin.read()

ret = pin.close()

if ret == None:
	ret = 0
else:
	ret = ret/256

print "Return: ", ret
