---
title: 提交一个仓库到 CDNJS
copyright: true
author:
  name: Godfery
  link: https://github.com/hiyangguo
date: 2018-04-18 11:33:20
tags:
  - CDN
  - 免费 CDN
  - github
---
## 概述
{% asset_img cdnjs-home-screenshoot.png cdnjs 官网截屏 %}

本篇文章主要介绍了：如何提交自己的库到 [cdnjs][cdnjs-home]，提交要求，详细的提交步骤及遇到的问题与解决办法。

<!-- more -->

## 科普

先解释一下什么叫 CDN:
> CDN是构建在网络之上的内容分发网络，依靠部署在各地的边缘服务器，通过中心平台的负载均衡、内容分发、调度等功能模块，使用户就近获取所需内容，降低网络拥塞，提高用户访问响应速度和命中率。CDN的关键技术主要有内容存储和分发技术。
> -- 百度百科

说白了，就是为了**加速**！

常用的免费的 cdn 比如：[unpkg][unpkg] 和 [cdnjs][cdnjs]。 `unpkg` 会去拉 [npmjs][npmjs]的所有东西，也就是说只要你提交到 npmjs 的所有东西，它都会帮你做 cdn 。用官网的一句话来说就是：
> unpkg is a fast, global content delivery network for everything on npm. 

不过在国内有时候速度感人。
这时候就不得不提到 [cdnjs][cdnjs]，这货有什么优点呢？就是国内常用的 cdn 如：
- [BootCDN][bootcdn]
- [百度 CDN][baiducdn]
- [奇舞 CDN][75cdn]
- ....
他们几乎都是会去 cndjs 同步数据，是的，你只要发布到 [cdnjs][cdnjs]，你就拥有了众多的国内 cdn，你值得拥有。

而他的一个小缺点是，提交优点麻烦。

我们先阅读一下[CONTRIBUTING.md][contributing-md]。（当然你也可以不读，因为我已经把必要的步骤整理在这篇文章了。）

## 必要条件
如果你想提交自己的库到，cdnjs 必须满足以下条件。
- 请确保它不是一个个人项目。
- 在 [github][github] 有超过200个 **star** 或者在 npm registry 有至少每月800的下载量。
- 必须至少有一个官方可公开访问的存储库和开源许可

## 使用 `package.json` 文件添加一个新的 `library`
### Fork 仓库
- Fork 仓库
{% asset_img fork.png Fork仓库 %}

首先在 [cdn 的 github 主页][cdnjs-github] fork 到自己的账户下。如果你又多个账号或者组织，会有一个弹窗，你选择 form 的目标即可。
在 cdnjs 的官方教程中时让你 clone 到本地进行操作，由于整个仓库巨大（约 65 GB），他还特意推荐你使用[sparse-checkout][sparse-checkout]的方式 clone，但这样仍然有 2GB。简直是有点大，所以还是直接在网页上操作了。

- 创建以你的 library 为名字的分支
点击 `Branch: master` 下拉框，输入你要添加的 `library` 的名字，点击 "Create branch <LIBRARY_NAME> from master" 按钮。
{% asset_img create-branch.png 创建分支 %}

- 进入 `ajax/libs` 文件夹


### 本地准备
之后在你的本地准备一个资源文件，以你的 `library` 命名（以下以 **rsuite** 为例）。

- 在`rsuite`目录根目录下创建 `package.json` 文件，内容如下

```json
{
  "name": "rsuite",
  "filename": "rsuite.min.js",
  "version": "3.0.0-alpha",
  "description": "A suite of react components",
  "homepage": "http://rsuitejs.com/",
  "keywords": [
    "react",
    "rsuite",
    "component",
    "react-component"
  ],
  "author": "Simon Guo <simonguo.2009@gmail.com>",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "git@github.com:rsuite/rsuite.git"
  },
  "npmName": "rsuite",
  "npmFileMap": [
    {
      "basePath": "dist",
      "files": [
        "**/*"
      ]
    }
  ]
}
```

- 将其他需要同步到 cdn 的文件，放入该目录中

字段解释：
- `name`：名称，仅能小写、不可空白、可有减号作分隔线。
- `filename`：主文件的名称。
- `version`：最新的版本号，请确保你使用用 Tag 做版本 release。
- `description`： library 英文介绍。
- `homepage`：网站主页。
- `keywords`：关键字。
- `repository.url`：仓库 url （一般为 github 地址）。
- `license`：授权许可，如MIT、GPL、BSD 等。
- `author`：作者名称和电子邮件地址。
- `npmName`: npm 的名字 。以 **https://www.npmjs.com/package/rsuite** 为例，则`npmName:rsuite`。
- `npmFileMap`: npm文件映射。把需要同步到 cdnjs 的文件配置在这里。
- `basePath`: 路径
- `filese`: 可以使用 `!(...)` 来排除你不需要对的文件。

