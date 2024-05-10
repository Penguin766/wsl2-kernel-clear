# Mainline Linux kernel for WSL2 with ClearLinux patches applied
This repo contains ready-made packages of the latest mainline Linux kernel for use in WSL2.
ClearLinux patches are applied on top of the kernel for optimizations and performance improvements
To build the kernel locally, use the build.sh script inside this repo.

# Installation instruction for prebuilt packages
1. Download the latest release of the kernel from the releases page
2. Save the kernel where you want it to be located
3. Ensure wsl is fully shut down before installing this kernel, to do that, run the `wsl --shutdown` command from a terminal
4. Create a file (if it doesn't already exist) called .wslconfig in your username's home folder `C:\Users\YOUR USERNAME\.wslconfig`
5. Add the following content to this file:
   ```
   [wsl2]
   kernel=C:\\path\\to\\kernel\\bzimage-VERSION
   ```

# ORIGINAL README - Custom Linux/x86 Kernel Configuration
Merge the last [linux kernel configuration from Microsoft for Windows Subsystem for Linux 2](https://github.com/microsoft/WSL2-Linux-Kernel/blob/linux-msft-wsl-6.1.y/Microsoft/config-wsl) with the [upstream torvalds linux sources](https://github.com/torvalds/linux/)

## Compile Mainline Kernel for WSL2
Steps for compile [Kernel Linux 6.1.y](https://github.com/microsoft/WSL2-Linux-Kernel/tree/linux-msft-wsl-6.1.y).
Can use the script `build.sh` to automate the download, configuration, and compilation of the kernel source code for WSL2

## Video Youtube
[![Compile Linux Kernel in Windows Subsystem for Linux 2](https://img.youtube.com/vi/4QSsyZsQMqE/mqdefault.jpg)](https://youtu.be/4QSsyZsQMqE)


## Actual Kernel
```bash
uname -a
Linux DESKTOP-ID 4.19.128-microsoft-standard #1 SMP Tue Jun 23 12:58:10 UTC 2020 x86_64 GNU/Linux
```

## Work dir linux
```bash
mkdir -p linux
cd linux
```

## Install requirements for Build
```bash
sudo apt install git bc build-essential flex bison libssl-dev libelf-dev dwarves
```

## Download Linux source code
```bash
wget https://github.com/torvalds/linux/archive/refs/tags/v5.15.tar.gz -O v5.15.tar.gz
```

## Untar linux sources
```bash
tar -xf v5.15.tar.gz
```

## Download config WSL
```bash
wget https://github.com/microsoft/WSL2-Linux-Kernel/raw/linux-msft-wsl-5.10.y/Microsoft/config-wsl
```

## Copy config WSL as default config to the linux config dir
```bash
cp config-wsl linux-5.15/arch/x86/configs/wsl_defconfig
```

## Generate the Configuration and Build
```bash
cd linux-5.15
make KCONFIG_CONFIG=arch/x86/configs/wsl_defconfig -j4
```

## Copy Linux kernel to YOUR_USER
```bash
powershell.exe /C 'Copy-Item .\arch\x86\boot\bzImage $env:USERPROFILE'
```

## Point to your custom kernel in .wslconfig:
```bash
powershell.exe /C 'Write-Output [wsl2]`nkernel=$env:USERPROFILE\bzImage | % {$_.replace("\","\\")} | Out-File $env:USERPROFILE\.wslconfig -encoding ASCII'
```

```
[wsl2]
kernel=C:\\Users\\<YOUR_USER>\\bzImage
```

## Shutdown WSL
```bash
wsl --shutdown
```

## Check shutdown the distro WSL
```bash
wsl -l -v
```

## Start distro
```bash
wsl -d Debian
```

## New Kernel Linux
```bash
uname -a
```

```
Linux HP450-2 5.15.0-oleksis-microsoft-standard-WSL2 #1 SMP Mon Nov 29 01:14:26 EST 2021 x86_64 x86_64 x86_64 GNU/Linux
```

