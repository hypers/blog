---
title: 🎉  React Suite 4.0 版本发布
date: 2019-09-09
copyright: true
categories:
  - 前端
tags:
  - React
  - Suite
---

开学了，又是一个新的起点。伴着丝丝凉爽的秋风，[React Suite](https://rsuitejs.com) 迎来了 4.0 版本的发布。从 2019 年 3 月份开始设计 V4 版本，经历了 6 个多月的开发与测试，讨论与争执，终于完成了所有的计划。 

春种一粒粟，秋收万颗子，在这个收获的季节，我们为大家准备了一系列的更新，准备好了吗? 嘟嘟嘟嘟...

#### 一、从 Flow 迁移到 TypeScript

首先，感谢 Flow 任教了整个 V3 版本，让组件库能够方便的拥有静态类型检查。随着我们在 TypeScript 的应用上更加广泛，以及 Flow 陆续暴露的一些问题后，在本次版本中 Flow 离开了我们的课堂，而采用 TypeScript 重构了所有代码。每一次破碎的重构都是一次重生，就是要让代码更具可读性和可维护性。

#### 二、可访问性改进

为支持新的浏览器特性，我们在上一个版本 V3 就放弃了 IE9。但我们任然希望用 React Suite 开发的 Web 应用尽可能有更多的人使用，更好的使用。我们在可访问性上尽量去覆盖更多的人群。

##### 2.1 颜色对比度改进

在全世界存在很多弱视人群，而这部分用户使用的显示器往往又是参差不齐，文字与背景的对比度就成了用户最基础的功能问题。作为一个贴心的 UI 组件库，怎么能不照顾用户的眼睛呢？ 

按照 《[Web Content Accessibility Guidelines (WCAG) ](https://www.w3.org/TR/WCAG/)》的要求，文字的颜色，字体的粗细，我们在对比度上都做了改进，调整了色板的算法，目的就是让您的产品更具有可访问性。

![f54078a0de16521a97fa7ff5aa34ff63.png](evernotecid://B94F2C27-2009-4193-810F-2A69B27CFC00/appyinxiangcom/4811070/ENResource/p343)

##### 2.2 新增 Dark Mode（夜间模式）主题 

在我们周围的电子产品中，从操作系统到浏览器、编辑器、以及各种阅读器都开始支持夜间模式。它是一种高对比度，或者反色模式的显示模式，如果您的用户需要长时间使用您的产品，拥有夜间模式能够有效的缓解眼疲劳，更易于阅读。

![51b75ddbb23f86d0d96beb8edaa1a20b.png](evernotecid://B94F2C27-2009-4193-810F-2A69B27CFC00/appyinxiangcom/4811070/ENResource/p342)

我们在您的夜里制作了一个美梦，在默认的主题基础上新增了 Dark Mode 主题，并提供了充分可以定制的选项，开发时候，只需要引入对应的样式文件：

```less
import 'rsuite/lib/styles/themes/dark/index.less';
```
更多关于主题相关的设置可以参考：[自定义主题](https://rsuitejs.com/guide/themes)



#### 三、新增组件

组件是 React Suite 提供的最小单元。随着 Web 应用原来越丰富，越来越多样性，我们会陆续提供更丰富的组件。

##### 3.1 支持 List 组件

[List](https://rsuitejs.com/en/components/list) 组件在移动端使用的非常多，但在中后台产品中，一直是一个不太好标准化的组件，在不同的业务场景下要求的表现形式都会存在差异，以至于我们在这个版本才实现它。List 除了可以自定义每一项的内容以外, 我们默认提供了拖拽排序功能。

![f9d5feaed93ed7da8036b16506f8bbe1.png](evernotecid://B94F2C27-2009-4193-810F-2A69B27CFC00/appyinxiangcom/4811070/ENResource/p344)

##### 3.2 支持 Placeholder 组件

在前端业内大家都知道“骨架屏”这个词，它的作用其实和 [Loader](https://rsuitejs.com/en/components/loader) 类似，都是在应用未加载完成前，显示给用户的一个状态，告诉用户当前数据正在加载中。而 “骨架屏” 的优点，是在数据尚未加载前提前先给用户看到页面的大致结构，提升感官上的体验。

[Placeholder](https://rsuitejs.com/en/components/placeholder) 就是这么一个提供数据大致结构的组件。可以通过线条、矩形、圆形概要的绘制出内容区域的大致结构。

![b47e22af5a21733e7dc9dd8930153793.png](evernotecid://B94F2C27-2009-4193-810F-2A69B27CFC00/appyinxiangcom/4811070/ENResource/p353)

##### 3.3 支持 Calendar 组件

[Calendar](https://rsuitejs.com/en/components/calendar) 是一个简单的日历面板，可以针对日程显示数据。提供了两种使用场景，一种就是默认的显示一个撑满容器的大日历面板，可以显示一个月内的数据。另外一种是提供了一个小的紧凑的小日历面板，在一些系统的侧边栏我们经常遇到，用于数据的筛选。

![eef8ad58fb8c439d02b2fef194aa24dd.png](evernotecid://B94F2C27-2009-4193-810F-2A69B27CFC00/appyinxiangcom/4811070/ENResource/p355)


##### 3.4 支持 Avatar 与 Badge 组件

支持 [Avatar](https://rsuitejs.com/components/avatar) 组件，用于展示一个头像或者商标。

支持 [Badge](https://next.rsuitejs.com/components/badge) 组件，用于按钮、图标旁的数字或状态标记。

![b775f7957bc59cfdc2d8db1d7853fbfb.png](evernotecid://B94F2C27-2009-4193-810F-2A69B27CFC00/appyinxiangcom/4811070/ENResource/p362)
![a3b40ad59de97d6f7e498f4f96101d38.png](evernotecid://B94F2C27-2009-4193-810F-2A69B27CFC00/appyinxiangcom/4811070/ENResource/p358)
![d71ba1541e56f518506b1b597b703af4.png](evernotecid://B94F2C27-2009-4193-810F-2A69B27CFC00/appyinxiangcom/4811070/ENResource/p360)


#### 四、破坏性的变更

每一次的更新我们都希望对历史版本做最大程度的兼容，但还是会存在一些破坏性的变更，比如使用了 React 新的特性，或者对之前不合理设计的改进。

##### 4.1 不支持小于 React 16.6 版本

在本次版本中使用了 React 新的一些特性。例如：新的 context API，在 React 16.6.0 版本中开始支持 Class 组件静态 contextType 属性 [#13728](https://github.com/facebook/react/pull/13728)，我们使用了这一特性。 所以要使用 React Suite 4.0 版本必须升级 react 及 react-dom 至 >=16.6 的版本。

##### 4.2 Less 兼容性变更

在本次版本中开始支持 Dark 主题，对 Less 文件的引入地址进行了调整。

**3.* 版本**
```less
import 'rsuite/styles/less/index.less';
```
**4.* 版本**
```less
import 'rsuite/lib/styles/themes/default/index.less'

// 或者
// import 'rsuite/lib/styles/index.less';
```

同时 Less 的版本需要升级至 >=3.0 版本。

##### 4.3 TreePicker 与 CheckTreePicker 废弃 expandAll 属性

TreePicker 组件与 CheckTreePicker 组件废弃了 `expandAll` 属性，同时添加了 `expandItemValues` 属性，用于展开指定节点。

##### 4.4 调整了 Dropdown、Whisper 以及所有  Picker 组件 placement 属性的值

placement 属性是配置选择器在打开后显示的位置，为了让参数值得可读性更好，对值做了如下调整：

```ts
type Placement4 = 'top' | 'bottom' | 'right' | 'left';
type Placement8 =
| 'bottomStart'
| 'bottomEnd'
| 'topStart'
| 'topEnd'
| 'leftStart'
| 'rightStart'
| 'leftEnd'
| 'rightEnd';
type PlacementAuto =
| 'auto'
| 'autoVerticalStart'
| 'autoVerticalEnd'
| 'autoHorizontalStart'
| 'autoHorizontalEnd';
```
兼容 3.* 版本


#### 五、修复及改进

##### 5.1 所有的 Picker 组件支持设置大小

我们在数据录入组件中有非常完善的 Picker 系列组件，除在可以在表单中使用以外，在一些数据过滤栏中也经常用到。考虑到 Input 和 Button 组件有 size 属性可以调整大小，所以对所有 Picker 也添加了 size 属性，满足更多场景的组合使用。

![6a0cff56a95ad2eaab752cb9e4dd54b4.png](evernotecid://B94F2C27-2009-4193-810F-2A69B27CFC00/appyinxiangcom/4811070/ENResource/p364)

##### 5.2 Whisper、Picker 组件的防溢出处理

所有的 Picker 组件与 Whisper 组件都是弹出一个指定位置的浮层，但有时候会因为浮层的大小超出容器的范围导致一部分浮层别挡住看不到，这个时候您可以设置一个 `preventOverfow` 属性，会根据容器的空闲空间调整浮层显示的相对位置，尽量让浮层完全展示在页面中。

![](https://media.giphy.com/media/YkyxOedelzhx6Edo4B/giphy.gif)

##### 5.3 FormControl 组件设置表单只读

[FormControl](https://rsuitejs.com/en/components/form) 新增两个属性支持：

- `readOnly` 让表单组件为只读状态，不可编辑。
- `plaintext` 让表单组件以纯文本方式展示。

当这两个属性设置 Form 组件上，将对表单内所有的表单组件进行全局设置。在很多情况下我们需要给录入完成的表单添加一个数据详细页面，这个时候需要单独新增一个模块再把数据排版显示出来。为了提高代码的复用性，在这里您可以通过给 Form 组件设置一个 plaintext 属性，就把一个表单变成了数据详细面板。

![92e4bc586fa6c1567fbb3900e7c13165.png](evernotecid://B94F2C27-2009-4193-810F-2A69B27CFC00/appyinxiangcom/4811070/ENResource/p368)


##### 5.4 DatePicker 与 DateRangePicker 支持显示周数

```html
<DatePicker showWeekNumbers />
<DateRangePicker showWeekNumbers /> 
```

如果在您的业务中需要查看周数，可以通过设置 `showWeekNumbers` 属性，日历选择器的左侧就会显示当前行的周数。
![3457979290927ebe4d8196587a1060ef.png](evernotecid://B94F2C27-2009-4193-810F-2A69B27CFC00/appyinxiangcom/4811070/ENResource/p367)


##### 5.5 Form 组合 Schema 支持异步校验

异步校验是一个基础的需求，在本次版本中 Schema 开始支持 Promise。以下是表单改进的几个内容：

- 在需要异步校验的 `<FormControl>` 上设置 `checkAsync` 属性。
- 异步校验的验证规则通过 `schema` 的 `addRule` 方法添加一个返回值为 Promise 的对象。
- 通过调用 `<Form>` 的 `checkAsync` 与 `checkForFieldAsync` 的访问，可以手动触发校验。


**Model**

示例中我们需要异步验证一个邮箱地址是否在服务端已经存在，在给 Modal 添加规则的时候，通过 addRule 方法返回一个 Promise 对象。

```js
function asyncCheckEmail(email) {
  return new Promise(resolve => {
     // 异步处理逻辑 resolve(true);
  });
}

const model = SchemaModel({
  email: StringType()
    .isEmail('Please input the correct email address')
    .addRule((value, data) => {
      return asyncCheckEmail(value);
    }, 'Email address already exists')
});
```
**Form**
把声明好的 model 设置到对应的 Form 上，同时需要给需要异步校验的组件设置一个 checkAsync 属性。

```jsx

const formRef = React.createRef();

function render(){
  return (
    <Form model={model} ref={formRef}>
     <FormControl checkAsync name="email"/>
    </Form>
  )
}
```

Form 默认提供了 check() 方法，如果是异步检查需要调用 checkAsync() 方法。

```js
formRef.current.checkAsync().then(result => {
    console.log(result);
});
```

##### 5.6 Alert 与 Notification 支持手动关闭

Alert 与 Notification 都支持 close 与 closeAll 方法，分别关闭最后一个消息和关闭所有消息。在某些业务情况下，需要在进行某个操作后关闭掉页面上的警告信息，可以通过以下方法操作：

```js
Alert.close();
Alert.closeAll();

Notification.close();
Notification.closeAll();
```

##### 5.7 FlexboxGrid 支持响应式

Grid 布局中的 Col 组件是可以针对响应式布局进行配置，但是它不具备 Flex 布局得一些特性，为了能够让两种布局融合，我们可以让 FlexboxGrid.Item 可以和 Col 组合使用，组合后  FlexboxGrid 及拥有了 Flex 布局得特性，同时拥有响应式配置相关的属性。

```html
<FlexboxGrid.Item componentClass={Col} md={6}>
  content
</FlexboxGrid.Item>
```

##### 5.8 所有的 Picker 新增打开和关闭方法

在某些情况下，需要通过执行某个操作后去打开或者关闭一个 Picker。例如：一个级联操作，在关闭一个 Picker 后希望快速选择，默认打个下一个 Picker。我们在 Picker 上提供了一个 open 与 close 方法：

```jsx
const pickerRef = React.createRef();

function render() {
  return <SelectPicker ref={pickerRef} />;
}

// 打开
pickerRef.current.open();

// 关闭
pickerRef.current.close();
```

##### 5.9 其他修复

- 修复了 Uploader 上传文件大于 1GB 显示问题。
- 修复了 Input 在 IE 浏览器显示上的兼容性问题。
- 修复了 InputPicker 在键盘 Delete 键会清除输入值得问题。
- 修复了 Dropdown 设置 `toggleComponentClass={Button}` 背景样式错误的问题。
- 修复了按需引入时候样式缺失的问题。
- 修复了 DatePicker 禁用日与禁用月不一致的问题。
- 修复了 Table 数据更新后滚动条位置不更新的问题。
- 修复了 Table 属性 expandedRowKeys 更新值不受控。
- 修复了 Table 属性 onRowClick 的回调参数缺少 event。
- 修复了 Form 组件对 focus 事件的支持。
- 修改了 Breadcrumb 的默认分隔符.
- 修复了 Slider 在从隐藏到显示状态变化后，手柄的位置不更新的问题。


#### 六、最后

希望我们的成长，能给更多的开发者带来更好的体验。如果您喜欢 React Suite，可以通过以下方式支持我们：

- [Star](https://github.com/rsuite/rsuite) 这个项目。
- 如果您在您的项目中使用了 React Suite，欢迎在这里[留言](https://github.com/rsuite/rsuite/issues/11)！
- 在 [OpenCollective](https://opencollective.com/rsuite#) 上赞助我们。

这个项目的存在归功于所有贡献者。
[![](https://opencollective.com/rsuite/contributors.svg?width=890)](https://github.com/rsuite/rsuite/graphs/contributors)

国内交流群, 添加 React Suite 小助手，备注 rsuite， 邀请入群。
![](https://user-images.githubusercontent.com/1203827/51657342-7ace0180-1fdf-11e9-9237-5d19c7a5c7da.jpeg)

