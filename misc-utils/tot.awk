#!/usr/bin/awk -f -
#
# tot.awk - Script to compute the total of the first field of a series of lines
# and print it at the end. Particularly useful after ... |sort|uniq -c|sort -n
#
# Written by Wil Cooley <wcooley@nakedape.cc>
#

{
    tot=tot+$1
    print
}
END {
    printf "%6d total\n", tot
}
