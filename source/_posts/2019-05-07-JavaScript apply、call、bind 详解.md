---
layout: post
toc: true
title: JavaScript apply、call、bind 详解
date: 2019-05-07
keywords: JavaScript

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
<!-- more -->
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
- <span style='color:red'>bind方法创建一个新绑定函数（bound function，BF）。绑定函数是一个exotic function object（怪异函数对象），包装了原函数对象。</span>
- <span style='color:red'>调用绑定函数通常会导致执行包装函数。</span>
- 绑定函数具有一下内部属性
- - <span style='color:red'>BoundTargetFunction - 包装的函数对象。</span>
- - <span style='color:red'>BoundThis - 在调用包装函数时始终作为this值传递的值</span>
- - <span style='color:red'>BoundArguments - 参数列表，在对包装函数做任何调用都会优先用列表元素填充参数列表。</span>
- - <span style='color:red'>Call - 执行与此对象关联的代码。通过函数调用表达式调用。内部方法的参数是一个this值和一个包含通过调用表达式传递给函数的参数的列表。</span>

- <span style='color:red'>当调用绑定函数时，它调用 BoundTargetFunction上的内部方法 Call，就像这样Call(boundThis,args)。</span>
- - <span style='color:red'>boundThis是BoundThis，args是BoundArguments加上通过函数调用传入的参数列表。</span>
- 在被调用是，这个新函数的this被bind的第一个参数指定，其余的参数将作为新函数的参数供调用时调用
- bind()方法与apply和call很相似，也是可以改变函数体内的this指向。
- 多次对某对象进行执行bind是无效的，只会是第一次bind的值
- bind也可以对bind的function进行new操作，但是这样this会不管用。
- 箭头函数由于没有this，bind同样对其无效。
- - 使用bind改变this后，再使用call或者apply会无效

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

- arg1,arg2,....
- - 当目标函数被调用时，预先添加到绑定函数的参数列表中的参数

>返回值

- 返回一个原函数的拷贝，并拥有制定的this的值和初始参数

>示例

- 利用bind实现由于上下文改变找不到this值的情况
```
// 1
let foo = {
    bar: 1,
    eventBind: function () {
        console.log(this.bar);
    },
};
let eventBindCopy1 = foo.eventBind;
// 这里由于上下文变了所有访问不到foo里面的bar
eventBindCopy1(); // undefined

let eventBindCopy2 = foo.eventBind.bind(foo);
eventBindCopy2(); // 1

// 2.通过bind改变this指向,并调用eventBind方法
let barFunc = function () {
    this.eventBind();
};
let func = barFunc.bind(foo);

func(); // 1

// 3.通过bind改变this指向，修改bar并调用eventBind方法
let bfFunc = function (num) {
    this.bar = num;
    this.eventBind();
};
func = bfFunc.bind(foo, 2);
func();

// 4.可以使用保存this的方式来获取上下文的值
const foo = {
    bar: 1,
    getBar: function () {
        let that = this;
        return function () {
            console.log(that.bar);
        };
    },
};
foo.getBar()();// 1

// 5.通过bind方法来改变this的指向
const foo = {
    bar: 1,
    getBar: function () {
        return function () {
            console.log(this.bar);
        }.bind(this);
    },
};
foo.getBar()();

// 6.
const getBar = function (num1) {
    return this.num2 + num1;
};
const b = {
    num2: 1,
};

getBar.bind(b, 2)(); // 3

```

- bind用在构造函数，this不起作用
```
const func = function () {
    console.log(this);
};
const paramObj = {
    x: 1,
};
func.bind(paramObj);
new func(); // func {}
```

- 使用bind改变this后，在使用call或者apply无效
```
const obj = {
    x: 81,
};

const foo = {
    getX: function () {
        console.log(this);
        return this.x;
    },
};
const obj1 = { x: 82 };

let x = foo.getX.bind(obj);
x = x.call(obj1);
console.log('x:', x);// 81
```

>如果对一个函数bind()多次

- 只有第一次时把func2的this指向到了foo，所以x是2第二次时func3把this指向到了func6，并没有指向到foo。
- 然后再结合MDN的那句话返回原函数的拷贝。所以并没有改变foo的this，也就是没有变。
- 内部是一个Call方法，参考上面标红的内容
```JavaScript
// 以上是个人理解欢迎讨论
// 可以参考上面返回值的说明，只对第一次进行处理
let func1 = { x: 1 };
let func2 = { x: 2 };
let func3 = { x: 3 };
let foo = function () {
    console.log('x:', this.x);
};
let func6 = foo.bind(func2);
func6(); // 2
func6 = func6.bind(func3);
func6(); // 2
```

# 3.apply、call、bind比较
- call、apply是立即执行
- bind是先返回函数然后再手动执行。

>异同

```JavaScript
var obj = {
    x: 81,
};

var foo = {
    getX: function () {
        return this.x;
    },
};

console.log(foo.getX.bind(obj)()); //81
console.log(foo.getX.call(obj)); //81
console.log(foo.getX.apply(obj)); //81
```
# 4.总结
- apply、call、bind 三者都是用来改变函数的this对象的指向的；
- apply、call、bind 三者第一个参数都是this要指向的对象，也就是想指定的上下文；
- apply、call、bind 三者都可以利用后续参数传参；
- bind是返回对应函数，便于稍后调用；apply、call则是立即调用 。

>如有侵权行为，请[点击这里](https://github.com/cooper-q/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/cooper-q/MattMeng_hexo/issues)

# 备注
>2019年08月19日

- 重构此文章（第一部分）

>2019年08月20日

- 重构此文章（重构完毕）
