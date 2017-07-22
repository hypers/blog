---
title: React 项目中的权限控制需要做哪些事情？
date: 2017-07-22
tag: 
- 前端 
- React
- 权限
- permission
---

## 背景

公司的产品在切换到 SPA 架构时候前，主要采用的 Spring MVC 架构，还是用的 jsp 多页面进行管理，基本上前端不需要管理权限，也不需要控制路由，都由后端 Java filter 层进行处理。当决定在产品线中用 `React` 技术栈以后，权限一部分的控制就交给了前端进行控制，后端只需要控制 API 以及 API 返回的数据权限。

很多 SPA 架构的项目都采用是 JWT 安全认证，是基于 Token 的一种方式。在本文中所讲的权限认证是基于 CAS (这里采用 cookie + session 身份验证) 的安全认证，所以接下来所讲的内容不一定适用于所有项目，也不是最佳实践，只是在某个环境中合适的。

首先，分析一下权限控制，在产品中我们要考虑那几个方面：

- 登录授权，用户没有登录只能访问登录页面，如果处于登录状态则跳转到当前用户的默认首页；
- 路由授权，当前登录用户的角色，如果对一个 URL 没有权限访问，则跳转到 403 页面；
- 数据授权，当访问一个没有权限的API，则跳转到 403 页面；
- 操作授权，当页面中某个按钮或者区域没有权限访问则在页面中隐藏。

针对这4个方面，具体看一下在 React 项目中我们怎么控制？

## 登录授权 

用户只有在登录以后才能访问一些页面，这部分的权限控制需要交给路由来控制， React 项目中的路由，我们用的是 `react-router` 。为了考虑到按需加载等问题，我们采用的是动态路由。

- 首先，在路由设计的时候，会把路由分为两大类，一类是在非登录状态下可以访问，一类是必须在登录以后才能访问的。 
- 然后，在必须要登录后的这类路由设置一个父路由，这个路由没有可以没有 `path`， 它需要做的一件事件就是在 `onEnter` 函数中判断当前用户是否处于登录状态，如果未登录则跳转到登录页面。

```js
export default {
  onEnter: (nextState, replace) => {
    // 验证是否已经登录，如果没有登录则跳转到登录页面
    if (!checkLogin()) {
      replace('/login');
    }
  },
  childRoutes: [
    // 登录后可以访问的子路由
    require('./users').default,
    require('./userGroups').default,
    ...
  ]
};
```
- 最后，在 `login` 路由中 `onEnter` 函数判断是否已经处于登录状态，如果已经登录则跳转到登录用户的默认首页。

```js
export default {
  path: 'login',
  onEnter: (nextState, replace) => {
    if (checkLogin()) {
      goHomePage();
    }
  },
  component: PageLogin
};
```

## 路由授权 

用户登录以后，不同的角色所具有访问那些路由的权限是不一样的，比如：一个管理员登录以后可以用户管理的路由，但是一个普通用户则不能访问。 一个角色到底具有那些路由的权限，这个权限信息我们是存储在数据库中，后台通过一个 API 返回给前端，用户在登录以后就可以拿到登录用户具有那些路由权限的一个配置。有了这个配置就好办了，我们只需监听路由的变化是否发生变化，如果发生变化，判断当前路由是否在配置的路由中存在，如果不存在就跳转到指定的错误页面。 

监听路由的变化我们放在了一个 `components` 层的基类 `componentWillReceiveProps` 中处理。

```js
componentWillReceiveProps(nextProps) {
    const { location } = nextProps;
    // URL 发生改变的时候检查是否有权限访问
    if (location.pathname === '/' || location.pathname !== this.props.location.pathname) {
      checkUrlByAllowRouters(routers);
    }
  }
```


## 数据授权 

不同的用户登录以后，对数据范围的权限是有限制的，那些能够访问，那些不能访问在产品设计的是就已经定义好，当访问一个当前登录用户无权访问的 API 或者数据的时候，API 响应中会返回对应的 `code`, 这个 `code` 是提前就前后的约定好的值。

