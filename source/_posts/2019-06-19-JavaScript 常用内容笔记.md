---
layout: post
toc: true
title: JavaScript 常用内容笔记
date: 2019-06-19
keywords: JavaScript

categories:
    - JavaScript
tags:
    - JavaScript
---

# 1.匿名函数立即执行函数以及var作用域
<!-- more -->

    (function(){
        alert(x+y);
    })(2.3)
    用下面的
    (function (){

    }());


    function 也是有作用域的
    var t=1;
    function a(){
        console.log(t);//undefined
        var t=3;
        console.log(t);//3
    }
    a();

    这里一开始输出undefined 是因为函数作为作用域范围，在这个范围里面，首先完成的过程是变量的初始化和声明。所以一开始是undefined


# 2.可以利用[key]来动态生成函数

    demo[key][key2]
    这是一个返回
## 2.1 通过key直接获取上面的变量

    let a = 1;
    let b = 2;
    let arr=['a','b']

    for(let key in arr){
        let demoVal=key;
        console.log(demoVal); // 1 ,2
    }

# 3.递归 闭包实现 队列

>示例01

    let serverArray=[];
    const upload=()=>{
        let recursive=()=>{
            let flag=serverArray.pop();
            //callback 执行回调
            if(callbackValue>0){
                recursive();
            }else{
                //执行其他的方法
            }
        }
        recursive();
    }

>示例02

    let inputParameter = [[[[{ a: 1 }]]], [[[[{ a: 2 }]]]]];
    let result=[];
    const recursive=(inputParameter)=>{
        if(inputParameter instanceof Array){
            inputParameter.forEach(v=>{
                recursive(v);
            })
        }else{
            result.push(inputParameter)
        }
    }
    recursive(inputParameter)
>注：递归
>自己在某种方式来调用自己

# 4.javascript Call,apply,bind方法

    call方法在使用一个指定的this对象值和若干个指定的参数值的前提下调用某个函数方法。call方法可以将一个函数的对象上下文从初始的
    上下文为由thisObj指定的新对象。说明一点就是更改对象的内部的指针，即改变了对象的this指向的内容。这对面向对象编程过程有时的确很有用的。

    function print(a,b){
        console.log(a+b);
    }
    functin example(a,b){
        print.apply(this,arguments);
        print.call(this,a,b);
        print.apply(this,[a,b]);
    }
    example('a','b');//ab
    bind:
        bind()方法会创建一个新函数，称为绑定函数，当调用这个绑定函数时，绑定函数会以创建它时传入 bind()方法的第一个参数作为 this，传入 bind() 方法的第二个以及以后的参数加上绑定函数运行时本身的参数按照顺序作为原函数的参数来调用原函数。
>区别

    传的参数不一样
    call(this,ar1,ar2,...);
    apply(this,[ar1,ar2]);


# 5.判断浏览器端

    req.headers['user-agent']&req.headers['user-agent'].indexOf("MicroMessenger") >= 0 ? 'Platform.Weixin' : 'platform'





# 7.闭包引发内存泄露


    这个说法存在问题，都是因为IE8一下浏览器的gc问题，跟js本身没关系

# 8.undefined 和null的区别

    null: 表示没有对象
        作为函数的参数，表示该函数的参数表示对象。
        作为对象原型链的终点。

    undefined ：表示缺少值
        变量被声明了，但没有赋值，就等于undefined
        调用函数时，应该提供的参数没有提供，该参数等于undefined。
        对象没有赋值的属性，该属性值为undefined。
        函数没有返回值时，默认返回undefined

# 9.instanceof 运算符

        instanceof判断一个对象是否是另一个对象的实例，而数字1是基础类型

        Object instanceof Object //true
        Function instanceof Function //true
        Number instanceof Number//false
        String instanceof String //false
        Function instanceof Object //true
        [] instanceof Array

        详细需要了解
            1.语言规范中是如何定义这个运算符的。
            2.JavaScript原型链继承机制。

# 10.typeof

        typeof xx ==='object'
        //typeof null =>object

        typeof yy ==='undefined'
        //typeof undefined =>undefined

        这样会出一些无法预知的错误

