---
title: React + Webpack 构建打包优化
date: 2018-01-22 23:26:50
category: 技术
tags:
- React
- Webpack
- 优化
---
## React 相关的优化
* 使用 [babel-react-optimize](https://github.com/thejameskyle/babel-react-optimize) 对 React 代码进行优化
* 检查没有使用的库，去除 import 引用
* 按需打包所用的类库，比如 `lodash` 、`echarts` 等

`lodash` 可以采用 [babel-plugin-lodash](https://github.com/lodash/babel-plugin-lodash) 进行优化。
**需要注意的是**

在 `babel-react-optimize` 中使用了 `babel-plugin-transform-react-remove-prop-types` 这个插件。正常情况下，如果你在代码中没有引用到组件的 `PropTypes`，则完全没问题。如果你的组件用到了，那么使用该插件可能会导致问题。
具体见：
>https://github.com/oliviertassinari/babel-plugin-transform-react-remove-prop-types#is-it-safe

## Webpack 构建打包优化
Webpack 构建打包存在的问题主要集中于下面两个方面：
- Webpack 构建速度慢
- Webpack 打包后的文件体积过大

### Webpack 构建速度慢
可以使用 `Webpack.DDLPlugin`，`HappyPack` 来提高构建速度。具体参见小铭在 DMP DDLPlugin 的文档。原文如下：

#### Webpack.DLLPlugin
- 添加一个 webpack.dll.config.js

主要是用到一个 DllPlugin 插件，把一些第三方的资源独立打包，同时放到一个 manifest.json 配置文件中，
这样在组件中更新后，就不会重新 build 这些第三方的资源，

- 同时独立配置 dll/vendors.js 文件，提供给 webpack.dll.config.js
- 修改 package.json

在 scripts 中添加: `"dll": "webpack --config webpack.dll.config.js --progress --colors ",`。
执行 npm run dll 以后，会在 dll 目录下生产 两个文件 vendor-manifest.json ，vendor.dll.js

- 配置 webpack.dev.config.js 文件，加入一个 DllReferencePlugin 插件，并指定 vendor-manifest.json 文件

```js
new webpack.DllReferencePlugin({
  context: join(__dirname, 'src'),
  manifest: require('./dll/vendor-manifest.json')
})
```
- 修改 html

```html
 <% if(htmlWebpackPlugin.options.NODE_ENV ==='development'){   %>
    <script src="dll/vendor.dll.js"></script>
 <% } %>
```
> 注意，需要在 htmlWebpackPlugin 插件中配置 NODE_ENV 参数

#### Happypack

通过多线程，缓存等方式提升 rebuild 效率 https://github.com/amireh/happypack

- 在 webpack.dev.config.js 中针对不同的资源创建多个 HappyPack, 比如 js 1 个，less 1 个，并设置好 id

```js
new HappyPack({
  id: 'js',
  threadPool: happyThreadPool,
  cache: true,
  verbose: true,
  loaders: ['babel-loader?babelrc&cacheDirectory=true'],
}),
new HappyPack({
  id: 'less',
  threadPool: happyThreadPool,
  cache: true,
  verbose: true,
  loaders: ['css-loader', 'less-loader'],
})
```

- 在 module.rules 中配置 use 为 happypack/loader， 设置 id

```js
{
  test: /\.js$/,
  use: [
    'happypack/loader?id=js'
  ],
  exclude: /node_modules/
}, {
  test: /\.less$/,
  loader: extractLess.extract({
    use: ['happypack/loader?id=less'],
    fallback: 'style-loader'
  })
}
```

### 减少 Webpack 打包后的文件体积大小
首先需要对我们整个 bundle 进行分析，由哪些东西组成及各组成部分所占大小。
这里推荐 [webpack-bundle-analyzer](https://github.com/webpack-contrib/webpack-bundle-analyzer)。安装后在 `webpack.dev.config.js` 中添加插件即可，就能在每次启动后自动在网站打开分析结果，如下图

```js
plugins.push( new BundleAnalyzerPlugin());
```

{% asset_img bundle.png react bundle %}

除此之外，还可以将打包过程输出成json文件

```
webpack --profile --json -> stats.json
```

然后到下面这两个网站进行分析
- [webpack/analyse](http://webpack.github.io/analyse)
- [Webpack Chart](http://alexkuz.github.io/webpack-chart/)


通过上面的图表分析可以清楚得看到，整个 bundle.js 的组成部分及对应的大小。
解决 bundle.js 体积过大的解决思路如下：

* 生产环境启用压缩等插件，去除不必要插件
* 拆分业务代码与第三方库及公共模块
* webpack 开启 gzip 压缩
* 按需加载

#### 生产环境启用压缩等插件，去除不必要插件
确保在生产环境启动 `webpack.DefinePlugin` 和 `webpack.optimize.UglifyJsPlugin`。

```js
const plugins = [
  new webpack.DefinePlugin({
    'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || 'production')
  }),
    new webpack.optimize.UglifyJsPlugin({
    compress: {
      warnings: false,
      drop_console: false //eslint-disable-line
    }
    })
]
```

#### 拆分业务代码与第三方库及公共模块
由于项目的业务代码变更频率很高，而第三方库的代码变化则相对没有那么频率。如果将业务代码和第三库打包到同一个 chunk 的话，在每次构建的时候，哪怕业务代码只改了一行，即使第三方库的代码没有发生变化，会导致整个 chunk 的 hash 跟上一次不同。这不是我们想要的结果。我们想要的是，如果第三方库的代码没有变化，那在构建的时候也要保证对应的 hash 没有发生变化，从而能利用浏览器缓存，更好的提高页面加载性能和缩短页面加载时间。
因此可以将第三库的代码单独拆分成 vendor chunk，与业务代码分离。这样就算业务代码再怎么发生变化，只要第三方库代码没有发生变化，对应的 hash 就不变。
首先 `entry` 配置两个 `app` 和 `vendor` 两个chunk

```js
  entry: {
    vendor: [path.join(__dirname, 'dll', 'vendors.js')],
    app: [path.join(__dirname, 'src/index')]
  },
  output: {
    path: path.resolve(__dirname, 'build'),
    filename: '[name].[chunkhash:8].js'
  },
```
其中 `vendros.js` 是自己定义的哪些第三方库需要纳入 vendor 中，如下：

```js
require('babel-polyfill');
require('classnames');
require('intl');
require('isomorphic-fetch');
require('react');
require('react-dom');
require('immutable');
require('redux');
```
然后通过 `CommonsChunkPlugin` 拆分第三库

```js
  plugins.push(
    // 拆分第三方库
    new webpack.optimize.CommonsChunkPlugin({ name: 'vendor' }),
    // 拆分 webpack 自身代码
    new webpack.optimize.CommonsChunkPlugin({
      name: 'runtime',
      minChunks: Infinity
    })
  );
```
上面的配置有两个细节需要注意
- 使用 `chunkhash` 而不用 `hash`
- 单独拆分 webpack 自身代码

**使用 `chunkhash` 而不用 `hash`**

先来看看这二者有何区别：
- hash 是 **build-specific**，任何一个文件的改动都会导致编译的结果不同，适用于开发阶段
- chunkhash 是 **chunk-specific**，是根据每个 chunk 的内容计算出的 hash，适用于生产

因此为了保证第三方库不变的情况下，对应的 `vendor.js` 的 `hash` 也要保持不变，我们再 `output.filename` 中采用了 `chunkhash`


**单独拆分 webpack 自身代码**

Webpack 有个已知问题：
>webpack 自身的 boilerplate 和 manifest 代码可能在每次编译时都会变化。

这导致我们只是在 入口文件 改了一行代码，但编译出的 vendor 和 entry chunk 都变了，因为它们自身都包含这部分代码。

这是不合理的，因为实际上我们的第三方库的代码没变，vendor 不应该在我们业务代码变化时发生变化。
因此我们需要将 webpack 这部分代码分离抽离

```js
new webpack.optimize.CommonsChunkPlugin({
      name: "runtime",
      minChunks: Infinity
}),
```
其中的 name 只要不在 entry 即可，通常使用 `"runtime"` 或 `"manifest"`。
另外一个参数 `minChunks` 表示：在传入公共chunk(commons chunk) 之前所需要包含的最少数量的 chunks。数量必须大于等于2，或者少于等于 chunks的数量，传入 `Infinity` 会马上生成 公共chunk，但里面没有模块。

更多关于 `CommonChunkPlugin` 可以查看 [官方文档](https://doc.webpack-china.org/plugins/commons-chunk-plugin/)
#### 拆分公共资源
同 上面的拆分第三方库一样，拆分公共资源可以将公用的模块单独打出一个 chunk，你可以设置 `minChunk` 来选择是共用多少次模块才将它们抽离。配置如下：

```js
    new webpack.optimize.CommonsChunkPlugin({
      name: 'common',
      minChunks: 2,
    }),
```
是否需要进行这一步优化可以自行根据项目的业务复用度来判断。
#### 开启 gzip
使用 `CompressionPlugin` 插件开启 `gzip` 即可：

```js
    // 添加 gzip
    new CompressionPlugin({
      asset: '[path].gz[query]',
      algorithm: 'gzip',
      test: /\.(js|html)$/,
      threshold: 10240,
      minRatio: 0.8
    })
```
#### 按需加载
本篇不做具体介绍

## 参考资料
- [Webpack 日常使用与优化](https://github.com/creeperyang/blog/issues/37)
- [使用 Webpack 打包单页应用的正确姿势](https://juejin.im/entry/5a41fbea6fb9a045117161a1)
- [webpack打包分析与性能优化](https://zhuanlan.zhihu.com/p/25212283)
- [Webpack 持久化缓存实践](https://github.com/happylindz/blog/issues/7)
- [深入理解 webpack 文件打包机制](https://github.com/happylindz/blog/issues/6)

>本文作者：[超人](github.com/superman66)
