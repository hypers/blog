---
title: Dart 简单入门
copyright: true
author:
  name: Sleaf
  link: https://github.com/Sleaf
date: 2019-02-02 10:20:51
tags:
  - Dart
---
{% asset_img logo.png 这个世界到底还需不需要一门新的语言？ %}
> - 推荐图书：[Dart编程语言 - 【美】Gilad Bracha ](https://book.douban.com/subject/27074797/)
> - 推荐阅读官方文档：[A Tour of the Dart Language](https://www.dartlang.org/guides/language/language-tour)
> - 建议切一个窗口打开[DartPad](https://dartpad.dartlang.org/)边看边码，更能加深印象！

# 写在前面
Dart 其实并不算一门非常新的语言，最早版本发行与 2011 年 10 月，目标是取代 JavaScript 成为下一代 Web 开发语言（很显然他失败了）。截止发稿已经发布了 2.x 版本，与初始版本并无太多改动，保持了兼容性。他没有像同胞哥哥[ Golang ](https://zh.wikipedia.org/wiki/Go)在后端占有一席之地一样在 Web 端有所作为，而是不温不火好几年，直到[ Flutter ](https://zh.wikipedia.org/wiki/Flutter)的出现才有所改善。
语言本身来说，他是一门**强类型且面向类编程**的语言，前端朋友如果长期以 JavaScript 为主力语言的话可能会有些许不适应，但是相信在短暂的学习之后就会上手，并喊出“真香”。
笔者是实实在在的新手，本文更多也是作为读书笔记，如果有什么不足或纰漏，还望各位不吝赐教，定虚心接受。
  
# 语言设计理念
## 万物皆对象
不同于 JavaScript 和 Java 有对象和基本值，在 Dart 的世界里**任何事物都是对象**，无一例外。这一点可以让我们更好地去操作我们的代码而不用关心拆装箱等问题，在一定程度上简化了构建逻辑，简化了实现任务。
## 面向接口编程，而非面向实现
关注对象的行为而非内部实现时 OOP 的核心原则，在 Dart 中这一原则被更好地强调和实现，具体方式有以下几条：
- 在 Dart 中并不存在声明的接口，因为**所有的类都可以被当做接口**，不管其他类是否采用了同样的底层实现（部分 core type 除外）
- Dart 中没有 final 方法，**允许几乎重写所有方法**（部分内置操作符除外）。
- Dart 把对象进行抽象封装，**所有的操作都是通过存取来改变对象状态的**，即在其他语言中习以为常的**`=`赋值和`.`取值在 Dart 中也只是`get()`和`set()`的语法糖**。

## 类型时为开发服务
这点我感觉与 TypeScript 的理念（或是说实现效果）比较相近，毕竟大家觉得强类型语言写起来舒服的原因就是**清晰的接口**和**便捷的 IDE 提示**，往编译层面来说就是为编译器提供更好的预判，从而优化性能。 Dart 在类型方面采用了可选类型(Sound type) ，算是在强弱类型之间找到了一个平衡：
  - 类型在语法层面时可选的
  - 类型对运行时的语义没有影响。

这意味着你也可以把 Dart 当做一门动态类型语言来编写，虽然不推荐，但是还是在一定程度上给了开发者很高的自由度，让其他语言的开发者更快迁移到 Dart 上来。

# 字面量
> 当然别忘了，他们也都还是对象

- 整数 *int*： `1` `2` `3`
- 浮点数 *double*：（遵循 IEEE754 标准的 64-bit 浮点数）`1.0` 
> 在 Dart 2.1 之后 `double value = 1;` 将自动转为（等价于） `double value = 1.0;`
- 数字 *num*： 作为*int*和*double*的父级
- 布尔 *bool*： `true`
- 字符串 *String*： （转义字符用法与 JavaScript 相似）
```dart
void main(){
  var man = 'Mick';
  var s1 = 'It\'s hot today!';
  var s2 = "It's hot today!";
  var s3 = "'It\'s hot today!'$man said.";
  var s4 = '''
  It!
  is!
  hot!
  today!
  ''';
  
  //You can create a “raw” string by prefixing it with r:
  var s = r'In a raw string, not even \n gets special treatment.';
}
```
- 列表 *List*：  `[1,2,3]`
- 映射 *Map*：   `{'1':1,'2':2}` 
> 注意：虽然和JavaScript中的对象很像但是不能通过`.something`的方式代替`['sonething']`
- 函数 *Function*： `()=>{}`
- Symbol： (使用 `#` 开头，后面跟着一个或多个`.`分割的标识符或运算符，基本用不到) `#MyClass` `#com.evil_empire.forTheWin`

# 基本语法
和其他 C-style 语法相似，你之前学到的知识大概率是能用得上的。如果你写过 Java / Kotlin 的话应该会感觉更加亲切，因为真的很像。
## 变量声明
变量声明方面其实没有声明特别的地方，你可以~~凭自己的喜好~~给变量增加类型：
```dart
var a='1';//不带类型的变量声明
String b ='1';//带类型的变量声明
const c='1';//常量声明
final d='1';//在调用后被初始化
var e;//未初始化的变量将被初始化为null
```
## 来写一个类吧
- 你可以像这样写一个类
> 注意： Dart 是**不支持函数重载**的

  ```dart
  class Point{
    var x, y;
    Point(a,b){
      x = a;
      y = b;
    }
    scale(factor){
      return new Point(x * factor, y * factor);//在 Dart2 中你可以无条件省略 new 关键词
    }
  }
  ```
- 你还可以像 Java / C++ 一样写个类
```dart
class Point{
  int x, y;
  Point(a,b){
    this.x = a;
    this.y = b;
  }
  scale(factor){
    return new Point(x * factor, y * factor);//在 Dart2 中你可以无条件省略 new 关键词
  }
}
```
- 当然， Dart 也有自己的语法糖
```dart
class Point{
  var x, y;
  Point(this.x,this.y);//第一个参数将会自动赋给 x ，第二个参数会自动赋给y
  scale(factor) =>  new Point(x * factor, y * factor);//在 Dart2 中你可以无条件省略 new 关键词
  operator +(p) => new Poinit(x + p.x,y + p.y);//就像在 c++ 里一样，你又可以重写运算符了！
}
```
- 在 Dart 中还支持了 `staic` / `final` / `const` 关键词，还有 `const构造方法`
> 还有抽象关键词`abstract`，与 Java 用法相似，在此就不做举例。

  ```dart
  class Foo{
    static var onlyOne = 1;
    static const neverChange = 0;
    final lazyLoad;//推荐大部分变量都设置为 final ，可以在声明时初始化，也可以在构造函数初始化（必须二选一）。
    get onlyOne(){}
    set onlyOne(){}
    Foo(lazyOne):lazyLoad=lazyOne,super(key:lazyOne);// final 值也可以通过构造函数后冒号初始化，调用父类构造函数 super。
    const Foo()//所有 const 关键词赋值中调用的只能是常量或字面量，因为所有被 const 修饰的方法/变量将会在编译阶段被求值。
  }
  ```
- Dart 的类支持了 `extends` / `with` / `implements`，按需取用。
> - 和其他现代语言一样， Dart 支持单继承多接口，在此基础上还增加了饱受争议的 mixin （一对多）。
> - `mixin` 关键词也可以替代 `class` 作为声明关键词来使用，以专门编写用于 mixin 的类，如果此 mixin 要求对象实现接口则使用 `on` 关键词在最后修饰。
> - 可参考[Flutter Dart语法(1):extends 、 implements 、 with的用法与区别](https://juejin.im/post/5c4881dae51d45098e4d96cf)

  ```dart
   class Bar {
     var a = 1;
     m(p, q) {}
   }
   
   mixin Bar2 on Bar {
     /*
       * on修饰符要求mixin对象的父类实现了Bar接口
       * */
     @override
     void m(q, p) {
       super.m(q, p);
     }
     //...
   }
   
   class Foo1 extends Bar {
     /*
       * 1. Dart中的继承是单继承
       * 2. 构造函数不能继承
       * 3. 子类重写超类的方法，要用@override
       * 4. 子类调用超类的方法，要用super
       * 注意：不可以重写父类中声明变量的set和get方法（隐式），同时重写的方法要与父类中方法参数个数相同。
       * */
     //...other codes
   }
   
   class Foo2 implements Bar {
     /*
       * 1. class 就是 interface
       * 2. 当class被当做interface用时，class中的方法就是接口的方法，需要在子类里重新实现，在子类实现的时候要加@override
       * 3. 当class被当做interface用时，class中的成员变量也需要在子类里重新实现。在成员变量前加@override
       * 4. 实现接口可以有多个
       * */
     @override
     var a = 1;
     @override
     m(p, q) {}
     //...other codes
   }
   
   class Foo3 with Bar {
     /*
       * 1. mixins类只能继承自object
       * 2. mixins类不能有构造函数
       * 3. 一个类可以mixins多个mixins类
       * 4. 可以mixins多个类，不破坏Dart的单继承
       * 注意：mixin有点像extends，但是我理解上更像是原型链的模型，with后即链上对象，采取的是覆盖原则，即靠后的生效。（甚至可以粗暴地理解为复制代码）
       * */
     //...other codes
   }
   
   class Foo4 extends Bar with Bar2 {
     //通过继承的方式实现。
     //...other codes
   }
   
   class Foo5 extends Foo2 with Bar2 {
     //通过继承的方式实现。
     //...other codes
   }
  ```

## 函数
- 基本的函数可以参考下面，包含了*三目运算符*和*错误抛出*。
```dart
maxElement(a){
  //你可以在maxElement前面加上返回类型 如 int maxElement(a)
  //你也可以在a前面标注上类型来声明a的类型  如 maxElement(List<int> a)
  var currentMax = a.isEmpty
    ? throw 'Maximal element undefined for empty array' : a[0];
  for(var i = 0; i < a.length; i++){
    currentMax = max(a[i],currentMax);
  }
  return currentMax;
}
```
- Dart还支持了`可选参数`/`具名参数`/`参数默认值`，当然你也可以使用`@required`来标注具名参数中必须传入的值。
```dart
void foo1(a, [ b = 1] ){//a为参数，b为可选参数并设置了默认值1
  print('${a},${b}');//当仅有变量时也可以简写为print('$a,$b')
}
void foo2(a,{ @required b, c = 0 }){//a为参数，b/c为具名参数,b为必传，c设置了默认值0
  print('${a},${b},${c}');  
}
void main() {
  foo1(1, 2);//1,2
  foo2(1, b:2);//1,2,0
}
```
- 支持函数作为参数传递，当然也就支持箭头函数，不同于 JavaScript 中的箭头函数和普通函数有 this 的区别，** Dart 中的箭头函数就是实实在在的“糖”**
```dart
void main()=>{};
```
- Dart同样支持了闭包，但是和JavaScript的又不大一样，这里有个不得不吐的槽：
```javascript
for (var i = 0; i < 5; i++) {
  setTimeout(function () {
    console.log(i);//他会很不合预期地打出五个5
  }, 1000 * i);
}
```
  这段代码应该是前端面试的常客了，但是与它类似的代码在 Dart 中就显得很“正常”
  ```dart
  import 'dart:async';
  void main(){
    for (var i = 0; i < 5; i++) {
      Timer(Duration(seconds: i), () {
        print(i);//0,1,2,3,4
      });
    }
  }
  ```
  因为在 Dart 中，每次执行 for 都会给代码新建一个* context *，所以在**每次执行的 Timer 都是一个全新的 `i` **

- 在函数的调用上页支持`..`来级联操作，它不像`.`会返回调用后的结果，而是返回被调用者本身，这样的设计给链式调用多了一种选择。
```dart
void main(){
  /*1*/"Hello".length.toString();//5
  /*2*/"Hello"..length.toString();//Hello
  /*第2行等价于*/
  "Hello".length;
  "Hello".toString();
}
```
- 如果函数调用`()`也是"糖"？没错。他就是`.call()`方法的语法糖。所以你可以给对象加上`call`方法以使用`()`来调用方法。
```dart
class fakeFunc {
  call() {
    print('works!');
  }
}

void main() {
  var a = fakeFunc();
  a();//works!
}
```
- Dart同样支持迭代器语法，支持同步和异步
```dart
naturalsTo(n) sync* {//同步迭代器
  var k=0;
  while(k<n) yield k++;
}
naturalsTo(n) async* {//异步迭代器
  var k=0;
  while(k<n) yield await k++;
}
```
- 还有一个不得不提的方法 `noSuchMethod` ，如果运行时对象没有对应的方法，将会调用这个方法，这使得我们可以由此做一些”Hack“(关于反射和动态代码)
对于 `noSuchMethod()` 的参数只有一个 `Invocation` 。关于 `Invocation` 的布尔属性所辨认的方法调用的句法形式，如下表所示：

|             | x.y   |	x.y = e	| x.y(…)|
|:-----------:|:-----:|:-------:|:-----:|
| isMethod    |	false |	false	  | true  |
| isGetter    |	true  | false   |	false |
| isSetter    |	false	| true    |	false |
| isAccessor  |	true	| true    |	false |

  ```dart
  class A{
    @override
    noSuchMethod(Invocation inv)=>print('fallback!');
  }
  void main(){
    var a = A();
    //注：更多时候你将会被 IDE 拦下来
    a.x();//'fallback!'
  }
  ```
## 其他语句
- 支持 c-style 的 `if(){}else if(){}else{}`
- 支持以`{}`分界的块状作用域，不允许块之间互相递归声明。
- 支持 c-style 的 `for` / `while` / `do-while` 循环以及相对应的 `continue` / `break`（还有对应的 label 也是支持的），还支持了 `for-in` 语法来快捷遍历集合类
- 支持 `switch-case` 多条件选择
> 注意：case 的值仅能为常量，且不允许[falls-through](https://en.wikipedia.org/wiki/Switch_statement#Fallthrough)，必须使用 break 跳出。
- 支持 `assert` 语法，优化开发体验。
```dart
void main(){
  int x = -1;
  assert(x>0);//在开发模式下报错
  x++;  
}
```

## 异常处理
 Dart 支持最舒适的 `throw` + `try{}catch(){}finally{}`语法，不多说！

# 库/模块
- Dart 的模块化比较像 C / C++ / Java ，他是将 import 的文件直接注入到**当前文件全局作用域**下的。
- Dart 引入关键词为 `import` ，支持使用 `as` 来重命名，还有 `deferred as` 来延迟加载，也支持使用 `show` / `hide` 组合器来限定引入范围。
```dart
import 'stack.dart' show pop,push;
import 'advancedStack.dart' as stack2 hide pop,push;
import 'mayUseless.dart' deferred as rarelyUsed;//只有在使用时才会被加载

void main(){
  onLoad(loadSuccess)=>loadSuceess?doStuff():makeExcusses();
  rarelyUsed.loadLibrary().then(onLoad);
}
```
- `export` 用于中转某个库需要在当前文件暴露的方法，但并不是和 import 配套使用的。同样支持使用 `show` / `hide` 组合器来限定引入范围。
> 类似于 JavaScript(ES6) 里的 `export from` 语法

  ```dart
  export 'stack.dart' hide pop;
  ```
- 还有一个对我而言比较陌生的关键词： `part` ，有的时候一个库可能太大，不能方便的保存在一个文件当中。Dart 允许我们把一个库拆分成一个或者多个较小的 part 组件。或者我们想让某一些库共享它们的私有对象的时候，我们需要使用 part。
```dart
// A.dart
import 'stack.dart' show pop;
part 'A_1.dart';
```
  ```dart
  //A_1.dart
  part of 'A.dart';
  void main(){
    pop(1);
  }
  ```
  这里我们可以看到，`A_1.dart`是`part of 'A.dart'`的文件，可以理解为，`A_1`是`A`的一部分。在`part test2.dart`中，我们并没有引入`stack.dart`包就直接使用了`pop`方法，是因为，在 part 中， import 进来的库是共享命名空间的。
  不是所有的库都有名称，但如果使用 part 来构建库，那么库必须要命名。
  ```dart
  library xxx;
  ```
  每个子 part 都存放在各自的文件中。但是它们共享同一作用域，库的内部命名空间，以及所有的导入（import）。

# 可选类型/泛型
正如之前提到的，Dart 中的类型是可选的，它仅为开发提供便利，同时也提供了泛型来约束集合内的类型，用法与 C++ / Java 类似。
```dart
List<num> list;
Map<String,int> map;
Map<String,dynamic> map2;
Map<dynamic,dynamic> freeMap;//等价于 Map freeMap;
```
你可以使用 `is` 关键字来检测是否为某个类的实例
```dart
void main(){ 
  var v=[1,2,3];
  v is Map;//false
  v is List;//true 
  v is Object;//always true
}
```
还可以使用 `as` 进行强制类型转换,这部分与 Java 的强制类型转换相似，只能是从子类转化为父类。
```dart
void main(){
  1 as Object;//无意义的转换，仅作举例
}
```

# 注解（Annotation）
> 对于 Java 程序员来说[注解](https://blog.csdn.net/briblue/article/details/73824058)一定不陌生，对于 JavaScript 程序员来说，可能听说过[装饰器(decorator)](http://es6.ruanyifeng.com/#docs/decorator)的提案。

注解作为[元数据(metadata)](https://www.dartlang.org/guides/language/language-tour#metadata)，是为了给代码提供额外的信息，提升编码体验，大部分时候并不会对代码产生实质性影响。它以`@`打头，后跟一个`const常量`或调用一个`const构造函数`，内置对象有 `@required` `@deprecated` 等。
```dart
class Television {
  /// _Deprecated: Use [turnOn] instead._
  @deprecated
  void activate() {
    turnOn();
  }

  /// Turns the TV's power on.
  void turnOn() {
    //...
  }
}
```
你也可以自定义一个注解：
```dart
class Todo {
  final String who;
  final String what;
  const Todo(this.who, this.what);
}

@Todo('seth', 'make this do something')//使用自定义注解
void doSomething() {
  print('do something');
}
```

# Async
让我很喜欢 JavaScript 的原因之一就是在疏不在堵的异步调用（在 Node 上更为明显），这也是很多 JavaScript 新手的末日。
很高兴在 Dart 上能找到几乎一样的实现方案: `Future`
```dart
import 'dart:async';
//定义了返回结果值为String类型
Future<String> getData(String category) async {
  var request = await _httpClient.getUrl(Uri.parse(url));  
  var response = await request.close();
  return await response.transform(utf8.decoder).join();
}

void main() async{
  var data = await getData('test');//调用 async 函数
  //链式调用，捕获异常
  var future = //调式调用
    new Future
    .then(funA(),onError: (e) { handleError(e); })
    .then(funB(),onError: (e) { handleError(e); });    
}
```
与 ES6 中的 `Promise` 用法基本一致，具名参数的加成使得代码可读性更佳，真香！

# 一些有趣的特性
- 在 Dart 程序中一定存在一个入口函数，和 C 一样，我们把他命名为 main ()，虽然是在面向类编程，但是我们依然可以**在文件的最外层可以直接声明函数和变量**，这点和 Java 倒是不大一样，但其实幕后工作编译器都帮我们做好了，我们只管写就好了!
- Dart 中的整数长度取决于你的内存大小（编译成目标语言除外~~。说你呢 JavaScript ！~~）
- `final` 声明的值将是采用**懒加载的方式**，即**只有当` get()`被调用之前，该变量才会被初始化**。
- 在 Dart 中**只有 `bool` 类型的 `true` 是 `true` ,其他对象都是 `false` **，~~虽然不影响编译，~~但是在你写出来的时候 IDE 就会拼命给你报错了。
- Dart **不存在内部类**，类中**不存在私有方法**所有的方法都是可见并大部分都是可以重写的。私有变量以`_`开头，如 `_privateThing`;

# 一些高级特性
> 由于本文为入门教程，笔者对于 Dart 也是入门不久，以下高级编程部分用的较少，作为补充仅提及，后续可能会更新补充，有兴趣的读者可以自行搜索学习。

- 代理 (Proxy)
- 反射 (Mirror)