```json
"files": [
  "**/!(*.+(flow|scss))"  // 排除  *.flow 和 *.scss 文件
]
```
**注意**:
这个件最好是直接使用自己的`package.json`文件，但是千万不要把`files`、`dependencies`、`peerDependencies`这种字段提交。
{% asset_img test-faild.png 测试未通过 %}

以上设置的自动更新是从 npm 更新，如果你希望从 git 更新，可以参考[说明][cdnjs-auto-update]

- 之后将你需要上传的文件放入 `rsuite` 文件夹。
{% asset_img my-resource.png 我的资源展示 %}

资源文件中不要带版本号，多个版本用文件夹分隔
```
# 不好的命名
rsuite.3.0.0.min.js
# 好的命名
rsuite.min.js
```
另外 js 文件推荐使用[UglifyJs][uglify-js]做个压缩。或者你也可以使用[web-minify-helper][web-minify-helper]（我没用过）。

### 上传资源
直接在你的仓库页面打开`ajax/libs`路径，将你的文件夹拖进去就好了。（文档说点击 `Upload File`按钮，然而并没有找到啊。）
{% asset_img upload-files-screenshots.png  上传文件界面%}
然后在 commit message 里填入 `Add LibrayName@version w/ npm auto-update`
```
Add rsuite@3.0.0-alpha w/ npm auto-update
```

### 提交 Issues
之后去 [提交 Issues][cdn-js-issues]，因为是请求所以在标题中添加了`[Request]`字段，如果你是作者（或主要贡献者），还可以添加`[Author]`，字段。例如：
```
[Request] [Author] Add rsuite.js
```
内容如下：
```
**Library name:** rsuite
**Git repository url:** [rsuite/rsuite][git-repository-url]
**npm package name or url** (if there is one): [npmjs.com/package/rsuite][npm]
**License (List them all if it's multiple):** [MIT][license]
**Official homepage:** [http://rsuitejs.com/][homepage]
**Wanna say something? Leave message here:** N/A


[license]:https://github.com/rsuite/rsuite/blob/master/LICENSE
[git-repository-url]: https://github.com/rsuite/rsuite
[homepage]:http://rsuitejs.com/
[npm]:https://www.npmjs.com/package/rsuite
```
翻译
```
**库的名字:** rsuite
**Git 仓库 url:** [rsuite/rsuite][git-repository-url]
**npm 名字或地址** (if there is one): [npmjs.com/package/rsuite][npm]
**许可证 (如果有多个请列出来):** [MIT][license]
**官方主页:** [http://rsuitejs.com/][homepage]
**想说什么其他的，在这儿留言:** N/A


[license]:https://github.com/rsuite/rsuite/blob/master/LICENSE
[git-repository-url]: https://github.com/rsuite/rsuite
[homepage]:http://rsuitejs.com/
[npm]:https://www.npmjs.com/package/rsuite
```
{% asset_img issues.png  issues界面%}

### 提交 Pr
一定要使用 [PULL_REQUEST_TEMPLATE.md][pull-request-template]！！ 请务必认真填写！！
翻译如下:
```
Pr 的 issue: #12712
相关的 issue(s): # #

**Pull request**  或者 **请求添加 lib 的 issue** 的约定列表
请注意，如果你使用的是以分发为目的仓库或者包，还请提供 url 和其他相关的信息，例如源代码仓库或者包的人气。

# Profile of the lib
 * Git 仓库网址（必填）:
 * 官方网站地址（可选、非仓库网址）:
 * NPM 仓库地址（可选）:
 * 授权方式：
 * GitHub / Bitbucket 人气（必填）:
   - 追踪者人数:
   - 星星数量:
   - 衍生数量:
 * NPM 下载统计（可选）:
   - 昨日下载次数:
   - 上星期下载次数:
   - 上个月下载次数:

# 必要检查项目
 * [ ] 我是这个库的作者
   * [ ] 我愿意在我的网站或仓库中加上  cdnjs 的相关链接
 * [ ] 这个 lib 没有出现在 cdnjs 里
 * [ ] 没有重复的问题／合并请求
 * [ ] 这个 lib 有值得关注的知名度
   * [ ] 大于 200 [颗星星／关注者／衍生次数] 在 [GitHub / Bitbucket] 上
   * [ ] 每个月在 npm 有大于 800 次下载数
 * [ ] 项目已经在知名的平台上发布过了 (或者在 npm 上)

# Auto-update checklist
 * [ ] 每个版本都有正确的tag名称 (for git auto-update)
 * [ ] Auto-update 设置
 * [ ] Auto-update 目标／来源是正确的
 * [ ] Auto-update filemap 是正确的

# Git commit checklist
 * [ ] 第一行的提交信息少于 50 个字，而且清晰易懂。
 * [ ] 复制的 cdnjs 仓库没有旧于 3 天
 * [ ] 合并请求是来自一个非 master 且具有意义的分支
 * [ ] 有将不相关的修改分开
 * [ ] 透过 rebase 将多余的修改合并成一个
 * [ ] 有在 commit message 中提及到相对应的问题使其自动关闭
 * [ ] 在  commit message 中提到相对应的问题、人
```
之后会有两次审核，第一次是机器人审核，然后是人工审核。[这是我的 Pull Request ][my-pr]

