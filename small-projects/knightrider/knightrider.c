#include <stdio.h>
#include <sys/ioctl.h>
#include <linux/kd.h>
#include <signal.h>

#define SLEEP 150000
#define CAPS 0x4
#define NUM 0x2
#define SCRL 0x1

/* This does't quite work right.
int quit (void) {
		ioctl(0, KDSETLED, 0) ;
		return 0 ;
}

void quit_handler (int sig) {
	switch (sig) {
		default :
			quit() ;
	}
}
*/

int main (void) {

	/* signal (SIGTERM, &quit_handler) ;
	signal (SIGPIPE, &quit_handler) ;
	signal (SIGINT,  &quit_handler) ;                        */

	while (1) {
		ioctl(0, KDSETLED, NUM) ;
		usleep (SLEEP*2) ;
		ioctl(0, KDSETLED, CAPS) ;
		usleep (SLEEP) ;
		ioctl(0, KDSETLED, SCRL) ;
		usleep (SLEEP*2) ;
		ioctl(0, KDSETLED, CAPS) ;
		usleep (SLEEP) ;
	}
}
