---
title: 如何使用 Electron 和 React 构建一个 APP
copyright: true
author:
  name: Godfery
  link: https://github.com/hiyangguo
date: 2018-03-28 18:44:08
tags:
  - electron
  - react
---

这篇文章主要记录了，使用 Electron 构建的一个 APP 过程的关键步骤和遇到的问题及解决方法。

# 最终成品效果图
{% asset_img electron-preview.gif 最终效果图 %}
[查看源码][bt-radish-app]

<!-- more -->

# 起步
首先使用 `create-react-app` 新建一个 react app。因为这玩意儿新建的时候会帮你初始化`npm`，相当刺激。
其实主要是使用`create-react-app`的时候必须要指定一个名字。
然后他就在当前目录下创建了一个同名的文件夹，所有东西都放在这个文件夹下面了。（可能我没找到如何在当前目录创建的方法，欢迎指正）

```bash
npx create-react-app test-app
```


> [npx 是什么][what-is-npx]


安装好以后，我们再按照 Electron 官方示例继续。
``` bash
npm install --save-dev electron
```
然后。。。就卡住了，卡住了有木有？！是我们姿势不对么？这里什么也没写啊。什么鬼？
```bash
> electron@1.8.4 postinstall /Users/godfery/GitRepo/hiyangguo.github.io/node_modules/electron
> node install.js


... and 1 more
```
那我们加个参数，看看到底是什么情况
```bash
npm install  --save-dev electron --verbose 
```
之后我们就能看到了，是在下载 electron 的地方，下载不下来，龟速，所以我们需要就[使用国内的镜像][use-chinese-mirror]。
在根目录新建一个 `.npmrc` 文件，内容如下:
```
## 这里推荐使用淘宝镜像，当然也可以使用其他镜像
electron_mirror=https://npm.taobao.org/mirrors/electron/
```
也可以使用声明临时变量的方式 
```bash
export electron_mirror="https://npm.taobao.org/mirrors/electron/"
```

之后再执行`npm install  --save-dev electron` 就可以顺利的安装了。
然后修改`package.json`
```diff
{
  "name": "test-app",
  "version": "0.1.0",
+ "main": "main.js",
  "private": true,
  "dependencies": {
    "react": "^16.2.0",
    "react-dom": "^16.2.0",
    "react-scripts": "1.1.1"
  },
  "scripts": {
+   "start-electron": "electron .",
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test --env=jsdom",
    "eject": "react-scripts eject"
  },
  "devDependencies": {
    "electron": "^1.8.4"
  }
}

```

之后在根目录新建一个`main.js`文件
```javascript
const { app, BrowserWindow } = require('electron')

// 保持一个对于 window 对象的全局引用，如果你不这样做，
// 当 JavaScript 对象被垃圾回收， window 会被自动地关闭
let win

function createWindow() {
  // 创建浏览器窗口。
  win = new BrowserWindow({ width: 800, height: 600 })

  // 然后加载应用的 index.html。
  win.loadURL('http://localhost:3000')

  // 打开开发者工具。
  win.webContents.openDevTools()

  // 当 window 被关闭，这个事件会被触发。
  win.on('closed', () => {
    // 取消引用 window 对象，如果你的应用支持多窗口的话，
    // 通常会把多个 window 对象存放在一个数组里面，
    // 与此同时，你应该删除相应的元素。
    win = null
  })
}

// Electron 会在初始化后并准备
// 创建浏览器窗口时，调用这个函数。
// 部分 API 在 ready 事件触发后才能使用。
app.on('ready', createWindow)

// 当全部窗口关闭时退出。
app.on('window-all-closed', () => {
  // 在 macOS 上，除非用户用 Cmd + Q 确定地退出，
  // 否则绝大部分应用及其菜单栏会保持激活。
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  // 在macOS上，当单击dock图标并且没有其他窗口打开时，
  // 通常在应用程序中重新创建一个窗口。
  if (win === null) {
    createWindow()
  }
})
```

