---
layout: post
toc: true
title: JavaScript、Node.js面试题（持续更新）
date: 2019-05-28
keywords: JavaScript

categories:
    - JavaScript
tags:
    - JavaScript
---
# JavaScript、Node.js面试题（持续更新）
# 1.问答题
## 1.JavaScript中的强制转换（coercion）是指的什么？
```
在JavaScript中，两个不同的内置类型间的转换称为强制类型。强制类型在JavaScript中有两种形式：显示和隐式。
```
<!-- more -->
>强制转型

```
var a ='42';
var b=Number(a);
```
>隐式强制转型

```
var a='42';
var b=a*1;
```

## 2.JavaScript中的作用域（scope）是指什么？

```
在JavaScript中，每个函数都有自己的作用域。作用域基本上是变量以及如何通过名称访问这些变量的规则的集合。只有函数中的代码才能访问函数作用域内的变量。
同一作用域中的变量名是必须是唯一的。一个作用域可以嵌套另一个作用域内。如果一个作用域嵌套再另一个作用域内，最内部作用域的代码可以访问另一个作用域的变量。
```

## 3.解释JavaScript中的相等性

```
严格比较===
抽象笔记== 允许强制转型
```

>==执行顺序

```
1.如果x不是正常值（比如抛出一个错误），中断执行。
2.如果y不是正常值，中断执行。
3.如果Type(x)与Type(y)相同，执行严格相等运算x === y。
4.如果x是null，y是undefined，返回true。
5.如果x是undefined，y是null，返回true。
6.如果Type(x)是数值，Type(y)是字符串，返回x == ToNumber(y)的结果。
7.如果Type(x)是字符串，Type(y)是数值，返回ToNumber(x) == y的结果。
8.如果Type(x)是布尔值，返回ToNumber(x) == y的结果。
9.如果Type(y)是布尔值，返回x == ToNumber(y)的结果。
10.如果Type(x)是字符串或数值或Symbol值，Type(y)是对象，返回x == ToPrimitive(y)的结果。
11.如果Type(x)是对象，Type(y)是字符串或数值或Symbol值，返回ToPrimitive(x) == y的结果。
12.返回false。
```

## 4.解释什么是回调函数，并提供一个简单的例子

```JavaScript
回调函数是可以作为参数传递给另一个函数的函数，并在某些操作完成后执行，下面是一个简单的回调函数示例，这个函数再某些操作完成后打印消息到控制台。

    function modifyArray(arr,callback){
        //对arr做一些操作
        arr.push(100);
        // 执行传进来的callback函数
        callback();
    }
modifyArray(arr,function(){
    console.log('array has been modify',arr);
});
```

## 5.use strict的作用是什么

```
它的好处是：
    消除Javascript语法的一些不严谨之处，减少一些怪异行为;
消除代码运行的一些不安全之处，保证代码运行的安全；
    提高编译器效率，增加运行速度；
    为未来新版本的Javascript做好铺垫。
    具体表现为：
    没有变量提升
静默失败会抛出异常
参数重名会抛出异常
禁止八进制数字语法
ES6下，对基本数据类型设置属性，会抛出异常
禁用 with
    eval 中同样失去了变量提升
函数参数的值不会随 arguments 对象的值的改变而变化
不再支持 arguments.callee
this 没有指向的时候不再指向 window，而是 undefined
增加关键保留字
在语句块中使用函数声明

它的坏处是：
        严格模式改变了语义。依赖这些改变可能会导致没有实现严格模式的浏览器中出现问题或者错误。尤其是合并严格代码和非严格代码时。
```

## 6.解释JavaScript中的null和undefined

```
JavaScript中有两种底层类型：null和undefined。

undefined:  尚未初始化的东西
null:       目前不可用的东西
```

## 7.编写一个可以执行如下操作的函数

```JavaScript
let addSix=createBase(6);
addSix(10);// 16
addSix(21);// 27

可以使用闭包做

const createBase(baseNumber)=>{
    return function(x){
        return baseNumber+x;
    }
}
addSix(10); // 返回16
addSix(21)  // 返回27
```

