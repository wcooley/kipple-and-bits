#!/usr/bin/python

import pwd, time

def convert_return (ret):
	return (ret / 256)

def copy_file (infile, outfile):
	open(outfile, "w").writelines(open(infile).readlines())

def nice_date ():
	return time.strftime("%A, %d %B %Y", time.localtime(time.time()))

def user_exists(username):
	try:
		pwd.getpwnam(username)
	except KeyError:
		return 0
	else:
		return 1


if __name__ == '__main__':
	print "This is a library module.  You probably don't need to run it."
	print convert_return(512)