# 11.首字符大写

    key[i].toLowerCase().replace(/( |^)[a-z]/g, (L) => L.toUpperCase());


# 12.简单解释下 String new String的区别

    String new String的区别
    let str1='123';
    let str2=String('123');
    let str3=new String('123');

    str1===str2//true
    str2===str3//false

    new出来的是对象 而String是字面量

# 13.if in

    let arr=['a','b','c']
    let flag=('a' in arr);//false
    flag=(2 in arr);//true
    这里的in不是判断是否存在
        arr[a]//是否存在
        arr[2]//exist

    如果是json 可以直接in判断里面是否有这个属性



# 15.== === 操作符是如何比较的

    当比较运算设计类型转换时 (i.e., non–strict comparison), JavaScript 会按以下规则对字符串，数字，布尔或对象类型的操作数进行操作:当比较数字和字符串时，字符串会转换成数字值。 JavaScript 尝试将数字字面量转换为数字类型的值。 首先, 一个数学上的值会从数字字面量中衍生出来，然后得到被四舍五入后的数字类型的值。如果其中一个操作数为布尔类型，那么布尔操作数如果为true，那么会转换为1，如果为false，会转换为整数0，即0。如果是一个对象与数字或字符串向比较，JavaScript会尝试返回对象的默认值。操作符会尝试将对象转换为其原始值（一个字符串或数字值）通过方法valueOf和toString。如果尝试转换失败，会产生一个运行时错误。
    注意：当且仅当与原始值比较时，对象会被转换为原始值。当两个操作数均为对象时，它们作为对象进行比较，仅当它们引用相同对象是返回true。

# 17.js表示集合的数据结构

    Array、Object ES6新加入Map和Set


# 19.for循环

    for(;;){
        console.log('死循环');
    }

# 20.slice()

    slice方法提取字符串的一部分，并返回这个新的字符串。
    slice(beginSlice,endSlice);
    endSlice可以为负数 比如从倒数第几个开始截取

# 21.无符号整数和有符号整数

    计算机里的数是用二进制表示的，最左边的这一位一般用来表示这个数是正数还是负数，这样的话这个数就是有符号整数。如果最左边这一位不用来表示正负，而是和后面的连在一起表示整数，那么就不能区分这个数是正还是负，就只能是正数，这就是无符号整数

# 22.some

    可以判断传入的参数是否非空

        function func(a,b){
            [a,b].some((v)=>{
                console.log(v);//1 undefined
                return !v;
            })
            //所以以上函数返回true
        }
        func('1');

# 23.原型、原型对象


    每一个JavaScript对象（null 除外），都和另一个对象关联。另一个就是我们熟知的原型。每一个对象都是从原型继承属性。
    所有通过对象直接创建的对象都具有同一个原型对象，并可以通过JavaScript代码Object.prototype获得对原型对象的引用。通过关键new和构造函数调用创建的对象的原型就是构造函数的prototype属性的值。

    function Person(){
        this.name='a';
    }
    let person=new Person();
    Person.prototype.say=function(){
        console.log('hello');
    }
    person.say();//hello
    原型对象的用途是为每个实例对象存储共享的方法和属性，它不仅仅是一个普通的对象而已。
    并且所有的实例是共享同一个原型对象，因此有别于实例方法或属性，原型对象仅有一份。
    所有的实例共享一个原型对象。没有原型的对象为数不对，Object.prototype就是其中之一。他不继承任何属性。其他原型对象就是普通对象，普通对象都就有原型。所有的内置构造函数以及大部分自定义的构造函数都具有一个集成自Object.prototype的原型。Date.prototype的属性集成自Object.prototype，因此由new Date()创建的Date对象的属性同时继承自Date.prototype和Object.prototype。这一系列链接的原型对象就是所谓的原型链（prototype chain）。

    prototype 原型
    __proto__ 原型对象

    所有的对象都有prototype，所以都有__proto__
    function a(){
        this.a='1';
    }
    a.prototype.name='2';
    里面的this都在constructor里面放着
    如果想要修改class中的属性，可以在实例中使用__proto__来修改Class的属性。

    let b =new a();
    b.__proto__.name='3';

    不能修改constructor中的内容，因为__proto__指向的是prototype。

    只需要明白原型对象就可以：

        Function.prototype={
            constructor:Function,
            __proto__:parent prototype,
            some prototype properties:...
        }
