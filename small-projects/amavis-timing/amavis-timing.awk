BEGIN {
	xstimemin=30*1000
}
/TIMING/ {
	timcnt += $9
	cnt += 1
	if ($9 > xstimemin) {
		xstime += 1
	}
	if ($9 > maxtime) {
		maxtime=$9
	}
    smtpehlo    += gensub(/^.*SMTP EHLO: ([[:digit:]]+).*$/, "\\1", "g")
    smtppremail += gensub(/^.*SMTP pre-MAIL: ([[:digit:]]+).*$/, "\\1", "g")
    smtppredataflush    += gensub(/^.*SMTP pre-DATA-flush: ([[:digit:]]+).*$/, "\\1", "g")
    smtpdata    += gensub(/^.*SMTP DATA: ([[:digit:]]+).*$/, "\\1", "g")
    bodyhash    += gensub(/^.*body hash: ([[:digit:]]+).*$/, "\\1", "g")
    mimedecode  += gensub(/^.*mime_decode: ([[:digit:]]+).*$/, "\\1", "g")
    getftype    += gensub(/^.*get-file-type: ([[:digit:]]+).*$/, "\\1", "g")
    decomppart  += gensub(/^.*decompose_part: ([[:digit:]]+).*$/, "\\1", "g")
    parts       += gensub(/^.*parts: ([[:digit:]]+).*$/, "\\1", "g")
    avscan1     += gensub(/^.*AV-scan-1: ([[:digit:]]+).*$/, "\\1", "g")
    fwdconnect  += gensub(/^.*fwd-connect: ([[:digit:]]+).*$/, "\\1", "g")
    fwdmailfrom += gensub(/^.*fwd-mail-from: ([[:digit:]]+).*$/, "\\1", "g")
    fwdrcptto   += gensub(/^.*fwd-rcpt-to: ([[:digit:]]+).*$/, "\\1", "g")
    writeheader += gensub(/^.*write-header: ([[:digit:]]+).*$/, "\\1", "g")
    fwddata     += gensub(/^.*fwd-data: ([[:digit:]]+).*$/, "\\1", "g")
    fwddataend  += gensub(/^.*fwd-data-end: ([[:digit:]]+).*$/, "\\1", "g")
    fwdrundown  += gensub(/^.*fwd-rundown: ([[:digit:]]+).*$/, "\\1", "g")
    unlink1file += gensub(/^.*unlink-1-files: ([[:digit:]]+).*$/, "\\1", "g")
    rundown     += gensub(/^.*rundown: ([[:digit:]]+).*$/, "\\1", "g")

#    print $1, $2, $3, "fwd-connect:", gensub(/^.*fwd-connect: ([[:digit:]]+).*$/, "\\1", "g")
}

END {
    print "\t* Summary *"
	print "Message count:\t\t" cnt 
	print "Total time:\t\t" timcnt " ms"
	printf "Average time:\t\t%0.2f s\n", timcnt/cnt/1000
	printf "Maximum time:\t\t%0.2f s\n", maxtime/1000
	printf "In excess of %d s:\t%d\n", xstimemin/1000, xstime

    print "\n\t* Stage Timing *"
    printf "SMTP EHLO:          %20d ms\n", smtpehlo/cnt
    printf "SMTP pre-Mail:      %20d ms\n", smtppremail/cnt
    printf "SMTP pre-DATA-flush:%20d ms\n", smtppredataflush/cnt
    printf "SMTP DATA:          %20d ms\n", smtpdata/cnt
    printf "Body Hash:          %20d ms\n", bodyhash/cnt
    printf "MIME Decode:        %20d ms\n", mimedecode/cnt
    printf "Get-File-Type:      %20d ms\n", getftype/cnt
    printf "Decompose-Parts:    %20d ms\n", decomppart/cnt
    printf "Parts:              %20d ms\n", parts/cnt
    printf "AV-scan-1:          %20d ms\n", avscan1/cnt
    printf "Forward Connect:    %20d ms\n", fwdconnect/cnt
    printf "Forward-Mail-From:  %20d ms\n", fwdmailfrom/cnt
    printf "Forward-RCPT-To:    %20d ms\n", fwdrcptto/cnt
    printf "Write-Header:       %20d ms\n", writeheader/cnt
    printf "Forward-Data:       %20d ms\n", fwddata/cnt
    printf "Forward-Data-End:   %20d ms\n", fwddataend/cnt
    printf "Forward-Rundown:    %20d ms\n", fwdrundown/cnt
    printf "Unlink-1-File:      %20d ms\n", unlink1file/cnt
    printf "Rundown:            %20d ms\n", rundown/cnt
}