## 8.解释JavaScript中的值和类型

```JavaScript
string
number
boolean
null
undefined
object
symbol
```

## 9.怎么查看一个数字是小数还是整数

```
将它对1进行取模如果不是0则是小数
```

## 10.什么是IIFE（立即调用函数表达式）？

```JavaScript
    (function(){
        console.log('hello world');
    }());
```

## 11.如果在JavaScript中比较两个对象？

```
用递归去实现
```

## 12.解释下es5 es6之间的区别

```
es6新特性
```

## 13.undefined和not defined区别

```
undefined ：声明未定义
not defined：未声明
```

## 14.声明式函数与赋值式函数有什么区别

```
js执行分两个步骤
1.预编译
2.执行期
当预编译时声明式函数已经加载完毕，但是赋值式函数未加载完毕所以调用是not defined

// a() 输出a
// b() b not defined
function a(){
    console.log('a');
}
const b= function (){
    console.log('b');
}
```

## 15.this关键字的原理是什么

```
this是指正在执行的函数的所有者或者更确切的说，指将当前函数作为方法的对象。
```

## 16.说一下对bind、call、apply三个函数的认识，自己实现bind方法
- [ ] [bind、call、apply（暂无实现bind方法）](/2019-05-07-JavaScript%20apply、call、bind%20详解/)

## 17.对nodejs的异步IO的认识，异步IO内部的工作原理，以及内部线程池相关内容、nodejs的事件循环怎么理解？事件循环里各个阶段的认识
- [ ] [Node.js异步IO详解]()

## 18.说一下应用服务的部署模式
- [ ] [详解]()

## 19.用redis做缓存中间件是为了解决什么问题？说一下你们关于redis的设计架构
- [ ] [详解]()

## 20.讲一下你对之前项目里使用的消息中间件的理解，为什么引入这个东西，它解决了什么问题

## 21.手写一下快排算法
- [ ] [详解]()

## 22.简单讲一下关于加密算法相关的内容
- [ ] [详解]()

## 23.说一下https的工作原理，里面涉及到的加密算法都有哪些？涉及中间人攻击，证书协议，加解密内容
- [ ] [详解]()

## 24.设计一个后台管理系统，从数据库表设计到后端服务提供
- [ ] [详解]()

## 25.一个数组中找出所有相同的元素，并且做出分类
- [ ] [详解]()

## 26.说一下nodejs里对Buffer数据类型的认识，对于初始化的Buffer，可以实现增加长度吗？
- [ ] [详解]()

## 27.说一说Linux的几种IO模型，分别描述一下是怎么一回事
- [ ] [详解]()

## 28.多进程部署的Nodejs应用有何优缺点，简述一下进程之间的通信方式
- [ ] [详解]()

## 29.TCP三次握手四次挥手的具体细节
- [ ] [详解]()

## 30.浏览器cookie和session的认识、token相关的一些内容
- [ ] [详解]()

## 31.跨域分哪几种类型，如何解决各个跨域的问题
- [ ] [详解]()

## 32.nodejs的setTimeOut不准时的原因分析
- [ ] [详解]()

## 33.nodejs进程间通信方式
- [ ] [详解]()

## 34.nodejs高并发怎么理解？为什么不适合运算量大的操作？如果我要用实现运算量大的操作有什么方式？
- [ ] [详解]()

## 35.redis缓存系统的相关内容。
- [ ] [详解]()

## 36.javascript同步异步的输出顺序问题
- [ ] [详解]()

## 37.关于Promise的then，catch，reject，all，race一些api的用法问题
- [ ] [详解]()

## 38.关于动态规划的算法题
- [ ] [详解]()

## 39.概率论关于摇硬币正反面概率的问题
- [ ] [详解]()

## 40.这一套关于nodejs的，主要涉及流(stream)与Buffer，事件触发器(EventEmitter)等相关模块的认识与使用
- [ ] [详解]()

## 41.手写Promise
- [x] [详解](/2019-05-22-JavaScript%20Promise%20实现原理/)

## 42.nodejs中的异步回调中的错误怎么处理
- [ ] [详解]()