# 24.method

    toFixed()//四舍五入保留几位小数

# 25.闭包

    是使用被作用域封闭的变量，函数，闭包等执行的一个函数的作用域。通常我们用和其相应的函数来指代这些作用域。可以访问独立数据的函数。


# 26.判断json中是否有这个key

    in

# 27.写法

    function demo(x) {
        let y = function (x) {
            console.log('y:', x);
        }
        return y;
    }
    let b = demo(1);
    b(2);
    //等于
    function demo(x) {
        let y = function (x) {
            console.log('y:', x);
        }
        return y;
    }
    let b = demo(1)(2);

# 28.默认值

    一个是es的参数默认值。
    另一个是。
    let config=a||{};

# 29.简约if写法,逻辑运算符的中断性

    const a=(a)=>{
        a===3&&(a=2)
        console.log(a);//2
    }
    a(3);


# 30.js三元运算符

    条件?符合条件要赋予的值:不符合条件的值
    a?1:2
    如果a不为空，则a=2


# 35.~

    加1取反
    ~1
    -2

# 36.连续比较

    1<2<1
    执行顺序是:
        1<2 为true
        然后Number(true)===>1
        1<1 为false

        所以总体结果为false

# 37.String match

    匹配所有的字符串中指定的字符的个数

    let a='123123123';
    let arr=a.match(/123/);
    匹配第一个123的位置
        [ '123', index: 0, input: '123123123' ].index // 0

    let arr=a.match('/123/g')；
    ['123','123','123']

    匹配不到返回null

# 38.Date

    (new Date).getFullYear()  : 2017 年
    (new Date).getMonth() + 1 : 12 月
    (new Date).getDate()  :7 日
    (new Date).getHours() ：14 小时
    (new Date).getMinutes() ：10 分钟

# 39.<< >>运算符、>>>0

    向右移动0比特。
    在计算机中移位是高位补0，科学计数法是低位补0。
    3<<3
    3 *2*2*2

    300>>4 18
    300/(2*2*2*2) 18.75

# 40.handler函数

    const handler = (result) => {
        return result + 1;
    }

    const sum = (result, func) => {
        return func(result);
    }

    let value = sum(1, handler);

# 41.Math

    绝对值
    Math.abs()

# 42.NaN为什么不等于NaN

    因为NaN 是not a number的意思就是说NaN可以是一字符串A，也可以是字符串B ，A!==B 所以NaN!==NaN


# 43.== 执行顺序

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

# 44.object和number比较

    object 与number比较，先调用 valueof，再调用tostring

# 45.settimeout

    for (var i = 0; i < 5; i++) {
        setTimeout((function (i) {
            return function () {
                console.log(i);
            }
        }(i)))
    }
    这样可以避免i的变量提升 立即执行

    setTimeout(function[,delay,params1,param2])
    function为时间到期执行的函数
    delay是为定时时间
    param为第一个函数执行时传入的值

    setTimeout(function (a, b) {
        console.log('a:', a);
        console.log('b:', b);
    }, 100, 111, 22);

# 46.可枚举不可枚举的区别 enumerable 参考Object

    1.对象的属性分为可枚举和不可枚举，它们是由属性的enumerable值决定的，不可枚举属性，用for...in是遍历不到的，js中内置属性是遍历不到的。

    2.定义Object对象的prototypeIsEnumerable()方法可以判断此对象是否包含某个属性，并且这个属性是否可枚举

# 47.||逻辑运算符赋值

    let b = {a:'1'}
    let c = b && b.a || ''
    当b不存在或者b.a不存在时赋值为''

# 48.填充Array

    let arr=[];
    arr[10]=1;
    arr 前面的10个都为empty js 堆栈所致

# 49.销毁变量

    把变量制空

# 50.随机数

    Math.random().toString(36).substring(2)

# 51.换行回车

    windows：\r\n
    linux：\n
    mac：\n

