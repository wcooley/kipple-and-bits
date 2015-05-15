#!/usr/bin/python

import curses

myscreen = curses.initscr()

curses.noecho()
curses.cbreak()

# keypad() doesn't seem to work in 1.5.2
#curses.keypad(1)

begin_x = 2 ; begin_y = 2
height = 5 ; width = 40
win = curses.newwin(height, width, begin_y, begin_x)

myscreen.border()
myscreen.addstr ( 2,3, "Test", curses.A_REVERSE)

myscreen.addstr ( 0,3, "Title")

win.refresh()
myscreen.refresh()

while 1:
	c = myscreen.getch()
	if c == ord('q'): break
	

# Reset the terminal
curses.nocbreak()
#curses.keypad(0)
curses.echo()

curses.endwin()


