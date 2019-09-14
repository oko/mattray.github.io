---
title: Installing Raspbian 10 on a Raspberry Pi Zero/3/4
---

## Getting Started

<a href="https://shop.pimoroni.com/products/raspberry-pi-zero-w"><img src="/assets/Pibow_Zero_ver_1.3_1_of_3_1024x1024.JPG" alt="Raspberry Pi Zero W" width="235" height="235" align="right" /></a>

In my home lab I have a [Raspberry Pi 4](https://core-electronics.com.au/raspberry-pi-4-model-b-2gb.html), a [Raspberry Pi 3 B+](https://core-electronics.com.au/raspberry-pi-3-model-b-plus.html), and a [Raspberry Pi Zero W](https://shop.pimoroni.com/products/raspberry-pi-zero-w) (thanks [Graham](https://grahamweldon.com/)!). Setting up and configuring these is pretty straightforward, I primarily followed the instructions from the [RaspberryPi.org](https://projects.raspberrypi.org/en/projects/raspberry-pi-setting-up) but I thought I'd add my notes for easier reference. The instructions are fairly similar for each, so I'm going to focus on the Raspberry Pi Zero W.

## Installing the Base Image

While I generally prefer straight [Debian](https://debian.org), the Raspberry Pi platform is best supported by the Debian-derived [Raspbian distro](https://www.raspberrypi.org/downloads/raspbian/). I used the [Raspbian Buster Lite](https://www.raspberrypi.org/downloads/raspbian/) base image to keep it minimal.

I flashed the image onto a 32 gig microSD card with [Balena Etcher for OSX](https://www.etcher.io/).

With my microSD card ready I plugged in my mini-HDMI adapter and HDMI cable, a micro-B OTG USB hub and a USB keyboard and USB ethernet cable and booted into Raspbian.

## Configuring Raspbian

The default user/password combination on Raspbian is `pi` and `raspberry`, which you'll want to immediately change with `passwd`.

I then used the built-in `raspi-config` command to enable SSH and to configure the hostname, wifi, timezone and locale.

    sudo raspi-config

I then copied over my SSH key so I wouldn't need to use my password when logging in.

    ssh-copy-id debian@10.0.0.3

### root

Now that I was able to SSH over and sudo to root, there were a few final steps. Raspbian has the swap configured, which isn't very useful on a system booting off an SD card.

    dphys-swapfile swapoff
    dphys-swapfile uninstall
    update-rc.d dphys-swapfile remove
    apt-get remove dphys-swapfile

To ensure the latest versions of the base install:

    apt-get update
    apt-get upgrade

Then I rebooted the box and unplugged the ethernet, video, and keyboard. It was now on my network via wifi and ready to be remotely administered.

## GPU Memory Usage

Because my systems are used primarily has headless servers, I've configured them to use less GPU memory by setting

    gpu_mem=16

in the `/boot/config.txt`. I do this in the [mattray::raspberrypi](https://github.com/mattray/mattray-cookbook/blob/master/recipes/raspberrypi.rb#L59) recipe used by all of my Raspbian systems.

## ld.so.preload

Raspbian sets the file `/etc/ld.so.preload` to

    /usr/lib/arm-linux-gnueabihf/libarmmem-${PLATFORM}.so

in an attempt to support both the 6l and 7l ARMHF platforms. This breaks the Chef 32-bit ARM builds on Raspbian so I have replaced this line with

    echo /usr/lib/arm-linux-gnueabihf/libarmmem-v7l.so > /etc/ld.so.preload

on the Raspberry Pi 3 and 4 and

    echo /usr/lib/arm-linux-gnueabihf/libarmmem-v6l.so > /etc/ld.so.preload

on the Raspberry Pi Zero.