# 52.i++ ++i区别

    i++先使用i的值再运算
    ++i先运算再使用(i=i+1)


# 56.void 运算符

    void 0代替undefined省3个字节
    防止undefined被定义
    let str=1!==2?3:void 0;// undefined

# 57.循环进行时

    外层要循环要相对少的数组

# 58.判断数组

    [] instanceOf Array

# 59.isNaN

    判断是否一个数字
    isNaN(num) // 如果是true则不是数字

# 60.JavaScript 引用

>代码示例

    const obj={
        name:1
    };

    (function(obj){
        obj.name=2;
    }(obj));
    console.log(obj);// {name:2}


    const obj={name:1}

    (function(obj){
        obj={name:2};
    }(obj));
    console.log(obj);// {name:1}

>代码实例二

    const arr = [1, 2, 3];
    (function (arr) {
        arr.shift();
    }(arr));
    console.log('arr:', arr);// [2,3]

    const arr = [1, 2, 3];
    (function (arr) {
        arr=[2,3];
    }(arr));
    console.log('arr:', arr);// [1,2,3]


>原因

    JavaScript总是按值传递，但是当变量引用对象（包括数组时），value是对象的引用
    更改变量的值永远不会更改基础元或对象，它只是将变量指向新的基元或对象。
    但是，更改变量的引用的对象的属性会更改基础对象

