---
layout: post
toc: true
title: JMeter for Mac 并发测试
date: 2019-07-26
keywords:

categories:
    - Mac
    - 并发测试
catalog:    true
tags:
    - Mac
    - JMeter
---

# 1.下载、安装、启动
## 1.下载
[点击此处打开官网，并下载下图中所示内容](http://jmeter.apache.org/download_jmeter.cgi)
<!-- more -->
<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/JMeter%E4%B8%8B%E8%BD%BD%E5%9C%B0%E5%9D%80.png' width='400'/>

##  2.安装、启动

- 下载完后解压，得到安装包
- 进入解压完毕后/bin/目录下
- 启动

```
sh jmeter
```
>命令行出现

```
Writing log file to: /Users/zhengcanrui/WORK/soft/apache-jmeter-3.1/bin/jmeter.log
================================================================================
Don't use GUI mode for load testing, only for Test creation and Test debugging !
For load testing, use NON GUI Mode & adapt Java Heap to your test requirements
================================================================================

```

>弹出jmeter界面

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/JMeter%E4%B8%BB%E7%95%8C%E9%9D%A2.png' width='400' />

>默认为英文可以修改bin下的jmeter.properties 文件

```
#language=en    // 默认为此内容
language=zh_CN  // 修改为此内容 重启客户端即可
```
# 2.使用示例

## 1.新建一个测试计划并重命名
<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/JMeter%20blog.mengxc.info%E5%B9%B6%E5%8F%91%E6%B5%8B%E8%AF%95%E8%AE%A1%E5%88%92.png' width='500'/>

## 2.新建一个线程组
- 添加->线程（用户）->线程组

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/JMeter%20blog.mengxc.info%E5%B9%B6%E5%8F%91%E6%B5%8B%E8%AF%95%E8%AE%A1%E5%88%92%20%E6%96%B0%E5%BB%BA%E7%BA%BF%E7%A8%8B%E7%BB%84.jpg' width='300'/>

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/JMeter%20%E7%BA%BF%E7%A8%8B%E7%BB%84%E4%B8%BB%E9%A1%B5.png' width='300'/>

>线程属性解释

- 线程数:要测试的线程数
- Ramp-Up时间（秒）:需要多长时间内建立全部线程。默认值0时一次性全部创建完毕。假设Ramp-Up设置为T秒，全部线程为N个，JMeter将每隔T/N秒建立一个线程。（这里有歧义，建议默认0，后续可以通过定时器处理）

## 3.新建一个HTTP请求

- 添加->取样器->HTTP请求

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/JMeter%20%E6%B7%BB%E5%8A%A0HTTP%E8%AF%B7%E6%B1%82.jpg' width='400'/>

>按照下图添加基本信息

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/JMeter%20HTTP%E8%AF%B7%E6%B1%82%E4%B8%BB%E7%95%8C%E9%9D%A2.jpg' width='400'/>

## 3.如需要Cookie信息可根据下图设置Cookie

- 添加->配置原件->HTTP Cookie管理器

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/JMeter%20%E6%B7%BB%E5%8A%A0Cookie%E7%AE%A1%E7%90%86%E5%99%A8.jpg' width='400'/>


## 4.新建响应断言

- 主要用于对返回的数据进行检测是否正确
- 添加->断言->响应断言

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/JMeter%20%E6%B7%BB%E5%8A%A0%E5%93%8D%E5%BA%94%E6%96%AD%E8%A8%80.jpg'/>

>可根据下图设置

- 字符串类似于substring 也就是只要返回的文本中包含指定的就可以

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/JMeter%E5%93%8D%E5%BA%94%E6%96%AD%E8%A8%80%E4%B8%BB%E7%95%8C%E9%9D%A2.jpg' width='400'/>

## 5.查看断言结果

- 主要用于观看4步骤断言后的结果输出
- 添加->监听器->断言结果

## 6.查看调用接口返回的结果、响应时间分布、汇总结果等
- 可查看每次返回的结果、QBS等值
- 添加->监听器->查看结果树
- 添加->监听器->汇总报告
- 添加->监听器->聚合报告
- 添加->监听器->响应时间图
- 添加->监听器->图形结果

## 7.保存响应失败后的值

- 添加->后置处理器->BeanShell监听器

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/JMeter%20BeanShell%20%E7%9B%91%E5%90%AC%E5%99%A8%20%E4%B8%BB%E7%95%8C%E9%9D%A2.jpg' width='400'/>

>代码

```
String Str="\"status\":200";
String response = prev.getResponseDataAsString();
if(response == ""){
	Failure = true;
	FailureMessage = "系统无响应";
	log.info(FailureMessage);
}else if(response.contains(Str)==false){
	Failure = true;
	log.info("期望结果:"+Str+" 实际结果:"+response);
}
// 默认写入程序目录bin目录下的jmeter.log文件
```

## 8.模拟真实的并发用户
- 添加->定时器->同步定时器
- 会等待线程全部创建完毕后，然后一直进行释放进行并发测试

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/JMeter%20%E5%90%8C%E6%AD%A5%E5%AE%9A%E6%97%B6%E5%99%A8.jpg' width='300'/>

>参数解释
- 模拟用户组数量：要等待启动的线程数量（小于等于线层组的设置的线程数）
- 超时时间以毫秒为单位：如果是0则等待线程启动到模拟用户组数量相同时释放线程进行测试，非0时等待创建的线程超过这个时间时并且还未创建完毕时不再等待直接释放创建后的。

## 9.设置完毕后的示例图

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/JMeter%20%E6%95%B4%E4%BD%93%E6%A0%91.png' width='300'/>

>如有侵权行为，请[点击这里](https://github.com/cooper-q/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/cooper-q/MattMeng_hexo/issues)

# 备注

