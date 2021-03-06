#!/bin/bash
set -euo pipefail
. ~/.mailenv
. ~/.tadasenv
rel=$1
pwd=$PWD
export tsprefix=${HOME}/.pkgsrc/root.$rel
export MANPATH=$tsprefix/man:$MANPATH
export PATH=$tsprefix/bin:$tsprefix/sbin:/usr/bin:/bin:/usr/sbin:/sbin

builddir=/dev/shm/tadas/pkgsrc/$rel
rm -rf $builddir $tsprefix
mkdir -p $builddir
cd $builddir
if [ ! -f /usr/bin/gcc ]; then
 export PATH=$PATH:$builddir/gcc48/bin
 xzcat ~/.pkgsrc/dist/gcc48el5.tar.xz | tar -x
fi

xzcat ~/.pkgsrc/dist/$rel/pkgsrc.tar.xz | tar -x --strip-components=1
cd bootstrap
CFLAGS="-U_FORTIFY_SOURCE" ./bootstrap --prefer-pkgsrc yes --make-jobs=10 --unprivileged --prefix=$tsprefix

cp -a $pwd/mk.conf $tsprefix/etc/mk.conf
sed -i 's,$tsprefix,'"$tsprefix"',g; s,$pwd,'"$pwd,g" $tsprefix/etc/mk.conf

cd $builddir/lang/gcc48
bmake install
export PATH=$tsprefix/bin:$tsprefix/sbin:/usr/bin:/bin:/usr/sbin:/sbin
sed -ri '/GCC_REQD|USE_TOOLS/s,^#+,,' $tsprefix/etc/mk.conf

cd $builddir/textproc/urlview
bmake install

cd $builddir/security/gnupg
bmake install

cd $builddir/devel/py-cython
bmake install

cd $builddir/devel/git
bmake install

cd $builddir/devel/subversion-base
bmake install

cd $builddir/devel/git-svn
bmake install

cd $builddir/devel/reposurgeon
bmake install

cd $builddir/time/py-vdirsyncer
bmake install

cd $builddir/time/khal
bmake install

cd $builddir/misc/tmux
bmake install

cd $builddir/sysutils/fdupes
bmake install

cd $builddir/converters/dos2unix
bmake install

cd $builddir/mail/maildrop
bmake install

cd $builddir/mail/procmail
bmake install

cd $builddir/mail/msmtp
bmake install

cd $builddir/mail/getmail
bmake install

cd $builddir/security/gpgme
git apply -p2 $pwd/gpgme.patch
cd $builddir/mail/mutt
bmake install

cd $builddir/mail/notmuch
git apply -p2 $pwd/notmuch.patch
bmake install

cd $builddir/www/w3m
bmake install

cd $builddir/www/surfraw
bmake install

cd $builddir/textproc/html2text
bmake install

cd $builddir/converters/docx2txt
bmake install

#cd $builddir/archivers/p7zip
#bmake install

cd $builddir/mail/mb2md
bmake install

cd $builddir/databases/lbdb
git apply -p2 $pwd/lbdb45.1.patch
bmake install

cd $builddir/pkgtools/pkg_alternatives
bmake install
pkg_alternatives manual python36

sed -i "s,/usr/bin/mutt,$tsprefix/bin/mutt," $tsprefix/bin/url_handler.sh
sed -i '/SURFRAW_duckduckgo_base_url/s,www.,,; s/kd=1/kd=-1/' $tsprefix/lib/surfraw/duckduckgo
if [ ! -f $tsprefix/etc/openssl/certs/ca-certificates.crt ]; then
 mozilla-rootcerts install
fi

pip install xlsx2csv

cp -a $pwd/tadaspkg $builddir/devel
cd $builddir/devel/tadaspkg
bmake install

echo -e '\a' done haha
# ./pkg_info -u - list user installed packages (manually selected, not deps)