## 43.闭包为什么会造成内存泄漏
- [ ] [详解]()

## 44.javascript的垃圾回收机制讲一下
- [ ] [详解]()

## 45.了解express的内部原理么？简单实现一下
- [ ] [详解]()

## 46.写一下希尔排序算法，注意空间和时间复杂度
- [ ] [详解]()

## 47.从页面输入一个链接到加载成功过程中发生了什么，尽可能详细
- [ ] [详解]()

## 48.nodejs的运行原理，有哪些优缺点？对nodejs怎样的看法？
- [ ] [详解]()

## 49.简历有做过断点续传的一些内容，问了一些断点续传在实现方面的一些内容
- [ ] [详解]()

## 50.XSS，CSRF攻击过程，前端怎么去防止这类攻击。
- [ ] [详解]()

# 2.代码面试题
## 题目1
>考察Promise.then、setTimeout的执行顺序

- [x] [详解链接](/2019-05-27-JavaScript%20事件循环/)

```JavaScript
setTimeout(v => {
    console.log(4);
}, 0);
new Promise((resolve, reject) => {
    console.log(1);
    for (let i = 0; i < 1000; i++) {
        i === 999 && resolve();
    }
    console.log(2);
}).then(v => {
    console.log(5);
});
console.log(3);
// 1 2 3 5 4
```

## 题目2
>考察带标签的模板字符串

```JavaScript
const tag = (a, b, c) => {
    console.log('a[0]:', a[0]);// hello
    console.log('a[1]:', a[1]);// world
    console.log('a[2]:', a[2]);//
    console.log('b:', b);// 1
    console.log('c:', c);// 2
};

tag`hello${1}world${2}`;

```
## 题目3
>考察bind的返回值（原始函数的this）

