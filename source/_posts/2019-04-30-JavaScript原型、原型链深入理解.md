---
layout: post
title: JavaScript原型、原型链深入理解
date: 2019-04-30
keywords: JavaScript

categories:
    - JavaScript
tags:
    - JavaScript
---
# 1.prototype
>prototype属性是每一个函数都具有的属性，但是不是每一个对象都具有的属性。
<!-- more -->
```

function Foo(){

}

let foo = new Foo();
```
>其中Foo中有prototype属性，而foo没有。
但是foo中的_proto_属性指向Foo.prototype
```
foo.__proto__===Foo.prototype
```
>为什么会存在prototype属性

>JavaScript里面所有的数据类型都是对象，为了使JavaScript实现面向对象的思想，就必须要能够实现<span style='color:red;font-weight:bold;'>继承</span>。JavaScript采用了类似于C++、java的方式，通过new的方式来实现实例。

>例子

>child1、child2都是Mother的孩子。同时都在c1教室上课
```
functiion Mother(name){
    this.name=name;
    this.classes='c1';
}
let child1=new Mother('huahua');
let child2=new Mother('huihui');
```
>但是突然如果有一天child2需要去别的教室上课，那么就要修改孩子的classes属性
```
child2.classes='c2';
console.log(child1.classes); // c1
```
>也就是说修改了其中一个孩子的classes属性不会对另外的一个产生影响，属性的值也无法共享，并且也不会影响父类的属性值。
正是这个原因才提出来prototype属性，把需要共享的属性放到构造函数中也就是父类的实例中去。

# 2.`__proto__`
>__proto__属性是每一个对象以及函数都隐含的一个属性。对于每一个含有__proto__属性，他所指向的是创建他的构造函数的prototype。
原型链就是通过这个属性构成的。
如果一个函数（构造函数）a的prototype是另一个函数（构造函数）b构建出的实例，a的实例就可以通过__proto__与b的原型链链接起来。而b的原型其实就是Object的实例，所以a的实例对象，就可以通过原型链和object的prototype链接起来。
```
function a(){

}
function b(){

}
a.prototype=b1;
let a1=new a();
console.log(a1.__proto__===b1); // true
console.log(a1.__proto__.__proto__===b1.prototype);// true
console.log(a1.__proto__.__proto__.__proto__===Object.prototype);// true
```
# 3.总结
>概念

- js中所有的东西都是对象，函数也是对象，而且是一种特殊的对象。
- js中所有的东西都是有Object衍生而来，即所有的东西的原型链的重点都指向Object.prototype
- js对象都有一个隐藏的__proto__属性，他指向创建它的构造函数的原型，但是有一个例外，Object.prototype.__proto__指向的是null；
- js中构造函数和实例（对象）之前微妙的关系

>构造函数通过定义prototype来约定起实例的规格，再通过new来构造出实例，他们的作用就是生产对象。

```
function Foo(){

}
let foo = new Foo();
foo其实是通过Foo.prototype来生成实例的。
```
>构造函数本事又是方法（Function）的实例，因此也可以查到它的__proto__（原型链）
```
function Foo(){

}
等价于
let Foo=new Function();
```
>而Function实际上是
```
function Function(){
    Native Code
}
也就是等价于
let Function= new Function();
```
>Object实际上也是通过Function创建出来的
```
typeof(Object) // function

所以

function Object(){
    Native Code
}
等价于

let Object = new Function();

那么Object的__proto__指向的是Function.prototype，也即是

Object.__proto__ === Function.prototype // true
```
>那Function.prototype的__proto__指向哪里呢
>因为js中所有的的东西都是对象，那么，Function.prototype也是对象，既然是对象，那么Function.prototype肯定是Object创建出来的，所以
```
Function.prototype.__proto__ === Object.prototype // true
```
>即，关系图为

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/JavaScript/Function%26Object%E5%8E%9F%E5%9E%8B%E3%80%81%E5%8E%9F%E5%9E%8B%E9%93%BE%E5%85%B3%E7%B3%BB%E5%9B%BE.png' width='400' height='200'/>

>对于单个的对象实例，如果通过Object创建
```
let obj = new Object();
那么它的原型和原型链的关系图如下
```
<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/JavaScript/%E5%8D%95%E4%B8%AA%E5%AF%B9%E8%B1%A1%E7%A4%BA%E4%BE%8B%E5%9B%BE.png' width='400' height='100'/>

>如果通过函数对象来创建
```
function Foo(){

}
let foo = new Foo();
那么它的原型和原型链的关系图如下
```
<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/JavaScript/%E5%87%BD%E6%95%B0%E5%88%9B%E5%BB%BA%E5%AF%B9%E8%B1%A1%E5%8E%9F%E5%9E%8B%E3%80%81%E5%8E%9F%E5%9E%8B%E9%93%BE%E7%A4%BA%E6%84%8F%E5%9B%BE.png'/>

>JavaScript整体的原型和原型链关系示意图

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/JavaScript/JavaScript%E6%95%B4%E4%BD%93%E7%9A%84%E5%8E%9F%E5%9E%8B%E5%92%8C%E5%8E%9F%E5%9E%8B%E9%93%BE%E7%A4%BA%E6%84%8F%E5%9B%BE.png'/>

>如有侵权行为，请[点击这里](https://github.com/cooper-q/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/cooper-q/MattMeng_hexo/issues)

# 备注