这部分的处理逻辑应该放在 `fetch api` 访问层处理 , 定义一个 `checkResponseCode` 函数，根据约定的 `code` 做出相应的处理。

```js
function checkResponseCode(code){
    ...
}

fetch(url, options)
  .then(checkHttpStatus)
  .then(parseJSON)
  .then((data) => {
    checkResponseCode(data.code);
    ...
    ...
    return data;
  })
  .catch((err) => {
    errorCallback(err, dispatch);
    ...
  });
```

## 操作授权

当用户进入到一个可以访问的路由以后，页面上的按钮不是所有角色都可以操作，有些角色具有查看的功能，有些角色具有新建和删除的功能，不同的角色进入到这个页面，有些按钮需要禁用或者直接不显示这是一个很普遍的业务功能。 

这部分的逻辑就只能在每个业务模块的 `components` 中单独处理，根据不同的业务做个性化处理。为了能够方便的拿到用户的角色相关的信息，在用户登录以后，可以把用户信息放在 `React` 组件最外层的 `context` 中, 这样在各个子组件中都可以很方便的获取到用户信息，进行判断验证并对组件进行对应的控制处理。

另外，很多产品系统中的菜单是动态的，所以菜单的信息可以保存在数据库中，不同的角色会有不同的配置，当用户登录以后，会获取菜单资源的信息，并进行菜单初始化。



## 其他方面的问题

那是不是做到以上几点就可以呢？ 其实还存在一些问题:

- 当用户登录以后，在地址栏你们直接输入一个 URL 地址，访问一个未授权的路由，这样是否还能做到路由授权的验证？ 路由授权那里讲到，在 `componentWillReceiveProps` 判断路由发生变化才会触发校验，在这种情况下是不会触发校验的。
- 当用户刷新当前页面的时候，或者直接访问一个没有权限的页面， 会出现页面会闪一下再进行跳转。出现这种情况的原因是，整个项目都是走 `redux` 单向数据流，获取用户的信息 `fetch...` 方法, 被绑定到 `components` 上，也就是说，要等组件渲染的时候才会去取用户信息，然后再通过返回的用户信息进行校验，这个时候组件已经显示出来，再进行页面跳转，就出现了这种闪动的问题。


针对这种情况，我们必须要在组件渲染前就必须拿到用户信息，然后再做对应正确的组件渲染。

- 首先，我们定义了一个 `ready` 函数，这个函数用来处理所有的预加载，会主动去那一次用户信息检验当是否处于等于状态，同时在这一步我们还做了一些其他时间，比如主题的预加载，环境信息的预加载。

```js
const filter=[];
/**
 * 获取用户信息，检验是否处于登录装
 */
filter.push(new Promise((resolve, reject) => {
    
    ...
    // 异步获取用户信息，如果拿到用信息后再检验一下，当前访问的路由是否有权限访问
    checkUrlByAllowRouters(view.routers);
}));

/**
 * 获取环境信息 ， 主题加载并初始化
 */
filter.push(new Promise((resolve, reject) => {
    ...
}));


export default function ready(callback) {
  Promise.all(filter)
    .then(values => {
      ...
      callback();
    })
    .catch((error) => {
      console.error('ready=>', error);
    });
}

```

- 然后，等 `ready` 所有事情处理完成以后，在回调函数中调用 `react-dom` 的 `render` 函数，渲染组件。 在 `ready` 处理是需要一点时间，这个这个时间内为了体验，最好是叫一个默认的 `Loading...` 。

```js
ready((values) => {
  render(<App />,
    document.getElementById('mount')
  );
});
```

## 总结
处理到这里，应该说能想到的要点都考虑到了。总结一下，其实前端在做权限控制的时候，依赖于后端 API 返回的配置信息，所以在权限设计，路由设计，数据结构设计的时候，前后端一定要约定好。

另外，路由授权这部分的逻辑是可以改进，可以把这部分路径放到 `router` 中处理，后续如果改进后，再更新本文档。



> 本文作者：[郭小铭](https://github.com/simonguo)