[外部链接](https://stackoverflow.com/questions/6605640/javascript-by-reference-vs-by-value)

# 61.JavaScript（a==1&&a==2&&a===3）可能为true么

    可以为true，当使用==时，如果两个参数的类型不一样，那么js会尝试将其中一个类型转换为何另一个相同。在这里左边是对象，右边是数字，会首先尝试去调用valueOf（如果可以调用的话）来将对象转换成数字，如果失败，再调用toString()

    const a={
        i:1,
        toString:function(){
            return a.i++;
        }
    };
    if(a==1&&a==2&&a==3){
        console.log(true)
    }

    const a={
        i:1,
        valueOf:function(){
            return a.i++;
        }
    }
    if(a==1&&a==2&&a==3){
        console.log(true);
    }

# 62.值类型&引用类型

>值类型（基本类型）

    String、Number、Boolean、Undefined、Null、Symbol（这六种基本数据类型是按值访问的，因为可以操作保存在变量的实际的值）

>引用类型

    Object、Array、Function、Date、RegExp


# 63.for in for of 区别
```
for in遍历数组，存在以下问题；
        1.index索引为字符串型数字，不能直接进行几何运算。
        2.遍历顺序有可能不是按照实际数组的内部顺序。
        3.使用for in会遍历所有的可枚举属性，包括原型。
        所以for in更适合遍历对象，不要使用for in遍历数组

        Object.prototype.method=function(){
            console.log(this);
        }
        var myObject={
            a:1,
            b:2,
            c:3
        };
        for(let key in myObject){
            console.log(key);
        }
        // a
        // b
        // c
        // method
        如果不想遍历原型方法和属性，可以循环内部判断一下，使用hasOwnProperty(key)
        for(let key in myObject){
            if(myObject.hasOwnProperty(key)){
                console.log(key)
            }
        }
        同样可以使用Object.keys()方法

    for of遍历的是数组元素值，而不包括数组的原型属性method和索引name。
        同样for of只会输出1,2,3
```

# 64.优化多层if else
- const object 做 type -> func 映射枚举, 然后返回对应的判定方法作为 switch 的 condition 能死么?
>示例

```JavaScript
const videoFunctionList=new Map([[1,fun1],[2,fun2],[3,fun3]])

let videoFunction = videoFunctionList.get(type);
if (typeof videoFunction === 'function') {
    return await videoFunction(params);
}
```
>示例2

```JavaScript
(videoFunction = videoFunctionList.get(type)) && (videoFunction = await videoFunction(params)) || function () {
        throw new Error(`视频链接暂无匹配方法,appID:${params.appID},videoID:${params.videoID}`);
    };
```

# 65.sort
## 1.参数

- compareFunction
- - firstE1 第一个用于比较的参数
- - secondE1 第二个用于比较的参数

## 2.返回值

- 排序后的数组。更改原数组

## 3.描述

- 如果没有指定compareFunction，那么元素会按照转换为的字符串的Unicode位点进行排序
- 如果是80 9,同时没有指定compareFunction，则会先转换成字符串，则"80" 要在 "9"前面
- 如果 compareFunction(a, b) 小于 0 ，那么 a 会被排列到 b 之前
- 如果 compareFunction(a, b) 等于 0 ， a 和 b 的相对位置不变。
- 如果 compareFunction(a, b) 大于 0 ， b 会被排列到 a 之前。
- compareFunction(a, b) 必须总是对相同的输入返回相同的比较结果，否则排序的结果将是不确定的。

- 比较函数如下
```
function compare(a, b) {
  if (a < b ) {           // 按某种排序标准进行比较, a 小于 b
    return -1;
  }
  if (a > b ) {
    return 1;
  }
  // a must be equal to b
  return 0;
}
```

## 4.示例

- 比较数字
```
let a = [2, 1];
a.sort((a, b) => a - b);
console.log(a); // [1 , 2]
```

- 对象排序
```
// 数字
let a = [{ name: 'd', score: 5 }, { name: 'b', score: 4 }, { name: 'c', score: 2 }, { name: 'a', score: 1 }];
a.sort((a, b) => a.score - b.score);
console.log(a);
// 输出
[
  { name: 'a', score: 1 },
  { name: 'c', score: 2 },
  { name: 'b', score: 4 },
  { name: 'd', score: 5 }
]

// 字符串
let a = [{ name: 'd', score: 5 }, { name: 'b', score: 4 }, { name: 'c', score: 2 }, { name: 'a', score: 1 }];
a.sort((a, b) => {
    if (a.name < b.name) {
        return -1;
    }
    if (a.name > b.name) {
        return 1;
    }
    return 0;
});
console.log(a);
// 输出
[
  { name: 'a', score: 1 },
  { name: 'b', score: 4 },
  { name: 'c', score: 2 },
  { name: 'd', score: 5 }
]
```

- 非 ASCII 字符排序（如包含类似 e, é, è, a, ä 等字符的字符串）
```
let items = ['réservé', 'premier', 'cliché', 'communiqué', 'café', 'adieu'];
items.sort(function (a, b) {
    return a.localeCompare(b);
});
console.log(items);
// [ 'adieu', 'café', 'cliché', 'communiqué', 'premier', 'réservé' ]
```

- 多字段排序（先进性score排序然后在排序name）
```
let list = [
    { score: 1, name: 'b' }, { score: 1, name: 'a' },
    { score: 2, name: 'd' }, { score: 2, name: 'c' }, { score: 0, name: 'e' },
];
list.sort((a, b) => {
    return (a.score - b.score) || -(a.name < b.name);
});
console.log(list);
// 输出
[
  { score: 0, name: 'e' },
  { score: 1, name: 'a' },
  { score: 1, name: 'b' },
  { score: 2, name: 'c' },
  { score: 2, name: 'd' }
]
```

# 66.为什么要用 Object.prototype.toString.call(callback) != "[object Function]"而不用typeof
- typeof是基于toString实现的
- 不同原型类型有不同的toString的实现
- 所以不同类型之前的toString的表现是不一样的
- 所以统一用Object的toString实现

# 67.实现Array.prototype.map方法
- 简易版
```
'use strict';
let a = [{ a: 1 }, { a: 2 }];
Array.prototype.mapDemo = function (cb) {
    let arr = [];
    for (let i = 0; i < this.length; i++) {
        arr.push(cb(this[i], i));
    }
    return arr;
};
let b = a.mapDemo((v, index, arr) => {
    if (index === 0) {
        v.a = 1.1;
    } else if (index === 1) {
        v.a = 2.1;
    }
    return v;
});
console.log('b:', b);
```
- 完整版 [点击这里查看](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Array/map#Compatibility)

>如有侵权行为，请[点击这里](https://github.com/cooper-q/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/cooper-q/MattMeng_hexo/issues)

# 备注
>2019年8月29日

- 增加sort具体用法

>2019年9月3日

- 实现Array.prototype.map方法
- 增加toString的统一用法
