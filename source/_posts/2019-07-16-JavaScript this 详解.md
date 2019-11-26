---
layout: post
title: JavaScript this详解
date: 2019-07-16
keywords:
top: 10
categories:
    - JavaScript
tags:
    - JavaScript
---
# JavaScript this详解

# 1.this的绑定的时机

- this在运行期绑定（有特殊）JavaScript 函数中的 this 指向并不是在函数定义的时候确定的，而是在调用的时候确定的。
- <span style='color:red'>函数的调用方式决定了 this 指向。</span>

# 2.this的指向和调用方式相关

- 直接调用、函数调用和 new 调用。
- 还有特殊调用，通过bind() 将函数绑定到对象之后再进行调用、通过 call()、apply() 进行调用等。
- es6 引入了箭头函数之后，箭头函数调用时，其 this 指向又有所不同。

# 3.调用方式

## 1.直接调用
- 直接调用并不是指在全局下调用，在任何作用域下，直接通过函数名来对函数调用的方式，都称为直接调用。
- 直接调用不在严格模式下都是指向的global或者window

```
const demo=function(){
    console.log(this);// global or undefined(use strict)
}
demo();

// global or window ，严格模式下为undefined
(function(){
    // demo
}());
```

## 2.方法调用

- 通过对象来调用其他方法函数，它是对象.方法函数这样的形式来调用。
- 这种情况下，函数中的this指向调用该方法的对象。
- 同样需要注意bind()的影响。

```
// 1.定义对象的时候定义其方法
const obj={
    test(){
        console.log(this===obj);
    }
}

// 2.对象定义好之后为其附加一个方法（函数表达式）
obj.test2=function(){
    console.log(this===obj);
}

// 3.和第二个类似，是对象定义好之后为其附加一个方法（函数定义）

function t(){
    console.log(this===obj);
}
obj.test3=t;

// 4.使用bind改变this的指向
obj.test4 = (function () {
    console.log('this:', this); // {a:1}
    console.log(this === obj);
}).bind({ a: 1 });

obj.test(); // true
obj.test2(); // true
obj.test3();// true
obj.test4(); // false
```

- 方法中this指向全局对象的情况
```
// 注意这里说的是方法中而不是方法调用中。
// 方法中的 this 指向全局对象，如果不是因为 bind()，那就一定是因为不是用的方法调用方式，比如
const obj={
    test(){
        console.log(this===obj)
    }
}

const t=obj.test;
t(); //false
```

## 3.new 调用
- 用new调用一个构造函数，会创建一个新对象，而其中的this就指向这个新对象。


- 箭头函数没有自己的this绑定。箭头函数时使用的this，其实是直接包含他的那个函数或者表达式中的this。
```
const obj = {
a () {
    const a = () => {
        console.log(this);
    }
},
b () {
    const bb = {
        c () {
            const d = () => {
                console.log(this);
            }
            d();
        }
    }
    bb.c();
}
};
obj.b();

// this指向是c // { c: [Function: c] }

```

- 当普通函数的上层时箭头函数时 this指向全局
```
const obj = {
    a () {
        console.log('a:', this);            // a: { a: [Function: a] }
        const b = () => {
            console.log('b:', this);        // b: { a: [Function: a] }
            const c = function () {
                console.log('c:', this);    // global or window
                const d = function () {
                    console.log('d:', this);// global or window
                };
                d();
            };
            c();
        };
        b();
    },
};
obj.a();
```

- 当一直为箭头函数时,this就会一直往上找，一直到顶层
```
const obj = {
    a () {
        console.log('a:', this);            // a: { a: [Function: a] }
        const b = () => {
            console.log('b:', this);        // b: { a: [Function: a] }
            const c = () => {
                console.log('c:', this);    // c: { a: [Function: a] }
                const d = () => {
                    console.log('d:', this);// d: { a: [Function: a] }
                };
                d();
            };
            c();
        };
        b();
    },
};
obj.a();

```
## 4.bind() 对直接调用的影响

- Function.prototype.bind() 的作用是将当前函数与指定的对象绑定，并返回一个新函数
- 这个函数无论以什么样的方式调用，其this始终都指向绑定的对象

```
const obj={};

function test(){
    console.log(this===obj);
}
const testObj=test.bind(obj);

test() //false
testObj() //true
```

## 4.call和apply对this的影响

- 他们第一个参数都是指定函数运行时其中的this的指向。

- 不过使用apply和call的时候需要注意，如果目录函数本身是一个绑定了this对象的函数，那apply和call不会像预期那样执行
- 对bind()后的方法进行call或apply后this的结果不像预期一样


```
const obj={}
function test(){
    console.log(this===obj)
}

//绑定到一个新对象，而不是obj
const testObj=test.bind({});

// 期望this是obj，即输出true
// 但是因为testObj 绑定了不是obj的对象，所有输出false
testObj.apply(obj)// false
```


>如有侵权行为，请[点击这里](https://github.com/cooper-q/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/cooper-q/MattMeng_hexo/issues)

# 备注

>2019年8月22日

- 重构此文章

