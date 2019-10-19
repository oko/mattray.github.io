---
title: Chef Infra Client 14.14.25 and 15.4.45 Builds for CentOS, Debian and Raspbian on 32-bit ARM
---

<a href="https://github.com/chef/chef"><img src="/assets/chef-logo.png" alt="Chef" width="200" height="200" align="right" /></a>

With the new releases of both the [Chef Infra Client 14.14.25] and [Chef Infra Client 15.4.45] it's time for new 32-bit ARM builds.

There's an [patch to omnibus-software](https://github.com/chef/omnibus-software/pull/1094) required for omnibus-software for Debian/Raspbian 10 and Ubuntu 18.04 that is included in the build script below. The version of Ruby used for the builds and packages has been upgraded to [2.6.5](https://www.ruby-lang.org/en/news/2019/10/01/ruby-2-6-5-released/). I've removed the BeagleBone Black **armv7l** builds because the Raspberry Pi 3/4 Raspbian builds work on this Debian machine so I've stopped making separate builds (they're both ARM7l).

# Build Instructions

If you want full instructions explained, here they are:

- [Chef 15 for 32-bit ARM](/2019/05/18/chef-15-on-arm)

**Please note the [ld.so.preload](/2019/09/14/installing-raspbian-10-0-on-a-raspberry-pi) instructions for Raspbian 10.** Here are the updated single scripts to do a full build as the `omnibus` user:

Chef Infra 14.14.25
- CentOS: [RPM-chef-14.14.25.sh](/assets/RPM-chef-14.14.25.sh) and run  `nohup bash RPM-chef-14.14.25.sh &`
- Debian/Raspbian: [DEB-chef-14.14.25.sh](/assets/DEB-chef-14.14.25.sh) and run `nohup bash DEB-chef-14.14.25.sh &`

Chef Infra 15.4.45
- CentOS: [DEB-chef-15.4.45.sh](/assets/DEB-chef-15.4.45.sh) and run  `nohup bash DEB-chef-15.4.45.sh &`
- Debian/Raspbian: [RPM-chef-15.4.45.sh](/assets/RPM-chef-15.4.45.sh) and run `nohup bash RPM-chef-15.4.45.sh &`

And `tail -f nohup.out` the output.

# Chef Infra Client 14.14.25 32-bit ARM DEB and RPM Packages

- The 32-bit CentOS ARMv7hl package (Raspberry Pi 3 (A, A+, B+)):
  - [chef-14.14.25-1.el7.armv7hl.rpm](https://www.dropbox.com/s/9f6a3kev9gdaapx/chef-14.14.25-1.el7.armv7hl.rpm?raw=1)

- The 32-bit Raspbian ARMv6l packages (Raspberry Pi 1 series):
  - [chef-14.14.25-rpi-armv6l_armhf.deb](https://www.dropbox.com/s/k1z0xl7f1oxdljy/chef-14.14.25-rpi-armv6l_armhf.deb?raw=1)

- The 32-bit Debian/Raspbian ARMv7l package (Raspberry Pi 3/4 series (Raspberry Pi 2 is untested but should work):
  - [chef-14.14.25-rpi3-armv7l_armhf.deb](https://www.dropbox.com/s/7oiiakvvyibfr2d/chef-14.14.25-rpi3-armv7l_armhf.deb?raw=1)

# Chef Infra Client 15.4.45 32-bit ARM DEB and RPM Packages

- The 32-bit CentOS ARMv7hl package (Raspberry Pi 3 (A, A+, B+)):
  - [chef-15.4.45-1.el7.armv7hl.rpm](https://www.dropbox.com/s/6kdg7xdpqizlv6p/chef-15.4.45-1.el7.armv7hl.rpm?raw=1)

- The 32-bit Raspbian ARMv6l packages (Raspberry Pi 1 series):
  - [chef-15.4.45-rpi-armv6l_armhf.deb](https://www.dropbox.com/s/6kdg7xdpqizlv6p/chef-15.4.45-1.el7.armv7hl.rpm?raw=1)

- The 32-bit Debian/Raspbian ARMv7l package (Raspberry Pi 3/4 series (Raspberry Pi 2 is untested but should work):
  - [chef-15.4.45-rpi3-armv7l_armhf.deb](https://www.dropbox.com/s/x1bj31ro4ji2gui/chef-15.4.45-rpi3-armv7l_armhf.deb?raw=1)
