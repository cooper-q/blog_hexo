---
layout:     post
title:      "JavaScript立即执行函数"
subtitle:   "不忘初心，方得始终"
date:       2019-01-22
header-img: "img/in-post/JavaScript/JavaScript.png"
header-mask: 0.3
categories:
    - JavaScript 
catalog:    true
tags:
    - JavaScript
---


# 1.函数声明&函数表达式

>函数声明

    function f(){

    }

>表达式（非匿名）

    const f1 = function f(){

    }
    对于非匿名函数也不能直接调用函数名而是需要通过调用赋值的变量名来调用。

>表达式（匿名）

    const f2 = function (){

    }

# 2.()运算符

    在JavaScript中()是一种运算符，跟在函数名之后，表示调用该函数，所以我们协议通过函数表达式后面跟上()表示调用该函数。

>1.匿名函数声明

    function (){

    }()

    根据JavaScript引擎规定，如果function关键字出现在首行开头，一律解释成语句，而不会解析成函数表达式。因此
    JavaScript引擎看到行首是function关键字之后，认为这一段都是函数的定义，而不是函数表达式，如果不明确告诉
    圆括号他是一个表达式，就会当做成一个没有名字的函数声明然后抛出一个错误。

>2.非匿名函数声明

    function fun(){

    }()

    这样虽然有名字了，但是也会报错，当圆括号放在一个函数表达式后面指明了这是一个被调用的函数，而圆括号放在一个
    函数声明后面意味着完全的和前面的函数声明分开了，此时圆括号只是一个简单的代表一个括号。因此圆括号需要包含表达式。


    JavaScript引擎会把上面那段代码解析成
    function fun(){

    }
    ();

# 3.立即执行函数IIFE

    最流行也最被接受的方法是将函数声明包裹再圆括号里来告诉语法分析器去表达一个函数表达式，因为再JavaScript里，
    圆括号不能包含声明。
    所以当圆括号为了包裹函数碰上了function关键字，他便知道将它作为一个函数表达式去解析而不是函数声明。
    这里的圆括号和上面的圆括号遇到的函数时的表现是不一样的。

    也就是说：

>1.当圆括号出现在匿名函数的末尾想要调用函数时，它会默认将函数当成函数声明。

>2.当圆括号包裹函数时，它会默认将函数作为表达式去解析，而不是函数声明。

>多种模式可以让函数立即执行

    (function(){}()) // 括号内的表达式代表函数的立即调用表达式
    (function (){})() // 括号内的表达式代表函数表达式 所以可以立即执行 类似于直接调用方法
    const i=function(){return 10}(); // 函数表达式方式 与上面的一样
    true&&function(){}(); // 与上同
    0,function(){}() // 与上同

    // 一元操作符方式
    !function(){}()
    ~function(){}()
    -function(){}()
    +function(){}()

    // new function()
    new function(){}
    new function(){}() 当只有参数传递时才加()

# 4.与闭包的关系

    就像当函数通过他们的名字被调用时，参数会被传递，而当函数表达式被立即调用时，参数也会被传递。一个立即调用的函数表达式可以用来锁定值并且有效的保存此时的状态，因为任何定义一个函数内的函数都可以使用外面函数传递进来的参数和变量（这种关系叫闭包）

    for(var i=0;i<5;i++){
        setTimeout((function(num){
            return function(){
                console.log(num)
            }
        }(i)))
    }

# 5.模块模式

    可以有效地减少外层函数的调用并更加的清晰调用内部的方法，有点类似于工厂模式。

    var counter =(function(){
       var i=0;
       return {
           get:function(){
               return i;
           },
           set:function(val){
                i=val;
           },
           increment:function(){
               return ++i;
           }
       };
    }());
    
>最后更新日期 2019年01月18日

>节选自一下两篇文章略有删减，如有侵权行为，请[点击这里](https://github.com/mattmengCooper/MattMeng_hexo/issues)联系我删除

[英文原文](http://benalman.com/news/2010/11/immediately-invoked-function-expression/#iife)

[中文译文](https://segmentfault.com/a/1190000003985390)

[如发现疑问或者错误点击反馈](https://github.com/mattmengCooper/MattMeng_hexo/issues)
