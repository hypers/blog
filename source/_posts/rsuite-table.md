---
title: React 实现一个漂亮的 Table
date: 2017-09-02
copyright: true
author:
  name: 郭小铭
  link: https://github.com/simonguo
categories:
  - 前端
tags:
  - React
  - Table
---



## 概述

对于企业级后台产品来说，Table 应该是使用最频繁的组件了，它通常比 Form 和 Chart 的使用还频繁。
这么一个常用的组件，我们决定要把它从 RSuite 中单独出来做，并且具有通用性，做的漂亮。

首先看一下，我们 Table 的效果

{% asset_img preview.gif rsuite table %}
- 预览地址: https://rsuitejs.com/rsuite-table/
- Github: https://github.com/rsuite/rsuite-table

最开始促使我们去实现这个 Table 原因，是因为产品经理希望 Table 可以像 Excel一样固定表头，固定列头，我们都知道原生的 HTML Table 是不支持这个功能，但是在实际应用中，对于数据行多列多的情况下，固定表头和列头非常有用，方便数据关联浏览。我们的组件库都是 React 的， 开源环境中也没有找到一个适合的我们的 Table 组件。 Ant Design 中的 Table 估计有些人用过，UI 比较漂亮，但是在固定表头和列头的这个功能上我还是有些不满意，特别是要同时固定表头和列的时候，他们的 Table 在 Retina 屏幕上，通过触摸板滚动表格的时候，固定的区域和非固定的区域会对不整齐，看上去会抖动，这个体验不是特别好。我知道 facebook 的 FixedDataTable 针对这块的处理做的还不错，是一个好的参考，特别是大数据量渲染也不卡顿，但是有些功能也不能满足我们的业务场景，比如：在 Table 中呈现一个树形结构。所以这个轮子决定自己造，然后我们又实现了，自定义调整列宽的功能，显示树结构数据等等功能。

## 设计

在 UI 的设计上符合 RSuite 的整体风格，当然这个是可以自定义的。 我们具体看一下组件的设计，整个 Table 提供了4个组件:


- <Table> 定义表格，可以设置数据源，表格类型等等;
- <Column> 定义列，设置列与数据源关联的 key, 设置列宽度，设置是否可以排序，是否需要固定列等等。
- <Cell>  定义单元格，用于渲染数据的组件，可以自定义显示的方式。
- <HeaderCell>  定义列头的单元格。
- <TablePagination> 定义分页，是一个可选组件。


看一个简单的示例:

```html
<Table data={dataList}  >
    <Column  width={100} sort fixed resizable>
        <HeaderCell>ID</HeaderCell>
        <Cell dataKey="id" />
    </Column>
    <Column  width={100} sort resizable>
        <HeaderCell>Name</HeaderCell>
        <Cell dataKey="name" />
    </Column>
    <Column  width={100} sort resizable>
        <HeaderCell>Email</HeaderCell>
        <Cell dataKey="email" />
    </Column>
</Table>
```
这是一个简单 3 列的表格，接下来我们来看一下具体的功能点

## 功能介绍

### 锁定列

表头是默认固定的，只需要配置需要固定的列, 在需要估计的列添加 `fixed` 属性。

```html
<Column  width={100} fixed>
    <HeaderCell>ID</HeaderCell>
    <Cell dataKey="id" />
</Column>
```

这个功能是所有功能里面最麻烦的，特别是表头和列同时固定的时候，前面我也提到过 Ant Design 的 Table 就存在未解决的问题，滚动的时候就存在对不整齐了，以下是一个  Ant Design 的 Table 的一个截图和访问链接。
{% asset_img ant-table.png ant table %}
访问地址: https://ant.design/components/table-cn/#components-table-demo-fixed-columns-header

造成这个问题的主要原因是 `onScroll` 触发的频率和渲染的速度跟不上造成的, 如果要列和表头都固定，那必然会在一个方向上需要手动修改元素的位置，这里肯定不能用 React state 存储位置，那太慢了。所有需要操作 DOM, 去改变元素的位置，这里有这几个需要注意的技术点：

- 用 transform: translate3D 代替 top 与 left ，因为 top/left 会导致回流，而 translate 只产生重绘，性能会更好，另外 translate3D 走的是 3D, 在手机浏览器器上会 GPU 加速。
- `onScroll` 触发的频率和渲染的速度会存在跟不上的情况，所有这里最好是自己实现一个滚动条，在 Table Body 上监听 `onWheel` 事件，在滚动条上监听 `onMouse*` 事件。 在自己实现滚动条的时候需要注意的是，在 Mac 的 chrome 上，左右滑动的时候会触发浏览器的上一页和下一页功能，所以这里的事件冒泡要处理好（本来想找一个开源的滚动条轮子，发现有好多这个问题没有处理好，所以就自己写了）。

我们的 Table 在处理上面两点以后，就解决了 Ant Design 的 Table 滚动存在的问题，当然如果大家有更好的方案，感谢你分享一下。
另外，Ant Table 有很多方面做得是比我们好的，比如它支持固定右侧的列，支持嵌套表格等等功能。

### 自定义调整列宽

在表格中有些列的数据有长有短，不太好预测，但还是希望在一个单元格内显示，如果给列固定好一个宽度以后，那超出单元格的内容就会被截断隐藏，导致信息显示不完整。
Excel 的列是可以调整宽度的，所以我们也希望列可以调整宽度，只需要在 `<Column>` 设置一个 `resizable` 属性。

```html
<Column width={130}  sortable>
    <HeaderCell>First Name</HeaderCell>
    <Cell dataKey="firstName" />
</Column>
```

### 自动设置列宽

有一种情况，Table 在页面中的宽度比如是 `1000px`+ （可能更宽，根据显示器屏幕的宽度决定）, 但是这个 Table 只有 3 列，如果每列都固定一个 `200px`， 肯定 撑不满整个 Table，导致不美观， 我们都知道原生的 HTML table, 当给 table 设置 `width:100%` 以后，列会根据内容自动撑满，如果给其中一个 td 设置了 `width`, 那 Table 剩下的 width, 会被剩下的几列撑满。那在 rsuite-table 怎么解决问题呢？ 看以下示例：

```html
<Table width={1000}>
  <Column width={200}>
      <HeaderCell>First Name</HeaderCell>
      <Cell dataKey="firstName" />
  </Column>
  <Column flexGrow={1}>
    <HeaderCell>City</HeaderCell>
    <Cell dataKey="city" />
  </Column>
  <Column flexGrow={2}>
    <HeaderCell>Company Name</HeaderCell>
    <Cell dataKey="companyName" />
  </Column>
</Table>
```



## 遗留的问题



