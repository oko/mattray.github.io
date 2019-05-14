---
title: Building Chef 14.12.9 for CentOS 7 on the Raspberry Pi 3
---

<a href="https://github.com/chef/chef"><img src="/assets/chef-logo.png" alt="Chef" width="200" height="200" align="right" /></a>

Now that I've got [CentOS 7 installed on my Raspberry Pi 3](/2019/05/07/installing-centos-7-6-on-a-raspberry-pi-three) I can make RPM builds available for this platform as well. The CentOS build has a few minor differences from the [Debian/Raspbian builds](2019/04/30/chef-14-on-arm) and I took the opportunity to streamline the instructions a bit.

# Overview

The [Chef](github.com/chef/chef) client is packaged with [Omnibus](http://github.com/chef/omnibus), which builds the application and all of its runtime dependencies with the [Omnibus-Toolchain](http://github.com/chef/omnibus-toolchain). Omnibus is built with Ruby, so the instructions need to start with building Ruby. These instructions follow the [Installing CentOS 7.6 on a Raspberry Pi 3](/2019/05/07/installing-centos-7-6-on-a-raspberry-pi-three), so the CentOS machine is ready for use.

## Preparation

There are several steps that need to be done before we get started. As the `root` user update to ensure the latest packages are installed and install the prerequisites for building Ruby and Omnibus-Toolchain.

    yum update
    yum install -y  autoconf automake bison flex gcc gcc-c++ gdbm-devel gettext git kernel-devel libffi-devel libyaml-devel m4 make ncurses-devel openssl-devel patch readline-devel rpm-build wget zlib-devel

Add the `omnibus` user for performing the builds.

    adduser omnibus

Let's add the `omnibus` user to the `wheel` group so they have permissions to manage the directories, this will make it easier to do the build with a single script rather than switching between the `root` and `omnibus` users.

    usermod -aG wheel omnibus

Use the `visudo` command and uncomment the following line:

    %wheel  ALL=(ALL)       NOPASSWD: ALL

You can now `sudo su - omnibus` and continue without changing users.

### Previous Installations

If you have previously-installed Chef and omnibus-toolchain packages (perhaps following these instructions), you'll need to uninstall those and clear out the directories.

    sudo systemctl stop chef-client
    sudo yum remove chef omnibus-toolchain -y
    sudo rm -rf /opt/chef /opt/omnibus-toolchain

## Ruby 2.6.3

The Omnibus-toolchain is built with <a href="https://www.ruby-lang.org/en/downloads/">Ruby 2.6.3</a>, so we will install it with [rbenv](https://github.com/rbenv). We don't need documentation for our gems, so first we'll disable that.

    echo 'gem: --no-document' >> ~/.gemrc

Let's install `rbenv` and add it to our `PATH`.

    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    cd ~/.rbenv && src/configure && make -C src
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"

Install the `ruby-build` plugin to make it easier to manage different Ruby versions.

    mkdir plugins
    git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
    rbenv install 2.6.3
    rbenv global 2.6.3
    eval "$(rbenv init -)"

## Omnibus CentOS Raspberry Pi 3 Patch

CentOS provides packages for the Raspberry Pi 3 platform, but the arch is `armv7hl` not `armv7l`. Omnibus does not have proper support for this yet, but the [following patch](https://github.com/chef/omnibus/pull/889) has been submitted. You will need to patch your `lib/omnibus/packagers/rpm.rb` in your `omnibus` gem provided by bundler accordingly.

## Omnibus-Toolchain

Now that Ruby is installed, let's build and install the [Omnibus-Toolchain](https://github.com/chef/omnibus-toolchain) as the `omnibus` user.

    cd
    git clone https://github.com/chef/omnibus-toolchain.git
    cd omnibus-toolchain
    bundle install --without development --path=.bundle

Apply the `lib/omnibus/packagers/rpm.rb` patch to

    ~/omnibus-toolchain/.bundle/ruby/2.6.0/bundler/gems/omnibus-*/lib/omnibus/packagers/rpm.rb

Now you can build and install the RPM.

    sudo mkdir /opt/omnibus-toolchain
    sudo mkdir /var/cache/omnibus
    sudo chown omnibus:omnibus -R /opt/omnibus-toolchain
    sudo chown omnibus:omnibus -R /var/cache/omnibus
    bundle exec omnibus build omnibus-toolchain -l internal
    sudo rm -rf /opt/omnibus-toolchain
    sudo rpm -Uvh ~/omnibus-toolchain/pkg/omnibus-toolchain*el7.armv7hl.rpm

## Chef 14.12.9

With `omnibus-toolchain` installed, we can reset our `PATH` and build Chef as the `omnibus` user.

    cd
    export PATH="/opt/omnibus-toolchain/bin:$PATH"
    wget https://github.com/chef/chef/archive/v14.12.9.tar.gz
    tar -xzf v14.12.9.tar.gz
    cd chef-14.12.9/omnibus/
    bundle install --without development --path=.bundle

Apply the `lib/omnibus/packagers/rpm.rb` patch to

     ~/chef-14.12.9/omnibus/.bundle/ruby/2.5.0/bundler/gems/omnibus-*/lib/omnibus/packagers/rpm.rb

Now you can complete the Chef build.

    sudo mkdir /opt/chef
    sudo chown omnibus:omnibus -R /opt/chef
    bundle exec omnibus build chef -l internal

This usually takes a 2 hours on this limited ARM machine.

# Installing Chef 14.12.9

Once the builds have completed we can delete the working build directory.

    sudo rm -rf /opt/chef

Now Chef 14.12.9 can be installed.

    sudo rpm -Uvh ~/chef-14.12.9/omnibus/pkg/chef_14.12.9*el7.armv7hl.rpm

## Using the new Chef build

From your workstation, you can now `knife bootstrap` the machine with the ARM build on it and register it with your Chef Server. If you are working with a previously Chef-managed box, you can run `chef-client` and the machine will continue to use its previous configuration.

# Chef 14.12.9 CentOS 7 Raspberry Pi 3 RPM

- The 32-bit CentOS ARMv7hl package (Raspberry Pi 3 (A, A+, B+)):
  - [chef-14.12.9-1.el7.armv7hl.rpm](https://www.dropbox.com/s/saldii376l185na/chef-14.12.9-1.el7.armv7hl.rpm?raw=1)
