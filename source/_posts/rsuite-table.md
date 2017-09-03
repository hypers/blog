---
title: React 实现一个漂亮的 Table
date: 2017-09-03
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

对于企业级后台产品来说，Table 应该是使用最频繁的组件了，它通常比 Form 和 Chart 的使用还频繁。对于这么一个常用的组件，我们决定要把它从 RSuite 中单独出来开发，并且要具有一定的通用性，适应很多场景。 首先看一下，Table 完成的效果。

{% asset_img preview.gif rsuite table %}
- 预览地址: https://rsuitejs.com/rsuite-table
- Github: https://github.com/rsuite/rsuite-table

最开始促使我们去实现这个 Table 组件是因为产品经理希望表格可以像 Excel一样固定表头和列，我们都知道 HTML table 是不支持这个功能，但是在实际应用中，对于数据行多列多的情况下，固定表头和列非常有用，方便数据关联浏览。我们的组件库都是 React 的， 开源环境中也没有找到一个适合的我们的 Table 组件。 Ant Design 中的 Table 估计有些人用过，UI 比较漂亮，但是在固定表头和列的这个功能上我还是有些不满意，特别是要同时固定表头和列的时候，在 Retina 屏幕上，Ant Table 通过触摸板滚动表格，固定的区域和非固定的区域会对不整齐，看上去会抖动，这个体验不是特别好。我知道 facebook 的 FixedDataTable 针对这块的处理做的还不错，是一个好的参考，特别是大数据量渲染也不卡顿，但是有些功能也不能满足我们的业务场景，比如在要 Table 中呈现一个树形结构就没有这个功能。所以还是决定自己造这个轮子。

<!-- more -->

## 设计



在 UI 的设计上符合 RSuite 的整体风格。 我们具体看一下组件的设计，整个 Table 提供了 5 个组件，分别是:


- `<Table>` 定义表格，可以设置数据源，表格类型等等
- `<Column>` 定义列，设置列与数据源关联的 key, 设置列宽度，设置是否可以排序，是否需要固定列等等。
- `<Cell>`  定义单元格，用于渲染数据的组件，可以自定义显示的方式。
- `<HeaderCell>`  定义列头的单元格。
- `<TablePagination>` 定义分页，是一个可选组件。



看一个简单的示例:

```
npm i rsuite rsuite-table --save
```

>  有些地方依赖了 RSuite 中的基础组件，所有需要安装 `rsuite`。

```js
import { Table, Column, HeaderCell, Cell } from 'rsuite-table';
```

```html
<Table data={data}  >
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

这是一个简单 3 列的表格，接下来我们来看一下具体的功能点。

## 功能介绍

### 锁定列

表头是默认固定的不需要额外的配置，要固定列，需要在固定的列 `<Column>` 添加 `fixed` 属性。

```html
<Column  width={100} fixed>
    <HeaderCell>ID</HeaderCell>
    <Cell dataKey="id" />
</Column>
```

这个功能是所有功能里面最麻烦的，特别是表头和列同时固定的时候，前面我也提到过 Ant Design 的 Table 就存在一个问题，滚动的时候固定列和非固定列未对齐，以下是一个  Ant Design 的 Table 的一个截图和访问链接。
{% asset_img ant-table.png ant table %}
访问地址: https://ant.design/components/table-cn/#components-table-demo-fixed-columns-header

造成这个问题的主要原因是 `onScroll` 触发的频率和渲染的速度跟不上造成的, 如果要列和表头都固定，那必然会在一个方向上需要手动修改元素的位置，这里肯定不能用 React state 存储位置，然后等待渲染，那太慢了。所有需要操作 DOM, 去改变元素的位置，这里有这几个需要注意的技术点：

- 用 transform: translate3D 代替 top 与 left ，因为 top/left 会导致回流，而 translate 只产生重绘，性能会更好，另外 translate3D 走的是 3D, 在手机浏览器器上会 GPU 加速。
- `onScroll` 触发的频率和渲染的速度会存在跟不上的情况，所有这里最好是自己实现一个滚动条，在 Table Body 上监听 `onWheel` 事件，在滚动条上监听 `onMouse*` 事件。 在自己实现滚动条的时候需要注意的是，在 Mac 的 chrome 上，左右滑动的时候会触发浏览器的上一页和下一页功能，所以这里的事件冒泡要处理好（本来想找一个开源的滚动条轮子，发现有好多组件这个问题没有处理好，所以就自己写了）。

> 对 DOM 操作用到了 [dom-lib](https://github.com/rsuite/dom-lib)

我们的 Table 在处理上面两点以后，就解决了 Ant Design 的 Table 滚动存在的问题，当然如果大家有更好的方案，感谢你分享一下。
另外，Ant Table 有很多方面做得是比我们好的，比如它支持固定右侧的列，支持嵌套表格等等功能。


> [完整示例代码](https://github.com/rsuite/rsuite-table/tree/master/docs/examples/FixedColumnTable.js)


### 可调整列宽

在表格中有些列的数据有长有短，不太好预测，但还是希望在一个单元格内显示，如果给列固定好一个宽度以后，那超出单元格的内容就会被截断隐藏，导致信息显示不完整。Excel 的列是可以调整宽度的，所以我们也希望列可以调整宽度，只需要在 `<Column>` 设置一个 `resizable` 属性。

```html
<Column width={130}  sortable>
    <HeaderCell>First Name</HeaderCell>
    <Cell dataKey="firstName" />