- [x] bind详解，[详解链接](https://blog.mengxc.info/2019-05-07-JavaScript%20apply%E3%80%81call%E3%80%81bind%20%E8%AF%A6%E8%A7%A3/)

```
let func1 = { x: 1 };
let func2 = { x: 2 };
let func3 = { x: 3 };
let func4 = { x: 4 };
let func5 = { x: 5 };
let foo = function () {
    console.log('x:', this.x);
};
let func6 = foo.bind(func2);
func6(); // 2
func6 = func6.bind(func3);
func6(); // 2
```
## 题目4
>考察pending可转换完几种状态以及改变状态后还是否可以执行

```JavaScript
(new Promise((resolve, reject) => {
    resolve(1);
    console.log(3);
    reject(2);
    console.log(4);
})).then(v => {
    console.log(v);
}).catch(e => {
    console.log(e);
});
// 3 4 1
```
## 题目5
>考察. =的执行优先级

```JavaScript
let a={n:1}
let b=a;
a.x=a={n:2}

console.log(a.x)// undefined
console.log(b.x)// {n:2}
```
>解读

- 优先级。.的优先级高于=,所以先执行a.x，堆内存中的{n:1}就会变成{n:1,x:undefined}，改变之后相应的b.x也比变化了，因为指向的是同一个对象。
- 赋值操作是从右往左，所以先执行a={n：2}，a的引用就被改变了，然后这个返回值又赋值给了a.x，需要注意的是这时候a.x是第一步中的{n:2,x:undefined}那个对象，其实就是b.x，相当于b.x={n:2}
<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/JavaScript/%E9%9D%A2%E8%AF%95%E9%A2%98/%E9%9D%A2%E8%AF%95%E9%A2%9801.png'/>

## 题目6

>考察点

- [ ] 词法作用域 [详解链接]()

```
let param1 = 'one man';

const foo = (question) => {
    console.log(param1, question);
};

const fun = () => {
    let param1 = 'two man';
    foo('how');
};

fun();

```
>解读

- 函数中的变量定义时决定，不是运行时决定

## 题目7
>考察点
- [ ] 声明式函数与赋值式函数定义、执行顺序，[详解链接]()

```
function fn () {
    return print();

    function print () {
        console.log('1');
    }
}

function fn2 () {
    return print();
    const print = () => {
        console.log('1');
    };
}

fn();
fn2()
```
>解读

- 在JS的预编译期，声明式函数将会先被提取出来，然后才按照顺序执行js代码。所以声明式函数可以先调用后声明。但是赋值式函数正好相反。

## 题目8
>考察点
- [x] js中宏任务和微任务以及事件循环，[详解链接](/2019-05-27-JavaScript%20事件循环/)

```
setTimeout(function() {
  console.log('setTimeout');
}, 0);
Promise.resolve().then(function() {
  console.log('promise1');
}).then(function() {
  console.log('promise2');
});

```
>答案

```
promise1  promise2  setTimeout
```
>解析

- 事件循环的机制是先执行函数，然后处理微任务，然后在执行下一个事件（就是宏任务）

## 题目9
>考察点
- [x] js中宏任务和微任务以及事件循环，[详解链接](/2019-05-27-JavaScript%20事件循环/)

```
//请写出输出内容
async function async1() {
    console.log('async1 start');
    await async2();
    console.log('async1 end');
}
async function async2() {
	console.log('async2');
}

console.log('script start');

setTimeout(function() {
    console.log('setTimeout');
}, 0)

async1();

new Promise(function(resolve) {
    console.log('promise1');
    resolve();
}).then(function() {
    console.log('promise2');
});
console.log('script end');


/*
script start
async1 start
async2
promise1
script end
async1 end
promise2
setTimeout
*/
```
## 题目10
>考察点
- [ ] [setTimeout详解]()

```
console.time('time');
setTimeout(function () {
    console.timeEnd('time');
}, 500);
for (let i = 0; i < 1000000000; i++) {

}
```
## 题目11
>考察then中的两种状态（onFulfilled，onRejected）

```
// onFulfilled，onRejected 是function的时候
Promise.reject('1')
    .then((v) => Promise.resolve(v), (e) => Promise.resolve(e))
    .then(v => console.log('v:', v), e => console.log('e:', e))
// v: 1


// onFulfilled，onRejected 非function时 会自动转换晨()=>x 即原样返回promise最终结果的函数
Promise.reject('1')
    .then(() => 1, 2)
    .then(v => console.log('v:', v))
    .catch(e => console.log('e:', e));
// e: 1
```
## 题目12
<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/%E9%9D%A2%E8%AF%95/%E9%9D%A2%E8%AF%9501.jpg' width=400 height=500/>
```
function f (n) {
    if (n <= 2) {
        return 1;
    }
    return f(n - 1) + f(n - 2);
}
```

## 题目13
<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/%E9%9D%A2%E8%AF%95/%E9%9D%A2%E8%AF%9502.png' width=400/>

## 题目14
>考察微任务、宏任务以及异步返回值
- 题目
```
const a = new Promise((resolve, reject) => {
    console.log('promise1')
    resolve()
}).then(() => {
    console.log('promise2')
})

const b = new Promise(async (resolve, reject) => {
    await a
    console.log('after1')
    // 我在等我resolve才能resolve
    await b
    console.log('after2')
    resolve()
})

console.log('end');
```
- 答案
```
promise1
end
promise2
after1
```

## 题目15
```
Promise.then(a,b) 和 Promise.then().catch()的区别
```
- 答案
```
第二个捕获错误会跑在新的microTask
```

## 题目16
- 题目
```
const promise = new Promise((resolve, reject) => {
  console.log(1)
  resolve()
  console.log(2)
})
setTimeout(() => console.log(3), 0)
throw new Error('123');
promise.then(() => {
  console.log(4)
})
```
- 答案
```
1， 2  throw 123, 3
```
# 3.技术外的面试题

## 1.说一下你做过最有成长的一个项目，简单总结一下
## 2.在之前工作中做的项目中有收获的，系统描述一下收获了什么？
## 3.介绍了一些他们使用的技术栈和正在做的事情

>如有侵权行为，请[点击这里](https://github.com/cooper-q/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/cooper-q/MattMeng_hexo/issues)

# 备注
>2019年7月17日
- 增加技术外的面试题
- 新增45条简单题
