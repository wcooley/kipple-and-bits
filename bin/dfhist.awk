{
    fs=$1
    pf=$2
    printf fs "\t(" pf "%):\t"
    i=pf
    while (i > 0) {
        printf "#"
        i = i-5
    }
    printf "\n"
}
