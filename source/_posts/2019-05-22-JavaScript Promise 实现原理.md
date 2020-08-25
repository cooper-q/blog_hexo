---
layout: post
title: JavaScript Promise 实现原理（转载）
date: 2019-05-22
keywords: JavaScript

categories:
    - JavaScript
tags:
    - JavaScript
---
# JavaScript Promise 实现原理
# 1.<span style='color:#C82B52;background-color:#F9F2F4'>Promise</span> 基本结构
```JavaScript
new Promise((resolve,reject)=>{
    setTimeout(()=>{
        resolve('Fulfilled');
    })
})
```
>构造函数<span style='color:#C82B52;background-color:#F9F2F4'>Promise</span>必须接受一个函数作为参数，我们称该函数为<span style='color:#C82B52;background-color:#F9F2F4'>handle</span>，<span style='color:#C82B52;background-color:#F9F2F4'>handle</span>又包含<span style='color:#C82B52;background-color:#F9F2F4'>resolve</span>和<span style='color:#C82B52;background-color:#F9F2F4'>reject</span>两个参数，它们是两个参数。
<!-- more -->

```JavaScript
定义一个判断一个变量是否为函数的方法，后面会用到

// 判断变量是否为function
const isFunction = variable=>typeof variable ==='function';
```
```JavaScript
首先，我们定义一个名为MyPromise的Class，他接受一个函数handle作为参数

class MyPromise {
    constructor(handle){
        if(!isFunction(handle)){
            throw new Error('MyPromise must accept a function as a parameter')
        }
    }
}
```
# 2.<span style='color:#C82B52;background-color:#F9F2F4'>Promise</span>状态和值
><span style='color:#C82B52;background-color:#F9F2F4'>Promise</span>对象存在三种状态：
- <span style='color:#C82B52;background-color:#F9F2F4'>Pending（进行中）
- <span style='color:#C82B52;background-color:#F9F2F4'>Fulfilled（已成功）
- <span style='color:#C82B52;background-color:#F9F2F4'>Rejected（已失败）

>状态只能由<span style='color:#C82B52;background-color:#F9F2F4'>Pending</span>变为<span style='color:#C82B52;background-color:#F9F2F4'>Fulfilled</span>或由<span style='color:#C82B52;background-color:#F9F2F4'>Pending</span>变为<span style='color:#C82B52;background-color:#F9F2F4'>Rejected</span>，且状态改变之后不会发生变化，会一直保持这个状态。


><span style='color:#C82B52;background-color:#F9F2F4'>Promise</span>的值是指改变状态时传递给回调函数的值

>上文中<span style='color:#C82B52;background-color:#F9F2F4'>handle</span>函数包含<span style='color:#C82B52;background-color:#F9F2F4'>resolve</span>和<span style='color:#C82B52;background-color:#F9F2F4'>reject</span>两个参数，它们是两个函数，可以用于改变Promise的状态和传入Promise的值。

```JavaScript
new Promise((resolve,reject)=>{
    setTimeout(()=>{
        resolve('Fulfilled')
    })
})
```
>这里的<span style='color:#C82B52;background-color:#F9F2F4'>resolve</span>传入的<span style='color:#C82B52;background-color:#F9F2F4'>Fulfilled</span>就是<span style='color:#C82B52;background-color:#F9F2F4'>Promise</span>的值

