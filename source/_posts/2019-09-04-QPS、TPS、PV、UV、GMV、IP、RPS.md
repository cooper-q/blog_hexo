---
layout: post
title: QPS、TPS、PV、UV、GMV、IP、RPS详解
date: 2019-09-04
keywords: 
top: 10
categories: 
    - 网络相关
tags:
    - 网络相关
---
# QPS、TPS、PV、UV、GMV、IP、RPS详解
# 1.QPS
- Queries Per Second,每秒查询数。每秒能够响应的查询次数
- QPS是对一个特定的查询服务器在规定时间内所处理流量多少的衡量标准。
- 每秒的响应请求数，即最大吞吐量。

# 2.TPS
- Transactions Per Second的缩写，每秒处理的事务数目。
- 一个事务是指一个客户机向服务端发送请求服务器做出反应的过程。
- 客户机在发送请求时开始计时，收到服务器响应结束后结束计时，以此来计算使用的时间和完成的事务个数，最终利用这些信息做出的评估分。
- TPS的过程包括：<span style='color:red'>客户端请求服务端、服务端内部处理、服务端返回数据</span>

## 1.示例
- 访问一个index页面会请求服务器3次，包括一次html，一次css，一次js，那么访问这个就会产生一个T以及三个Q


# 3.PV
- page view 页面浏览量，通常是衡量一个网络新闻频道或网站甚至一条网络新闻的主要指标。
- 用户每一次对网站中的每个页面访问均被记录1次
- 用户对同一页的多次刷新，访问量累计。

# 4.RV
- repeat visitors 与PV相关，重复访问者数量

# 5.UV
- Unique Visitor 独立访问数，一台电脑终端为一个访客


# 6.IP
- Internet Protocol 独立IP个数，对访问的IP记录并去重则得到这个数值。

# 7.GMV 
- Gross Merchandise Volume 只要是订单，不管消费者是否付款、卖家是否发货、是否退货，都放到GMV里面。

# 8.RPS
- Requests Per Second 代表吞吐率
- 吞吐率是服务器并发处理能力的量化描述，单位是reqs/s，指的是某个并发用户数下单时间内处理的请求数。
- 某个并发用户数下单为时间内能处理的最大的请求为最大吞吐率
- 类似于QPS，叫法不同
  
>如有侵权行为，请[点击这里](https://github.com/mattmengCooper/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/mattmengCooper/MattMeng_hexo/issues)

# 备注