最后运行
```
npm run start
npm run start-electron
```

当当当当！
{% asset_img electron-with-react-preview.png electron-with-react-preview] %}

# 安装扩展
既然是用`react`开发，肯定是要用[React Developer Tools][react-developer-tools]的，这里就来说一下，如何在`electron`中使用拓展。(以 mac 为例)
1. 打开 Chrome 浏览器，导航到 `chrome://extensions`，找到 React Developer Tools 插件的 ID：**fmkadmapgofadopljbjfkapdkoienihi**
2. 进入 `~/Library/Application Support/Google/Chrome/Default/Extensions` 目录。在 Finder 中，点击 前往 > 前往文件夹。（或使用快捷键 `shift + command + G`）。粘贴即可。
3. 进入 `fmkadmapgofadopljbjfkapdkoienihi` 文件夹，子目录`3.2.1_0`（也可能是其他的，反正是个版本号）中的的文件拷贝项目根目录下`chrome-extensions`目录中，并重命名为`react-dev-tools`。
4. 修改代码
```diff
const { app, BrowserWindow } = require('electron')
+ const path = require('path')

// 保持一个对于 window 对象的全局引用，如果你不这样做，
// 当 JavaScript 对象被垃圾回收， window 会被自动地关闭
let win

function createWindow() {
+ installExtensions()

  // 创建浏览器窗口。
  win = new BrowserWindow({ width: 800, height: 600 })

  // 然后加载应用的 index.html。
  win.loadURL('http://localhost:3000')

  // 打开开发者工具。
  win.webContents.openDevTools()

  // 当 window 被关闭，这个事件会被触发。
  win.on('closed', () => {
    // 取消引用 window 对象，如果你的应用支持多窗口的话，
    // 通常会把多个 window 对象存放在一个数组里面，
    // 与此同时，你应该删除相应的元素。
    win = null
  })
}

// Electron 会在初始化后并准备
// 创建浏览器窗口时，调用这个函数。
// 部分 API 在 ready 事件触发后才能使用。
app.on('ready', createWindow)

// 当全部窗口关闭时退出。
app.on('window-all-closed', () => {
  // 在 macOS 上，除非用户用 Cmd + Q 确定地退出，
  // 否则绝大部分应用及其菜单栏会保持激活。
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  // 在macOS上，当单击dock图标并且没有其他窗口打开时，
  // 通常在应用程序中重新创建一个窗口。
  if (win === null) {
    createWindow()
  }
})

+ function installExtensions() {
+   BrowserWindow.addDevToolsExtension(path.join(__dirname, 'chrome-extensions', 'react-dev-tools'));
+ }
```

之后重启 electron
{% asset_img electron-with-react-dev-tools-preview.png 安装好react-developer-tools的截图] %}

# create-react-app  使用 less
## 方法一
[官方推荐的方式][creat-react-app-adding-a-css-preprocessor-sass-less-etc]。

大致是说：
  - 安装 less 
  - 使用 less 编译
  - 添加 watch 监控文件变更实时编译
  - 引入最终编译的 css 文件

妈耶，简直 low 到爆啊。

## 方法二
运行 `npm run eject` ，然后改 webpack 的 config 。这方法破坏了整个项目，简直了。也不推荐。

