#!/bin/bash

# Chef 15.1.36 DEB
echo `date`
sudo systemctl stop chef-client
sudo apt-get remove omnibus-toolchain -y
sudo apt-get remove chef -y
rm -rf ~/.bundle
rm -rf ~/.gem
rm -rf ~/.rbenv
rm -rf ~/omnibus-toolchain
rm -rf ~/chef-15.1.36
sudo rm -rf /opt/omnibus-toolchain
sudo rm -rf /var/cache/omnibus/build
sudo rm -rf /opt/chef

# Ruby 2.6.3
cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
mkdir plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
rbenv install 2.6.3
rbenv global 2.6.3

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
# cp ~/rpm.rb ~/omnibus-toolchain/.bundle/ruby/2.6.0/bundler/gems/omnibus-*/lib/omnibus/packagers/rpm.rb
bundle exec omnibus build omnibus-toolchain -l internal
cp ~/omnibus-toolchain/pkg/omnibus-toolchain*deb ~/
sudo rm -rf /opt/omnibus-toolchain
sudo dpkg -i ~/omnibus-toolchain/pkg/omnibus-toolchain*deb
# sudo rm -f /opt/omnibus-toolchain/bin/tar

# Chef 15.1.36
cd
sudo rm -rf /var/cache/omnibus/build
sudo mkdir /opt/chef
sudo chown omnibus:omnibus -R /opt/chef
sudo chown omnibus:omnibus -R /opt/omnibus-toolchain
sudo chown omnibus:omnibus -R /var/cache/omnibus
export PATH="/opt/omnibus-toolchain/bin:$PATH"
wget https://github.com/chef/chef/archive/v15.1.36.tar.gz
tar -xzf v15.1.36.tar.gz
cd ~/chef-15.1.36/omnibus/
bundle install --without development --path=.bundle
# cp ~/rpm.rb ~/chef-15.1.36/omnibus/.bundle/ruby/2.6.0/bundler/gems/omnibus-*/lib/omnibus/packagers/rpm.rb
bundle exec omnibus build chef -l internal
cp ~/chef-15.1.36/omnibus/pkg/chef*deb ~/
echo "15.1.36 Complete!"
echo `date`
