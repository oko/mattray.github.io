---
title: Installing Debian 10 on a BeagleBone Black
---
I previously blogged about [Installing Debian 9.7 on a BeagleBone Black](/2019/01/29/installing-debian-9-7-on-a-beaglebone-black) and there's been a major release of [Debian 10 'Buster'](https://www.debian.org/News/2019/20190706) in the meantime.

## Getting Started

<a href="https://www.adafruit.com/product/1996"><img src="/assets/1996-01.jpg" alt="BeagleBone Black" width="235" height="228" align="right" />

Installing Debian on the <a href="https://www.adafruit.com/product/1996">BeagleBone Black</a> is fairly straightforward. Most of what I needed came from [Debian BeagleBoard instructions](https://elinux.org/BeagleBoardDebian).

## Installing the Base Image

I got my Debian BeagleBone base images from [https://rcn-ee.com/rootfs/bb.org/testing/](https://rcn-ee.com/rootfs/bb.org/testing/) because the [https://beagleboard.org/latest-images](https://beagleboard.org/latest-images) were quite stale. I used the latest Debian stable "Stretch" IOT build for ARMHF on the BeagleBone [buster-iot/bone-debian-10.0-iot-armhf compressed image](https://rcn-ee.com/rootfs/bb.org/testing/2019-09-01/buster-iot/bone-debian-10.0-iot-armhf-2019-09-01-4gb.img.xz). I flashed the image onto a 32 gig microSD card with [Balena Etcher for OSX](https://www.balena.io/etcher/), which was quite painless.

With my microSD card ready I plugged in my micro HDMI cable, ethernet, and a USB keyboard and booted into Debian.

## Configuring Debian

The default user/password combination on Debian is `debian` and `temppwd`, which you'll want to immediately change with `passwd`.

I then copied over my SSH key so I wouldn't need to use my password when logging in.

    ssh-copy-id debian@10.0.0.4

### root

To ensure the latest versions of the base install:

    apt-get update
    apt-get upgrade

To set the hostname I ran:

    hostnamectl set-hostname cubert.bottlebru.sh

To set the timezone I ran:

    timedatectl set-timezone Australia/Sydney

To use the whole microSD card I followed [these instructions](http://elinux.org/Beagleboard:BeagleBoneBlack_Debian#Expanding_File_System_Partition_On_A_microSD):

    cd /opt/scripts/tools/
    git pull
    ./grow_partition.sh
    reboot

## Finishing Up

Because I've previously built [Chef 15.1 for the BeagleBone Black](/2019/07/02/chef-15-on-arm), I installed the .DEB:

    dpkg -i chef_15.1.36_armhf.deb

and bootstrapped the box with my a [home boxes cookbook](https://github.com/mattray/mattray-cookbook) and policyfile from my [home-repo](https://github.com/mattray/home-repo/):

    knife bootstrap 10.0.0.4 -x debian --sudo -N cubert --policy-group home --policy-name beaglebone

Now it was ready to use again.
