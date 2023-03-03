# ft_linux

## Host Machine

[Ubuntu 22.04.2 (amd64)](https://releases.ubuntu.com/22.04.2/ubuntu-22.04.2-desktop-amd64.iso)

## VM Software

[Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Setup VM

- Allow 80Gb of disk to the machine
- At least 16Gb of RAM
- The more cores you can

At the launch, do not INSTALL it, but choose "Try Ubuntu" to make it a LiveCD version

## How to setup SSH

### Port Forwarding

If you know your VirtualBox IP, it may not change go directly to the Port Forwarding
If not follow this:

```
sudo su
apt install -y net-tools
ifconfig
```

Keep the address in mind and turn off the machine

Go to the machine settings, Network, Advanced, Port Forwarding

Add a new rule with: Random Rule Name | 127.0.0.1 | 2222 | Machine's IP | 22

Turn on the machine, still in LiveCD

### Setup OpenSSH

```
sudo su
apt install -y openssh-server
echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config
systemctl restart sshd
```

Now you can use whatever SSH you want with `ssh -p 2222 ubuntu@127.0.0.1`

No password is required, but if you already used this method on other machine, make sure to edit your .ssh/known_hosts and delete the line of 127.0.0.1

## Setup LFS Host

We need to install some missing packages and remake symlink

`nano /etc/apt/sources.list`

add `universe multiverse` at the end of the second line

### Installing packages

```
apt update
apt install -y gcc g++ texinfo gawk binutils bison make m4 build-essential
rm -f /bin/sh
ln -s /bin/bash /bin/sh
```

Once done make sure everything is ok

### Testing

```
cat > version-check.sh << "EOF"
#!/bin/bash
export LC_ALL=C
bash --version | head -n1 | cut -d" " -f2-4
MYSH=$(readlink -f /bin/sh)
echo "/bin/sh -> $MYSH"
echo $MYSH | grep -q bash || echo "ERROR: /bin/sh does not point to bash"
unset MYSH
echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-
bison --version | head -n1
if [ -h /usr/bin/yacc ]; then
echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
elif [ -x /usr/bin/yacc ]; then
echo yacc is `/usr/bin/yacc --version | head -n1`
else
echo "yacc not found"
fi
echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2
diff --version | head -n1
find --version | head -n1
gawk --version | head -n1
if [ -h /usr/bin/awk ]; then
echo "/usr/bin/awk -> `readlink -f /usr/bin/awk`";
elif [ -x /usr/bin/awk ]; then
echo awk is `/usr/bin/awk --version | head -n1`
else
echo "awk not found"
fi
gcc --version | head -n1
g++ --version | head -n1
grep --version | head -n1
gzip --version | head -n1
cat /proc/version
m4 --version | head -n1
make --version | head -n1
patch --version | head -n1
echo Perl `perl -V:version`
python3 --version
sed --version | head -n1
tar --version | head -n1
makeinfo --version | head -n1 # texinfo version
xz --version | head -n1
echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ]
then echo "g++ compilation OK";
else echo "g++ compilation failed"; fi
rm -f dummy.c dummy
EOF
```

`bash version-check.sh`

No error should appear

### Partition creation

`cfdisk`

Select gpt and now you should have 80Gb of space available.
Create:

• 1Mb of Bios boot (/dev/sda1)
• 8Gb of Linux swap (/dev/sda2)
• 71,99 Gb  of Linux filesystem (/dev/sda3)

Don't forget to Write it before Quitting

## First Step

Now, still as root you can copy paste the following code to create the /mnt/lfs and downloading every required packages

[1_first_step.sh](https://github.com/AzodFR/RatiOS/ft_linux/1_first_step.sh)

After this you need to set a password to lfs user

`passwd lfs`

You can just set it blank by entering Enter 2 times, but you need to do it

Now connect to this user with

`su - lfs`

## Second Step

/!\ Make sur you are connected with lfs user, not the root

You can now copy paste the following code, it may take a while but everything must be done

(You can change every `make -j5` with the number of allocated cores, if you have 8 cores on this machine, use -j8)

[2_second_step.sh](https://github.com/AzodFR/RatiOS/ft_linux/2_second_step.sh)