><span style='color:#C82B52;background-color:#F9F2F4'>resolve</span>和<span style='color:#C82B52;background-color:#F9F2F4'>reject</span>
- <span style='color:#C82B52;background-color:#F9F2F4'>resolve</span>：将<span style='color:#C82B52;background-color:#F9F2F4'>Promise</span>对象的状态从<span style='color:#C82B52;background-color:#F9F2F4'>Pending（进行中）</span>变为<span style='color:#C82B52;background-color:#F9F2F4'>Fulfilled（已成功）</span>
- <span style='color:#C82B52;background-color:#F9F2F4'>reject</span>：将<span style='color:#C82B52;background-color:#F9F2F4'>Promise</span>对象的状态从<span style='color:#C82B52;background-color:#F9F2F4'>Pending（进行中）</span>变为<span style='color:#C82B52;background-color:#F9F2F4'>Rejected（已失败）</span>
- <span style='color:#C82B52;background-color:#F9F2F4'>resolve</span>和<span style='color:#C82B52;background-color:#F9F2F4'>reject</span>都可以传入任意类型的值作为参考，表示<span style='color:#C82B52;background-color:#F9F2F4'>Promise</span>对象成功<span style='color:#C82B52;background-color:#F9F2F4'>（Fulfilled）</span>和失败<span style='color:#C82B52;background-color:#F9F2F4'>（Rejected）</span>的值。

>了解了<span style='color:#C82B52;background-color:#F9F2F4'>Promise</span>的状态和值，接下来为<span style='color:#C82B52;background-color:#F9F2F4'>MyPromise</span>添加状态属性和值

```
// 首先定义两个常量，用于标记Promise对象的三种状态
const PENDING = 'PENDING';
const FULFILLED = 'FULFILLED';
const REJECTED = 'REJECTED';
```
>再为<span style='color:#C82B52;background-color:#F9F2F4'>MyPromise</span>添加状态和值，并添加状态改变的执行逻辑(这里可以用最新版Node.js的私有变量定义)。

```JavaScript
class MyPromise {
    constructor (handle){
        if(isFunction(handle)){
            throw new Error('MyPromise must accept a function as a parameter')
        }
        this._status = PENDING;
        this._value = undefined;
        try{
            handle(this._resolve.bind(this),this._reject.bind(this));
        }catch(err){
            this._reject(err);
        }
    }
    // 添加resolve时执行的函数
    _resolve(val){
        if(this._status!==PENDING){
            return;
        }
        this._status=FULLFILLED;
        this._value=val;
    }
    // 添加reject时执行的函数
    _reject(err){
        if(this._status!==PENDING){
            return;
        }
        this._status=REJECTED;
        this._value=err;
    }
}
// 这样就实现了Promise状态和值得改变。
```
# 3.<span style='color:#C82B52;background-color:#F9F2F4'>Promise</span>的then方法

><span style='color:#C82B52;background-color:#F9F2F4'>Promise</span>对象的then方法接受两个参数：
```
promise.then(onFullfilled,onRejected)
```
## 1.参数可选

- <span style='color:#C82B52;background-color:#F9F2F4'>onFulfilled</span>和<span style='color:#C82B52;background-color:#F9F2F4'>onRejected</span>都是可选参数
- - 如果<span style='color:#C82B52;background-color:#F9F2F4'>onFulfilled</span>或<span style='color:#C82B52;background-color:#F9F2F4'>onRejected</span>不是函数，其必须被忽略。


- <span style='color:#C82B52;background-color:#F9F2F4'>onFulfilled</span>特性
- - 如果<span style='color:#C82B52;background-color:#F9F2F4'>onFulfilled</span>是函数
- + + 当<span style='color:#C82B52;background-color:#F9F2F4'>promise</span>状态变为成功时必须被调用，其第一个参数为<span style='color:#C82B52;background-color:#F9F2F4'>promise</span>成功状态传入的值（resolve执行时传入的值）
- + + 在<span style='color:#C82B52;background-color:#F9F2F4'>promise</span>状态改变前其不可被调用
- + + 其调用次数不可以超过一次


- <span style='color:#C82B52;background-color:#F9F2F4'>onRejected</span>特性
- + 如果<span style='color:#C82B52;background-color:#F9F2F4'>onReject</span>是函数
- + + 当<span style='color:#C82B52;background-color:#F9F2F4'>promise</span>状态变为失败时必须被调用，其第一个参数为<span style='color:#C82B52;background-color:#F9F2F4'>promise</span>失败状态传入的值（<span style='color:#C82B52;background-color:#F9F2F4'>reject</span>执行时传入的值）
- + + <span style='color:#C82B52;background-color:#F9F2F4'>在promise</span>状态改变前其不可以被调用
- + + 其调用次数不可超过一次

