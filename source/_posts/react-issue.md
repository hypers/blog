---
title: React 项目开发中的常见问题
date: 2017-07-21
tag: 
- 前端 
- React 
---

## Each child in an array or iterator should have a unique `key` prop.

这个警告很明确，在遍历子元素的时候，每一个子元素都应该有一个唯一的 `key`。

参考官网相关说明 [lists and keys](https://facebook.github.io/react/docs/lists-and-keys.html#keys)

但是，这里需要注意的是避免使用数组的 index 来作为属性 key 的值，推荐使用唯一 ID。
参考 [Index as a key is an anti-pattern](https://medium.com/@robinpokorny/index-as-a-key-is-an-anti-pattern-e0349aece318)

```js
const todoItems = todos.map((todo) =>
  <li key={todo.id}>
    {todo.text}
  </li>
);
```


## 在 IE 11 控制台报错：Objects are not valid as a React child

错误的全文: [error-decoder](https://facebook.github.io/react/docs/error-decoder.html?invariant=31&args%5B%5D=object%20with%20keys%20%7B%24%24typeof%2C%20type%2C%20key%2C%20ref%2C%20props%2C%20_owner%7D&args%5B%5D=)

这问题一般会在开发环境中遇到，在使用 React 15.4 以后，如果使用了 `react-hot-loader` 则必须在热加载之前加载 `babel-polyfill`, 在你的 `webpack.config.js` 中参考如下配置:

```js
entry: [
  'babel-polyfill',
  'react-hot-loader/patch',
  'webpack-dev-server/client?http://127.0.0.1:3000',
  'webpack/hot/only-dev-server',
  path.resolve(__dirname, './scr/index')
]
```

## 在 IE 11 控制台报错：Minified exception occurred; use the non-minified dev environment for the full error message and additional helpful warnings.

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

## 在 IE 11 控制台报错： Promise is undefined

IE 11 不支持 Promise 对象，解决办法

```
npm i —save es6-promise
```

在项目入口，引入`es6-promise`

```js
import 'es6-promise/auto';
```