## 方法三
那就没有什么既不破坏项目，又可以方便的使用 less 的方法呢？当然有
使用 **[react-app-rewired][react-app-rewired]** 即可，方便简单的扩展 create-react-app
1. 安装 **react-app-rewired**
```bash
npm install react-app-rewired react-app-rewire-less --save-dev
```
2. 在根目录创建`config-overrides.js` 文件。
```javascript
const rewireLess = require('react-app-rewire-less');
module.exports = function override(config, env) {
  config = rewireLess(config, env);
  return config;
};
```
3. 将 `packge.json` 中所有的 `react-scripts` 换成 `react-app-rewired`
```diff
{
  "name": "test-app",
  "version": "0.1.0",
  "main": "main.js",
  "private": true,
  "dependencies": {
    "react": "^16.2.0",
    "react-dom": "^16.2.0",
    "react-scripts": "1.1.1"
  },
  "scripts": {
    "start-electron": "electron .",
-   "start": "react-scripts start",
+   "start": "react-app-rewired start",
-   "build": "react-scripts build",
+   "build": "react-app-rewired build",
-   "test": "react-scripts test --env=jsdom",
+   "test": "react-app-rewired test --env=jsdom",
-   "eject": "react-scripts eject"
  },
  "devDependencies": {
    "electron": "^1.8.4",
    "react-app-rewire-less": "^2.1.1",
    "react-app-rewired": "^1.5.0"
  }
}
```
4. 运行  `npm run start`

# electron 跨域
electron 可以禁用跨域检查
```diff
win = new BrowserWindow({
    width: 800,
    height: 600,
+   //禁用跨域检查
+   webPreferences: {
+     webSecurity: false
+   }
})
```

开发过程不再赘述，有兴趣可以直接[查看源码][bt-radish-app]。后续会单开一篇文章详细讲解开发过程以及如何更好的发挥 electron 的优势。

# 打包
## 修改 electron 代码
修改`package.json`中的 `script`， 添加`NODE_ENV` 环境变量用于区分环境
```diff
- "start-electron": "electron .",
+ "start-electron": "NODE_ENV=development electron .",
```
然后修改 `main.js`
```diff
const { app, BrowserWindow } = require('electron')
const path = require('path')
+ const url = require('url')
+ const IS_DEV = process.env.NODE_ENV === 'development'

// 保持一个对于 window 对象的全局引用，如果你不这样做，
// 当 JavaScript 对象被垃圾回收， window 会被自动地关闭
let win

function createWindow() {
  installExtensions()

  // 创建浏览器窗口。
  win = new BrowserWindow({
    width: 800,
    height: 600,
    //禁用跨域检查
    webPreferences: {
      webSecurity: false
    }
  })

-  // 然后加载应用的 index.html。
-  win.loadURL('http://localhost:3000')
+  // 加载应用
+  const staticIndexPath = path.join(__dirname, './index.html');
+  const main = IS_DEV ? `http://localhost:3000` : url.format({
+    pathname: staticIndexPath,
+    protocol: 'file:',
+    slashes: true
+  });
+  win.loadURL(main)

  // 打开开发者工具。
-  win.webContents.openDevTools()
+  IS_DEV &&win.webContents.openDevTools()

  // 当 window 被关闭，这个事件会被触发。
  win.on('closed', () => {
    // 取消引用 window 对象，如果你的应用支持多窗口的话，
    // 通常会把多个 window 对象存放在一个数组里面，
    // 与此同时，你应该删除相应的元素。
    win = null
  })
}

// Electron 会在初始化后并准备
// 创建浏览器窗口时，调用这个函数。
// 部分 API 在 ready 事件触发后才能使用。
app.on('ready', createWindow)

// 当全部窗口关闭时退出。
app.on('window-all-closed', () => {
  // 在 macOS 上，除非用户用 Cmd + Q 确定地退出，
  // 否则绝大部分应用及其菜单栏会保持激活。
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  // 在macOS上，当单击dock图标并且没有其他窗口打开时，
  // 通常在应用程序中重新创建一个窗口。
  if (win === null) {
    createWindow()
  }
})