## 2.多次调用
- then方法可以被同一个<span style='color:#C82B52;background-color:#F9F2F4'>promise</span>对象调用多次
- + 当<span style='color:#C82B52;background-color:#F9F2F4'>promise</span>成功状态时，所有<span style='color:#C82B52;background-color:#F9F2F4'>onFulfilled</span>需按照其顺序依次回调。
- + 当<span style='color:#C82B52;background-color:#F9F2F4'>promise</span>失败状态时，所有<span style='color:#C82B52;background-color:#F9F2F4'>onRejected</span>需按照其注册顺序一次回调。

## 3.返回
>then方法必须返回一个新的<span style='color:#C82B52;background-color:#F9F2F4'>promise</span>对象

```JavaScript
promise2 = promise1.then(onFulfilled,onRejected);
```
>因此<span style='color:#C82B52;background-color:#F9F2F4'>promise</span>支持链式调用

```JavaScript
promise1.then(onFulfilled,onRejected).then(onFulfilled,onRejected)
```
>这里涉及到<span style='color:#C82B52;background-color:#F9F2F4'>Promise</span>的执行规则，包括 ==值得传递==和==错误捕获==机制

### 1.如果<span style='color:#C82B52;background-color:#F9F2F4'> onFulfilled </span>或者<span style='color:#C82B52;background-color:#F9F2F4'> onRejected </span>返回一个x值，则运行下面的<span style='color:#C82B52;background-color:#F9F2F4'> Promise </span>解决过程：<span style='color:#C82B52;background-color:#F9F2F4'> [[Resolve]] (promise2,x) </span>

- 若<span style='color:#C82B52;background-color:#F9F2F4'> x </span>不为<span style='color:#C82B52;background-color:#F9F2F4'> Promise </span>，则使<span style='color:#C82B52;background-color:#F9F2F4'> x </span>直接作为新返回的<span style='color:#C82B52;background-color:#F9F2F4'> Promise </span>对象的值，即新的<span style='color:#C82B52;background-color:#F9F2F4'> onFulfilled </span>或者<span style='color:#C82B52;background-color:#F9F2F4'> onRejected </span>函数的参数
- 若<span style='color:#C82B52;background-color:#F9F2F4'> x </span>为<span style='color:#C82B52;background-color:#F9F2F4'> Promise </span>，这时后一个回调函数，就会等待该<span style='color:#C82B52;background-color:#F9F2F4'> Promise </span>对象（即<span style='color:#C82B52;background-color:#F9F2F4'> x </span>）的状态发生变化，才会被调用，并且新的<span style='color:#C82B52;background-color:#F9F2F4'> Promise </span>状态和<span style='color:#C82B52;background-color:#F9F2F4'> x </span>的状态相同。

>例子

```JavaScript
let promise1 = new Promise((resolve,reject)=>{
    setTimeout(()=>{
        resolve()
    },1000)
})
promise2 = promise1.then(res=>{
    // 返回一个普通值
    return '这里返回一个普通值';
})
promise2.then(res=>{
    console.log(res) // 1秒后打印出：这里返回一个普通值
})
```
```JavaScript
let promise1 = new Promise((resolve,reject)=>{
    setTimeout(()=>{
        resolve();
    },1000)
})
promise2 = promise1.then(res=>{
    return new Promise((resolve,reject)=>{
        setTimeout(()=>{
          resolve('这里返回一个Promise')
        },2000)
    }
})
promise2.then(res=>{
    console.log(res) // 3秒后打印出：这里返回一个Promise
})
```
### 2.如果<span style='color:#C82B52;background-color:#F9F2F4'> onFulfilled </span>或者<span style='color:#C82B52;background-color:#F9F2F4'> onRejected </span>抛出一个异常，则<span style='color:#C82B52;background-color:#F9F2F4'> promise2 </span>必须变为<span style='color:#C82B52;background-color:#F9F2F4'>（Rejected）</span>，并返回失败的值e
```JavaScript
let promise1 = new Promise((resolve,reject)=>{
    setTimeout(()=>{
        resolve('success')
    },1000)
})
promise2 = promise1.then(res=>{
    throw new Error('这里抛出一个异常e')
})
promise2.then(res=>{
    console.log(res)
},(err)=>{
    console.log(err) // 1秒后打印：这里抛出一个异常e
})
```
### 3.如果<span style='color:#C82B52;background-color:#F9F2F4'> onFulfilled </span>不是函数且<span style='color:#C82B52;background-color:#F9F2F4'> promise1 </span>状态为成功<span style='color:#C82B52;background-color:#F9F2F4'>（Fulfilled）</span>，<span style='color:#C82B52;background-color:#F9F2F4'> promise2 </span>必须变成成功<span style='color:#C82B52;background-color:#F9F2F4'>（Fulfilled）</span>并返回<span style='color:#C82B52;background-color:#F9F2F4'> promise1 </span>成功的值

