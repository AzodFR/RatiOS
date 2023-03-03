mkfs -v -t ext4 /dev/sda3

mkswap /dev/sda2

export LFS=/mnt/lfs

echo $LFS

mkdir -pv $LFS

mount -v -t ext4 /dev/sda3 $LFS

/sbin/swapon -v /dev/sda2

mkdir -v $LFS/sources

chmod -v a+wt $LFS/sources

cd /mnt/lfs/sources/

wget http://ftp.wrz.de/pub/LFS/lfs-packages/lfs-packages-11.3.tar
wget https://ftp.gnu.org/gnu/wget/wget-1.21.1.tar.gz
wget https://github.com/djlucas/make-ca/releases/download/v1.7/make-ca-1.7.tar.xz
wget https://github.com/p11-glue/p11-kit/releases/download/0.24.0/p11-kit-0.24.0.tar.xz

tar xvf lfs-packages-11.3.tar 

cp -rf 11.3/* .

rm -rf 11.3/

ls

rm -rf lfs-packages-11.3.tar 

mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do ln -sv usr/$i $LFS/$i; done

for i in bin lib sbin; do ln -sv usr/$i $LFS/$i; done

case $(uname -m) in x86_64) mkdir -pv $LFS/lib64 ;; esac

mkdir -pv $LFS $LFS/tools

groupadd lfs

useradd -s /bin/bash -g lfs -m -k /dev/null lfs

chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}

chown -v lfs $LFS/lib64

chown -v lfs $LFS/sources