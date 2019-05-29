---
layout: post
title: JavaScript 事件循环（转载）
date: 2019-05-27
keywords: JavaScript、Event Loop
top: 10
categories: 
    - JavaScript
tags:
    - JavaScript
---
# JavaScript 事件循环（转载）
[toc]
# 版本
- Node.js:v12.3.1（不同v8版本结果有所有不同）
# 1.任务队列
>首先我们要明白一下几个事件

- js分为同步任务和异步任务
- 同步任务都在主线程上执行，形成一个执行栈
- 主线程之外，事件触发管理者一个任务队列，只要异步任务有了运行结果，就在任务队列之中放置一个事件。
- 一旦执行栈中的所有同步任务执行完毕（此时js引擎空闲），系统就会读取任务队列，将可运行的异步任务添加到可执行栈中，开始执行。

>规范

- 事件循环是通过任务队列的机制来进行协调的。
- 一个Event loop中，可以有一个或者多个任务队列（task queue），一个任务队列便是一系列有序任务（task）的集合；
- 每个任务都有一个任务源（task source），源自同一个任务源的task必须放在同一个队列，从不同源来的则被添加到不同队列。
- setTimeout/Promise等API便是任务源，而进入任务队列的是他们指定的具体任务。
<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/JavaScript/Event%20loop%20%E8%A7%84%E8%8C%83%E7%A4%BA%E4%BE%8B%E5%9B%BE01.png'/>

# 2.宏任务
>(macro)task（又称之为宏任务），可以理解是每次执行栈执行的代码就是一个宏任务（包括每次从事件队列中获取一个事件回调并放到执行栈中执行）。

>浏览器为了能够使得js内部(micor)task与DOM任务能有有序的执行，会在一个(macro)task执行结束后，在下一个(macro)task执行开始前，对页面进行重新渲染

- 流程如下
```
(macro)task-->渲染-->(macro)task->...
```

>(macro)task主要包括：script（整体代码）、setTimeout、setInterval、I/O、UI交互、postMessage、MessageChannel、setImmediate(Node.js)
# 3.微任务
>microtask(又称为微任务)，可以理解是在当前task执行结束后立即执行的任务。也就是说，在当前task任务后，下一个task之前，在渲染之前。

>所以它响应速度相比setTimeout(setTimeout是task)会更快，因此无需等渲染。也就是说，在某个macrotask执行完毕后，就会将在它执行期间产生的所有microtask都执行完毕(在渲染前)

>microtask主要包括:Promise.then、MutaionObserver、process.nextTick(Node.js环境)

# 4.运行机制
>在事件循环中，每进行一次循环操作称为tick，每一次tick的任务处理模型是比较复杂的，关键步骤如下：

- 执行一个宏任务（栈中没有就从事件队列中获取）
- 执行过程中如果遇到微任务，就会将它添加到微任务的任务队列中。
- 宏任务执行完毕后，立即执行当前微任务队列中的所有微任务（依次执行）
- 当前宏任务执行完毕，开始检查渲染，然后GUI线程接管渲染
- 渲染完毕后，js线程接管，开始下一个宏任务（从事件队列中获取）

>流程图如下

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/JavaScript/JavaScript%20%E5%AE%8F%E4%BB%BB%E5%8A%A1%20%E5%BE%AE%E4%BB%BB%E5%8A%A1%E6%89%A7%E8%A1%8C%E9%A1%BA%E5%BA%8F.jpeg'/>

# 5.Promise和async中的立即执行
>我们知道Promise中的异步体现在then和catch中，所以写Promise中的代码是被当成同步任务立即执行的。而在async/await中，在出现async/await出现之前，其中的代码也是立即执行的，那么出现await时候发生了什么?

## await做了什么
>从字面意思是上看await就是等待，await等待的是一个表达式。这个表达式的返回可以是一个promise对象也可以是其他值。

>很多人以为await会一直等待之后的表达式执行完毕后才会继续执行后面的代码。