```JavaScript
let promise1 = new Promise((resolve,reject)=>{
    setTimeout(()=>{
        resolve('success')
    },1000)
})
promise2 = promise1.then('这里的onFulfilled本来是一个函数，但现在不是')
promise2.then(res=>{
    console.log(res) // 1秒后打印出：success
},err=>{
    console.log(err)
})
```
### 4.如果<span style='color:#C82B52;background-color:#F9F2F4'> onRejected </span>不是函数且<span style='color:#C82B52;background-color:#F9F2F4'> promise1 </span>状态为失败<span style='color:#C82B52;background-color:#F9F2F4'>（Rejected）</span>，<span style='color:#C82B52;background-color:#F9F2F4'> promise2 </span>必须变为失败<span style='color:#C82B52;background-color:#F9F2F4'>（Rejected）</span>并返回<span style='color:#C82B52;background-color:#F9F2F4'> promise1</span>失败的值
```JavaScript
let promise1 = new Promise((resolve,reject)=>{
    setTimeout(()=>{
        reject('fail');
    },1000)
})
promise2 = promise1.then(res=>res,'这里的onRejected本来就是一个函数，但现在不是')
promise2.then(res=>{
    console.log(res)
},res=>{
    console.log(err) // 1秒打印出:fail
})
```
>根据上面的规则，我们来为完善<span style='color:#C82B52;background-color:#F9F2F4'>  MyPromise </span>
>修改<span style='color:#C82B52;background-color:#F9F2F4'> constructor </span>：增加执行队列

>由于<span style='color:#C82B52;background-color:#F9F2F4'> then </span>方法支持多次调用，我们可以维护两个数组，将每次<span style='color:#C82B52;background-color:#F9F2F4'> then </span>方法注册时的回调函数添加到数组中，等待执行

```JavaScript
construcotr(handle){
    if(!isFunction(handle)){
        throw new Error('MyPromiise must accept a functiion as a parameter')
    }
    // 添加状态
    this._status = PENDING;
    // 添加状态
    this._value = undefined;
    // 添加成功回调函数队列
    this._fulfilledQueues=[];
    // 添加失败回调函数队列
    this._rejectedQueues = [];
    // 执行handle
    try{
        handle(this._resolve.bind(this),this._reject.bind(this))
    }catch(err){
        this._reject(err)
    }
}
```
>添加<span style='color:#C82B52;background-color:#F9F2F4'> then </span>方法

>首先,<span style='color:#C82B52;background-color:#F9F2F4'> then </span>返回一个新的<span style='color:#C82B52;background-color:#F9F2F4'> Promise </span>对象，并且需要将回调函数加入到执行队列中去

