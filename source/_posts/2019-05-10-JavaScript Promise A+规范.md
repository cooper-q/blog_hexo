---
layout: post
toc: true
title: JavaScript Promise A+规范
date: 2019-05-10
keywords: JavaScript

categories:
    - JavaScript
tags:
    - JavaScript
---

# 1.概述
<!-- more -->
```
一份针对健全、通用JavaScript promises对象的开发标准——由实现者制定，
仅供参考。

一个Promise对象代表一个异步操作的最终结果。
与promise进行交互的主要方式是通过它的then方法，通过该方法注册回调函数，进行接收promise对象最终的值（value）
或不能完成（fulfill）的原因（reason）

本规范详细阐述了then方法的行为，
给所有遵循本规范的promise实现提供了一份通用的实现基础。
所以本规范可以认为一个标准。尽管Promise/A+ 组织可能偶尔处理一些新发现的边界情况（cornercases），
对本规范进行微小的向后兼容的修正，如果将要加入较大的不兼容的修正，
我们一定会进行仔细详尽的考虑、讨论以及测试。
删除和修正了Promise/A规范的某些规范。
本规范的核心不会讨论如何创建（create）、完成（fulfill）或者拒绝（reject）promises对象，
而是会专注如果提供一个通用的then方法。

```
# 2.术语
-  2.1 promise 是一个遵循本规范，并拥有then方法的对象或函数。
-  2.2 thenable 是一个定义了then方法的对象或函数。
-  2.3 value是一个JavaScript任意一种符合规范的值（包括undefined、thenable以及promise）
-  2.4 exception 是一个使用了throw语句抛出的值。
-  2.5 reason 是一个指示了promise为何被拒绝的值（rejected）

# 3.要求（Requirements）
## 1.Promise的状态

>一个Promise必须是以下三种状态之一：等待态（pending）、完成态（fulfilled）或拒绝态（rejected）

- 当处于pending状态时，pending->fulfilled 或者 pending->rejected
- 当处于fulfilled状态时
```
不能转换为其他状态
必须拥有一个固定不变的值
```
- 当处于rejected状态时
```
不能转换为其他状态
必须拥有一个固定不变的理由（reason）

```

## 2.then方法
>一个promise对象必须提供一个then方法来访问起当前值、最终的值或原因。promise对象的then方法接受两个参数:

```
promise.then(onFulfilled,onRejected)
```
>onFulfilled和onRejected都是可选参数

```
如果onFulfilled、onRejected不是函数，必须将其忽略。
```
>如果onFulfilled是一个函数

- 当promise完成（fulfilled）后必须对其调用，并且promise最终的值（value）作为第一个参数；
- promise未完成（fulfilled）前，不能对其调用。
- 调用次数不可超过一次。

>如果onRejected是一个函数

- 当promise被拒绝（rejected）后必须对其调用，并且promise最终的原因（reason）作为第一个参数。
- promise未被拒绝（rejected）前，不能对其调用。
- 调用次数不可超过一次。

>onFulfilled和onRejected只有在执行上下文（execution context）堆栈仅包含平台代码（platform code）时才可以被调用。

>onFulfilled和onRejected必须被作为函数调用。
>then方法可以被同一个promise对象调用多次。

- 如果当promise执行完成后（fulfilled），所有onFulfilled回调函数，必须按照其最初调用then的顺序依次执行。
- 如果当promise执行被拒绝后，所有onRejected回调函数，必须按照其最初调用的then的顺序依次执行。

>then方法必须返回一个promise对象

```
promise2 = promise1.then(onFulfilled,onRejected)
```

- 如果onFulfilled或者onRejected返回一个值x，运行Promise Resolution Procedure [[Resolve]] (promise2,x)
- 如果onFulfilled或者onRejected抛出一个异常e，则promise2必须拒绝执行，并以作为拒绝的原因。
- 如果onFulfilled不是函数，并且promise1执行完成，promise2必须成功完成并返回相同的值（value）。
- 如果onRejected不是函数，并且promise1执行被拒绝，promise2必须以相同的原因（reason）被拒绝执行。

## 3.The Promise Resolution Procedure （PRP）