</Column>
```

> [完整示例代码](https://github.com/rsuite/rsuite-table/tree/master/docs/examples/ResizableColumnTable.js)


### 自动设置列宽

有一种情况，Table 在页面中的宽度比如是 `1000px`+ （可能更宽，根据显示器屏幕的宽度决定）, 但是这个 Table 只有 3 列，如果每列都固定一个 `200px`， 肯定 撑不满整个 Table，导致不美观， 我们都知道 HTML table, 当给 table 设置 `width:100%` 以后，列会根据内容自动撑满，如果给其中一个 td 设置了 `width`, 那 Table 剩下的 width, 会被剩下的几列撑满。那在 rsuite-table 怎么解决问题呢？ 看以下示例：

```html
<Table width={1000}>
  <Column width={100}>
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

在 `<Column>` 组件上提供了一个 `flexGrow` 属性，有点类似 CSS3 中的 `flex-grow` 属性。上面示例中，Table 的 `width` 为 `1000` , 第一列的 `width:100`, 第二列设置为  `flexGrow:1`, 第三列设置为  `flexGrow:2`。 渲染后计算的结果是：

- 第一列: `100px`
- 第二列: `flexGrow:1`, `(1000 - 100)/(2 + 1) * 1` = `300px`
- 第三列: `flexGrow:2`, `(1000 - 100)/(2 + 1) * 2` = `600px`

