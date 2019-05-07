---
layout: post
title: JavaScript apply、call、bind 详解
date: 2019-05-07
keywords: JavaScript
top: 10
categories: 
    - JavaScript
tags:
    - JavaScript
---
# JavaScript apply、call、bind 详解
# 1.apply、call 概述

```JavaScript
在JavaScript中，call和apply都是为了改变某个函数的上下文（context）而存在的。
其实也就是为了改变this的指向。
```
>JavaScript一大特点
- 定义时上下文
- 运行时上下文
- 上下文是可以改变的

>举例说明

```JavaScript
function Fruit(){
    
}
Fruit.prototype={
    color:'red',
    say:function(){
        console.log('My Color is ',this.color)
    }
}
let redApple = new Fruit();
redApple.say() // My Color is red

但是如果我们有一个对象 banana = {color:'yellow'},我们不想对它重新定义say方法，
那么我们可以通过call或apply用redApple的say方法

let banana ={
    color:'yellow'
}
redApple.say.call(banana);
redApple.say.apply(banana);

所以，可以看出call和apply是为了动态改变this而出现的，当一个object没有某个方法
（本例子中的banana没有say方法），但是其他的有（本例子中的redApple有say方法），
我们可以借助call或apply用其他对象的方法才操作
```

# 2.apply、call的区别
>apply、call作用完全一样，但是参数不同

```JavaScript
let func = function(arg1,arg2){
    
}

就可以通过以下方式调用

func.call(this,arg1,arg2)
func.apply(this,[arg1,arg2])
其中this是你想指定的上下文，他可以是任何一个JavaScript对象，
call需要把参数按顺序传递进去，而apply则是把参数放在数组里。

当某个函数的参数数量是固定时，用call
当不固定时，用apply。

```
>举例说明，apply与call的异同

```JavaScript
let arr1=[1,2,3,4,5]
let arr2=[6,7,8,9]
Array.prototype.push.apply(arr1,arr2); // 输出arr1值为
[1,2,3,4,5,6,7,8,9]

==============
let arr1=[1,2,3,4,5]
let arr2=[6,7,8,9]
Array.prototype.push.call(arr1,arr2); // 输出arr1值为
[1,2,3,4,5,[6,7,8,9]]

从这两段代码可以看出
    apply,后面跟着是一个数组,所以他把arr2里面的每一个值通过Array的push方法push进了arr1
    call后面跟着的是一个个的参数或者对象，所以他会把一整个arr2都push进arr1
```
## 常用用法
>1.获取数组中最大值和最小值

```JavaScript
let numbers = [ 1,2,3,4,5]
let maxInNumbers=Math.max.apply(this,numbers) // 这里的this写成Math也可以
maxInNumbers=Math.max.call(this,...numbers)
```
>2.验证是否为数组

```JavaScript
function isArray(){
    return Object.prototype.toString.call(obj)==='[object Array]'
}
```

>3.深入理解运用apply、call

>举例说明

```JavaScript
定义一个log方法，让它可以代理console.log方法，常见的解决方法是：

function log(param1){
    console.log(param1)
}
log(1); // 1
log(1,2); // 1
当参数的个数不确定时，上面的方法就失效了，这个时候可以考虑用apply或者call。
由于传入的参数是不确定的，所以使用apply

function log(args){
    console.log.apply(console,arguments)
}
log(1); //1
log(1,2)// 1,2
```
# 3.bind
## 1.bind()概述
>bind()方法与apply和call很相似，也是可以改变函数体内的this指向。

>例子01


```JavaScript
// 01
let foo = {
    bar: 1,
    eventBind: function () {
        console.log(this.bar);
    },
};
let eventBindCopy1 = foo.eventBind;
eventBindCopy1(); // undefined 这里由于上下文变了所有访问不到foo里面的bar

let eventBindCopy2 = foo.eventBind.bind(foo);
eventBindCopy2(); // 1

// 02 调用上一个foo中的bar的值

let bar=function(){
    console.log(this.bar)
}
bar(); // undefined
let func = bar.bind(foo);
func() // 1
```
>例子02

```JavaScript
// 01 手动保存this
var foo = {
    bar: 1,
    eventBind: function () {
        var _this = this;
        $('.someClass').on('click', function (event) {
            /* Act on the event */
            console.log(_this.bar); //1
        });
    },
};
// 02 bind
var foo = {
    bar: 1,
    eventBind: function () {
        $('.someClass').on('click', function (event) {
            /* Act on the event */
            console.log(this.bar); //1
        }.bind(this));
    },
};
```
## 2.如果对一个函数bind()多次？
```JavaScript
let func1 = { x: 1 };
let func2 = { x: 2 };
let func3 = { x: 3 };
let func4 = { x: 4 };
let func5 = { x: 5 };
let foo = function () {
    console.log('x:', this.x);
};
let func6 = foo.bind(func2);
func6(); // ?
func6 = func6.bind(func3);
func6(); // ?

结果是2，并非是3，所以总结到多次bind是无效的。
原因：
截取MDN上的一段话：
    bind函数返回值：返回一个原函数的拷贝，并拥有指定的this值和初始参数。
    上面的代码只有第一次把func2

截取网络上大部分资料的一段话（我不是很理解这句话）：
    bind() 的实现，相当于使用函数在内部包了一个 call / apply ，
    第二次 bind() 相当于再包住第一次 bind() ,故第二次以后的 bind 是无法生效的。

通过MDN那句话的个人理解：
    只有第一次时把func2的this指向到了foo，所以x是2 
    第二次时func3把this指向到了func6，并没有指向到foo。
    然后再结合MDN的那句话返回原函数的拷贝。所以并没有改变foo的this，也就是没有变。
```
>以上为个人见解欢迎讨论。

# 4.apply、call、bind比较
>异同

```JavaScript
var obj = {
x: 81,
};

var foo = {
getX: function() {
return this.x;
}
}

console.log(foo.getX.bind(obj)()); //81
console.log(foo.getX.call(obj)); //81
console.log(foo.getX.apply(obj)); //81

通过bind的执行发现，后面还需要一个()来执行返回的函数。
所以可以看出call、apply是立即执行，而bind是先返回函数然后再手动执行。

```
>总结
- apply 、 call 、bind 三者都是用来改变函数的this对象的指向的；
- apply 、 call 、bind 三者第一个参数都是this要指向的对象，也就是想指定的上下文；
- apply 、 call 、bind 三者都可以利用后续参数传参；
- bind是返回对应函数，便于稍后调用；apply、call则是立即调用 。

>如有侵权行为，请[点击这里](https://github.com/mattmengCooper/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/mattmengCooper/MattMeng_hexo/issues)

# 备注

