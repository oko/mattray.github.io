---
title: Chef Infra Client 14.14.29 and 15.5.15 Builds for CentOS, Debian and Raspbian on 32-bit ARM + Chef LEDs Handler Cookbook
---

<a href="https://github.com/chef/chef"><img src="/assets/chef-logo.png" alt="Chef" width="200" height="200" align="right" /></a>

With another new releases of both the [Chef Infra Client 14.14.29](https://discourse.chef.io/t/chef-infra-client-14-14-29-released/16177) and [Chef Infra Client 15.5.15](https://discourse.chef.io/t/chef-infra-client-15-5-15-released/16259) it's time for new 32-bit ARM builds.

The previous patches have been upstreamed, so these build right off of the master branch. I've removed the BeagleBone Black **armv7l** builds because the Raspberry Pi 3/4 Raspbian builds work on this Debian machine so I've stopped making separate builds (they're both ARM7l).

# Chef LEDs Handler Cookbook

<a href="https://github.com/mattray/leds_handler-cookbook"><img src="/assets/flashing_leds.gif" alt="Flashing LEDs" width="213" height="120" align="left" /></a>

If you're using these builds you might be interested in the LEDs Handler cookbook. At the beginning of the Chef client run the LEDs blink a heartbeat pattern and at the end of the client run the LEDs are disabled. If the Chef client run fails the LEDs all stay on. It's pretty simple but it's a fun notification that the nodes are converging.

https://github.com/mattray/leds_handler-cookbook

# Build Instructions

If you want full instructions explained, here they are:

- [Chef 15 for 32-bit ARM](/2019/05/18/chef-15-on-arm)

**Please note the [ld.so.preload](/2019/09/14/installing-raspbian-10-0-on-a-raspberry-pi) instructions for Raspbian 10.** Here are the updated single scripts to do a full build as the `omnibus` user:

Chef Infra 14.14.29
- CentOS: [RPM-chef-14.14.29.sh](/assets/RPM-chef-14.14.29.sh) and run  `nohup bash RPM-chef-14.14.29.sh &`
- Debian/Raspbian: [DEB-chef-14.14.29.sh](/assets/DEB-chef-14.14.29.sh) and run `nohup bash DEB-chef-14.14.29.sh &`

Chef Infra 15.5.15
- CentOS: [RPM-chef-15.5.15.sh](/assets/RPM-chef-15.5.15.sh) and run `nohup bash RPM-chef-15.5.15.sh &`
- Debian/Raspbian: [DEB-chef-15.5.15.sh](/assets/DEB-chef-15.5.15.sh) and run  `nohup bash DEB-chef-15.5.15.sh &`

And `tail -f nohup.out` the output.

# Chef Infra Client 14.14.29 32-bit ARM DEB and RPM Packages

- The 32-bit CentOS ARMv7hl package (Raspberry Pi 3 (A, A+, B+)):
  - [chef-14.14.29-1.el7.armv7hl.rpm](https://www.dropbox.com/s/u1el27tggpcdd4o/chef-14.14.29-1.el7.armv7hl.rpm?raw=1)

- The 32-bit Raspbian ARMv6l packages (Raspberry Pi 1 series):
  - [chef-14.14.29-rpi-armv6l_armhf.deb](https://www.dropbox.com/s/9xyqosgohq8lnxh/chef-14.14.29-rpi-armv6l_armhf.deb?raw=1)

- The 32-bit Debian/Raspbian ARMv7l package (Raspberry Pi 3/4 series (Raspberry Pi 2 is untested but should work):
  - [chef-14.14.29-rpi3-armv7l_armhf.deb](https://www.dropbox.com/s/84n76tm02s3mvun/chef-14.14.29-rpi3-armv7l_armhf.deb?raw=1)

# Chef Infra Client 15.5.15 32-bit ARM DEB and RPM Packages

- The 32-bit CentOS ARMv7hl package (Raspberry Pi 3 (A, A+, B+)):
  - [chef-15.5.15-1.el7.armv7hl.rpm](https://www.dropbox.com/s/bcelkt4hbaz16k2/chef-15.5.15-1.el7.armv7hl.rpm?raw=1)

- The 32-bit Raspbian ARMv6l packages (Raspberry Pi 1 series):
  - [chef-15.5.15-rpi-armv6l_armhf.deb](https://www.dropbox.com/s/1ho32cptw5texvg/chef-15.5.15-rpi-armv6l_armhf.deb?raw=1)

- The 32-bit Debian/Raspbian ARMv7l package (Raspberry Pi 3/4 series (Raspberry Pi 2 is untested but should work):
  - [chef-15.5.15-rpi3-armv7l_armhf.deb](https://www.dropbox.com/s/9gl23z2aeqtngmh/chef-15.5.15-rpi3-armv7l_armhf.deb?raw=1)
