/*
 *  knightrider.c
 *
 *  It's called "Knightrider" because it makes the Num Lock, Caps Lock,
 *  and Scroll Lock blink on and off in a pattern similar to the lights
 *  on the front of (the original) Knightrider car.
 *
 *  Wil made this because he wanted a way to know whether he had new mail
 *  without turning on his monitor, which he says can lead him into
 *  temptation.  (ie: Away from his study books.)  He uses WindowMaker,
 *  and a little app called `wmmail', which can run a program when you
 *  get new mail.  So, it runs this program for him.  By default,
 *  double-clicking on the mail icon starts an xterm with Pine; Wil
 *  prepended 'killall knightrider ;' to kill the blinking.
 *
 *  This is compatible with `tleds', and both can be run at the same
 *  time.  So, you can have blinkers when there's modem or network
 *  traffic, and chasers if you got some mail.  The patterns are
 *  distinct.
 *
 *  For a nicer way to read your mail, if you're tired of `pine', you
 *  might like to see if Karl's `moz-XE' package contains anything you
 *  could stick together and make your `wmmail' icon open up Gnus or VM
 *  for you. :-)  It's a kit.
 *
 *
 *   (c) 1998  W. Reilly Cooley, Esq. <wcooley@nakedape.ml.org>
 *             http://nakedape.ml.org
 *
 *   (c) 1998  Karl M. Hegbloom <karlheg@debian.org>
 *             http://www.inetarena.com/~karlheg/
 *
 *   GPL - This program is free software ...   http://www.gnu.org/
 *
 *  -------------------------------------------------------------------
 * lclint +posixlib -retvalint -exportlocal knightrider.c
 * cc -g -O2 -Wall -o knightrider knightrider.c
 * chown root.root knightrider
 * chmod u+s knightrider
 */

#define _GNU_SOURCE 1
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <signal.h>
#include <sys/ioctl.h>
#include <linux/kd.h>

volatile sig_atomic_t fatal_error_in_progress = 0;
char                  saved_led_state;

/*
 *  There are inconsistencies between the documentation and the headers
 *  for the return type of signal handlers.  The Libc TeXinfo says that
 *  you should use `sighandler_t' and `man signal' says it's `void'.
 *
 *  When I defined `quit_handler()' to return a `sighandler_t', the
 *  compiler warned about "passing arg 2 of `signal' from incompatible
 *  pointer type".
 *
 *  I think that `sighandler_t' is more correct, for portablility, and
 *  that there's currently a bug in both the `signal(2)' man page and the
 *  glibc2 <signal.h>.  Please advise.
 *
 *  The example shown in (Info-goto-node "(libc)Termination in Handler")
 *  is not right (?when -D_GNU_SOURCE).  The signal must be retargeted to
 *  SIG_DFL before you re-raise it, or it will just loop back into the
 *  handler, as near as I can tell.
 *
 */
/* sighandler_t */
void
quit_handler (int sig)
{
/*
 *  See: (Info-goto-node "(libc)Termination Signals")
 *       (Info-goto-node "(libc)Termination in Handler")
 *       (Info-goto-node "(libc)Nonreentrancy")
 */
	if (fatal_error_in_progress != 0) return;
	fatal_error_in_progress++;

	signal (sig, SIG_DFL);

	switch (sig) {
	default :
	        ioctl(0, KDGKBLED, &saved_led_state);
		ioctl(0, KDSETLED, &saved_led_state);
		raise (sig);
		break;
	}
}

int
main (void)
{
	int fd;

	/* ioctl() needs an open file descriptor, and the KD* ones
           need one opened on /dev/console.  You will need permissions. */
	if ((fd = open ("/dev/console", 0)) < 0) {
		perror ("Cannot open /dev/console");
		exit (EXIT_FAILURE);
	}

	dup2 (fd, 0);
	/*	if (fd != 1) close (1);
		if (fd != 2) close (2); */

	signal (SIGTERM, quit_handler);
	signal (SIGINT,  quit_handler);                       
	signal (SIGHUP,  quit_handler);

	/* ? Is there a pipe to this program? */
	signal (SIGPIPE, quit_handler);

	ioctl (0, KDGETLED, &saved_led_state);
        ioctl (0, KDGKBLED, &saved_led_state);

/* This is a safe blink frequency known *not* to cause epileptic seizures
 * or migraine headaches in laboratory geeks or email robots. */
#define BLINK 120000

	for (;;) {
		ioctl (0, KDSETLED, saved_led_state | LED_NUM);
		usleep (BLINK);
		ioctl (0, KDSETLED, saved_led_state | LED_NUM | LED_CAP);
		usleep (BLINK);
		ioctl (0, KDSETLED, saved_led_state | LED_CAP | LED_SCR);
		usleep (BLINK);
		ioctl (0, KDSETLED, saved_led_state & ~LED_NUM);
		usleep (2 * BLINK);
		ioctl (0, KDSETLED, saved_led_state & ~LED_CAP);
		usleep (2 * BLINK);
		ioctl (0, KDSETLED, saved_led_state & ~LED_SCR);
		usleep (2 * BLINK);
	}

/* 	raise (SIGSALARY); */
}

/*
  Local Variables:
  c-indentation-style: "linux"
  End:
*/