## 修正错误
当有错误的时候，你就有点悲剧了。因为[CONTRIBUTING.md][contributing-md]中约定：
1. 不要提交无关的`commit log`。
2. 如果你要修改提交，请使用 `git commit --amend` / `git rebase`命令更新你的提交。
然而`github` 并没有提供在线进行这样操作的方案，[Changing a commit message][changing-a-commit-message]。
这时候你就需要将仓库拉到本地里。这时候，请使用[git-sparse-checkout][sparse-checkout]拉取。步骤如下：
```bash
# 新建一个仓库
git init cdnjs && cd cdnjs
# 启用 sparseCheckout（稀疏检出）
git config core.sparseCheckout true
# 设置你要检出的内容 这里我只需要检出 rsuite 目录下的所有文件
echo '/ajax/libs/rsuite/*' >> .git/info/sparse-checkout
# 然后添加 remote （使用 ssh 机器人会报错，不知道是不是个别现象）
git remote add origin https://github.com/rsuite/cdnjs.git
# 切换分支到 rsuite 分支
git checkout -b rsuite
# 拉取
git pull origin rsuite --depth 10
# 之后就是等，死等。由于网速感人，建议晚上睡觉挂机拉，或者先拉到服务器再拉回来。（我一共拉了3个多小时，仅供参考）
```
最后拉下来的东西看一下`du -d 1 -h`
> 6.4G	./.git
> 3.6M	./ajax
>  40K	./.idea
> 6.4G	.

一共`6.4G`没毛病。

然后就是修改内容，重新提交等待人工审核了。

> 经过漫长的审核，最终 rsuite 终于成功提交到 cdnjs ，[地址](https://cdnjs.com/libraries/rsuite)。欢迎使用，相信过不了多久，就能使用国内各大 cdn 引入 rsuite 了。

React Suite 是 HYPERS 前端团队和 UX 团队开源的一套基于 React 的 UI 组件库，能够帮助您快速构建一个企业级应用。

官网访问地址： [rsuitejs.com](https://rsuitejs.com)

[cdnjs]:https://cdnjs.com/
[cdnjs-github]:https://github.com/cdnjs/cdnjs
[contributing-md]:https://github.com/cdnjs/cdnjs/blob/master/CONTRIBUTING.md
[unpkg]:https://unpkg.com/
[npmjs]:http://npmjs.com/
[bootcdn]:http://www.bootcdn.cn/
[baiducdn]:http://cdn.code.baidu.com/
[75cdn]:https://cdn.baomitu.com/
[github]:https://github.com
[sparse-checkout]:https://github.com/cdnjs/cdnjs/blob/master/documents/sparseCheckout.md
[cdnjs-auto-update]:https://github.com/cdnjs/cdnjs/blob/master/documents/autoupdate.md
[uglify-js]:http://lisperator.net/uglifyjs/
[web-minify-helper]:https://github.com/PeterDaveHello/web-minify-helper
[cdn-js-issues]:https://github.com/cdnjs/cdnjs/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc
[pull-request-template]:https://github.com/cdnjs/cdnjs/blob/master/PULL_REQUEST_TEMPLATE.md
[changing-a-commit-message]:https://help.github.com/articles/changing-a-commit-message/
[sparse-checkout]:https://github.com/cdnjs/cdnjs/blob/master/documents/sparseCheckout.md
[my-pr]:https://github.com/cdnjs/cdnjs/pull/12713