```JavaScript
then (onFulfilled,onRejected){
    const {_value,_status}=this;
    switch(_status){
        // 当状态为pending时，将then方法回调函数加入执行队列等待执行
        case PENDING:
            this._fulfilledQueues.push(onFulfilled)
            this._rejectedQueues.push(onRejected)
        // 当状态已经改变时，立即执行对应的回调函数
        case FULFILLED:
            onFulfilled(_value)
            break;
        case REJECTED:
            onRejected(_value);
            break;
    }
    // 返回一个新的Promise对象
    return new MyPromise((onFullfilledNext,onRejectedNext)=>{

    })
}
```
>那返回的新的<span style='color:#C82B52;background-color:#F9F2F4'> Promise </span>对象什么时候改变状态？改变为哪种状态呢？

>根据上文中<span style='color:#C82B52;background-color:#F9F2F4'> then </span>方法的规则，我们知道返回新的<span style='color:#C82B52;background-color:#F9F2F4'> Promise </span>对象的状态依赖于当前<span style='color:#C82B52;background-color:#F9F2F4'> then </span>方法回调函数执行的情况以及返回值，例如<span style='color:#C82B52;background-color:#F9F2F4'> then </span>参数的是否为一个函数、回调函数执行是否出错、返回值是否为<span style='color:#C82B52;background-color:#F9F2F4'> Promise </span>对象。

```JavaScript
// 添加then方法
then (onFulfilled, onRejected) {
  const { _value, _status } = this
  // 返回一个新的Promise对象
  return new MyPromise((onFulfilledNext, onRejectedNext) => {
    // 封装一个成功时执行的函数
    let fulfilled = value => {
      try {
        if (!isFunction(onFulfilled)) {
          onFulfilledNext(value)
        } else {
          let res =  onFulfilled(value);
          if (res instanceof MyPromise) {
            // 如果当前回调函数返回MyPromise对象，必须等待其状态改变后在执行下一个回调
            res.then(onFulfilledNext, onRejectedNext)
          } else {
            //否则会将返回结果直接作为参数，传入下一个then的回调函数，并立即执行下一个then的回调函数
            onFulfilledNext(res)
          }
        }
      } catch (err) {
        // 如果函数执行出错，新的Promise对象的状态为失败
        onRejectedNext(err)
      }
    }
    // 封装一个失败时执行的函数
    let rejected = error => {
      try {
        if (!isFunction(onRejected)) {
          onRejectedNext(error)
        } else {
            let res = onRejected(error);
            if (res instanceof MyPromise) {
              // 如果当前回调函数返回MyPromise对象，必须等待其状态改变后在执行下一个回调
              res.then(onFulfilledNext, onRejectedNext)
            } else {
              //否则会将返回结果直接作为参数，传入下一个then的回调函数，并立即执行下一个then的回调函数
              onFulfilledNext(res)
            }
        }
      } catch (err) {
        // 如果函数执行出错，新的Promise对象的状态为失败
        onRejectedNext(err)
      }
    }
    switch (_status) {
      // 当状态为pending时，将then方法回调函数加入执行队列等待执行
      case PENDING:
        this._fulfilledQueues.push(fulfilled)
        this._rejectedQueues.push(rejected)
        break
      // 当状态已经改变时，立即执行对应的回调函数
      case FULFILLED:
        fulfilled(_value)
        break
      case REJECTED:
        rejected(_value)
        break
    }
  })
}
```
>这一部分可能不太好理解，需要结合上文中<span style='color:#C82B52;background-color:#F9F2F4'> then </span>方法的规则来细细的分析


>接着修改<span style='color:#C82B52;background-color:#F9F2F4'> _resolve </span>和<span style='color:#C82B52;background-color:#F9F2F4'> _reject </span>：依次执行队列中的函数

>当<span style='color:#C82B52;background-color:#F9F2F4'> resolve </span>和<span style='color:#C82B52;background-color:#F9F2F4'> reject </span>方法执行时，我们依次提取成功或失败任务队列当中的函数开始执行，并清空队列，从而实现then方法的多次调用。

