BEGIN {
	timcnt=0;
	cnt=0;
	maxtime=0;
	xstime=0;
	xstimemin=30*1000;	# 30 secs
}
/TIMING/ {
	timcnt=timcnt+$9;
	cnt=cnt+1;
	if ($9 > xstimemin) {
		xstime = xstime + 1
	}
	if ($9 > maxtime) {
		maxtime=$9
	}
}
END {
	print "Message count:\t" cnt 
	print "Total time:\t" timcnt " msecs"
	printf "Average time:\t%0.2f seconds\n", timcnt/cnt/1000
	printf "Maximum time:\t%0.2f seconds\n", maxtime/1000
	printf "In excess of %d seconds: %d\n", xstimemin/1000, xstime
}
