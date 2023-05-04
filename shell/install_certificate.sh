#!/usr/bin/env bash

sudo "$HOME/.acme.sh/acme.sh" --issue -d "www.cooper-q.info" -d "blog.cooper-q.info" --standalone -k ec-256
#sudo "$HOME/.acme.sh/acme.sh" --issue -d "blog.cooper-q.info" --standalone -k ec-256
#~/.acme.sh/acme.sh --issue -d blog.cooper-q.info --standalone -k ec-256

sudo "$HOME/.acme.sh/acme.sh" --installcert -d "blog.cooper-q.info" --fullchainpath /root/project/blog_hexo/certificate/blog.cooper-q.info.crt --keypath /root/project/blog_hexo/certificate/blog.cooper-q.info.key  --ecc
sudo "$HOME/.acme.sh/acme.sh" --installcert -d "www.cooper-q.info"  --fullchainpath /root/project/blog_hexo/certificate/www.cooper-q.info.crt  --keypath /root/project/blog_hexo/certificate/www.cooper-q.info.key  --ecc
