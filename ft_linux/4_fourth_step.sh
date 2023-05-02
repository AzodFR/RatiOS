tar xvf man-pages-6.03.tar.xz
cd man-pages-6.03

make prefix=/usr install

cd ../
rm -rf man-pages-6.03

tar xvf iana-etc-20230202.tar.gz
cd iana-etc-20230202

cp services protocols /etc

cd ../
rm -rf iana-etc-20230202


tar xvf glibc-2.37.tar.xz
cd glibc-2.37

patch -Np1 -i ../glibc-2.37-fhs-1.patch

sed '/width -=/s/workend - string/number_length/' \
    -i stdio-common/vfprintf-process-arg.c

mkdir -v build
cd       build

echo "rootsbindir=/usr/sbin" > configparms

../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=3.2                      \
             --enable-stack-protector=strong          \
             --with-headers=/usr/include              \
             libc_cv_slibdir=/usr/lib

# Be carefull needed to do make check before [WARN]

make -j8

make check

# http://fr.linuxfromscratch.org/view/lfs-systemd-stable/chapter08/glibc.html

cd ../
rm -rf glibc-2.37

