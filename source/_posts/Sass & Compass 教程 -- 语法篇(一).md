---
title: Sass & Compass 教程 —— 语法篇（一）
date: 2017-08-06 17:36:00
tags:
- Sass 
- CSS 
- Compass
---

> 阅读本篇你将收获
  - 变量需要先声明后使用，且不存在变量提升。
  - 嵌套使得样式结构清晰。
  - 利用导入来分离代码，优化文件组织。

<!-- more -->
### 1. 变量

SASS使用 `$` 符号来标志变量。变量遵循**先声明后使用**的原则。
```sass
body { 
  font-size: $normal-size;
}

$normal-size: 14px;

// 编译代码将会得到错误输出
// Undefined variable: "$normal-size".
```
变量的声明具有**作用域**，我们甚至可以多次定义同一个变量的值。看下面的例子：
```sass
$normal-size: 14px;

body { 
  $normal-size: 12px;
  font-size: $normal-size;
}

p {
  font-size: $normal-size;
}

$normal-size: 12px;

h6 {
  font-size: $normal-size;
}
```
编译后：
```css
body {
  font-size: 12px;
}

p {
  font-size: 14px;
}

h6 {
  font-size: 12px;
}
```
在上面例子中，`body`内部声明的变量仅仅在其内部产生作用，同样的变量在`p`使用时没有被影响，然而，在同一作用域内，再次定义变量的值，只会影响后面的规则，前面的规则却没有被影响，这就是为何`h6`与`p`字号结果不一。可见 SASS 的编译过程是从上到下依次执行的，但与 js 不一样的是它不存在变量的提升。
**它的基本原理是：变量被值替换。**


----------
### 2. 嵌套

嵌套的存在使得我们编写规则更加直观，层次结构十分清晰。就像是在 `html` 标签之间相互嵌套一般。**嵌套是为解决重复书写的问题。**先来个直观的感受：
```sass
// 在 CSS 中我们使用下面的形式来描述层级结构的样式
article h1 {
  color: #333;
}
article p {
  color: #eee;
}

// SASS 使用嵌套写法
article {
  h1 { color: #333 }
  p { color: #eee }
}
```
这样的写法让我们很容易联想到DOM。
它的原理十分简单：当父选择器内存在子选择器的时候，SASS会将子选择（包括其内的规则）抽出，然后将父选择器放在子选择器前，并用一个**空格**将二者连接起来。
但有的时候我们并不希望使用空格连接，比如：
```SASS
a {
  color: red;
}
a:hover {
  color: green;
}

// 想要编译出上面的CSS，如果使用普通的嵌套写法
a { 
  color: red;
  
  :hover { color: green }
}
// 编译后
a {
  color: red;
}
a :hover {
  color: green;
}
```
很显然，**伪类**是不能直接嵌套书写的。
默认的前后选择器之间的连接是存在一个空格的，如果想要消除它，可以使用 `&` 符号。官方将它叫做**父选择器**，笔者给它起了一个接地气的名字：**粘贴符**😛，顾名思义，它会将前后两者紧紧的粘在一起，因此上述 SASS 正确的写法是：
```sass
a { 
  color: red;
  
  &:hover { color: green }
}
```
除了重复书写选择器，重复书写属性名也是十分繁琐的工作。例如
```CSS
nav {
  border-style: solid;
  border-width: 1px;
  border-color: #ccc;
}

nav {
  border: solid 1px #ccc;
  border-left: 0;
}
```
SASS的嵌套语法同样可以作用于属性名，只不过这回使用的连接符号不是空格而是 `-` 符号。
```SASS
nav {
  border: {
    style: solid;
    width: 1px;
    color: #ccc;
  }
}

nav {
  border: solid 1px #ccc {
    left: 0;
  }
}
```
上述一直在讲述如何使用嵌套语法来简化我们的工作，但别忘了它给我们带来的另一大益处是，直观的视觉缩进使得结构清晰，行文优雅，易于阅读。


----------
### 3. 导入@import

SASS的导入命令是在预编译阶段完成的，这有利于我们更好的组织管理样式文件。我们约定，在文件的开头使用 `@import` 命令导入外部文件。
有些文件是专门为了整合 `@import` 命令而编写的，并不需要编译成CSS文件，这样的文件官方称之为**局部文件**。
**并且约定，这样的文件名以下划线开头，而在导入时，省略开头的下划线**。

“导入”的存在使得变量声明结果不可预料，一般来说，后者覆盖前者。当为变量声明添加额外的 `!default` 标签时，意味着该值是变量的默认值，默认值的优先级是最低的，无论它在何处声明。

另外，CSS中存在也存在 `@import`，为了将两者区分开来，SASS的导入命令只针对SASS文件有效，凡以`.sass`或者`.scss`结尾的文件都可以在预编译阶段完成导入操作，而已 `.css` 结尾的文件会被保留下来，作为原生的CSS导入。如果你希望在预编译阶段导入CSS文件，不妨将`.css`后缀改成`.scss`后缀。


----------
### 4. 静默注释

SASS 支持两种注释方式，一种是 CSS 标准注释，即`／*...*／`。
另外一种类似于 JS 中的单行注释，以 `//` 开头一直到行末，这种注释方式称为**静默注释**，是用这种方式书写的注释会在预编译阶段自动抹去。


----------
> 本文作者：[She Liu](https://github.com/ShelLiu)
> 系列教程： [Sass & Compass 教程](https://www.zybuluo.com/Shel/note/835485)
> 参考文献：《SASS and Compass IN ACTION》 [美] Wynn Netherland