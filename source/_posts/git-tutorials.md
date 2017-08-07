---
title: Git使用入门教程
date: 2017-08-06 21:20:22
tags:
- git 
- 入门教程
---

# 大纲图
{% asset_img git-outline.png git入门教程 %}

<!-- more -->

[原图地址](http://naotu.baidu.com/file/5dcda8cf019f0f79dc6285c98298daf8?token=a65a47efab6ab2be)

# 起步 - 关于版本控制

- 什么是“版本控制”？
> 版本控制是一种记录一个或若干文件内容变化，以便将来查阅特定版本修订情况的系统。

## 本地版本控制系统

- 使用本地数据库记录文件的历次更新**差异**

{% asset_img version-control-1.png git入门教程 %}

>许多人习惯用复制整个项目目录的方式来保存不同的版本，或许还会改名加上备份时间以示区别。 
>这么做唯一的好处就是简单，但是特别容易犯错。
>为了解决这个问题，人们很久以前就开发了许多种本地版本控制系统，大多都是采用某种简单的数据库来记录文件的历次更新差异。
>其中最流行的一种叫做 RCS，它的工作原理是在硬盘上保存补丁集（补丁是指文件修订前后的变化）；通过应用所有的补丁，可以重新计算出各个版本的文件内容。


## 集中化的版本控制系统 Centralized Version Control Systems，简称 CVCS

接下来人们又遇到一个问题，如何让在不同系统上的开发者协同工作？ 于是，集中化的版本控制系统
- 优点：方便协作、权限控制、相比于维护本地数据库成本更低
- 缺点：容错率低（服务器宕机、服务器数据丢失导致不可恢复的问题）
{% asset_img version-control-2.png git入门教程 %}

## 分布式版本控制系统
- 客户端把代码仓库**完整地镜像**下来。每一次的克隆操作，实际上都是一次对代码仓库的完整备份。
- 这类系统都可以指定和若干不同的远端代码仓库进行交互。
{% asset_img version-control-3.png git入门教程 %}


# Git 简介

## 什么是Git
Git 是目前世界上被最广泛使用的现代软件版本管理系统。

## 优点
- 速度
- 简单的设计
- 对非线性开发模式的强力支持（允许成千上万个并行开发的分支）
- 完全分布式
- 有能力高效管理类似 Linux 内核一样的超大规模项目（速度和数据量）

## 安装 Git
- Mac 用户：Xcode Command Line Tools 自带 Git (`xcode-select --install`)
- Linux 用户：`sudo apt-get install git`
- Windows 用户：下载 [Git SCM](https://git-scm.com/)
- 对于 Windows 用户，安装后如果希望在全局的 cmd 中使用 git，需要把 git.exe 加入 PATH 环境变量中，或在 Git Bash 中使用 Git。

# 初始化
- [配置SSH公钥](https://coding.net/help/doc/git/ssh-key.html)

## 基础配置

```
$ git config --global user.name "your_username"
$ git config --global user.email your_email@domain.com
```

## `git config` 常用配置

```
# 默认情况下，Git 会调用环境变量（$VISUAL 或 $EDITOR）设置的任意文本编辑器
$ git config --global core.editor emacs
# 设置 commit 的模板
$ git config --global commit.template ~/.gitmessage.txt
# 查看最后10次提交 
$ git config --global alias.last "log -10 --pretty=format:'%C(yellow)%h%Creset(%Cred%ad%Creset) - %Cgreen%aN%Creset : %s'  --date=format:'%Y-%m-%d %H:%M:%S' --graph"
```
Git 将配置项保存在三个单独的文件中，允许你分别对单个仓库、用户和整个系统设置。
 * `.git/config` – 特定仓库的设置。
 * `~/.gitconfig` – 特定用户的设置。这也是 `--global` 标记的设置项存放的位置。
 * `$(prefix)/etc/gitconfig` – 系统层面的设置。

所有配置项都储存在纯文本文件中，所以 `git config` 命令其实只是一个提供便捷的命令行接口。

 
> 拓展阅读
>   [How do I make Git use the editor of my choice for commits?](https://stackoverflow.com/questions/2596805/how-do-i-make-git-use-the-editor-of-my-choice-for-commits)
>   [Git log pretty formats](https://git-scm.com/docs/git-log#_pretty_formats)


# 检出仓库
语法
```bash
git clone <repo> <directory>
```
例子
```
# 本地仓库
$ git clone /path/to/repository
# 通过 SSH
$ git clone git@git.hypers.com:Godfery/git-share-salloto.git
# 通过 HTTPS
$ git clone https:/path/to/repository.git
```
克隆某个分支
```bash
git clone -b master git@git.hypers.com:Godfery/git-share-salloto.git
```
## HTTPS和 SSH 
> - HTTPS：拿到url可以随便clone，但是在push的时候需要验证用户名和密码；可以缓存密码
> - SSH：安全，需要在clone前添加SSH Key。SSH 在push的时候，是不需要输入用户名的，如果配置SSH key的时候设置了密码，则需要输入密码的，否则直接是不需要输入密码的。

> 拓展阅读
> [Git Url HTTPS SSH 区别](http://wanderyt.github.io/2016/04/12/Git-Url-HTTPS-SSH-Difference/)

 
# 创建新仓库
```
git init
#在指定目录创建一个空的 Git 仓库
git init <directory>
#初始化一个裸的 Git 仓库
git init --bare <directory>
```

{% asset_img git-init-bare.svg 初始化裸仓库 %}

无论什么时候，都可以通过 `git status` 来查看你的 git 仓库状态。

> `-—bare` 标记创建了一个没有工作目录的仓库，这样我们在仓库中更改文件并且提交了。中央仓库应该总是创建成裸仓库，因为向非裸仓库推送分支有可能会覆盖已有的代码变动。将`-—bare`看成是用来将仓库标记为储存设施，而不是一个开发环境。也就是说，对于所有的 Git 工作流，中央仓库是裸仓库，开发者的本地仓库是非裸仓库。

# 管理 `remote`
```bash
# 查看当前 remote
$ git remote -v  
# 删除 remote
$ git remote remove origin
# 添加 remote
$ git remote add origin git@git.hypers.com:Godfery/git-share-salloto.git
```


# 工作方式
## 本地工作流
{% asset_img workflow.png git入门教程 %}

> 你的本地仓库由 git 维护的三棵“树”组成。
> 第一个是你的 `工作目录`，它持有实际文件；
> 第二个是 `缓存区（Index）`，它像个缓存区域，临时保存你的改动；
> 最后是 `HEAD`，指向你最近一次提交后的结果。

## 工作原理

{% asset_img workflow2.png 工作原理 %}

| 术语 | 解释 |
| --- | --- |
|  仓库（Repository） |  一个仓库包括了所有的版本信息、所有的分支和标记信息。在Git中仓库的每份拷贝都是完整的。仓库让你可以从中取得你的工作副本。 |
|  分支（Branches）  |  一个分支意味着一个独立的、拥有自己历史信息的代码线（code line）。 |
|  标签（Tags） |  一个标记指的是某个分支某个特定时间点的状态。 |
|  提交（Commit） |  提交代码后，仓库会创建一个新的版本。这个版本可以在后续被重新获得。 |
|  修订（Revision） |  用来表示代码的一个版本状态。最新的版本可以通过HEAD来获取。之前的版本可以通过"HEAD~1"来获取，以此类推。Git通过用SHA1 hash算法表示的id来标识不同的版本。每一个 SHA1 id都是160位长，16进制标识的字符串。 |

# 添加与提交
## `git add`
```bash
# 添加某个文件
$ git add < filename >
# 添加所有更改的文件
$ git add .
# 交互式添加文件
$ git add -p
```

## `git commit`
```bash
$ git commit
$ git commit -m "测试提交"
# 注意此操作会重写之前的提交
$ git commit -m "测试提交" --amend
```

# 忽略特定的文件
可以配置 Git 忽略特定的文件或者是文件夹。这些配置都放在 “`.gitignore`” 文件中。这个文件可以存在于不同的文件夹中，可以包含不同的文件匹配模式。
```bash
# 工作目录下的 gitignore，对所有的 clone 有效
/.gitignore
# 用户全局 gitignore，只对当前的用户有效
~/.gitignore_global
# 项目目录下的 gitignore ，只对当前的 clone 有效(你也可以使用配置变量 `core.excludesfile`)
$GIT_DIR/info/exclude
```
忽略已被跟踪的文件的更改
```bash
# 忽略某个文件的变更
$ git update-index --assume-unchanged
# 去取消忽略某个文件的变更
$ git update-index --no-assume-unchanged
# 列出所有被 `assume-unchanged` 的文件
$ git ls-files -v | grep '^h'
```

> 拓展阅读
> [git-ls-files](https://git-scm.com/docs/git-ls-files)


# 储藏与取出储藏
## `git stash`
```bash
# 储藏当前所有的未提交 回到 HEAD 的状态
$ git stash 
# 还原一个储藏，如不指定则为最后一个储藏
$ git stash apply  <stash@{1}>
# 储藏列表
$ git stash list
# 还原最后一个储藏，并将其从 list 中删除
$ git stash pop
# 清空所有储藏
$ git stash clear
```


# 检查仓库状态
## `git status`
用法
```bash
$ git status
```
{% asset_img git-status-screenshots.png git入门教程 %}

- new file：新文件
- modified：修改的文件
- deleted：删除的文件
- Untracked file：未跟踪的文件

## `git log` 
```bash
#使用默认格式显示完整地项目历史
$ git log
# 将每个提交压缩到一行。当你需要查看项目历史的上层情况时这会很有用。
$ git log --oneline
#搜索特定作者的提交。`<pattern>` 可以是字符串或正则表达式。
$ git log --author="<pattern>"
#搜索提交信息匹配特定 `<pattern>` 的提交。`<pattern>` 可以是字符串或正则表达式。
$ git log --grep="<pattern>"
#只显示发生在 `<since>` 和 `<until>` 之间的提交。两个参数可以是提交 ID、分支名、`HEAD` 或是任何一种引用。
$ git log <since>..<until>
#只显示包含特定文件的提交。查找特定文件的历史这样做会很方便。
$ git log <file>
```


## 检出之前的提交
`git checkout` 这个命令有三个不同的作用：**检出文件**、**检出提交**和**检出分支**。
```bash
# 查看文件之前的版本。它将工作目录中的 `<file>` 文件变成 `<commit>` 中那个文件的拷贝，并将它加入缓存区。
$ git checkout <commit> <file>
# 更新工作目录中的所有文件，使得和某个特定提交中的文件一致。
$ git checkout <commit>
```


# 回滚错误的修改
## `git revert` 和 `git reset`
```bash
# 用来撤销一个已经提交的快照。
$ git revert
# 重置提交
$ git reset
```
{% asset_img git-revert.png git入门教程 %}

通过搞清楚如何撤销这个提交引入的更改，然后在最后加上一个撤销了更改的新提交，而不是从项目历史中移除这个提交。这避免了Git丢失项目历史，这一点对于你的版本历史和协作的可靠性来说是很重要的。
<br/>
撤销（revert）应该用在你想要在项目历史中移除一整个提交的时候。比如说，你在追踪一个 bug，然后你发现它是由一个提交造成的，这时候撤销就很有用。与其说自己去修复它，然后提交一个新的快照，不如用 `git revert`，它帮你做了所有的事情。

### `git revert`
```bash
# 编辑一些文件

# 提交一份快照
$ git commit -m "做了一些改变"

# 撤销刚刚的提交
$ git revert HEAD
```

{% asset_img git-revert-show1.png git入门教程 %}
{% asset_img git-revert-show2.png git入门教程 %}

### `git reset`
和 `git checkout` 一样，`git reset` 有很多种用法。它可以被用来移除提交快照。它应该只被用于 _本地_ 修改——你永远不应该重设和其他开发者共享的快照。
```bash
# 从缓存区移除特定文件，但工作目录不变。
$ git reset <file>
# 重设缓冲区，匹配最近的一次提交，但工作目录不变。
$ git reset
# 重设缓冲区和工作目录，匹配最近的一次提交。
$ git reset --hard
# 将当前分支的末端移到 `<commit>`，将缓存区重设到这个提交，但不改变工作目录。
$ git reset <commit>
# 将当前分支的末端移到 `<commit>`，将缓存区和工作目录都重设到这个提交。
$ git reset --hard <commit>
```

### `git revert` 和 `git reset`的区别
撤销(revert)被设计为撤销 _公开_ 的提交的安全方式，`git reset`被设计为重设 _本地_ 更改。
因为两个命令的目的不同，它们的实现也不一样：重设完全地移除了一堆更改，而撤销保留了原来的更改，用一个新的提交来实现撤销。

**不要重设公共历史** 

当有 `<commit>` 之后的提交被推送到公共仓库后，你绝不应该使用 `git reset`。发布一个提交之后，你必须假设其他开发者会依赖于它。
重点是，确保你只对本地的修改使用 `git reset`，而不是公共更改。如果你需要修复一个公共提交，`git revert` 命令正是被设计来做这个的。

### 取消文件缓存
`git reset` 命令在准备缓存快照时经常被用到。下面的例子假设你有两个文件，`hello.js` 和 `main.js`它们已经被加入了仓库中。
- 例1
```bash
# 编辑了hello.js和main.js

# 缓存了目录下所有文件
$ git add .

# 意识到hello.js和main.js中的修改应该在不同的快照中提交

# 取消main.js缓存
$ git reset main.js
# 只提交hello.js
$ git commit -m "在hello.js做了一些改变"
# 在另一份快照中提交main.js
$ git add main.js
$ git commit -m "编辑 main.js"
```
- 例2
```bash
# 创建一个叫`foo.js`的新文件，增加代码

# 提交到项目历史
$ git add foo.js
$ git commit -m "开始开发一个屌爆了的功能"

# 再次编辑`foo.js`，修改其他文件

# 提交另一份快照
$ git commit -a -m "添加了屌炸了的功能"

# 决定废弃这个功能，并删除相关的更改
$ git reset --hard HEAD~2

```

## `git clean`

`git clean` 命令将未跟踪的文件从你的工作目录中移除。他和`rm`一样，只是提供了一条捷径。
`git clean` 命令经常和 `git reset --hard` 一起使用。`reset` 只影响被跟踪的文件。
```bash
# 告诉你那些文件在命令执行后会被移除，而不是真的删除它。
$ git clean -n
# 移除当前目录下未被跟踪的文件
$ git clean -f
# 移除未跟踪的文件，但限制在某个路径下。
$ git clean -f <path>
# 移除未跟踪的文件，以及目录。
$ git clean -df
```

如果你在本地仓库中作死之后想要毁尸灭迹，`git reset --hard` 和 `git clean -f` 是你最好的选择。运行这两个命令使工作目录和最近的提交保持一致，让你在干净的状态下继续工作。
```bash
# 编辑了一些文件
# 新增了一些文件
# 发现有点问题需要 "回滚"

# 将跟踪的文件回滚回去
$ git reset --hard

# 移除未跟踪的文件
$ git clean -df
```

>移除当前目录下未被跟踪的文件。`-f`（强制）标记是必需的，除非 `clean.requireForce` 配置项被设为了 `false`（默认为 `true`）。它 _不会_ 删除 `.gitignore` 中指定的未跟踪的文件。


# 重写项目历史
## `git commit --amend`
```bash
$ git commit --amend
```

{% asset_img git-commit-ammend1.png git入门教程 %}
{% asset_img git-commit-ammend2.png git入门教程 %}

> 注意 **不要修复公共提交**
> 修复过的提交事实上是全新的提交，之前的提交会被移除出项目历史。

```bash
# 编辑 hello.js 和 main.js
$ git add hello.js
$ git commit

# 意识到你忘记添加 main.js 的更改
$ git add main.js
$ git commit --amend --no-edit
```
加入 `--no-edit` 标记会修复提交但不修改提交信息。

> `git commit --amend` 命令是修复最新提交的便捷方式。amend 不只是修改了最新的提交——它进行了一次替换。

## `git rebase`
```bash
# 将当前分支 rebase 到 `<base>`
$ git rebase <base>
```
> 这里可以是任何类型的提交引用（ID、分支名、标签，或是 `HEAD` 的相对引用）。

rebase 的主要目的是为了保持一个线性的项目历史。

{% asset_img git-rebase-1.png git入门教程 %}
要将你的 feature 分支整合进 master 分支，你有两个选择：直接 merge，或者先 rebase 后 merge。前者会产生一个三路合并（3-way merge）和一个合并提交，而后者产生的是一个快速向前的合并以及完美的线性历史。下图展示了为什么 rebase 到 master 分支会促成一个快速向前的合并。
{% asset_img git-rebase-2.png git入门教程 %}
{% asset_img git-rebase-3.png git入门教程 %}
rebase 是将上游更改合并进本地仓库的通常方法。你每次想查看上游进展时，用 git merge 拉取上游更新会导致一个多余的合并提交。在另一方面，rebase 就好像是说「我想将我的更改建立在其他人的进展之上」。


 
> 注意 **不要 rebase 公共历史**

### `git rebase -i`
```bash
pick fc62e55 added:file_size
pick 9824bf4 fixed:little thing
pick 21d80a5 added:number to log
pick 76b9da6 added:the apply command
pick c264051 Revert:"added file_size" - not implemented correctly

# Rebase f408319..b04dc3d onto f408319
#
# Commands:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# e, edit = use commit, but stop for amending
# s, squash = use commit, but meld into previous commit
# f, fixup = like "squash", but discard this commit's log message
# x, exec = run command (the rest of the line) using shell
# d, drop = remove commit
#
# If you remove a line here THAT COMMIT WILL BE LOST.
# However, if you remove everything, the rebase will be aborted.
#
```

这些信息表示从你上一次推送操作起有5个提交。每个提交都用一行来表示，行格式如下：
```bash
(action) (partial-sha) (short commit message)
```

- 如果指定进行'pick'操作，git会以同样的提交信息（commit message）保存提交
- 如果指定进行'reword'操作，git会保存提交，但是会停下来修改提交信息（commit message）
- 如果指定进行'edit'操作，git会完成同样的工作，但是在对下一提交进行操作之前，它会返回到命令行让你对提交进行修正，或者对提交内容进行修改。
- 如果指定进行'squash'操作，git会把这个提交和前一个提交合并成为一个新的提交
- 如果指定进行'fixup'操作，但是丢弃提交的日志信息
- 如果指定进行'exec'操作，使用 shell 执行命令
- 如果指定进行'drop'操作，删除此次提交

更改完成之后
```bash
git rebase --continue
```

## `git reflog`
Git 用引用日志这种机制来记录分支顶端的更新。

每次当前的 HEAD 更新时（如切换分支、拉取新更改、重写历史或只是添加新的提交），引用日志都会添加一个新条目。

🌰

```bash
$ git reflog
```
{% asset_img git-reflog.png git入门教程 %}
```bash
$ git reset --hard 9d43f81
```
使用 `git reset`，就有可能能将master变回之前的那个提交。

**务必记住**，引用日志提供的安全网只对提交到本地仓库的更改有效


# 保持同步
## `git remote`
```bash
# 显示你和其他远程仓库的连接。
$ git remote
# 和上个命令相同，并且同时显示每个连接的 URL。
$ git remote -v
# 创建一个新的远程仓库连接。
$ git remote add <name> <url>
# 移除名为 <name> 的远程仓库的连接。
$ git remote rm <name>
# 重命名远程连接
$ git remote rename <old-name> <new-name>
```

> 当你用 `git clone` 克隆仓库时，它会自动创建了一个名为 origin 的远程连接，指向被克隆的仓库。

## `git fetch`
```bash
# 拉取仓库中所有的分支。同时会从另一个仓库中下载所有需要的提交和文件。
$ git fetch <remote>
# 和上一个命令相同，但只拉取指定的分支。
$ git fetch <remote> <branch>
```

🌰

```bash
$ git fetch origin
```

{% asset_img git-fetch.png git入门教程 %}

```bash
# 查看 master 与 origin/master 的区别
$ git log --oneline master..origin/master
# 合并
$ git merge origin/master
```

```bash
$ git pull 
# 等价于
$ git fetch && git merge
```
用法
```bash
# 拉取当前分支对应的远程副本中的更改，并立即并入本地副本。
$ git pull <remote>
# 效果等同于
$ git fetch && git merge origin/.
# 使用 `git rebase` 合并远程分支和本地分支，而不是使用 `git merge`。
$ git pull --rebase <remote>
```

> `--rebase` 标记可以用来保证线性的项目历史，防止合并提交（merge commits）的产生。很多开发者倾向于使用 rebase 而不是 merge，因为「我想要把我的更改放在其他人完成的工作之后」。

## `git push`
Push 是你将本地仓库中的提交转移到远程仓库中时要做的事。
```bash
# 将指定的分支推送到 `<remote>` 上
$ git push <remote> <branch>
# 强制推送
$ git push <remote> --force
# 将所有本地分支推送到指定的远程仓库。
$ git push <remote> --all
# 当你推送一个分支或是使用 `--all` 选项时，标签不会被自动推送上去。`--tags` 将你所有的本地标签推送到远程仓库中去。
$ git push <remote> --tags
```

### 将本地提交推送到中央仓库的一些标准做法。

```bash
# 切换到 master 分支
$ git checkout master
# fetch 远程分支的代码
$ git fetch origin master
# 変基到 origin/master
$ git rebase -i origin/master
# Squash commits, fix up commit messages etc.
$ git push origin master
```
> 因为我们已经确信本地的 `master` 分支是最新的，它应该导致快速向前的合并，`git push` 不应该抛出非快速向前之类的问题。

```bash
# 列出仓库中所有分支。
$ git branch
# 创建一个名为 `<branch>` 的分支，__不会__ 自动切换到那个分支去
$ git branch <branch>
# 删除指定分支。这是一个安全的操作，Git 会阻止你删除包含未合并更改的分支。
$ git branch -d <branch>
# 强制删除指定分支，即使包含未合并更改。
$ git branch -D <branch>
# 将当前分支命名为 `<branch>`
$ git branch -m <branch>
```


# 使用分支
## `git checkout`

```bash
# 查看特定分支，分支应该已经通过 `git branch` 创建。之后 `<existing-branch>` 成为当前的分支，并更新工作目录的版本。
$ git checkout <existing-branch>
# 创建一个名为 `<branch>` 的分支，__不会__ 自动切换到那个分支去
$ git checkout -b <new-branch>
# 与上一条命令相同，只是将 `<existing-branch>` 作为新分支的基，而不是当前分支。
$ git checkout -b <new-branch> <existing-branch>
```

## `git merge`
合并是 Git 将被 fork 的历史放回到一起的方式。`git merge` 命令允许你将 `git branch` 创建的多条分支合并成一个。
```bash
git merge <branch>
```

{% asset_img git-merge.png git入门教程 %}

# Git cheat sheet
最后附上[cheat sheet 下载链接](https://www.atlassian.com/dam/jcr:8132028b-024f-4b6b-953e-e68fcce0c5fa/atlassian-git-cheatsheet.pdf)

# 参考文章列表
- [git book](https://git-scm.com/book/en/v2)
- [git-recipes BY 童仲毅（geeeeeeeeek@github）](https://github.com/geeeeeeeeek/git-recipes/wiki/)
- [atlassian git tutorials](https://www.atlassian.com/git/tutorials)
- [sparkbox/standard/style/git/.gitmessage](https://github.com/sparkbox/standard/blob/master/style/git/.gitmessage)
- [你需要知道的12个Git高级命令](http://www.infoq.com/cn/news/2016/01/12-git-advanced-commands)
- [Why does GitHub recommend HTTPS over SSH?](https://stackoverflow.com/questions/11041729/why-does-github-recommend-https-over-ssh)
- [Git Community Book 中文版](http://gitbook.liuhui998.com/index.html)

> 本文作者：[杨过](https://github.com/hiyangguo)