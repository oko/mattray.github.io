#!/bin/bash

# Build 15.3.14 RPM
echo `date`
sudo systemctl stop chef-client
sudo yum remove omnibus-toolchain -y
sudo yum remove chef -y
rm -rf ~/.bundle
rm -rf ~/.gem
rm -rf ~/.rbenv
rm -rf ~/omnibus-toolchain
rm -rf ~/chef-15.3.14
sudo rm -rf /opt/omnibus-toolchain
sudo rm -rf /var/cache/omnibus/build
sudo rm -rf /opt/chef

# Ruby 2.6.4
cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
mkdir plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
rbenv install 2.6.4
rbenv global 2.6.4

# Omnibus-Toolchain
cd
sudo mkdir /opt/omnibus-toolchain
sudo mkdir /var/cache/omnibus
sudo chown omnibus:omnibus -R /opt/omnibus-toolchain
sudo chown omnibus:omnibus -R /var/cache/omnibus
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
git clone https://github.com/chef/omnibus-toolchain.git
cd omnibus-toolchain
bundle install --without development --path=.bundle
bundle exec omnibus build omnibus-toolchain -l internal
cp ~/omnibus-toolchain/pkg/omnibus-toolchain*rpm ~/
sudo rm -rf /opt/omnibus-toolchain
sudo rpm -Uvh ~/omnibus-toolchain/pkg/omnibus-toolchain*rpm

# Chef 15.3.14
cd
sudo rm -rf /var/cache/omnibus/build
sudo mkdir /opt/chef
sudo chown omnibus:omnibus -R /opt/chef
sudo chown omnibus:omnibus -R /opt/omnibus-toolchain
sudo chown omnibus:omnibus -R /var/cache/omnibus
export PATH="/opt/omnibus-toolchain/bin:$PATH"
wget https://github.com/chef/chef/archive/v15.3.14.tar.gz
tar -xzf v15.3.14.tar.gz
cd ~/chef-15.3.14/omnibus/
bundle install --without development --path=.bundle
bundle exec omnibus build chef -l internal
cp ~/chef-15.3.14/omnibus/pkg/chef*rpm ~/
echo "15.3.14 Complete!"
echo `date`
