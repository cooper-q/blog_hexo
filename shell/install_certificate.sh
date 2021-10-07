#!/usr/bin/env bash

sudo "$HOME/.acme.sh/acme.sh" --issue -d "www.mengxc.info" -d "blog.mengxc.info" --standalone -k ec-256
#sudo "$HOME/.acme.sh/acme.sh" --issue -d "blog.mengxc.info" --standalone -k ec-256
#~/.acme.sh/acme.sh --issue -d blog.mengxc.info --standalone -k ec-256

sudo "$HOME/.acme.sh/acme.sh" --installcert -d "blog.mengxc.info" --fullchainpath /root/project/MattMeng_hexo/certificate/blog.mengxc.info.crt --keypath /root/project/MattMeng_hexo/certificate/blog.mengxc.info.key  --ecc
sudo "$HOME/.acme.sh/acme.sh" --installcert -d "www.mengxc.info"  --fullchainpath /root/project/MattMeng_hexo/certificate/www.mengxc.info.crt  --keypath /root/project/MattMeng_hexo/certificate/www.mengxc.info.key  --ecc
