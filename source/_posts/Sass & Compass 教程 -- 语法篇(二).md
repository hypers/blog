---
title: Sass & Compass 教程 -- 语法篇(二)
date: 2017-8-19 10:00:00
tags:
- Sass 
- CSS 
- Compass
---

> 阅读本篇你将收获
  - 使用混合器封装重用的样式。 
  - 使用选择器继承减少样式重复。
  - 从视觉效果的角度出发描述元素。

<!-- more -->

### 5. 混合器@mixin

如果读者曾经接触过 `Less`，那么这个概念你一定不会陌生。就如同 JS 中的函数一样，在样式的世界里，我们将重复使用的属性、规则包装在一个混合器中，并用 `@mixin` 来声明，然后在需要的地方，使用 `@include` 调用。先让我们来一个例子，直观的感受一下。
```sass
@mixin no-bullets {
  list-style: none;
   li {
     list-style: {
       image: none;
       type: none;
     }
     margin: 0;
   }
}

ul.plain {
  @include no-bullets;
}

// 编译成CSS
ul.plain {
  list-style: none;
}
ul.plain li {
  list-style-image: none;
  list-style-type: none;
  margin: 0;
}
```
使用混合器最终目的是让它返回一堆属性和规则。
同时，我们还可以给它传递参数，使它输出不同的结果。
就如同 js 中函数的参数一样，混合器的参数其实就是在混合器内部声明的局部变量，我们可以在声明时给参数附上默认值。
而在调用混合器时，采用**模式匹配**给参数赋值。
```sass
@mixin link-colors($normal,$hover:$normal,$visited:$normal) {
  color: $normal;
  &:hover { color: $hover; }  // 给参数附上默认值
  &:visited { color: $visited; }
}

a {
  @include link-colors($normal: red,$hover: blue);
}

// 编译后的CSS
a {
  color: red;
}
a:hover {
  color: blue;
}
a:visited {
  color: red;
}
```
混合器很强大，就如同函数在 js 中一样的地位一样。然而无休止的滥用混合器会导致项目难以维护。

> When you have only one hammer in your hand, you tend to look at all the problems as nails. 
> —— Maslow

一条经验法则：**你能否为这个混合器找到一个短名字来描述这些属性修饰的样式。**

对于混合器的命名，应该带有**展示性的描述**，侧重于表达当应用了这个样式后所带来的视觉效果。比如："fancy-font"。这与CSS类名有所不同，两者容易混淆。

一种主流的命名方法：CSS类名使用语义化的描述，混合器的名字则采用展示性的描述。

鉴于上面的命名方法，我们得出，混合器的最佳使用点是封装重用的展示性样式。


----------
### 6. 选择器继承 @extend

先看下面例子：
```sass
// SASS
.error {
  border: 1px red solid;
  color: red;
  background: #fff;
}
.danger-error {
  @extend .error;
  color: #fff;
  background: red;
  font-size: 1.8em;
}

// CSS
.error, .danger-error {
  border: 1px red solid;
  color: red;
  background: #fff;
}

.danger-error {
  color: #fff;
  background: red;
  font-size: 1.8em;
}
```

SASS 使用 `@extend` 来实现选择器继承。
它背后的基本原理是，**如果 A 继承于 B ，那么在样式表的任何一处 B 都将会被 A，B 这一选择器组替换**。

继承是基于选择器的，常常是基于类选择器，上面说到类的命名应当是语义化的，因此，继承也是建立在语义化的关系上。就好比当你在编写样式时发现一个类是另一个类的细化的时候，比如上面`.danger-error` 是 `.error`的细化。

同样的目的我们可以使用混合器来解决，然而混合器的使用会复制大段的代码，并且混合器的命名也会违背上面的原则，对此更好的解决方案是使用继承，上面的例子可以看出，继承只会增加选择器的数量，不会复制大量属性代码。

想要熟练的使用混合器与继承，需要日常反复练习，在实践中体会二者的侧重，这里笔者给出一条经验法则：**为效果而混合，为逻辑而继承**。

----------
> 本文作者：[She Liu](https://github.com/ShelLiu)
> 系列教程： [Sass & Compass 教程](https://www.zybuluo.com/Shel/note/835485)
> 参考文献：《SASS and Compass IN ACTION》 [美] Wynn Netherland