function installExtensions() {
  BrowserWindow.addDevToolsExtension(path.join(__dirname, 'chrome-extensions', 'react-dev-tools'));
}
```
## 打包
由于 `create-react-app` 默认打包的路径为 `/` 根目录，而在 electron 中，需要使用相对路径所以需要再次次改`package.json`
```diff
{
  "name": "test-app",
  "version": "0.1.0",
  "main": "main.js",
  "private": true,
+ "homepage": "./",
  "dependencies": {
    "react": "^16.2.0",
    "react-dom": "^16.2.0",
    "react-scripts": "1.1.1"
  },
  "scripts": {
    "start-electron": "NODE_ENV=development electron .",
    "start": "react-app-rewired start",
    "build": "react-app-rewired build",
    "test": "react-app-rewired test --env=jsdom"
  },
  "devDependencies": {
    "electron": "^1.8.4",
    "react-app-rewire-less": "^2.1.1",
    "react-app-rewired": "^1.5.0"
  }
}
```
打包工具这里使用的是[electron-builder][electron-builder-home]。
### 操作步骤
1. 安装 `electron-builder` 
```bash
npm install electron-builder --save-dev
```
2. 修改配置，添加必要的文件。
  - 修改 `name`，`verison`，`description`，`author`字段
  - 在 `./public`文件夹中放入 `icon.png` 文件
  - 将 `main.js` 重命名为 `electron.js`，让如根目录`./public` 目录下。同时修改 `package.json`
  - 由于`electron-builder`中不能使用`dependencies`，所以**务必将所有的`dependencies`加入`devDependencies`**。
最终的 `package.json`文件：

```diff
{
  "name": "test-app",
  "version": "0.1.0",
  "description": "A Eleactron app with react.",
  "author": "Godfery.Yang<hiyangguo@qq.com>",
- "main": "main.js",
+ "main": "./public/electron.js",
  "private": true,
  "homepage": "./",
-  "dependencies": {
-    "react": "^16.2.0",
-    "react-dom": "^16.2.0",
-    "react-scripts": "1.1.1"
-  },
+  "build": {
+    "mac": {
+      "category": "demo"
+    },
+    "files": [
+      {
+        "from": "./",
+        "to": "./",
+        "filter": [
+          "**/*",
+          "!node_modules"
+        ]
+      }
+    ],
+    "directories": {
+      "buildResources": "public"
+    }
+  },
  "scripts": {
    "start-electron": "NODE_ENV=development electron .",
    "start": "react-app-rewired start",
    "build": "react-app-rewired build",
    "test": "react-app-rewired test --env=jsdom",
+   "packager": "npm run build && rm -rf dist && electron-builder"
  },
  "devDependencies": {
    "electron": "^1.8.4",
    "electron-builder": "^20.8.1",
+   "react": "^16.2.0",
    "react-app-rewire-less": "^2.1.1",
    "react-app-rewired": "^1.5.0",
+   "react-dom": "^16.2.0",
+   "react-scripts": "1.1.1"
  }
}
```

之后运行`npm run packager` 即可得到 `dmg` 安装文件。

[起步demo 源代码](https://github.com/hiyangguo/electron-with-react)


> 参考文章
> [From React to an Electron app ready for production](https://medium.com/@kitze/%EF%B8%8F-from-react-to-an-electron-app-ready-for-production-a0468ecb1da3)
> [如何加载一个开发者工具扩展](https://electronjs.org/docs/tutorial/devtools-extension#%E5%A6%82%E4%BD%95%E5%8A%A0%E8%BD%BD%E4%B8%80%E4%B8%AA%E5%BC%80%E5%8F%91%E8%80%85%E5%B7%A5%E5%85%B7%E6%89%A9%E5%B1%95)
> [Electron 官放文档](https://electronjs.org/docs)
> 本文同步发表于[我的博客](http://hiyangguo.github.io/2018/03/27/build-a-app-width-electron-and-react/#more)

[what-is-npx]:https://zhuanlan.zhihu.com/p/27840803
[react-developer-tools]:https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=zh-CN
[creat-react-app-adding-a-css-preprocessor-sass-less-etc]:https://github.com/facebook/create-react-app/blob/master/packages/react-scripts/template/README.md#adding-a-css-preprocessor-sass-less-etc
[react-app-rewired]:https://github.com/timarney/react-app-rewired
[bt-radish-app]:https://github.com/hiyangguo/bt-radish-app
[electron-builder-home]:https://electron.build/
[use-chinese-mirror]:https://electronjs.org/docs/tutorial/ins