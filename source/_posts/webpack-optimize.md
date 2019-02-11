---
title: Webpack性能优化整理
copyright: true
author:
  name: Sleaf
  link: https://github.com/Sleaf
date: 2018-12-12 10:16:46
tags:
  - webpack
  - 优化
  - 前端
---
# 加速构建
## 配置webpack中的Devtool选项
>**开发环境**推荐：
>cheap-module-eval-source-map
>**生产环境**推荐：
>cheap-module-source-map （这也是下版本 webpack 使用-d命令启动 debug 模式时的默认选项）

```js
//webpack.config.js
module.exports = {
  //...
  entry: {
    app: './src/index.js',
  },
  mode: 'development',
  devtool: 'cheap-module-eval-source-map',
  //...
}
```
模式|解释
---|---
eval | 每个 module 会封装到 eval 里包裹起来执行，并且会在末尾追加注释 //@ sourceURL.
source-map | 生成一个 SourceMap 文件.
hidden-source-map | 和 source-map 一样，但不会在 bundle 末尾追加注释.
inline-source-map | 生成一个 DataUrl 形式的 SourceMap 文件.
eval-source-map | 每个 module 会通过 eval() 来执行，并且生成一个 DataUrl 形式的 SourceMap .
cheap-source-map | 生成一个没有列信息（column-mappings）的 SourceMaps 文件，不包含 loader 的 sourcemap（譬如 babel 的 sourcemap）
cheap-module-source-map | 生成一个没有列信息（column-mappings）的 SourceMaps 文件，同时 loader 的 sourcemap 也被简化为只包含对应行的。
>注1：webpack 不仅支持这 7 种，而且它们还是可以任意组合上面的 eval、inline、hidden 关键字，就如文档所说，你可以设置 souremap 选项为 cheap-module-inline-source-map。
>注2：如果你的 modules 里面已经包含了 SourceMaps ，你需要用 source-map-loader  来和合并生成一个新的 SourceMaps 。

{% asset_img devtools-compare.jpeg SourceMap 模式效率对比图 %}
- 使用 cheap 模式可以大幅提高 souremap 生成的效率。大部分情况我们调试并不关心列信息，而且就算 sourcemap 没有列，有些浏览器引擎（例如 v8） 也会给出列信息。
- 使用 eval 方式可大幅提高持续构建效率。参考官方文档提供的速度对比表格可以看到 eval 模式的编译速度很快。
- 使用 module 可支持 babel 这种预编译工具（在 webpack 里做为 loader 使用）。
- 使用 eval-source-map 模式可以减少网络请求。这种模式开启 DataUrl 本身包含完整 sourcemap 信息，并不需要像 sourceURL 那样，浏览器需要发送一个完整请求去获取 sourcemap 文件，这会略微提高点效率。而生产环境中则不宜用 eval，这样会让文件变得极大。

## uglifyJS使用parallel参数
```js
//webpack.config.js
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
module.exports = {
  //...
  plugins: [
    new UglifyJsPlugin({
    parallel: true
    })
  ],
};
```

## 为babel-loader设置cacheDir
```js
//webpack.config.js
module.exports = {
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /(node_modules|bower_components)/,
        use: {
          loader: 'babel-loader',
          options: {
            cacheDirectory:true,//或者制定文件夹
          }
        }
      }
    ]
  }
};
```
> cacheDirectory：默认值为`false`。当有设置时，指定的目录将用来缓存 loader 的执行结果。之后的 webpack 构建，将会尝试读取缓存，来避免在每次执行时，可能产生的、高性能消耗的 Babel 重新编译过程(recompilation process)。如果设置了一个空值`(loader: 'babel-loader?cacheDirectory')`或者`true (loader: babel-loader?cacheDirectory=true)`，loader 将使用默认的缓存目录`node_modules/.cache/babel-loader`，如果在任何根目录下都没有找到`node_modules`目录，将会降级回退到操作系统默认的临时文件目录。

## 使用happypack插件
```js
//webpack.config.js
const HappyPack = require('happypack');
const os = require('os');
const happyThreadPool = HappyPack.ThreadPool({ size: os.cpus().length });
module.exports = {
 module: {
   rules: [
     {
       test: /\.js$/,
       //把对.js 的文件处理交给id为happyBabel 的HappyPack 的实例执行
       loader: 'happypack/loader?id=happyBabel',
       //排除node_modules 目录下的文件
       exclude: /node_modules/
     },
   ]
 },
plugins: [
   new HappyPack({
       //用id来标识 happypack处理那里类文件
     id: 'happyBabel',
     //如何处理  用法和loader 的配置一样
     loaders: [{
       loader: 'babel-loader?cacheDirectory=true',
     }],
     //共享进程池
     threadPool: happyThreadPool,
     //允许 HappyPack 输出日志
     verbose: true,
   })
 ]
}
```
>- 在 Loader 配置中，所有文件的处理都交给了 happypack/loader 去处理，使用紧跟其后的`querystring ?id=babel`去告诉 happypack/loader 去选择哪个 HappyPack 实例去处理文件。
>- 在 Plugin 配置中，新增了两个 HappyPack 实例分别用于告诉 happypack/loader 去如何处理`.js`和`.css`文件。选项中的 id 属性的值和上面`querystring`中的`?id=babel`相对应，选项中的`loaders`属性和`Loader`配置中一样。

## 使用parallel-webpack
> npm install parallel-webpack --save-dev

可代替webpack使用

# 减小尺寸
## 使用WebpackDeepScopeAnalysisPlugin插件
```js
//webpack.config.js
const WebpackDeepScopeAnalysisPlugin = require('webpack-deep-scope-plugin').default;
module.exports = {
  //...
  plugins:[
      new WebpackDeepScopeAnalysisPlugin(),
  ]
};
```
>- 首先，要用到tree-shaking，必然要保证引用的模块都是ES6规范的。例如lodash要替换为lodash-es。
>- 在项目中，注意要把babel设置module: false，避免babel将模块转为CommonJS规范。
>- 在package.json中定义sideEffect: false，这也是为了避免出现import xxx导致模块内部的一些函数执行后影响全局环境，却被去除掉的情况。
## 使用webpack externals选项
**index.html**:
```html
<script  src="https://code.jquery.com/jquery-3.1.0.js"</script>
<!--other scripts-->
```
**webpack.config.js**:
```js
module.exports = {
  //...
  externals: {
    jquery: 'jQuery'
  }
};
```
> 可使用该选项将模块以cdn的形式引入，保持代码中的引入

# 参考文章
>- [\[webpack\]devtool里的7种SourceMap模式是什么鬼？](https://juejin.im/post/58293502a0bb9f005767ba2f)
>- [Webpack - UglifyjsWebpackPlugin](https://webpack.docschina.org/plugins/uglifyjs-webpack-plugin/)
>- [Webpack - babel-loader](https://webpack.docschina.org/loaders/babel-loader/)
>- [amireh/happypack: Happiness in the form of faster webpack build times.](https://github.com/amireh/happypack)
>- [trivago/parallel-webpack: Builds multi-config webpack projects in parallel](https://github.com/trivago/parallel-webpack)
>- [体积减少80%！释放webpack tree-shaking的真正潜力 - 掘金](https://juejin.im/post/5b8ce49df265da438151b468)
>- [Webpack - 外部扩展(externals)](https://webpack.docschina.org/configuration/externals/)
