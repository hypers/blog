---
title: 小而美的 React Form 组件
date: 2017-09-09
copyright: true
author:
  name: 郭小铭
  link: https://github.com/simonguo
categories:
  - 前端
tags:
  - React
  - Form
  - RSuite
---



## 背景

之间在一篇介绍过 Table 组件[《React 实现一个漂亮的 Table》](http://blog.hypers.io/2017/09/03/rsuite-table/) 的文章中讲到过，在企业级后台产品中，用的最多且复杂的组件主要包括 Table、 Form、 Chart，在处理 Table 的时候我们遇到了很多问题。今天我们这篇文章主要是分享一下 Form 组件，在业务开发中， 相对 Table 来说，Form 处理起来更麻烦，不是所有表单都像注册页面那样简单，它往往需要处理非常多的逻辑，比如：
- 需要处理数据验证逻辑。
- 在一个项目中的很少有可以复用的表单，每个表单的逻辑都需要单独处理。
- 在表单中往往存在需要自定义的组件，比如：Toggle、Tree、Picker 等等。

Form 作为一个功能型组件，它需要解决的问题无非就是两个：
- 把一个数据对象扔给它，它能够在让 Form 内的交互型组件获取到数据并展示出来，同时这些组件上的数据也能反过来让 Form 组件获取到。
- 对数据的有效性进行验证。

> 在 React 项目开发中没有用过其他 Form 相关的组件，但是这里我又忍不住想和 Ant Design 的 Form 对比一下，以下是我在 antd 官网上的一个截图：

{% asset_img antd-form.png antd form %}

大家可以通过以上图片看到，我想输入自己的中文名字都不能正常输入，这里主要存在两个问题：
- onChange 被触发了多次，在一次中文未完整的输入前，不应该触发 `onChange` 事件。
- 另外，中文在文本框内就不能正常显示。

我在想这两个问题不在组件上处理，在哪里处理的呢？访问地址: https://ant.design/components/form-cn/ 可以试一下，也希望他们可以解决掉这个问题。这个问题应该怎么解决，我之前做过记录: [React 中, 在 Controlled(受控制)的文本框中输入中文 onChange 会触发多次](https://github.com/hypers/blog/blob/master/source/_posts/react-issue.md#react-中-在-controlled受控制的文本框中输入中文-onchange-会触发多次)。

我们在设计的时候自然是解决了这些问题，预览效果: https://rsuitejs.com/form-lib/ ，接下来看一下具体的设计。

<!-- more -->
## 设计

针对前面提到 Form 需要解决的两个问题（数据校验和数据获取），在设计的时候，我们把这个两个问题作为两个功能，独立在不同的库处理。
- [form-lib](https://github.com/rsuite/form-lib) 处理表单数据初始化，数据获取。
- [rsuite-schema](https://github.com/rsuite/rsuite-schema) 定义数据模型，做数据有效性验证。

这两个库可以独立使用，如果你有自己一套自己的 Form 组件，只是缺少一个数据验证的工具，那你可以单独把 `rsuite-schema` 拿过来使用。


### Form 定义一个表单

分别看一下它们是怎么工作的，`form-lib` 用起来比较简单，提供了两个组件：
- `<Form>` 处理整个表单服务的逻辑
- `<Field>` 处理表单中各个交互型组件的逻辑，比如 `input`,`select`。

看一个示例：

#### 安装

首先需要安装 `form-lib`

```
npm i form-lib --save
```

#### 示例代码

```js
import { Form, Field, createFormControl } from 'form-lib';
const SelectField = createFormControl('select');

const user = {
  name:'root',
  status:1
};

```

```html
<Form data={user}>
  <Field name="name"   />
  <Field name="status" accepter={SelectField} >
    <option value={1}>启用</option>
    <option value={0}>禁用</option>
  </Field>
</Form>
```

在默认情况下 Field 是一个文本输入组件，如果你需要使用 HTML 表单中其他的标签，你可以像上面示例一样 通过 `createFormControl(标签名称)` 方法创建一个组件， 在把这个组件通过 `accepter` 属性赋给`Field` 组件，这样你就能像操作原生 HTML 一样设置 `Field`。 通过这种方式，后面在功能介绍的时候会讲到怎么把自定义组件放在 `Field` 中。

#### 自定义布局

这里存在一个疑问，`<Field>` 必须放在 `<Form>` 下面第一层吗？ 如果对布局没有要求，设计成这样是处理起来最方便的，因为在 `<Form>` 中可以直接通过 `props.children` 获取到所有的 `<Field>`，想怎么处理都可以。
刚开始我们是这样的，后来在实际应用中发现，表单的布局是有很多种，如果要设计成这样，那肯定就带来一个问题，不好自定义布局。 所以这里 `<Form>` 与 `<Field>` 之间的通信我们用的是 React 的 context。  这样的话你就可以任意布局:

```html
<Form data={user}>
  <div className="row">
    <Field name="name"   />
  </div>
  <div className="row">
    <Field name="status" accepter={SelectField} >
      <option value={1}>启用</option>
      <option value={0}>禁用</option>
    </Field>
  </div>
</Form>
```

#### Form Props

`<Form>` 与  `<Field>` 详细 API 说明，参考以下表格

`<Form>` Props :

| 名称            | 类型                                    | 描述                                                 |
|---------------|---------------------------------------|----------------------------------------------------|
| horizontal    | bool                                  | 设置表单内的元素左右两栏布局                                     |
| inline        | bool                                  | 设置表单内元素在一行布局                                       |
| values        | object                                | 表单的值 `受控组件`                                        |
| defaultValues | object                                | 表单的初始默认值 `非受控组件`                                   |
| model         | Schema                                | rsuite-schema 对象                                   |
| checkDelay    | number                                | 数据校验的时候，延迟处理，默认为 500 毫秒                            |
| checkTrigger  | string                                | 数据校验的触发类型,可选项： `change`、`blur`、`null`，默认为：`change` |
| onChange      | function(values:Object, event:Object) | 数据改变后的回调函数                                         |
| onError       | function(errors:Object)               | 校验出错的回调函数                                          |
| onCheck       | function(errors:Object)               | 数据校验的回调函数                                          |
| errors        | object                                | 表单错误信息                                             |

`<Field>` Props :

| 名称       | 类型          | 描述     |
|----------|-------------|--------|
| name     | string      | 表单元素名称 |
| accepter | elementType | 受代理的组件 |



### Schema 定义一个数据模型

#### 安装

```
npm i rsuite-schema --save
```

在 `rsuite-schema` 主要有两个对象

- `SchemaModel` 用于定义数据模型。
- `Type` 用于定义数据类型，包括：
  - StringType
  - NumbserType
  - ArrayType
  - DateType
  - ObjectType
  - BooleanType

> 这里的 Type 有点像 React 中 PropTypes 的定义。

#### 示例代码

一个示例:

```js
const userModel = SchemaModel(
    username: StringType().isRequired('用户名不能为空'),
    email: StringType().isEmail('请输入正确的邮箱'),
    age: NumberType('年龄应该是一个数字').range(18, 30, '年应该在 18 到 30 岁')
});
```

这里定义了一个 `userModel`, 包含 `username`、`email`、`age` 3个字段， `userModel` 拥有了一个 `check` 方法, 当把数据扔进去后会返回验证结果：

```js
const checkResult = userModel.check({
    username: 'foobar',
    email: 'foo@bar.com',
    age: 40
})

// checkResult 结果:
/**
  {
      username: { hasError: false },
      email: { hasError: false },
      age: { hasError: true, errorMessage: '年应该在 18 到 30 岁' }
  }
**/
```

#### 多重验证

```js
StringType()
  .minLength(6,'不能少于 6 个字符')
  .maxLength(30,'不能大于 30 个字符')
  .isRequired('该字段不能为空');
```


#### 自定义验证

通过 addRule 函数自定义一个规则。
如果是对一个字符串类型的数据进行验证，可以通过 pattern 方法设置一个正则表达式进行自定义验证。

```js
const myModel = SchemaModel({
    field1: StringType().addRule((value) => {
        return /^[1-9][0-9]{3}\s?[a-zA-Z]{2}$/.test(value);
    }, '请输入合法字符'),
    field2: StringType().pattern(/^[1-9][0-9]{3}\s?[a-zA-Z]{2}$/, '请输入合法字符')
});
```

#### 自定义动态错误信息

例如，要通过值的不同情况，返回不同的错误信息，参考以下

```js
const myModel = SchemaModel({
    field1: StringType().addRule((value) => {
        if(value==='root'){
          return {
            hasError: true,
            errorMessage:'不能是关键字 root'
          }
        }else if(!/^[a-zA-Z]+$/.test(value)){
          return {
            hasError: true,
            errorMessage:'只能是英文字符'
          }
        }

        return {
            hasError: false
        }
    })
});
```


#### 复杂结构数据验证

```js
const userModel = SchemaModel({
  username:StringType().isEmail('正确的邮箱地址').isRequired('该字段不能为空'),
  tag: ArrayType().of(StringType().rangeLength(6, 30, '字符个数只能在 6 - 30 之间')),
  profile: ObjectType().shape({
    email: StringType().isEmail('应该是一个 email'),
    age: NumberType().min(18, '年龄应该大于18岁')
  })
})
```

> 更多设置，可以查看 [rsuite-schema API 文档](https://github.com/rsuite/rsuite-schema#api)



### Form 与 Schema 的结合

```js
const userModel = SchemaModel({
    username: StringType().isRequired('用户名不能为空'),
    email: StringType().isEmail('请输入正确的邮箱'),
    age: NumberType('年龄应该是一个数字').range(18, 30, '年应该在 18 到 30 岁')
});
```

```html
<Form model={userModel}>
  <Field name="username" />
  <Field name="email" />
  <Field name="age" />
</Form>
```

把定义的的`SchemaModel`对象赋给，`<Form>`的 `model` 属性，就把它们绑定起来了，`<Field>` 的 `name` 对应 `SchemaModel` 对象中的 `key`。

以上的示例代码是不完整的，没有处理错误信息和获取数据，只是为了方便大家理解。完整的示例，可以参考接下来的实践与解决方案。

## 实践与解决方案

### 一个完整的示例

```js
import React from 'react';
import { Form, Field, createFormControl } from 'form-lib';
import { SchemaModel, StringType } from 'rsuite-schema';

const TextareaField = createFormControl('textarea');
const SelectField = createFormControl('select');

const model = SchemaModel({
  name: StringType().isEmail('请输入正确的邮箱')
});

class DefaultForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      values: {
        name: 'abc',
        status: 0
      },
      errors: {}
    };
    this.handleSubmit = this.handleSubmit.bind(this);
  }
  handleSubmit() {
    const { values } = this.state;
    if (!this.form.check()) {
      console.error('数据格式有错误');
      return;
    }
    console.log(values, '提交数据');
  }
  render() {
    const { errors, values } = this.state;
    return (
      <div>
        <Form
          ref={ref => this.form = ref}
          onChange={(values) => {
            console.log(values);
            this.setState({ values });
            // 清除表单所有的错误信息
            this.form.cleanErrors();
          }}
          onCheck={(errors) => {
            this.setState({ errors });
          }}
          values={values}
          model={model}
        >
          <div className="form-group">
            <label>邮箱: </label>
            <Field name="name" className="form-control" />
            <span className="help-block error" style={{ color: '#ff0000' }}>
              {errors.name}
            </span>
          </div>

          <div className="form-group">
            <label>状态: </label>
            <Field name="status" className="form-control" accepter={SelectField} >
              <option value={1}>启用</option>
              <option value={0}>禁用</option>
            </Field>
          </div>

          <div className="form-group">
            <label>描述 </label>
            <Field name="description" className="form-control" accepter={TextareaField} />
          </div>
          <button onClick={this.handleSubmit}> 提交 </button>
        </Form>
      </div>
    );
  }
}

export default DefaultForm;
```

### 在 rsuite 中的应用

在 `rsuite` 提供了很多 `Form` 相关的组件，比如 `FormGroup`,`FormControl`,`ControlLabel`,`HelpBlock` 等等， 我们通过一个例子看一下怎么结合使用。

通过上一个例子中我们可以看到，没有个 `Field` 中有很多公共部分，所以我们可以自定义一个无状态组件 `CustomField`,把 `ControlLabel`,`Field`,`HelpBlock` 这些表单元素都放在一起。

```js

import React from 'react';
import { Form, Field, createFormControl } from 'form-lib';
import { SchemaModel, StringType, ArrayType } from 'rsuite-schema';
import {
  FormControl,
  Button,
  FormGroup,
  ControlLabel,
  HelpBlock,
  CheckboxGroup,
  Checkbox
} from 'rsuite';

const model = SchemaModel({
  name: StringType().isEmail('请输入正确的邮箱'),
  skills: ArrayType().minLength(1, '至少应该会一个技能')
});

const CustomField = ({ name, label, accepter, error, ...props }) => (
  <FormGroup className={error ? 'has-error' : ''}>
    <ControlLabel>{label} </ControlLabel>
    <Field name={name} accepter={accepter} {...props} />
    <HelpBlock className={error ? 'error' : ''}>{error}</HelpBlock>
  </FormGroup>
);

class DefaultForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      values: {
        name: 'abc',
        skills: [2, 3],
        gender: 0,
        status: 0
      },
      errors: {}
    };
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit() {
    const { values } = this.state;
    if (!this.form.check()) {
      console.error('数据格式有错误');
      return;
    }
    console.log(values, '提交数据');
  }

  render() {
    const { errors, values } = this.state;
    return (
      <div>
        <Form
          ref={ref => this.form = ref}
          onChange={(values) => {
            this.setState({ values });
            console.log(values);
          }}
          onCheck={errors => this.setState({ errors })}
          defaultValues={values}
          model={model} >

          <CustomField
            name="name"
            label="邮箱"
            accepter={FormControl}
            error={errors.name}
          />

          <CustomField
            name="status"
            label="状态"
            accepter={FormControl}
            error={errors.status}
            componentClass="select"
          >
            <option value={1}>启用</option>
            <option value={0}>禁用</option>
          </CustomField>

          <CustomField
            name="skills"
            label="技能"
            accepter={CheckboxGroup}
            error={errors.skills}
          >
            <Checkbox value={1}>Node.js</Checkbox>
            <Checkbox value={2}>Javascript</Checkbox>
            <Checkbox value={3}>CSS 3</Checkbox>
          </CustomField>

          <CustomField
            name="gender"
            label="性别"
            accepter={RadioGroup}
            error={errors.gender}
          >
            <Radio value={0}>男</Radio>
            <Radio value={1}>女</Radio>
            <Radio value={2}>未知</Radio>
          </CustomField>

          <CustomField
            name="bio"
            label="简介"
            accepter={FormControl}
            componentClass="textarea"
            error={errors.bio}
          />
          <Button shape="primary" onClick={this.handleSubmit}> 提交 </Button>
        </Form>
      </div>
    );
  }
}
export default DefaultForm;
```

### 自定义 Field

如果一个组件不是原生表单控件，也不是 RSuite 库中提供的基础组件，要在 form-lib 中使用，应该怎么处理呢？
只需要在写组件的时候实现以下对应的 API:

- value : 受控时候设置的值
- defalutValue: 默认值，非受控情况先设置的值
- onChange: 组件数据发生改变的回调函数
- onBlur: 在失去焦点的回调函数(可选)

接下来我们使用 rsuite-selectpicker 作为示例, 在 rsuite-selectpicker 内部已经实现了这些 API。

```js
import React from 'react';
import { SchemaModel, NumberType } from 'rsuite-schema';
import { Button, FormGroup, ControlLabel, HelpBlock } from 'rsuite';
import Selectpicker from 'rsuite-selectpicker';
import { Form, Field } from 'form-lib';

const model = SchemaModel({
  skill: NumberType().isRequired('该字段不能为空')
});

const CustomField = ({ name, label, accepter, error, ...props }) => (
  <FormGroup className={error ? 'has-error' : ''}>
    <ControlLabel>{label} </ControlLabel>
    <Field name={name} accepter={accepter} {...props} />
    <HelpBlock className={error ? 'error' : ''}>{error}</HelpBlock>
  </FormGroup>
);

class CustomFieldForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      values: {
        skill: 3,
      },
      errors: {}
    };
    this.handleSubmit = this.handleSubmit.bind(this);
  }
  handleSubmit() {
    const { values } = this.state;
    if (!this.form.check()) {
      console.error('数据格式有错误');
      return;
    }
    console.log(values, '提交数据');
  }
  render() {
    const { errors, values } = this.state;
    return (
      <div>
        <Form
          ref={ref => this.form = ref}
          onChange={(values) => {
            this.setState({ values });
            console.log(values);
          }}
          onCheck={errors => this.setState({ errors })}
          defaultValues={values}
          model={model}
        >


          <CustomField
            name="skill"
            label="技能"
            accepter={Selectpicker}
            error={errors.skill}
            data={[
              { label: 'Node.js', value: 1 },
              { label: 'CSS3', value: 2 },
              { label: 'Javascript', value: 3 },
              { label: 'HTML5', value: 4 }
            ]}
          />
          <Button shape="primary" onClick={this.handleSubmit}> 提交 </Button>
        </Form>
      </div>
    );
  }
}

export default CustomFieldForm;
```


更多示例：[参考](https://github.com/rsuite/form-lib/tree/master/docs/examples)



如果你在使用中存在任何问题，可以提交 issues，如果你有什么好的想法欢迎你 pull request，GitHub地址：

- rsuite: https://github.com/rsuite/rsuite
- form-lib: https://github.com/rsuite/form-lib
- rsuite-schema: https://github.com/rsuite/rsuite-schema
