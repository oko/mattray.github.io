---
title: Installing CentOS 7 on a Raspberry Pi 3
---

## Getting Started

<a href="https://www.raspberrypi.org/products/raspberry-pi-3-model-b-plus/"><img src="/assets/raspberry-pi-3-b+.jpg" alt="raspberry Pi 3 B+" width="199" height="130" align="right" /></a>

I recently added a new [Raspberry Pi 3 B+](https://www.raspberrypi.org/products/raspberry-pi-3-model-b-plus/) to my home lab and need to use it with both Raspbian and CentOS for a customer's testing. The Raspbian instructions are nearly identical to the [Raspberry Pi Zero](/2019/01/30/installing-raspbian-9-6-on-a-raspberry-pi-zero) despite being a 64-bit ARM8 system. Getting it working with CentOS was relatively straightforward since it's a popular platform, but I figured I should document it for ease of reproducibility.

I primarily followed the instructions from the [CentOS Linux on the Raspberry Pi 3 wiki](https://wiki.centos.org/SpecialInterestGroup/AltArch/Arm32/RaspberryPi3) and [RichTech Security & Technology Guide: CentOS 7 Installation Guide on Raspberry PI](https://rharmonson.github.io/cos7instpi.html).

## Installing the Base Image

CentOS has official Raspberry Pi 3 builds, I downloaded mine from the [mirror listing](http://isoredirect.centos.org/altarch/7/isos/armhfp/) and downloaded the [CentOS-Userland-7-armv7hl-RaspberryPI-Minimal-1810-sda.raw.xz](http://mirror.nsw.coloau.com.au/centos-altarch/7.6.1810/isos/armhfp/CentOS-Userland-7-armv7hl-RaspberryPI-Minimal-1810-sda.raw.xz) to keep it minimal.

I flashed the image onto a 32 gig microSD card with [baleenaEtcher for OSX](https://www.balena.io/etcher/).

With my microSD card ready I plugged in my HDMI cable, a USB keyboard, and an ethernet cable and booted into CentOS.

## Configuring CentOS

The default user/password combination on CentOS is `root` and `centos`, which you'll want to immediately change with `passwd`. The first thing I did was resize the filesystem to expand into the entire microSD card with

    /usr/bin/rootfs-expand

Next I configured the hostname with

    hostnamectl set-hostname banjo.bottlebru.sh

where `banjo` is the shortname and `bottlebru.sh` is the internal-only domain I use for my systems. Next I set the timezone to `Australia/Sydney` with

    timedatectl set-timezone Australia/Sydney

### Package Updates

To get the latest versions of the base install I ran

     yum update

and rebooted the system to ensure the hostname and timezone changes were in effect.

## WiFi

Initially I used the ethernet port, but I wanted to use the wifi. Configuring wifi is several steps, but [https://www.raspberrypi.org/forums/viewtopic.php?t=146109](this post) provides a link to a [](script) that configures your Raspberry Pi 3 wifi. Be sure to read it since you're running it as root :)

    curl https://gist.githubusercontent.com/anonymous/9119317cdf0c141cb50c523db0f3b70f/raw/d4c2bedcf4799783ca0bf5f54a52e82241faea93/wifi-setup-c7-rpi3.sh >> wifi-setup.sh
    chmod +x wifi-setup.sh
    ./wifi-setup.sh SSID PASSWORD

Then I rebooted the box and unplugged the ethernet, video, and keyboard. It was now on my network via wifi and ready to be remotely administered.