```JavaScript
// 添加resovle时执行的函数
_resolve (val) {
  if (this._status !== PENDING) return
  // 依次执行成功队列中的函数，并清空队列
  const run = () => {
    this._status = FULFILLED
    this._value = val
    let cb;
    while (cb = this._fulfilledQueues.shift()) {
      cb(val)
    }
  }
  // 为了支持同步的Promise，这里采用异步调用
  setTimeout(() => run(), 0)
}
// 添加reject时执行的函数
_reject (err) {
  if (this._status !== PENDING) return
  // 依次执行失败队列中的函数，并清空队列
  const run = () => {
    this._status = REJECTED
    this._value = err
    let cb;
    while (cb = this._rejectedQueues.shift()) {
      cb(err)
    }
  }
  // 为了支持同步的Promise，这里采用异步调用
  setTimeout(run, 0)
}
```
>这里还有一中特殊情况，就是当<span style='color:#C82B52;background-color:#F9F2F4'> resolve </span>方法传入的参数为一个<span style='color:#C82B52;background-color:#F9F2F4'>  </span>，则该<span style='color:#C82B52;background-color:#F9F2F4'> Promise </span>对象状态决定当前<span style='color:#C82B52;background-color:#F9F2F4'> Promise </span>对象的状态

```
const p1 = new Promise(function(resolve,reject){
    // ....
})
const p2 = new Promise(function(resolve,reject){
    // ...
    resolve(p1);
})
// 上面代码中，p1和p2都是Promise的实例，
但是p2的resolve方法将p1作为参数，即一个异步操作的结果是返回另一个异步操作。
// 注意，这时p1的状态就会传递给p2，也就是说,p1的状态决定了p2的状态。
如果p1的状态时Pending，那么p2的回调函数就会等待p1的状态改变；
如果p1的状态已经是Fulfilled或者Rejected，那么p2的回调函数就会立即执行
```
>我们来修改<span style='color:#C82B52;background-color:#F9F2F4'> _resolve </span>来支持这样的特性

```JavaScript
  // 添加resovle时执行的函数
  _resolve (val) {
    const run = () => {
      if (this._status !== PENDING) return
      // 依次执行成功队列中的函数，并清空队列
      const runFulfilled = (value) => {
        let cb;
        while (cb = this._fulfilledQueues.shift()) {
          cb(value)
        }
      }
      // 依次执行失败队列中的函数，并清空队列
      const runRejected = (error) => {
        let cb;
        while (cb = this._rejectedQueues.shift()) {
          cb(error)
        }
      }
      /* 如果resolve的参数为Promise对象，则必须等待该Promise对象状态改变后,
        当前Promsie的状态才会改变，且状态取决于参数Promsie对象的状态
      */
      if (val instanceof MyPromise) {
        val.then(value => {
          this._value = value
          this._status = FULFILLED
          runFulfilled(value)
        }, err => {
          this._value = err
          this._status = REJECTED
          runRejected(err)
        })
      } else {
        this._value = val
        this._status = FULFILLED
        runFulfilled(val)
      }
    }
    // 为了支持同步的Promise，这里采用异步调用
    setTimeout(run, 0)
  }
```

><span style='color:#C82B52;background-color:#F9F2F4'> catch </span>方法

```JavaScript
相当于调用then方法，但是只传入Rejected状态的回调函数
```

```JavaScript
// 添加catch方法
catch (onReject){
    return this.then(undefined,onRejected)
}
```

>静态<span style='color:#C82B52;background-color:#F9F2F4'> resolve </span>方法

```JavaScript
// 添加静态resolve方法
static resolve (value) {
  // 如果参数是MyPromise实例，直接返回这个实例
  if (value instanceof MyPromise) return value
  return new MyPromise(resolve => resolve(value))
}
```

>静态<span style='color:#C82B52;background-color:#F9F2F4'> reject </span>方法

```JavaScript
// 添加静态reject方法
static reject (value) {
  return new MyPromise((resolve ,reject) => reject(value))
}
```

>静态<span style='color:#C82B52;background-color:#F9F2F4'> all </span>方法

