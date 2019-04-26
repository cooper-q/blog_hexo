# 概述
[博客地址](https://blog.mengxc.info)
## 1.架构
   
采用[hexo](https://hexo.io/zh-cn/index.html)+[hexo-theme-next](https://github.com/theme-next/hexo-theme-next)搭建。

## 2.软件版本
```    
Nodejs v10.15.3
hexo-theme-next v7.0.1
hexo 3.8.0
``` 
## 3.已配置好的功能点
```
// todo 有时间就更新、如果找不到配置的可以通过网站右下角的信息图标联系我
```

[设置可以参考这个文章，但是内容稍微有一点老](https://zhuanlan.zhihu.com/p/30836436)
    
### 1.文章更新时间
```   
// todo 
```   
### 2.阅读时长
```
// todo
```   
### 3.本文字数
```
// todo
```   
### 4.阅读全文折叠
```
// todo
```   
### 5.文章加密
```
// todo
```   
### 6.tidio 聊天
```
// todo
```   
### 7.右上角Github显示
```
// todo
```   
### 8.左侧列表显示
```
// todo
```
### 9.本地文章搜索
```
// todo
```
### 10.文章底部总字数以及总阅读时间添加
```
// todo
```
### 11.文章底部去掉与软件官方相关的地址
```
// todo
```
### 12.左侧友情链接、Github地址、logo
```
// todo
```
### 13.自定义网站favicon.ico
```
// todo
```
### 14.阅读进度
```
// todo
```
### 15.版权声明、打赏
```
// todo
```
### 16.文章目录、站点概述
```
// todo
```
### 17.文章置顶&文章显示优先
```
// todo
```
### 18.Google Analytics
``` 
// todo
```
### 19.文章分享
``` 
// todo
```
### 20.显示ICP信息
``` 
// todo
```
### 21.SEO
``` 
// todo
```
### 22.RSS订阅
``` 
// todo
```
### 22.gitalk留言
``` 
// todo
```
### 23.leancloud统计
``` 
// todo
```
### 23.边栏改为圆角
``` 
// todo
```
### 24.点击头像跳转首页
``` 
// todo
```
### 25.保存用户观看位置
``` 
```

2.修改bookmark下enable为true。
```
bookmark:
  enable: true   
```
### 26.预加载加快访问速度

1.修改主题下_config.yml文件中的vendors下的quicklink
```
quicklink: //cdn.jsdelivr.net/npm/quicklink@1/dist/quicklink.umd.js
```

2.修改quicklink下enable为true。
``` 
quicklink:
  enable: true
  ...
```
### 27.图片预览
1.修改主题下 _config.yml文件中的fancybox为true
```
fancybox: true
```

2.修改主题下_config.yml文件中的vendors下的 fancybox_css&fancybox
```
fancybox_css: //cdn.jsdelivr.net/gh/fancyapps/fancybox@3/dist/jquery.fancybox.min.css
fancybox_css: //cdnjs.cloudflare.com/ajax/libs/fancybox/3.5.6/jquery.fancybox.min.css
```

3.根据官方文档进行安装
```
https://github.com/theme-next/theme-next-fancybox3
```
