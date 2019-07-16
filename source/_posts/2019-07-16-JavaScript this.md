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
    
- this在运行期绑定（有特殊）JavaScript 函数中的 this 指向并不是在函数定义的时候确定的，而是在调用的时候确定的。换句话说，函数的调用方式决定了 this 指向。

# 2.this的指向和调用方式相关
    
- 直接调用、方法调用和 new 调用。除此之外，还有一些特殊的调用方式，比如通过bind() 将函数绑定到对象之后再进行调用、通过 call()、apply() 进行调用等。而 es6 引入了箭头函数之后，箭头函数调用时，其 this 指向又有所不同。下面就来分析这些情况下的 this 指向

# 3.调用方式
    
## 1.直接调用

```
const demo=function(){
    console.log(this);// global or undefined(use strict)
}
demo();
普通调用为global or window ，严格模式下为undefined

## 直接调用并不是指在全局下调用，在任何作用域下，直接通过函数名来对函数调用的方式，都称为直接调用。也就是说直接调用不在严格模式下都是指向的global或者window

(function(){
    // demo
}());
```

## 2.bind() 对直接调用的影响

- Function.prototype.bind() 的作用是将当前函数与指定的对象绑定，并返回一个新函数，这个函数无论以什么样的方式调用，其this始终都指向绑定的对象

```
const obj={};

function test(){
    console.log(this===obj);
}
const testObj=test.bind(obj);

test() //false
testObj() //true
```

## 3.call和apply对this的影响

- 他们第一个参数都是指定函数运行时其中的this的指向。

- 不过使用apply和call的时候需要注意，如果目录函数本身是一个绑定了this对象的函数，那apply和call不会像预期那样执行

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

由此可见，bind()对函数的影响是深远的，慎用。
```


## 4.方法调用

>方法调用是指通过对象来调用其他方法函数，它是对象.方法函数这样的形式来调用。这种情况下，函数中的this指向调用该方法的对象。但是同样需要注意bind()的影响。

```
const obj={
    // 第一种方式，定义对象的时候定义其方法
    test(){
        console.log(this===obj);
    }
}
// 第二种方式，对象定义好之后为其附加一个方法（函数表达式）

obj.test2=function(){
    console.log(this===obj);
}

// 第三种方式和第二种方式原理相同
// 是对象定义好之后为其附加一个方法（函数定义）

function t(){
    console.log(this===obj);
}

obj.test3=t;

obj.test4=(function(){
    console.log(this===obj);
}).bind({});

obj.test(); // true
obj.test2(); // true
obj.test3();// true

受bind的影响，test4中的this指向的不是obj
obj.test4(); // false

### 后三种方式都是预定定义函数，再将其附加给obj对象作为其方法。再次强调，函数内部的this指向与定义无关，受调用方式的影响。
```

>方法中this指向全局对象的情况

- 注意这里说的是方法中而不是方法调用中。方法中的 this 指向全局对象，如果不是因为 bind()，那就一定是因为不是用的方法调用方式，比如

```
const obj={
    test(){
        console.log(this===obj)
    }
}

const t=obj.test;
t(); //false
```

>new 调用

- 用new调用一个构造函数，会创建一个新对象，而其中的this就指向这个新对象。

>箭头函数中的this

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

// this指向是c

当this为箭头的顶层是指向的是exports
```
      
>如有侵权行为，请[点击这里](https://github.com/mattmengCooper/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/mattmengCooper/MattMeng_hexo/issues)

# 备注