```
Promise Resolution Procedure是一个抽象的操作，以一个promise和一个值（value）
作为输入参数，我们表示为[[Resolve]] (promise,x)。
如果x是一个thenable的对象（即一个拥有then方法的函数或对象），
并且其行为和一个promise对象至少些许相似，PRP就会尝试让promise接受x的状态，
否则，其用x的值来执行完成promise。

这种处理thenables的方式使得各种promise的实现可以互通，只要它们开放一个
与Promise/A+协议兼容的then方法即可。
这也使得遵循Promise/A+规范的实现可以接受(这里的接受，
原文使用了assimiltate这个单词，愿意为消化吸收，这里指的是可以接受其他非规范化实现的then方法)
那些未遵循规范实现的合理的then方法。
```
>通过以下步骤来运行[[Resolve]] (promise,x)

- 如果promise和x引用同一对象，以TypeError为原因拒绝执行promise
- 如果x是一个promise对象，则promise采纳x的状态
  + 如果x处于等待态（pending），promise必须保持为等待态（pending）直到x完成（fulfilled）和拒绝（rejected）
  +  如果当x已经完成（fulfilled），使用相同的值执行完成promise。
  +  如果当x被拒绝（reject），使用相同的原因拒绝执行promise。
- 其他情况，如果x为一个对象或者函数:
  + 把then赋值为x.then
  + 如果取x.then的值时抛出错误e，则使用e为原因拒绝promise。
  + 如果then是一个函数，则以作为this的值对其进行调用，并以resolvePromise作为第一个参数，x作为第二个参数
    * 如果当以y值为参数调用resolvePromise时，则运行[[Resolve]] (promise,y)
    * 如果当以r原因为参数调用rejectPromise时，则使用原因r拒绝执行promise。
    * 如果resolvePromise和rejectPromise都被调用，或者被使用相同的参数调用了多次，则首次调用将被优先采用，其他调用将被忽略。
    * 如果调用then方法过程中抛出异常e：
        * 如果resolvePromise或rejectPromise都已经被调用，则忽略该异常。
        * 否则使用e为原因拒绝执行promise。
  + 如果then不是函数，以x为值完成promise。
- 如果x不是对象或者函数，以x为值完成promise。
# 4.注释
- 1.这里 "平台代码"指的是引擎（engine）、环境（envireonment）以及promise的实现代码（implementation code）。实际上，这个要求确保了 onFulfilled和onReject方法能够异步执行，即在调用then方法的那个事件循环之后的新执行栈中异步执行。这个要求可以通过 "宏任务(macro-task)"机制（例如 setTimeout或者setImmediate）或者微任务（micro-task）机制（例如MutationObserver或者process.nextTick）来实现。既然promise的实现代码本事也被认为是 "平台代码"，所以其自身可能也会包含一种任务调度队列或者trampoline控制结构来对其处理程序进行调动。
- 2.也就是说，this的值，在严格模式下（strict）下为undefined；在非严格模式下为全局对象（global object）。
- 3.在满足所有要求的情况下，现实实现中可能允许promise2===promise1。每个实现都需要说明其是否允许出现promise2===promise1,以及在何种条件下出现。
- 4.通常来说，只有当x是从当前实现中定义出来的，我们才知道它是一个真正的promise对象。这条规则允许使用特定实现中的方法去采用符合规范的promise对象的状态。
- 5.这一步骤我们首先会存储一个指向x.then的引用，然后测试该调用，之后调用该引用，这一系列过程为了防止x.then属性的多处访问。这些预防措施对于保证访问器属性的一致性至关重要，因为其值可能在多次取值期间发生变化。
- 6.本规范的实现不应该任意限定thenable链的深度，并认识只要超过了该限定递归就是无限的。只有真正的循环递归才应导致一个TypeError；如果一个无限长链上的thenable对象各不相同，那么无限递归下去则是正确的行为

>[原文英文链接](https://promisesaplus.com/)

>如有侵权行为，请[点击这里](https://github.com/cooper-q/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/cooper-q/MattMeng_hexo/issues)

# 备注
>2019年5月10日
```
本资料来源于网络，加上自己的理解。如果有错误，请及时指正。
```
