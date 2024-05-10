#!/bin/bash
# Step by Step Guide: How to quickly build a trimmed Linux kernel
# https://www.leemhuis.info/files/misc/How%20to%20quickly%20build%20a%20trimmed%20Linux%20kernel%20%E2%80%94%20The%20Linux%20Kernel%20documentation.html

# Requirements for Debian/Ubuntu
#sudo apt install -y git bc build-essential flex bison openssl libssl-dev libelf-dev dwarves
#sudo apt install -y binutils gcc make pahole perl-base

# [Install build requirements](https://www.leemhuis.info/files/misc/How%20to%20quickly%20build%20a%20trimmed%20Linux%20kernel%20%E2%80%94%20The%20Linux%20Kernel%20documentation.html#install-build-requirements)

# Requirements for Windows
# Windows Powershell CLI
# %SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe

# Fail on errors.
set -e

mkdir -p linux
pushd linux

linux_url="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.8.9.tar.xz"
kernelversion=6.8.9

echo -n "Housekeeping..."
rm -rf ./build
rm -rf ./linux-6.8.9
rm -rf ./patches
echo ""

if [[ ! -d ./linux-6.8.9 ]]; then
	mkdir -p ./build
	echo "Fetching kernel..."
	wget -O ${kernelversion}.tar.xz ${linux_url}
	echo "Extracting kernel archive..."
	tar xf ${kernelversion}.tar.xz
	cd linux-6.8.9/
else
	mkdir ./build
	cd linux-6.8.9/
fi

linux_version=v$(make -s kernelversion)

echo -n "Copy custom default config..."
cp -f ../../Microsoft/config-wsl ../build/.config
echo ""

echo -n "Cloning ClearLinux patchset..."
git clone https://github.com/Penguin766/wsl-kernel-patches -b main ../patches

echo -n "Applying ClearLinux patches..."
for patch in ../patches/*.patch; do
  patch -Np1 < "$patch"
done

_start=$SECONDS

make O=../build/ olddefconfig
make -j $(nproc --all) O=../build/

_elapsedseconds=$(( SECONDS - _start ))
TZ=UTC0 printf 'Kernel builded: %(%H:%M:%S)T\n' "$_elapsedseconds"
echo "Kernel build finished: $(date -u '+%H:%M:%S')"

powershell.exe /C 'Copy-Item -Force ..\build\arch\x86\boot\bzImage $env:USERPROFILE\bzImage-'$linux_version
powershell.exe /C 'Write-Output [wsl2]`nkernel=$env:USERPROFILE\bzImage-'$linux_version' | % {$_.replace("\","\\")} | Out-File $env:USERPROFILE\.wslconfig -encoding ASCII'

popd
