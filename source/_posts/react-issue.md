---
title: React 项目开发中的常见问题
date: 2017-07-21
tag: 
- 前端 
- React 
---

## 在 IE 11控制台报错：Minified exception occurred; use the non-minified dev environment for the full error message and additional helpful warnings.

如果出现这个错误是提示，在本地环境配置 `NODE_ENV=development` ，再看一下控制台是否输出了一些更详细的错误信息，参考 [Introducing React's Error Code System](https://facebook.github.io/react/blog/2016/07/11/introducing-reacts-error-code-system.html) 。

如果这个错误只在 IE 11 浏览器环境出现，一般都是 ES6+ 的语法在IE存在兼容问题，一个比较通用的解决办法就是在项目中引入一个 `babel-polyfill`

```
npm i —save babel-polyfill
```

在项目入口，引入 `babel-polyfill` 

```js
import 'babel-polyfill'
```

> 在 webpack 构建的时候会兼容性处理

## 在 IE 11控制台报错： Promise is undefined

IE 11 不支持 Promise 对象，解决办法

```
npm i —save es6-promise
```

在项目入口，引入`es6-promise`

```js
import 'es6-promise/auto';
```