```JavaScript
// 添加静态all方法
static all (list) {
  return new MyPromise((resolve, reject) => {
    /**
     * 返回值的集合
     */
    let values = []
    let count = 0
    for (let [i, p] of list.entries()) {
      // 数组参数如果不是MyPromise实例，先调用MyPromise.resolve
      this.resolve(p).then(res => {
        values[i] = res
        count++
        // 所有状态都变成fulfilled时返回的MyPromise状态就变成fulfilled
        if (count === list.length) resolve(values)
      }, err => {
        // 有一个被rejected时返回的MyPromise状态就变成rejected
        reject(err)
      })
    }
  })
}
```
>静态<span style='color:#C82B52;background-color:#F9F2F4'> race </span>方法

```JavaScript
// 添加静态race方法
static race (list) {
  return new MyPromise((resolve, reject) => {
    for (let p of list) {
      // 只要有一个实例率先改变状态，新的MyPromise的状态就跟着改变
      this.resolve(p).then(res => {
        resolve(res)
      }, err => {
        reject(err)
      })
    }
  })
}
```

><span style='color:#C82B52;background-color:#F9F2F4'> finally </span> 方法

```JavaScript
finally方法用于指定不管Promise对象最后状态如何，都会执行操作
```
```JavaScript
finally (cb) {
  return this.then(
    value  => MyPromise.resolve(cb()).then(() => value),
    reason => MyPromise.resolve(cb()).then(() => { throw reason })
  );
};
```
>这样一个完整的 <span style='color:#C82B52;background-color:#F9F2F4'> Promsie </span> 就实现了，大家对 <span style='color:#C82B52;background-color:#F9F2F4'> Promise </span> 的原理也有了解，可以让我们在使用<span style='color:#C82B52;background-color:#F9F2F4'> Promise </span>的时候更加清晰明了

>完整代码如下