> [完整示例代码](https://github.com/rsuite/rsuite-table/tree/master/docs/examples/FluidColumnTable.js)


### 排序

排序是一个基础的功能，在需要排序的列 `<Column>` 设置一个 `sortable` 属性。 同时在 `<Table>` 定义一个 `onSortColumn:Function` 回调函数，点击列头排序图标的时候，会触发该方法，并返回 `sortColumn:String` 和 `sortType:String('asc'|desc)`。 看一下示例：

```html
<Table
  onSortColumn={(sortColumn, sortType)=>{
    console.log(sortColumn, sortType);
  }}
  >
  <Column width={50}  sortable>
      <HeaderCell>Id</HeaderCell>
      <Cell dataKey="id" />
  </Column>
  <Column width={130} sortable >
      <HeaderCell>First Name</HeaderCell>
      <Cell dataKey="firstName" />
  </Column>
  <!--... -->
</Table>
```

> [完整示例代码](https://github.com/rsuite/rsuite-table/tree/master/docs/examples/SortTable.js)


### 分页

提供了一个 `<TablePagination>` 组件，用于显示分页栏，这里的分页需要开发人员自己去处理数据，看一下示例代码：

```js
function formatLengthMenu(lengthMenu) {
    return (
        <div className="table-length">
            <span> 每页 </span>
            {lengthMenu}
            <span> 条 </span>
        </div>
    );
}

function formatInfo(total, activePage) {
    return (
        <span>共 <i>{total}</i> 条数据</span>
    );
}
```

```html
<TablePagination
    formatLengthMenu={formatLengthMenu}
    formatInfo={formatInfo}
    displayLength={100}
    total={500}
    onChangePage={this.handleChangePage}
    onChangeLength={this.handleChangeLength}
/>
```
- formatLengthMenu 格式化显示行数；
- formatInfo 格式化显示总条目信息；
- displayLength 默认显示多少行数据，可以通过 state 管理；
- total 它不是当前返回数据的行数，他是所有数据的总条目数，这个需要后端 API 的返回，通过这个值与displayLength，才能计算出表格分多少页。可以通过 state 管理；
- onChangePage 切换分页的回调函数；
- onChangeLength 切换显示条目数的回调函数。

看一下，效果：
{% asset_img pages.png table pagebar %}

> [完整示例代码](https://github.com/rsuite/rsuite-table/tree/master/docs/examples/PaginationTable.js)

### 树形表格

先看一下树形表格的样子
{% asset_img tree.png table tree %}

渲染成树形的表格需要设置两个地方，首先 `<Table>` 组件上设置一个 `isTree` 属性，同时 `data` 中的数据需要通过 `children` 来定义关系结构。

```html
<Table data={data} isTree expand  height={400}>
```

data 中的数据结构

```js
[{
    labelName: '汽车',
    status: 'ENABLED',
    children: [
        {
            labelName: '梅赛德斯-奔驰',
            status: 'ENABLED',
            count: 460
        }
        ...
    ]
    ...
}]
```
> [完整示例代码](https://github.com/rsuite/rsuite-table/tree/master/docs/examples/TreeTable.js)


### 自定义单元格

单元格中的内容往往需要能交互的，比如设置为一个连接，或者 `hover` 的时候能显示一段信息等等。 在 rsuite-table 中，可以对 `Cell` 进行自定义。
先看一下以下是一个自定义后的表格图例：
{% asset_img custom-cell.png Custom `Cell` %}


比如，显示一个图片，定义一个 `ImageCell` 组件：
```js
const ImageCell = ({ rowData, dataKey, ...props }) => (
  <Cell {...props}>
    <img src={rowData[dataKey]} width="50" />
  </Cell>
);
```
用的时候：

```html
<Column width={200} >
    <HeaderCell>Avartar</HeaderCell>
    <ImageCell dataKey="avartar" />
</Column>
```
比如，要格式化日期，就定义一个 `DateCell` 组件：
```js
const DateCell = ({ rowData, dataKey, ...props }) => (
  <Cell {...props}>
    {rowData[dataKey].toLocaleString()}
  </Cell>
);
```
用的时候：
```html
<Column width={200} >
  <HeaderCell>Action</HeaderCell>
  <DateCell dataKey="date" />
</Column>
```

**自定义行高**

如果在实际应用中需要根据数据内容来定义行高，可以使用以下方式

```html
<Table
  onRerenderRowHeight={(rowData) => {
    if (rowData.firstName === 'Janis') {
        return 30;
      }
    }}
  >
...
</Table>
```

> [完整示例代码](https://github.com/rsuite/rsuite-table/tree/master/docs/examples/CustomColumnTable.js)


### 可编辑的表格

{% asset_img edit-table.png Edit Table %}

可编辑的表格，只需要自定义一个 `<Cell>`, 然后通过 `state` 管理状态。

```js
export const EditCell = ({ rowData, dataKey, onChange, ...props }) => {
  return (
    <Cell {...props}>
      {rowData.status === 'EDIT' ? (
        <input
          className="input"
          defaultValue={rowData[dataKey]}
          onChange={(event) => {
            onChange && onChange(rowData.id, dataKey, event.target.value);
          }}
        />
      ) : rowData[dataKey]}
    </Cell>
  );
};
```
> [完整示例代码](https://github.com/rsuite/rsuite-table/tree/master/docs/examples/EditTable.js)

## 遗留的问题

- 内容自动换行，并且自动设置行高，在 HTML table 中很容易实现这个功能，如果整个 `<Table>` 是的通过 CSS 布局控制也许能实现这个功能，但是在实现的时候，很多地方都是通过 JS 控制高度，比如: 行高、单元格的 left，top 相对位置等等，所以要根据内容来自动行高是比较麻烦的事情，暂时没想到好的解决办法，但是我们提供了一个 `onRerenderRowHeight` 函数，可以让用户自己根据内容来控制行高。
- 根据内容自动设置列宽， 这个问题暂时也没有想到好的解决方案， 现在只能通过 `flexGrow` 来填充剩余宽度。
- 固定列在右侧，这个功能后续会考虑加进去。
- 表头分组，合并单元格，这个功能麻烦点在于，我们所有的列都是可以调整列宽的，如果同时考虑合并单元格逻辑上处理有些麻烦，不过后续会考虑加入该功能。


如果，你对这些问题有好的想法欢迎你 提交 [pull request](https://github.com/rsuite/rsuite-table)。
如果，你在使用中存在任何问题，可以提交 [issues](https://github.com/rsuite/rsuite-table/issues)。

