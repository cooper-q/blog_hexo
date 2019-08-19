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
# 1.apply、call

## 1.概述

- 在JavaScript中，call和apply都是为了改变某个函数的上下文（context）而存在的。
- 其实也就是为了改变this的指向。

>JavaScript一大特点

- 定义时上下文
- 运行时上下文
- 上下文是可以改变的

## 2.apply
>语法

```
func.apply(thisArg,[argsArray])
```
>参数

- thisArg，可选参数。
- - 在func函数运行时使用的this值。
- - 在非严格模式下，如果指定为null或者undefined时会自动替换为指向全局对象，原始值会被包装

- argsArray 可选参数。
- - 一个数组或者类型化数组对象。
- - 如果该参数的值为null或undefined，则表示不需要传入任何参数。

>返回值

- 调用有指定this值和参数的函数的结果

>示例

- 将a的this绑定到add方法上面，传入numArr参数，并调用方法
```
const add = function (num, num2) {
    return this.a + num + num2;
};

const a = { a: 1 };
const numArr = [1, 1];
add.apply(a, numArr); // 3
```

- 利用内置函数和apply，来实现某些需要遍历的方法
```
// 如果数组长度过大，调用apply会导致参数的长度限制
let b = [1, 2, 3];
Math.max.apply(null, b); // 3
// 也可以使用Rest
Math.max(...b)

// 如果过大可以使用参数数组切片循环传入目标方法
function minOfArray (arr) {
    let min = Infinity;
    let QUANTUM = 32768;

    for (var i = 0, len = arr.length; i < len; i += QUANTUM) {
        let submin = Math.min.apply(null, arr.slice(i, Math.min(i + QUANTUM, len)));
        min = Math.min(submin, min);
    }

    return min;
}

minOfArray([5, 6, 2, 3, 7]); // 2
```
## 3.call
- call()允许为不同的对象分配和调用属于一个对象的函数/方法
- call()提供新的this值给当前调用的函数/方法。可以使用call来实现继承，写一个方法让另一个新的对象来继承它。

>语法

```
fun.call(thisArg, arg1, arg2, ...)
```

>参数

- thisArg 在fun函数运行时指定的this值。
- arg1、arg2 指定的参数列表

>返回值

- 使用调用者提供的this值和参数调用该函数的返回值
- 若没有返回值则是undefined

>示例

- 将a的this绑定到add方法上面，并传入a、b参数
```
const add = function (num, num2) {
    return this.a + num + num2;
};

const a = { a: 1 };
const b = 1;
const c = 1;
add.call(a, 1, 1); // 3
```

- 动态改变this，使用call或者apply使用实例的say方法
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
redApple.say();             // My Color is red

let banana ={
    color:'yellow'
}
redApple.say.call(banana); // My Color is  yellow
redApple.say.apply(banana);// My Color is  yellow
```


## 3.apply、call的区别
- apply、call作用完全一样，但是参数不同
- this是你想指定的上下文，他可以是任何一个JavaScript对象
- call需要把参数按顺序传递进去，而apply则是把参数放在数组里。
- 当某个函数的参数数量是固定时，用call
当不固定时，用apply。

>示例

- 基本示例
```JavaScript
let func = function(arg1,arg2){
    
}

func.call(this,arg1,arg2)
func.apply(this,[arg1,arg2])
```

- 传入相同的参数时
```JavaScript
// apply
// apply,后面跟着是一个数组,所以他把arr2里面的每一个值通过Array的push方法push进了arr1
let arr1=[1,2,3,4,5]
let arr2=[6,7,8,9]
Array.prototype.push.apply(arr1,arr2); // [1,2,3,4,5,6,7,8,9]

// call
// call后面跟着的是一个个的参数或者对象，所以他会把一整个arr2都push进arr1
let arr1=[1,2,3,4,5]
let arr2=[6,7,8,9]
Array.prototype.push.call(arr1,arr2); // [1,2,3,4,5,[6,7,8,9]]
```

- 验证是否为数组
```JavaScript
function isArray(obj){
    return Object.prototype.toString.call(obj)==='[object Array]'
}
```

- 利用apply实现动态参数输出
```JavaScript
function log (params) {
    console.log.apply(console, arguments);
}

log(1, 2); // 1 2
```

# 2.bind
- bind方法创建一个新的函数
- 在被调用是，这个新函数的this被bind的第一个参数指定，其余的参数将作为新函数的参数供调用时调用
- bind()方法与apply和call很相似，也是可以改变函数体内的this指向。

>语法

```
function.bind(thisArg[, arg1[, arg2[, ...]]])
```

>参数

- thisArg 
- - 调用绑定函数时作为this参数传递给目标函数的值。
- - 如果使用new运算符构造绑定函数，则忽略该值。
- - 当使用bind在setTimeout中创建一个函数（作为回调提供）时，作为thisArg传递的任何原始值都将被转换为object。
- - 如果bind函数的参数列表为空，执行作用域的this将被视为新函数的thisArg


>如有侵权行为，请[点击这里](https://github.com/mattmengCooper/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/mattmengCooper/MattMeng_hexo/issues)

# 备注
>2019年08月19日

- 重构此文章（第一部分）

