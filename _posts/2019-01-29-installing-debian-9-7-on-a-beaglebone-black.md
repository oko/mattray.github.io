---
title: Installing Debian 9 on a BeagleBone Black
---
I previously blogged about [Installing Debian 8.6 on a BeagleBone Black](https://leastresistance.wordpress.com/2016/10/14/installing-debian-8-6-on-a-beaglebone-black/) and not too much has changed. I figured I'd post a streamlined version for my own notes.

## Getting Started

<a href="https://www.adafruit.com/product/1996"><img src="/assets/1996-01.jpg" alt="BeagleBone Black" width="235" height="228" align="right" />

Having done it a few times now, installing Debian on the <a href="https://www.adafruit.com/product/1996">BeagleBone Black</a> is fairly straightforward. Most of what I needed came from [Debian BeagleBoard instructions](https://elinux.org/BeagleBoardDebian).

## Installing the Base Image

I got my Debian BeagleBone base images from [https://rcn-ee.com/rootfs/bb.org/testing/](https://rcn-ee.com/rootfs/bb.org/testing/) because the [https://beagleboard.org/latest-images](https://beagleboard.org/latest-images) were a bit stale. I used the latest Debian stable "Stretch" IOT build for ARMHF on the BeagleBone [stretch-iot/bone-debian-9.7-iot-armhf compressed image](https://rcn-ee.com/rootfs/bb.org/testing/2019-01-27/stretch-iot/bone-debian-9.7-iot-armhf-2019-01-27-4gb.img.xz). I flashed the image onto a 32 gig microSD card with [Etcher for OSX](https://www.etcher.io/), which was quite painless.

With my microSD card ready I plugged in my micro HDMI cable, ethernet, and a USB keyboard and booted into Debian.

## Configuring Debian

The default user/password combination on Debian is `debian` and `temppwd`, which you'll want to immediately change with `passwd`.

I then copied over my SSH key so I wouldn't need to use my password when logging in.

    scp ~/.ssh/id_rsa.pub debian@10.0.0.4:~/.ssh/authorized_keys
    ssh debian@10.0.0.4
    sudo su -

### root

To ensure the latest versions of the base install:

    apt-get update
    apt-get upgrade

To set the timezone I ran:

    timedatectl set-timezone Australia/Sydney

To use the whole microSD card I followed [these instructions](http://elinux.org/Beagleboard:BeagleBoneBlack_Debian#Expanding_File_System_Partition_On_A_microSD):

    cd /opt/scripts/tools/
    git pull
    ./grow_partition.sh
    reboot

## Finishing Up

Because I've previously built [Chef for the BeagleBone Black](https://leastresistance.wordpress.com/2018/04/04/chef-14-arm-on-the-beaglebone-black/), I installed the .DEB:

    dpkg -i chef_14.5.33_armhf.deb

and bootstrapped the box with my a [home boxes cookbook](https://github.com/mattray/mattray-cookbook) and policyfile from my [home-repo](https://github.com/mattray/home-repo/):

    knife bootstrap 10.0.0.4 -x debian --sudo -N cubert --policy-group home --policy-name beaglebone

Now it was ready to use again.
