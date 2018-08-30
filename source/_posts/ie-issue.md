---
title: IE 常见问题
date: 2017-07-24
tag:
- IE
---

万恶的 IE，总是存在奇怪特有的问题，本文用于收集整理开发中遇到的与 IE 相关的问题
<!-- more -->

## 在 IE 11 浏览器上 FontIcon 图标不显示

在 IE11 会下载 .ttf/.woff 字体文件， 通过 Network 我们可以看到字体文件 `response headers` 中有一个 `Pragma：no-cache`,由于 IE 似乎有缓存和字体的问题，所有导致图标不能正常显示。所以删除 WEB 服务(Nginx..)中的 `Pragma：no-cache` 和 `Cache-Control：no-store` 就能正常访问。

参考 [IE and Cache-Control](https://github.com/FortAwesome/Font-Awesome/issues/6454)

## svg 在 IE 中自适应宽度

svg 在其他浏览器中如 `chrome` 中，会自动随着父级容器的宽度自营式应，无需单独设置宽度和高度。但是在 IE 中则不起作用。

**解决办法**

在 `svg` 节点添加 `style="width:100%;height:100%"` 属性和 `preserveAspectRatio="xMidYmin slice"`，这样就能在 IE 中也实现 SVG 自适应宽度。完整代码如下：
```
<svg version="1.1" id="图层_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="100%" height="100%"
	 viewBox="-125 202 359.9 389" style="width: 100%;height: 100%;overflow:auto" xml:space="preserve"  preserveAspectRatio="xMidYMin slice">
```

## IE 中如何更新 svg text 节点的内容
JavaScript 可以像操作 DOM 节点那样来操作 svg style 属性和内容。比如可以通过 `document.querySelector('#selectorName').style.display='none'` 来设置显示或隐藏某个节点。
此外还可以通过 `document.querySelector('#selectorName').innerText='newText'` 可以设置 `text` 节点的内容。

但是在 IE，`element.innerText` 和 `element.innerHTML` 都不起作用。

**解决办法**

使用 `element.textContent` 代替 `element.innerText`。这样就可以在 IE 通过 JavaScript 来操作 `text` 节点的内容。

>关于 `element.textContent` 的介绍及、与`innerText` 和 `innerHTML` 的区别，可以参考：[Node.textContent](https://developer.mozilla.org/en-US/docs/Web/API/Node/textContent)

## React input 在 IE 中的异常
>下面产生的问题发生在 `react@0.14.9`、`react-dom@0.14.9`

### lodash.debounce 自动触发 input onChange 事件
**问题描述**

如果你的项目中采用了和 DMP 相同的 TableView 写法，在 `SeachInput`中使用了 `lodash.debounce` 的话，如下面的代码:

```js
        <SearchInput
          word={params.word}
          onKeyDown={this.handleKeyDown}
          onChange={debounce(chain(
            this.handleSearch,
            searchControl.onSearch
          ), 200)}
        />
```
 会导致 table 页面在首次加载会出现列表刷新两次。出现的原因是因为：使用 `debounce` 会导致搜索框里的 `input`（或者是 rsuite 的 `FormControl`）在页面加载完成会自动触发 `onChange` 事件。

 **解决办法**

针对 IE 去除 `debounce` 即可。

## Input 设置 placeholder 导致 onChange 触发异常
**问题描述**

当 `input` 组件设置了 `placeholder` 属性后，会导致 `onChange` 触发异常。
当 input 框没有内容的时候，鼠标进入input框会触发 `onChange`，鼠标再次离开input框，也会触发`onChange` 事件。就相当于在
input value 为空的情况下，input `onFocus` 和 `onBlur` 事件都会表现成 `onChange` 事件。如下图：
{% asset_img react-input-ie.png react react input in ie %}

**解决办法**

每次调用 `onChange` 方法的时候，去判断 input current value 与 next value 之间是否相同。不相同才执行方法，相同就什么也不做。
