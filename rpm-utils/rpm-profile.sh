# The following is a collection of shell aliases and functions useful for RPM
# packaging


alias rpmdu='rpm -qa --queryformat "%{SIZE} %{NAME}\n"|sort -n'

function rpmwhich {
    for f in $*; do
        ff=$(which $f 2>/dev/null)
        if [ -n "$ff" ]; then
            printf "%s: " $ff
            rpm -qf $ff
        else
           printf "'%s' not found!\n" $f 
        fi
    done
}


getspec () { 
    rpm2cpio $1 | cpio -div '*.spec' 
}

getsrc () { 
    rpm2cpio $1 | cpio -div '*.tar.gz' 
}

getpatches () { 
    rpm2cpio $1 | cpio -div '*.patch' 
}

rpmdump () { 
    rpm2cpio $1 | ( export dir=$(rpm -qp --queryformat '%{NAME}\n' $1) && mkdir $dir && cd ${dir} && cpio -div) 
}