>实际上await是一个让出线程的标记。await后面的表达式会先执行一遍，将await后面的代码加入到microtask中，然后就会跳出整个async函数来执行后面的代码。

>由于async await本身就是promise+generator的语法糖。所以await后面的代码是microtask。所以对于下面代码

```
async function async1(){
    console.log('async1 start')
    await async2();
    console.log('async1 end')
}

// 等价于

async function async1(){
    console.log('async1 start');
    Promise.resolve(async2()).then(()=>{
        console.log('async1 end');
    })
}
```

# 6.相关面试题
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
>考察点

- 主要考察的是事件循环中函数执行顺序的问题，其中包括 async、await、setTimeout、Promise函数。

>解析相关知识点

1. 首先，事件循环从宏任务（macrotask）队列开始，这个时候，宏任务队列中，只有一个script（整体代码）任务；当遇到任务源（task source）时，则会先分发到对应的任务队列中去。所以上面的例子第一步执行如图所示：
<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/JavaScript/JavaScript%20Event%20loop%20%E7%9B%B8%E5%85%B3%E9%9D%A2%E8%AF%95%E9%A2%98%E7%AC%AC%E4%B8%80%E6%AC%A1%E6%89%A7%E8%A1%8C%E7%A4%BA%E4%BE%8B.png'/>

2. 然后我们看到首先定义了两个async函数，接着往下看，然后遇到了console语句，直接输出script start。输出之后，script任务继续往下执行，遇到setTimeout，其作为一个宏任务源，则会先将其任务分发到对应的队列中：
<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/JavaScript/JavaScript%20Event%20loop%20%E7%9B%B8%E5%85%B3%E9%9D%A2%E8%AF%95%E9%A2%98%E7%AC%AC%E4%BA%8C%E6%AC%A1%E6%89%A7%E8%A1%8C%E7%A4%BA%E4%BE%8B.png'/>
3. script任务继续往下执行，执行了async1()函数，前面讲过async函数中的await之前的代码是立即执行的，所以会立即输出async1 start。遇到await时，会将await后面的表达式执行一遍，所以就紧接着输出async2，然后将await后面的代码也就是console.log('async1 end')加入到microtask中的Promise队列中，接着就跳出async1函数来执行后面的代码
<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/JavaScript/JavaScript%20Event%20loop%20%E7%9B%B8%E5%85%B3%E9%9D%A2%E8%AF%95%E9%A2%98%E7%AC%AC%E4%B8%89%E6%AC%A1%E6%89%A7%E8%A1%8C%E7%A4%BA%E4%BE%8B.png'/>
4. script任务继续往下执行，遇到Promise实例。由于Promise中的函数式立即执行，而后续的.then则会被分发到microtask的Promise队列中去。所以先输出promise1，然后执行resolve，将promise2分配到对应队列。
<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/JavaScript/JavaScript%20Event%20loop%20%E7%9B%B8%E5%85%B3%E9%9D%A2%E8%AF%95%E9%A2%98%E7%AC%AC%E5%9B%9B%E6%AC%A1%E6%89%A7%E8%A1%8C%E7%A4%BA%E4%BE%8B.png'/>

5. script任务继续往下执行，最后只有一句输出了 script end，至此，全局任务就执行完毕了。

    根据上述，每次执行完一个宏任务之后，会去检查是否存在 Microtasks；如果有，则执行 Microtasks 直至清空 Microtask Queue。

    因而在script任务执行完毕之后，开始查找清空微任务队列。此时，微任务中， Promise 队列有的两个任务async1 end和promise2，因此按先后顺序输出 async1 end，promise2。当所有的 Microtasks 执行完毕之后，表示第一轮的循环就结束了。
6. ~~第二轮循环开始，这个时候就会跳回async1函数中执行后面的代码，然后遇到了同步任务 console 语句，直接输出 async1 end。这样第二轮的循环就结束了。（也可以理解为被加入到script任务队列中，所以会先与setTimeout队列执行）~~
7. 第二轮循环依旧从宏任务队列开始。此时宏任务中只有一个 setTimeout，取出直接输出即可，至此整个流程结束。