```JavaScript
  // 判断变量否为function
  const isFunction = variable => typeof variable === 'function'
  // 定义Promise的三种状态常量
  const PENDING = 'PENDING'
  const FULFILLED = 'FULFILLED'
  const REJECTED = 'REJECTED'

  class MyPromise {
    constructor (handle) {
      if (!isFunction(handle)) {
        throw new Error('MyPromise must accept a function as a parameter')
      }
      // 添加状态
      this._status = PENDING
      // 添加状态
      this._value = undefined
      // 添加成功回调函数队列
      this._fulfilledQueues = []
      // 添加失败回调函数队列
      this._rejectedQueues = []
      // 执行handle
      try {
        handle(this._resolve.bind(this), this._reject.bind(this))
      } catch (err) {
        this._reject(err)
      }
    }
    // 添加resovle时执行的函数
    _resolve (val) {
      const run = () => {
        if (this._status !== PENDING) return
        // 依次执行成功队列中的函数，并清空队列
        const runFulfilled = (value) => {
          let cb;
          while (cb = this._fulfilledQueues.shift()) {
            cb(value)
          }
        }
        // 依次执行失败队列中的函数，并清空队列
        const runRejected = (error) => {
          let cb;
          while (cb = this._rejectedQueues.shift()) {
            cb(error)
          }
        }
        /* 如果resolve的参数为Promise对象，则必须等待该Promise对象状态改变后,
          当前Promsie的状态才会改变，且状态取决于参数Promsie对象的状态
        */
        if (val instanceof MyPromise) {
          val.then(value => {
            this._value = value
            this._status = FULFILLED
            runFulfilled(value)
          }, err => {
            this._value = err
            this._status = REJECTED
            runRejected(err)
          })
        } else {
          this._value = val
          this._status = FULFILLED
          runFulfilled(val)
        }
      }
      // 为了支持同步的Promise，这里采用异步调用
      setTimeout(run, 0)
    }
    // 添加reject时执行的函数
    _reject (err) {
      if (this._status !== PENDING) return
      // 依次执行失败队列中的函数，并清空队列
      const run = () => {
        this._status = REJECTED
        this._value = err
        let cb;
        while (cb = this._rejectedQueues.shift()) {
          cb(err)
        }
      }
      // 为了支持同步的Promise，这里采用异步调用
      setTimeout(run, 0)
    }
    // 添加then方法
    then (onFulfilled, onRejected) {
      const { _value, _status } = this
      // 返回一个新的Promise对象
      return new MyPromise((onFulfilledNext, onRejectedNext) => {
        // 封装一个成功时执行的函数
        let fulfilled = value => {
          try {
            if (!isFunction(onFulfilled)) {
              onFulfilledNext(value)
            } else {
              let res =  onFulfilled(value);
              if (res instanceof MyPromise) {
                // 如果当前回调函数返回MyPromise对象，必须等待其状态改变后在执行下一个回调
                res.then(onFulfilledNext, onRejectedNext)
              } else {
                //否则会将返回结果直接作为参数，传入下一个then的回调函数，并立即执行下一个then的回调函数
                onFulfilledNext(res)
              }
            }
          } catch (err) {
            // 如果函数执行出错，新的Promise对象的状态为失败
            onRejectedNext(err)
          }
        }
        // 封装一个失败时执行的函数
        let rejected = error => {
          try {
            if (!isFunction(onRejected)) {
              onRejectedNext(error)
            } else {
                let res = onRejected(error);
                if (res instanceof MyPromise) {
                  // 如果当前回调函数返回MyPromise对象，必须等待其状态改变后在执行下一个回调
                  res.then(onFulfilledNext, onRejectedNext)
                } else {
                  //否则会将返回结果直接作为参数，传入下一个then的回调函数，并立即执行下一个then的回调函数
                  onFulfilledNext(res)
                }
            }
          } catch (err) {
            // 如果函数执行出错，新的Promise对象的状态为失败
            onRejectedNext(err)
          }
        }
        switch (_status) {
          // 当状态为pending时，将then方法回调函数加入执行队列等待执行
          case PENDING:
            this._fulfilledQueues.push(fulfilled)
            this._rejectedQueues.push(rejected)
            break
          // 当状态已经改变时，立即执行对应的回调函数
          case FULFILLED:
            fulfilled(_value)
            break
          case REJECTED:
            rejected(_value)
            break
        }
      })
    }
    // 添加catch方法
    catch (onRejected) {
      return this.then(undefined, onRejected)
    }
    // 添加静态resolve方法
    static resolve (value) {
      // 如果参数是MyPromise实例，直接返回这个实例
      if (value instanceof MyPromise) return value
      return new MyPromise(resolve => resolve(value))
    }
    // 添加静态reject方法
    static reject (value) {
      return new MyPromise((resolve ,reject) => reject(value))
    }
    // 添加静态all方法
    static all (list) {
      return new MyPromise((resolve, reject) => {
        /**
         * 返回值的集合
         */
        let values = []
        let count = 0
        for (let [i, p] of list.entries()) {
          // 数组参数如果不是MyPromise实例，先调用MyPromise.resolve
          this.resolve(p).then(res => {
            values[i] = res
            count++
            // 所有状态都变成fulfilled时返回的MyPromise状态就变成fulfilled
            if (count === list.length) resolve(values)
          }, err => {
            // 有一个被rejected时返回的MyPromise状态就变成rejected
            reject(err)
          })
        }
      })
    }
    // 添加静态race方法
    static race (list) {
      return new MyPromise((resolve, reject) => {
        for (let p of list) {
          // 只要有一个实例率先改变状态，新的MyPromise的状态就跟着改变
          this.resolve(p).then(res => {
            resolve(res)
          }, err => {
            reject(err)
          })
        }
      })
    }
    finally (cb) {
      return this.then(
        value  => MyPromise.resolve(cb()).then(() => value),
        reason => MyPromise.resolve(cb()).then(() => { throw reason })
      );
    }
  }
```

>[原文链接，略有删减](https://segmentfault.com/a/1190000012664201?share_user=1030000018203896)

>如有侵权行为，请[点击这里](https://github.com/cooper-q/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/cooper-q/MattMeng_hexo/issues)

# 备注

