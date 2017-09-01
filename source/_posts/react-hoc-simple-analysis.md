---
title: React 高阶组件浅析
date: 2017-08-24 21:04:26
copyright: true
author: 
  name: Godfery
  link: https://github.com/hiyangguo
categories:
  - 前端
tags:
  - React
  - 函数式编程
  - HOC
---

# 背景

高阶组件的这种写法的诞生来自于社区的实践，目的是解决一些交叉问题(Cross-Cutting Concerns)。而最早时候 `React` 官方给出的解决方案是使用 `mixin` 。而 React 也在官网中写道：
> We previously recommended mixins as a way to handle cross-cutting concerns. We've since realized that mixins create more trouble than they are worth. 

官方明显也意识到了使用`mixins`技术来解决此类问题所带来的困扰远高于其本身的价值。[更多资料](https://react.bootcss.com/react/blog/2016/07/13/mixins-considered-harmful.html)可以查阅官方的说明。

# 高阶函数的定义

说到高阶组件，就不得不先简单的介绍一下高阶函数。下面展示一个最简单的高阶函数

```javascript
const add = (x,y,f) => f(x)+f(y)
```
当我们调用`add(-5, 6, Math.abs)`时，参数 x，y 和f 分别接收 -5，6 和 `Math.abs`，根据函数定义，我们可以推导计算过程为：
```
x ==> -5
y ==> 6
f ==> abs
f(x) + f(y) ==> Math.abs(-5) + Math.abs(6) ==> 11
```
用代码验证一下：
```javascript
add(-5, 6, Math.abs); //11
```
高阶在维基百科的定义如下
> 高阶函数是至少满足下列一个条件的函数：
> - 接受一个或多个函数作为输入
> - 输出一个函数

# 高阶组件的定义
那么，什么是高阶组件呢？类比高阶函数的定义，**高阶组件就是接受一个组件作为参数并返回一个新组件的函数**。这里需要注意**高阶组件是一个函数**，并不是组件，这一点一定要注意。
同时这里强调一点高阶组件本身并不是 `React` API。它只是一种模式，这种模式是由 `React` 自身的组合性质必然产生的。
更加通俗的讲，高阶组件通过包裹（wrapped）被传入的React组件，经过一系列处理，最终返回一个相对增强（enhanced）的 React 组件，供其他组件调用。

<!-- more -->

# 一个简单的高阶组件
下面我们来实现一个简单的高阶组件
```javascript
export default WrappedComponent => class HOC extends Component {
  render() {
    return (
      <fieldset>
        <legend>默认标题</legend>
        <WrappedComponent {...this.props} />
      </fieldset>
    );
  }
};
```
在其他组件中，我们引用这个高阶组件来强化它
```javascript
export default class Demo extends Component {
  render() {
    return (
      <div>
        我是一个普通组件
      </div>
    );
  }
}

const WithHeaderDemo = withHeader(Demo);
```

下面我们来看一下`React DOM Tree`，调用了高阶组件之后，发生了什么：
{% asset_img p1.png 一个简单的高阶组件 %}

可以看到，`Demo` 被 `HOC` 包裹(wrapped)了之后添加了一个标题默认标题。但是同样会发现，如果调用了多个 `HOC` 之后，我们会看到很多的`HOC`，所以应
该做一些优化，也就是在高阶组件包裹(wrapped)以后，应该保留原有的名称。

我们改写一下上述的高阶组件代码，增加一个 `getDisplayName` 函数，之后为`Demo` 添加一个静态属性 `displayName`。
```javascript
const getDisplayName = component => component.displayName || component.name || 'Component';

export default WrappedComponent => class HOC extends Component {
  static displayName = `HOC(${getDisplayName(WrappedComponent)})`;

  render() {
    return (
      <fieldset>
        <legend>默认标题</legend>
        <WrappedComponent {...this.props} />
      </fieldset>
    );
  }
};

```

再次观察`React DOM Tree`

{% asset_img p2.png 一个简单的高阶组件 %}

可以看到，该组件原本的名称已经显示在`React DOM Tree`上了。
这个HOC 的功能是为原有的组件添加一个标题，也就是说所有需要添加标题的组件都可以通过调用此 HOC 进行包裹(wrapped) 后实现此功能。

# 为高阶组件传参
现在，我们的 `HOC` 已经可以为其他任意组件提供标题了，但是我们还希望可以修改标题中的字段。由于我们的高阶组件是一个函数，所以可以为其添加一个参数`title`。下面我们对`HOC`进行改写：
```javascript
export default (WrappedComponent, title = '默认标题') => class HOC extends Component {
  static displayName = `HOC(${getDisplayName(WrappedComponent)})`;

  render() {
    return (
      <fieldset>
        <legend>{title}</legend>
        <WrappedComponent {...this.props} />
      </fieldset>
    );
  }
};
```
之后我们进行调用：
```javascript
const WithHeaderDemo = withHeader(Demo,'高阶组件添加标题');
```
此时观察`React DOM Tree`。

{% asset_img p3.png 为高阶组件传参 %}

可以看到，标题已经正确的进行了设置。

当然我们也可以对其进行柯里化：

```javascript
export default (title = '默认标题') => WrappedComponent => class HOC extends Component {
  static displayName = `HOC(${getDisplayName(WrappedComponent)})`;

  render() {
    return (
      <fieldset>
        <legend>{title}</legend>
        <WrappedComponent {...this.props} />
      </fieldset>
    );
  }
};

const WithHeaderDemo = withHeader('高阶组件添加标题')(Demo);
```

# 常见的HOC 实现方式
## 基于属性代理（Props Proxy）的方式
属性代理是最常见的高阶组件的使用方式，上面所说的高阶组件就是这种方式。
它通过做一些操作，将被包裹组件的`props`和新生成的`props`一起传递给此组件，这称之为属性代理。
```javascript
export default function GenerateId(WrappedComponent) {
  return class HOC extends Component {
    static displayName = `PropsBorkerHOC(${getDisplayName(WrappedComponent)})`;

    render() {
      const newProps = {
        id: Math.random().toString(36).substring(2).toUpperCase()
      };

      return createElement(WrappedComponent, {
        ...this.props,
        ...newProps
      });
    }
  };
}
```
调用`GenerateId`:
```javascript
const PropsBorkerDemo = GenerateId(Demo);
```
之后我们观察`React Dom Tree`：
{% asset_img p4.png 基于属性代理的方式实现的高阶组件 %}
可以看到我们通过 `GenerateId` 顺利的为 `Demo` 添加了 `id`。

## 基于反向继承（Inheritance Inversion）的方式
首先来看一个简单的反向继承的例子：
```javascript
export default function (WrappedComponent) {
  return class Enhancer extends WrappedComponent {
    static displayName = `InheritanceHOC(${getDisplayName(WrappedComponent)})`;

    componentWillMount() {
      // 可以方便地得到state，做一些更深入的修改。
      this.setState({
        innerText: '我被Inheritance修改了值'
      });
    }

    render() {
      return super.render();
    }
  };
}
```
如你所见返回的高阶组件类（`Enhancer`）继承了 `WrappedComponent`。而之所以被称为反向继承是因为 `WrappedComponent` 被动地被 `Enhancer` 
继承，而不是 `WrappedComponent` 去继承 `Enhancer`。通过这种方式他们之间的关系倒转了。

反向继承允许高阶组件通过 `this` 关键词获取 `WrappedComponent`，意味着它可以获取到 `state`，`props`，组件生命周期（Component Lifecycle）钩子，以及渲染方法（render）。[深入了解](http://www.jianshu.com/p/0aae7d4d9bc1)可以阅读__@Wenliang__文章中`Inheritance Inversion（II）`这一节的内容。


# 使用高阶组件遇到的问题
## 静态方法丢失
当使用高阶组件包装组件，原始组件被容器组件包裹，也就意味着新组件会丢失原始组件的所有静态方法。
下面为 Demo 添加一个静态方法：
```javascript
Demo.getDisplayName = () => 'Demo';
```
之后调用 `HOC`：
```javascript
// 使用高阶组件
const WithHeaderDemo = HOC(Demo);

// 调用后的组件是没有 `getDisplayName` 方法的
typeof WithHeaderDemo.getDisplayName === 'undefined' // true
```
解决这个问题最简单(Yǘ Chǚn)的方法就是，将原始组件的所有静态方法全部拷贝给新组件：
```javascript
export default (title = '默认标题') => (WrappedComponent) => {
  class HOC extends Component {
    static displayName = `HOC(${getDisplayName(WrappedComponent)})`;

    render() {
      return (
        <fieldset>
          <legend>{title}</legend>
          <WrappedComponent {...this.props} />
        </fieldset>
      );
    }
  }

 HOC.getDisplayName = WrappedComponent.getDisplayName;

  return HOC;
};
```
这样做，就需要你清楚的知道都有哪些静态方法需要拷贝的。或者你也可是使用[hoist-non-react-statics](https://github.com/mridgway/hoist-non-react-statics)来帮你自动处理，它会自动拷贝所有非React的静态方法：
```javascript
import hoistNonReactStatic from 'hoist-non-react-statics';

export default (title = '默认标题') => (WrappedComponent) => {
  class HOC extends Component {
    static displayName = `HOC(${getDisplayName(WrappedComponent)})`;

    render() {
      return (
        <fieldset>
          <legend>{title}</legend>
          <WrappedComponent {...this.props} />
        </fieldset>
      );
    }
  }

  // 拷贝静态方法
  hoistNonReactStatic(HOC, WrappedComponent);

  return HOC;
};

```

## Refs属性不能传递
一般来说，高阶组件可以传递所有的props属性给包裹的组件，但是不能传递 `refs` 引用。因为并不是像 `key` 一样，`refs` 是一个伪属性，`React` 对它进行了特殊处理。
如果你向一个由高级组件创建的组件的元素添加 `ref` 应用，那么 `ref` 指向的是最外层容器组件实例的，而不是包裹组件。
但有的时候，我们不可避免要使用 `refs`，官方给出的解决方案是：
> 传递一个ref回调函数属性，也就是给ref应用一个不同的名字

同时还强调道：**React在任何时候都不建议使用 ref应用**
改写 `Demo`
```javascript
class Demo extends Component {
  static propTypes = {
    getRef: PropTypes.func
  }

  static getDisplayName() {
    return 'Demo';
  }

  constructor(props) {
    super(props);
    this.state = {
      innerText: '我是一个普通组件'
    };
  }

  render() {
    const { getRef, ...props } = this.props;
    return (
      <div ref={getRef} {...props}>
        {this.state.innerText}
      </div>
    );
  }
}
```
之后我们进行调用：
```javascript
<WithHeaderDemo
  getRef={(ref) => {
    // 该回调函数被作为常规的props属性传递
    this.headerDemo = ref;
  }}
/>
```
虽然这并不是最完美的解决方案，但是`React`官方说他们正在探索解决这个问题的方法，能够让我们安心的使用高阶组件而不必关注这个问题。

# 结语
这篇文章只是简单的介绍了高阶组件的两种最常见的使用方式：`属性代理`和`反向继承`。以及高阶组件的常见问题。希望通过本文的阅读使你对高阶组件有一个基本的认识。
写本文所产生的代码在[study-hoc](https://github.com/hiyangguo/study-hoc)中。

参考文章:
> [Higher-Order Components](https://facebook.github.io/react/docs/higher-order-components.html)
> [深入浅出React高阶组件](https://mp.weixin.qq.com/s/AdP-3oA9ofv9hQfDc2r7KA)
> [带着三个问题一起深入浅出React高阶组件](https://juejin.im/post/59818a485188255694568ff2)
> [廖雪峰 - Python 2.7教程 高阶函数](http://t.cn/RKWUqko)
> [深入理解高阶组件](http://www.jianshu.com/p/0aae7d4d9bc1)