# 7.扩展面试题
## 变式1

>在上面的面试题进行简单的修改，只修改了async2方法return的是一个Promise.resolve,结果但是不同

```
//请写出输出内容
async function async1() {
    console.log('async1 start');
    await async2();
    console.log('async1 end');
}
async function async2() {
	console.log('async2');
	return Promise.resolve('1');
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


// 结果
script start
async1 start
async2
promise1
script end
promise2
async1 end
setTimeout
```
>解析
- 将async的返回值修改为异步后，执行的结果是promise2与async1 end调换，结论是：
- + 当await的返回结果是一个异步时会加入微任务的异步队列，但是promise2的更早的加入异步队列，按照顺序执行则promise2先输出
- + 当await的返回结果不是一个异步队列时，首次await时会跳出本次循环，当第二次进入时会当成同步代码执行
## 变式2

>在第一个变式中我将async2中的函数也变成了Promise函数

```
async function async1() {
    console.log('async1 start');
    await async2();
    console.log('async1 end');
}
async function async2() {
    //async2做出如下更改：
    new Promise(function(resolve) {
    console.log('promise1');
    resolve();
}).then(function() {
    console.log('promise2');
    });
}
console.log('script start');

setTimeout(function() {
    console.log('setTimeout');
}, 0)
async1();

new Promise(function(resolve) {
    console.log('promise3');
    resolve();
}).then(function() {
    console.log('promise4');
});

console.log('script end');

// 结果
script start
async1 start
promise1
promise3
script end
promise2 
async1 end
promise4
setTimeout
```

>解析

- 在第一次macrotask执行完之后，也就是输出script end之后，会去清理所有microtask。所以会相继输出promise2， async1 end ，promise4

## 变式4
>在第二个变式中，我将async1中await后面的代码和async2的代码都改为异步的

```
async function async1() {
    console.log('async1 start');
    await async2();
    //更改如下：
    setTimeout(function() {
        console.log('setTimeout1')
    },0)
}
async function async2() {
    //更改如下：
	setTimeout(function() {
		console.log('setTimeout2')
	},0)
}
console.log('script start');

setTimeout(function() {
    console.log('setTimeout3');
}, 0)
async1();

new Promise(function(resolve) {
    console.log('promise1');
    resolve();
}).then(function() {
    console.log('promise2');
});
console.log('script end');

// 结果
script start
async1 start
promise1
script end
promise2
setTimeout3
setTimeout2
setTimeout1
```
>解析

- 在输出为promise2之后，接下来会按照加入setTimeout队列的顺序来依次输出，通过代码我们可以看到加入顺序为3 2 1，所以会按3，2，1的顺序来输出。

## 变式5
>变式三是我在一篇面经中看到的原题，整体来说大同小异，代码如下：

```
async function a1 () {
    console.log('a1 start')
    await a2()
    console.log('a1 end')
}
async function a2 () {
    console.log('a2')
}

console.log('script start')

setTimeout(() => {
    console.log('setTimeout')
}, 0)

Promise.resolve().then(() => {
    console.log('promise1')
})

a1()

let promise2 = new Promise((resolve) => {
    resolve('promise2.then')
    console.log('promise2')
})

promise2.then((res) => {
    console.log(res)
    Promise.resolve().then(() => {
        console.log('promise3')
    })
})
console.log('script end')


// 结果
script start
a1 start
a2
promise2
script end
promise1
a1 end
promise2.then
promise3
setTimeout
```

>[原文链接，已获得博主转载许可](https://github.com/Advanced-Frontend/Daily-Interview-Question/issues/7)
>如有侵权行为，请[点击这里](https://github.com/mattmengCooper/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/mattmengCooper/MattMeng_hexo/issues)

# 备注
>2019年5月29日

- 对面试题稍作修改添加变式1

