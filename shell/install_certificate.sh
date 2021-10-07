#!/usr/bin/env bash

"$HOME/.acme.sh/acme.sh" --issue -d "www.mengxc.info" -d "blog.mengxc.info" --standalone -k ec-256
#~/.acme.sh/acme.sh --issue -d blog.mengxc.info --standalone -k ec-256

"$HOME/.acme.sh/acme.sh" --installcert -d "www.mengxc.info" --fullchainpath /root/project/MattMeng_hexo/certificate/www.mengxc.info.crt --keypath /root/project/MattMeng_hexo/certificate/www.mengxc.info.key  --ecc
"$HOME/.acme.sh/acme.sh" --installcert -d "blog.mengxc.info" --fullchainpath /root/project/MattMeng_hexo/certificate/www.mengxc.info.crt --keypath /root/project/MattMeng_hexo/certificate/www.mengxc.info.key  --ecc
