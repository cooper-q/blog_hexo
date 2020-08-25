---
layout: post
title: JavaScript基础概念
date: 2019-04-19
keywords: JavaScript基础概念

categories:
    - JavaScript
tags:
    - JavaScript
---
# JavaScript基础概念（持续更新）
<!-- more -->
# 1.函数（function）
```
function foo(){

}
let foo=function(){

}
前者为函数声明，后者为函数表达式。typeof foo的结果都是function。
```
# 2.函数对象（function object）
```
函数就是对象，代表函数的对象就是函数对象。
在JavaScript中，每一个函数实际上都是函数对象。
JavaScript代码中定义函数，或者调用Function创建函数时，最终都会以类似于这样的形式调用Function函数。

let newFun= new Function(funArgs,funBody);

其实也就是说，我们定义的函数，语法上，都称为函数对象，看我们如何去使用。如果我们单纯的把它当成一个函数使用，
那么它就是函数，如果我们通过她来实例化出对象来使用，那么它就可以当成一个函数对象来使用，
在面向对象的范畴里面，函数对象类似于类的概念。

let foo=new Function(){

}

typeof foo // object

或者
function Foo(){

}
let foo = new Foo();
typeof foo // object
```

# 3.本地对象（native object）
```
ECMA-262 把本地对象（native object）定义为 "独立于宿主环境的ECMAScript实现提供的对象"。简单来说，本地对象就是ECMA-262定义的类（引用类型）。

Object,Function,Array,String,Boolean,Number
Date,RegExp,Error,EvalError,RangeError,ReferenceError,SyntaxError,TypeError,URIError

js中万物皆为对象，但是通过

typeof(Object)
typeof(Array)
typeof(Date)
typeof(RegExp)
typeof(Math)
返回的都是function

也就是其实这些对象都是本地对象（类）通过function建立起来的

function Object(){

}
function Array(){

}
可以看出Object原本就是一个函数，通过new Object()之后实例化后，创建对象。类似于java的类。
```
# 4.内置对象（build-in object）
```
ECMA-262吧内置对象（build-in object）定义为 "由ECMAScript实现提供的、
独立于宿主环境的所有对象，在ECMAScript程序开始执行时出现"。
这意味着开发者不必明确实例化内置对象，它已被实例化了。
ECMA-262只定义了两个内置对象，即Global和Math（它们也是本地对象，根据定义，每个内置对象都是本地对象）
```

# 5.宿主对象（host object）
```
所有非本地对象都是宿主对象，即由ECMAScript实现的宿主环境提供的对象。
所有的BOM和DOM对象都是宿主对象。
```
# 6.todo

>如有侵权行为，请[点击这里](https://github.com/cooper-q/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/cooper-q/MattMeng_hexo/issues)

# 备注

