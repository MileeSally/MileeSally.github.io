---
title: Dart 语言基础语法
---

<font color=black face="黑体" size=10><center>Dart 语言基础语法</center></font>

首先我们看下 Dart 语言基础语法思维导图，让我们有个大概的脉络。
![Dart 语法思维导图](./flutter-dart-syntax-tour.md.svg '')

接下来我将详细介绍 Dart 语言语法。

### 变量与常量

#### 变量

##### 显式指定类型（<font color=red face="宋体" size=3>内置数据类型</font>）来定义变量
```
String name = "张三";
num age = 18;
```

##### 使用关键字 var 来定义变量
```
var name = "张三";
var id = 100;
```

使用var定义变量，即使未显式指定类型，一旦赋值后类型就被固定，因此使用var定义的变量不能改变数据类型
```
var number = 19;
// 以下代码错误，无法运行，number变量已确定为int类型
number = "2019";
```
##### 使用 dynamic 或 Object 来定义变量
如想动态改变变量的数据类型，可以通过使用dynamic或Object来定义变量。
```
// dynamic声明变量
dynamic var1 = "hello";
var1 = 19;
print(var1);    // 19

// Object声明变量
Object var2 = 20;
var2 = "Alice";
print(var2);    // Alice
```

#### 常量

##### 使用final关键字来定义常量
```
// 1.使用final关键字定义常量
final height = 10;
```

##### 使用const关键字来定义常量
```
// 2.使用const关键字定义常量
const pi = 3.14;

const bar = 1000000; 
const atm = 1.01325 * bar;
```

**final 与 const 的区别**
```
// 1.实例变量可以为 final 但是不能是 const 。

// 2.const 定义常量为编译时常量，可以直接定义 const 和其值，也可以定义一个 const 变量使用其他 const 变量的值来初始化其值。

    const bar = 1000000; 
    const atm = 1.01325 * bar;

// 3.final 定义的常量是运行时常量，也就是说 final 定义常量时，其值可以是一个变量，而 const 定义的常量，其值必须是一个字面常量值。

    final time = new DateTime.now(); // 正确
    const time = new DateTime.now(); // 错误

    const list = const [1,2,3];       // 正确
    const list = [1,2,3];            // 错误

// 4.const 变量在类中，请定义为 static const。

// 5.const 关键字不仅仅只用来定义常量，也可以用来创建不变的值，还能定义构造函数为 const 类型的，这种类型的构造函数创建的对象是不可改变的。任何变量都可以有一个不变的值。
```

##### 枚举常量
枚举列表中的每个符号代表一个整数值，一个大于它之前的符号。默认情况下，第一个枚举符号的值为0。
```
enum Status { 
   none, 
   running, 
   stopped, 
   paused 
}
```

### 内置数据类型
#### [数值（num）](https://api.dartlang.org/stable/2.6.0/dart-core/num-class.html)
Dart 支持两种数值类型：int和double
##### int数值类型
整数，取值范围-2<sup>53</sup>和2<sup>53</sup>之间。
```
var x = 1;
var hex = 0xDEADBEEF;
var bigInt = 34653465834652437659238476592374958739845729;
int a = 1;
```
##### double数值类型
浮点数，64位的双精度浮点数。
```
var x = 1.1;
var exponents = 1.42e5;
double f = 0.1;
```

**常见用法**
```
// String 转 int
var one = int.parse('1');

// String 转 double
var onePointOne = double.parse('1.1');

// int 转 String
String oneAsStr = 1.toString();

// double 转 String
String piAsStr = 3.14159.toStringAsFixed(2); // 保留两位 '3.14'

// Dart也支持整数位操作，<<、 >>、&、|
print((3 << 1) == 6);  // 0011 << 1 == 0110
print((3 >> 1) == 1);  // 0011 >> 1 == 0001
print((3 | 4)  == 7);  // 0011 | 0100 == 0111

```
#### [字符串（String）](https://api.dartlang.org/stable/2.6.0/dart-core/String-class.html)
Dart 字符串是UTF-16编码的字符序列（<font color=red face="宋体" size=3>Dart 中用runes表示UTF-32字符序列</font>），可以使用<font color=red face="宋体" size=3>单引号</font>或者<font color=red face="宋体" size=3>双引号</font>来创建字符串。
```
var s1 = 'It\'s easy to escape the string delimiter.';
var s2 = "It's even easier to use the other delimiter.";
```

**常见用法**
```
// 1.Dart可以使用单引号或双引号来创建字符串
var s1 = "hello";
var s2 = 'world';

// 2.类似Python，Dart可以使用三引号来创建包含多行的字符串
//三个双引号
var multiLine1 = """This is also a
multi-line1 string.""";

//三个单引号
var multiLine2 = '''
You can create
multi-line2 strings like this one.
'''

// 3.类似Python，还可以在字符串字面值的前面加上`r`来创建原始字符串，则该字符串中特殊字符可以不用转义
var path = r"In a raw string, even \n isn't special.";

// 4.Dart支持使用"+"操作符拼接字符串
var greet = "hello" + " world";

// 5.Dart提供了插值表达式"${}"
var name = "王五";
var aStr = "hello,${name}";
print(aStr);    // hello,王五

// 当仅取变量值时，可以省略花括号
var aStr2 = "hello,$name"; // hello,王五

// 当拼接的是一个表达式时，则不能省略花括号
var str1 = "link";
var str2 = "click ${str1.toUpperCase()}";
print(str2);   // click LINK

// 6. 与Java不同，Dart使用"=="来比较字符串的内容
print("hello" == "world");
```

#### [布尔值（bool）](https://api.dartlang.org/stable/2.6.0/dart-core/bool-class.html)
Dart 中的布尔类型值只有true跟false两个值，不能使用0、非0或者null、非null来表达false和true。（布尔类型的默认值为null，这与Dart的所有类型都是对象特性有关）
```
var real = true;
bool isReal = false;
```

#### [列表（Lists）](https://api.dartlang.org/stable/2.6.0/dart-core/List-class.html)
```
var list = [1, 2, 3];
```

**常见用法**
```
// 创建列表
var list = [1, 2, 3];
// 下标从0开始。使用length可以访问list的长度
print(list[0]);
print(list.length);

// 可以使用add添加元素
list.add(5);

// 可在list字面量前添加const关键字，定义一个不可改变的 列表（编译时常量）
var constantList = const [1, 2, 3];
constantList[1] = 1;     // 报错
```

#### [集合（Set）](https://api.dartlang.org/stable/2.6.0/dart-core/Set-class.html)
Dart 中的Set是无序的唯一项的集合。使用前面带有类型参数的{}，或者将{}赋给类型为Set的变量。
**常见用法**
```
// 1.简单的Dart集，使用set文字创建。
var halogens = {'yiibai.com', 'chlorine', 'bromine', 'iodine', 'astatine'};
var names = <String>{};
Set<String> names = {}; // This works, too.
//var names = {}; // Creates a map, not a set.

// 2.使用add()或addAll()方法将项添加到现有集合。
var elements = <String>{};
elements.add('fluorine');
elements.addAll(halogens);

// 3.使用.length来获取集合中的项目数量：
var elements = <String>{};
elements.add('fluorine');
elements.addAll(halogens);
assert(elements.length == 5);

// 4.使用const创建一个编译时常量的集合。
final constantSet = const {
  'fluorine',
  'chlorine',
  'bromine',
  'iodine',
  'astatine',
};
```

#### [映射（Maps）](https://api.dartlang.org/stable/2.6.0/dart-core/Map-class.html)
**常见用法**
```
// 1.通过字面量创建Map
var gifts = {
  'first' : 'partridge',
  'second': 'turtledoves',
  'fifth' : 'golden rings'
};

// 2.使用Map类的构造函数创建对象
var pic = new Map();
// 往Map中添加键值对
pic['first'] = 'partridge';
pic['second'] = 'turtledoves';
pic['fifth'] = 'golden rings';

// 3.获取Map的长度
print(pic.length);

// 4.查找Map
pirnt(pic["first"]);
print(pic["four"]);    // 键不存在则返回 null
```

#### [Runes（UTF-32字符集的字符）](https://api.dartlang.org/stable/2.6.0/dart-core/Runes-class.html)
**常见用法**
```
// 打印Emoji表情
Runes input = new Runes('\u2665  \u{1f605}  \u{1f60e}  \u{1f47b}  \u{1f596}  \u{1f44d}');
print(new String.fromCharCodes(input));
输出：♥  😅  😎  👻  🖖  👍
```

#### [Symbols](https://api.dartlang.org/stable/dart-core/Symbol-class.html)
Symbol对象表示Dart程序中声明的运算符或标识符。可能永远不需要使用符号，但它们对于按名称引用标识符的API非常有用，因为缩小会更改标识符名称而不会更改标识符符号。
```
#radix
#bar
```

### [函数](https://api.dartlang.org/stable/2.6.0/dart-core/Function-class.html)
Dart 是一个真正的面向对象语言，方法也是对象并且具有一种类型 Function。 这意味着，方法可以赋值给变量，也可以当做其他方法的参数。也可以把 Dart 类的实例当做方法来调用。

#### 函数定义
在Dart中，函数类型是可选，可以省略显式的类型。
```
String greet(String name){
    return "hello,$name";
}

或则

greet(name){
    return "hello,$name";
}
```

##### 命名函数

命名函数就是带有函数名称的函数，也就是一般普通的函数。

```
String greet(String name){
    return "hello,$name";
}

或则

greet(name){
    return "hello,$name";
}
```

##### 匿名函数

Dart 中可以创建没有名字的函数，称为匿名函数，也被称为lambda表达式或者闭包。
```
// 定义匿名函数，并将其赋值给一个变量func，注意，函数体最后的花括号处必须有分号结束。
var func = (x,y){
    return x + y;
};

print(func(10,11));    // 21
```

##### 箭头函数

Dart 中的箭头函数与JavaScript中的基本相同。当函数体中只包含一个语句时，我们就可以使用=>箭头语法进行缩写。注意，箭头函数仅仅只是一个简洁表达的语法糖。
```
add(num x, num y) => x + y;

与

add(num x, num y){
    return x + y;
}

完全等价
```

箭头函数省略了花括号的表达，箭头后面跟一个表达式，函数的返回值也就是这个表达式的值。另外，箭头函数也可以与匿名函数结合，形成匿名箭头函数。
```
var func = (num x, num y) => x + y;
```

#### 函数参数

Dart 中支持两种可选参数：命名可选参数、位置可选参数。
在Java中通常使用方法重载来实现同名方法的不同参数调用，Dart 中则可以通过可选参数来实现相同效果。

##### 命名可选参数

<font color=red face="宋体" size=3> 命名可选参数 </font> 中的参数与顺序无关，无需按顺序传参，且传参数时需使用冒号。

在定义方法的时候，使用花括号 {param1, param2, …} 的形式来指定命名参数。

```
enableFlags({bool bold, bool hidden}) {
  // ...
}
```

调用方法的时候，你可以使用 key-value 形式 paramName:value 来指定命名参数。

```
enableFlags(hidden:true, bold:false);
```

如果在定义函数时，给参数列表中的参数设置默认值，则该参数就是可选的，函数调用时可以忽略该参数，使用默认的值。

<font color=red face="宋体" size=3>Dart SDK 1.21之前的版本中，命名参数不能使用 "=" 号来设置默认值，而SDK 1.21之后，只能使用 "=" 号来设置默认值。</font>

```
// 定义add函数
add({int x, int y=1, int z=0}){
    print(x + y + z;
}

// 调用
add(x:18);              // 19
add(x:18, y:2, z:10);   // 30
```

##### 位置可选参数

在定义方法的时候，使用中括号来定义参数列表，中括号中的参数是可选的。

```
add(int x, [int y, int z]){
  int result = x;
  if (y !=  null){
    result = result + y;
  }

  if (z !=  null){
    result = result + z;
  }

  print(result);
}

// 调用
add(18);           // 18
add(18,12);        // 30
add(18, 12, 15);   // 45

// 1.定义函数（有默认值）
add(int x, [int y=0, int z=0]){
  print(x +ｙ＋ｚ);
}
```

#### 词法闭包

一个<font color=red face="宋体" size=3> 闭包 </font>是一个方法对象，不管该对象在何处被调用，该对象都可以访问其作用域内的变量。

方法可以封闭定义到其作用域内的变量。

```
// 下面的示例中，makeAdder()捕获到了变量 addBy。不管你在那里执行 makeAdder()所返回的函数，都可以使用 addBy 参数。
Function makeAdder(num addBy) {
  return (num i) => addBy + i;
}

main() {
  // Create a function that adds 2.
  var add2 = makeAdder(2);

  // Create a function that adds 4.
  var add4 = makeAdder(4);

  assert(add2(3) == 5);
  assert(add4(3) == 7);
}
```

### 运算符

#### 算术运算符

| 操作   |      解释 
|:----------|:-------------|
| +           |   加号 
| -           |   减号   
| -expr       |   负号
| *           |   乘号 
| /           |   除号   
| ～/         |   除号（返回值为整数）
| %           |   取模 
| ++var       |   var = var + 1 (expression value is var + 1)
| var++       |   var = var + 1 (expression value is var)
| --var       |   var = var – 1 (expression value is var – 1) 
| var--       |   var = var – 1 (expression value is var)

#### 相等相关的操作符
<table class="table table-bordered table-striped table-condensed">
<tr>
<th>操作符</th>
<th>解释</th>
</tr>
<tr>
<td>==</td>
<td>相等</td>
</tr>
<tr>
<td>!=</td>
<td>不等</td>
</tr>
<tr>
<td>></td>
<td>大于</td>
</tr>
<tr>
<td><</td>
<td>小于</td>
</tr>
<tr>
<td>>=</td>
<td>大于等于</td>
</tr>
<tr>
<td><=</td>
<td>小于等于</td>
</tr>
</table>

#### 类型判定运算符
<table class="table table-bordered table-striped table-condensed">
<tr>
<th>操作符</th>
<th>解释</th>
</tr>
<tr>
<td>as</td>
<td>类型转换</td>
</tr>
<tr>
<td>is</td>
<td>如果对象是指定的类型返回 true</td>
</tr>
<tr>
<td>is!</td>
<td>如果对象是指定的类型返回 false</td>
</tr>
</table>

使用 as 操作符把对象转换为特定的类型。一般情况下，可以把 as 当做用 is 判定类型然后调用所判定对象的函数的缩写形式。例如下面的示例：
```
if (emp is Person) { // Type check
  emp.firstName = 'Bob';
}

使用 as 操作符可以简化上面的代码：

(emp as Person).firstName = 'Bob';
```

<font color=red face="宋体" size=3>注意: 上面这两个代码效果是有区别的。如果 emp 是 null 或者不是 Person 类型，则第一个示例使用 is 则不会执行条件里面的代码，而第二个情况使用 as 则会抛出一个异常。</font>

#### 赋值操作符
##### = 操作符

```
a = value;   // 给 a 变量赋值
```

##### ??= 操作符

```
b ??= value; // 如果 b 是 null，则赋值给 b；
             // 如果不是 null，则 b 的值保持不变
```

##### 复合赋值操作符
<table class="table table-bordered table-striped table-condensed">
<tr>
<td>–=</td>
<td>/=</td>
<td>%=</td>
<td>>>=</td>
<td>^=</td>
<td>+=</td>
</tr>
<tr>
<td>*=</td>
<td>~/=</td>
<td><<=</td>
<td>&=</td>
<td>|=</td>
<td></td>
</tr>
</table>

#### 逻辑操作符
可以使用逻辑操作符来操作布尔值。


<table class="table table-bordered table-striped table-condensed">
    <tr>
    <th>操作符</th>
    <th>解释</th>
    </tr>
    <tr>
    <td>!expr</td>
    <td>对表达式结果取反（true 变为 false ，false 变为 true）</td>
    </tr>
    <tr>
    <td>||</td>
    <td>逻辑 OR</td>
    </tr>
    <tr>
    <td>&&</td>
    <td>逻辑 AND</td>
    </tr>
</table>

#### 位移操作符
<table class="table table-bordered table-striped table-condensed">
    <tr>
    <th>操作符</th>
    <th>解释</th>
    </tr>
    <tr>
    <td>&</td>
    <td>AND</td>
    </tr>
    <tr>
    <td>|</td>
    <td>OR</td>
    </tr>
    <tr>
    <td>^</td>
    <td>XOR</td>
    </tr>
    <tr>
    <td>~expr</td>
    <td>取反</td>
    </tr>
    <tr>
    <td><<</td>
    <td>左移</td>
    </tr>
    <tr>
    <td>>></td>
    <td>右移</td>
    </tr>
</table>

#### 条件表达式
<table class="table table-bordered table-striped table-condensed">
    <tr>
    <th>操作符</th>
    <th>解释</th>
    </tr>
    <tr>
    <td>condition ? expr1 : expr2</td>
    <td>如果 condition 是 true，执行 expr1；否则执行 expr2。</td>
    </tr>
    <tr>
    <td>expr1 ?? expr2</td>
    <td>如果 expr1 是 non-null，返回其值； 否则执行 expr2。</td>
    </tr>
</table>

如果你需要基于布尔表达式 的值来赋值，考虑使用（?:）。
```
var finalStatus = m.isFinal ? 'final' : 'not final';
```

如果布尔表达式是测试值是否为null，考虑使用（??）。
```
String toString() => msg ?? super.toString();
```

#### 级联运算符

级联操作符(..)可以在同一个对象上连续调用多个函数以及访问成员变量。使用级联操作符可以避免创建临时变量，并且写出来的代码看起来更加流畅。

```
querySelector('#button') // Get an object.
  ..text = 'Confirm'   // Use its members.
  ..classes.add('important')
  ..onClick.listen((e) => window.alert('Confirmed!'));

等价于

var button = querySelector('#button');
button.text = 'Confirm';
button.classes.add('important');
button.onClick.listen((e) => window.alert('Confirmed!'));
```

级联调用也可以嵌套。
```
final addressBook = (new AddressBookBuilder()
      ..name = 'jenny'
      ..email = 'jenny@example.com'
      ..phone = (new PhoneNumberBuilder()
            ..number = '415-555-0100'
            ..label = 'home')
          .build())
    .build();
```

#### 其他操作符

<table class="table table-bordered table-striped table-condensed">
    <tr>
    <th>操作符</th>
    <th>名称</th>
    <th>解释</th>
    </tr>
    <tr>
    <td>( )</td>
    <td>使用方法</td>
    <td>代表调用一个方法</td>
    </tr>
    <tr>
    <td>[ ]</td>
    <td>访问列表</td>
    <td>访问列表中特定位置的元素</td>
    </tr>
    <tr>
    <td>.</td>
    <td>访问成员</td>
    <td>访问元素，例如 foo.bar 代表访问 foo 的 bar 成员</td>
    </tr>
    <tr>
    <td>?.</td>
    <td>条件成员访问</td>
    <td>和 . 类似，但是左边的操作对象不能为 null，例如 foo?.bar 如果 foo 为 null 则返回 null，否则返回 bar 成员</td>
    </tr>
</table>

### 流程控制
#### if-else
#### for循环
#### while循环
#### switch语句

有一种情况与C、Java等不一样，如下：

```
var command = 'OPEN';
switch (command) {
  case 'OPEN':
    executeOpen();
    // ERROR: Missing break causes an exception!!

  case 'CLOSED':
    executeClosed();
    break;
}

// 如果需要实现这种继续到下一个 case 语句中继续执行，则可以使用 continue 语句跳转到对应的标签（label）处继续执行：
var command = 'CLOSED';
switch (command) {
  case 'CLOSED':
    executeClosed();
    continue nowClosed;
    // Continues executing at the nowClosed label.

nowClosed:
  case 'NOW_CLOSED':
    // Runs for both CLOSED and NOW_CLOSED.
    executeNowClosed();
    break;
}
```

#### 断言

#### 异常

### 类和对象

#### 类的定义

Dart 中没有<font color=red face="宋体" size=4>private、public</font>这些成员访问修饰符。如果是类私有的成员，不希望外面访问，只需要在成员变量之前加上一个下划线 <font color=red face="宋体" size=4> _ </font> 变为私有即可。

```
// Dart 中定义一个类
class  Person {
    String name;
    int _age;

    // 有参无名的构造函数（普通构造函数）
    Person(String name, num age) {
      this.name = name;
      this.age = age;
    }
}
```

<font color=red face="宋体" size=4>可简化等价于</font>

```
// Dart 中定义一个类
class  Person {
    String name;
    int age;

    // 有参无名的构造函数（普通构造函数）
    Person(this.name, this.age);
}
```

#### 构造函数

Dart 中声明一个和类名相同的函数，来作为类的构造函数（与有名构造函数相对，也可以叫<font color=red face="宋体" size=4>作无名构造函数</font>）。

Dart 中子类<font color=red face="宋体" size=4>不会继承</font>父类的<font color=red face="宋体" size=4>无名有参构造函数</font>和<font color=red face="宋体" size=4>命名构造函数</font>（只能继承父类<font color=red face="宋体" size=4>无参无名构造函数</font>）。

Dart 中<font color=red face="宋体" size=4>没有</font>构造方法的重载。

```
class  Person {
    String name;
    int age;

    // 无参无名的构造函数
    Person() {
        print('in Person');
    }

    // 有参无名构造函数（普通孤构造函数）
    Person(String name, num age) {
      this.name = name;
      this.age = age;
    }

    // 构造方法不能重载，否则会报错
    // Person(this.name, this.age, String address){
    //     print(address);
    // }
}
```

##### 默认构造函数

如果子类<font color=red face="宋体" size=4>没有</font>定义构造函数，则会有个<font color=red face="宋体" size=4>默认构造函数</font>，这个构造函数<font color=red face="宋体" size=4>没有</font>参数。

如果子类有父类，那么默认构造函数会自动调用父类的<font color=red face="宋体" size=4>无参</font>构造函数。

<font color=red face="宋体" size=4>默认构造函数</font> == <font color=red face="宋体" size=4>无参无名构造函数</font>

```
// Dart 默认构造函数表现形式类似与以下表示：
class  Person {
    String name;
    int _age;

    //默认构造函数 == 无参无名构造函数
    // 无参无名构造函数
    Person() {
        print('in Person');
    }
}
```

##### 命名构造函数

使用<font color=red face="宋体" size=4>命名构造函数</font>可以为一个类实现<font color=red face="宋体" size=4>多个</font>构造函数。
使用<font color=red face="宋体" size=4>命名构造函数</font>可以<font color=red face="宋体" size=4>更清晰</font>的表明您的意图。

```
class Person {
    String name;
    int age;

    // 有参无名构造函数（普通构造函数）
    Person(this.name, this.age);

    // 命名构造函数
    Person.fromJson(Map json) {
    name = json['name'];
    age = json['age'];
  }
}
```

##### 常量构造函数

如果要实现功能：<font color=red face="宋体" size=4>类需要提供一个状态不变的对象</font>。
Dart 中可以把这些对象定义为编译时常量，<font color=red face="宋体" size=4>定义一个 const 构造函数，并且声明所有类的变量为 final 变量</font>。

```
class ImmutablePoint {
  final num x;
  final num y;
  const ImmutablePoint(this.x, this.y);
  static final ImmutablePoint origin =
      const ImmutablePoint(0, 0);
}
```

##### 工厂方法构造函数

如果一个构造函数并不总是返回一个新的对象，则使用 factory 来定义这个构造函数。

```

class Logger {
  final String name;
  bool mute = false;

  // _cache 为私有变量
  static final Map<String, Logger> _cache =
      <String, Logger>{};

  //注意：工厂构造函数无法访问 this。
  factory Logger(String name) {
    if (_cache.containsKey(name)) {
      return _cache[name];
    } else {
      final logger = new Logger._internal(name);
      _cache[name] = logger;
      return logger;
    }
  }

  Logger._internal(this.name);

  void log(String msg) {
    if (!mute) {
      print(msg);
    }
  }
}
```

使用<font color=red face="宋体" size=4> new 关键字</font>来调用工厂构造函数

```
var logger = new Logger('UI');
logger.log('Button clicked');
```

##### 初始化列表

初始化列表核心作用就是<font color=red face="宋体" size=4>可以在构造函数之前初始化成员变量</font>。

初始化列表的执行顺序是在整个构造函数的最前面，它除了可以调用父类的构造函数，还可以在子类的构造函数方法体之前初始化一些成员变量。

初始化列表尤其对初始化那些 <font color=red face="宋体" size=4>final</font> 修饰的成员变量很有用，这是因为在方法体中不能给 final 修饰的成员变量赋值，因为在执行方法体的时候，final 修饰的成员变量已经不能变了。

```
class Person {
    String name;
    int age;

    // 有参无名构造函数（普通构造函数）
    Person(this.name, this.age);

    // 初始化列表
    // 初始化列表可以在构造函数体之前设置变量
    // 初始化表达式等号右边的部分不能访问 this
    // 如果在构造函数的初始化列表中使用 super()，需要把它放到最后
    Person.fromJson(Map json) 
        : name = json['name'],
          age = json['age'] ,
          super(style) {
              print('In Person.fromJson(): ($name, $age)');
          }
}
```

##### 重定向构造函数

定义构造函数的时候，除了一个普通构造函数，还可以有若干命名构造函数。有时候一个构造函数会调动类中的其他构造函数。 

```
class Point {
  num x;
  num y;

  // 有参无名构造函数（普通构造函数）
  Point(this.x, this.y);

  // 重定向构造函数
  // 一个重定向构造函数是没有代码的，在构造函数声明后，使用:冒号调用其他构造函数。
  Point.alongXAxis(num x) : this(x, 0);
}
```

##### 子类构造函数调用父类构造函数

###### 隐式调用父类的无参数构造函数

如果存在以下情况：
1.父类有一个<font color=red face="宋体" size=4>无参数构造函数</font>。
2.子类<font color=red face="宋体" size=4>没有显式调用</font>父类的构造函数。
Dart 就会在子类的构造函数方法体的最前面，自动调用父类的无参数构造函数。

```
class Person {
    String name;
    int _age;

    // 无参数的，无名的构造函数
    Person() {
        print('in Person');
    }
}

class Employee extends Person {
    // 因为父类有无参数的无名构造函数，所以可以不用手动调用父类的构造函数。
    Employee.fromDictionary(Map data) {
        print('in Son');
    }
}
```

构造函数分成好几部分来初始化成员变量，调用的顺序如下：
```
初始化列表
父类的无参数构造函数
子类的无参数构造函数
```

###### 显式调用父类构造函数

父类<font color=red face="宋体" size=4>没有显式提供</font>无参构造函数。子类中必须手动显式调用父类的一个构造函数。

调用父类的构造函数的参数<font color=red face="宋体" size=4>无法访问</font> <font color=blue face="宋体" size=4>this</font>，所以参数可以为<font color=red face="宋体" size=4>静态函数</font>但是不能是实例函数。

```
class Person {
    String firstName;

    // 命名构造函数
    Person.fromDictionary(Map data) {
        print('in Person');
      }
}

class Employee extends Person {
    // 父类没有无参数的无名构造函数，必须手动调用一个父类的构造函数
    Employee.fromDictionary(Map data) : super.fromDictionary(data) {
        print('in Employee');
    }

    //所以这种写法会报错，因为父类没有无参数的无名构造函数
    // Employee.fromDictionary(Map data) {
    //     print('in Employee');
    // }
}
```

#### 变量和函数

##### 静态变量
使用 <font color=red face="宋体" size=4>static</font> 关键字来实现类级别的变量。

```
class Color {
  static const red =
      const Color('red'); // A constant static variable.
  final String name;      // An instance variable.
  const Color(this.name); // A constant constructor.
}
```
##### 实例变量


##### 静态函数
使用 <font color=red face="宋体" size=4>static</font> 关键字来实现类级别的函数。

```
class Point {
  num x;
  num y;
  Point(this.x, this.y);

  static num distanceBetween(Point a, Point b) {
    var dx = a.x - b.x;
    var dy = a.y - b.y;
    return sqrt(dx * dx + dy * dy);
  }
}
```

##### 实例函数

对象的实例函数<font color=red face="宋体" size=4>可以访问</font> <font color=blue face="宋体" size=4>this</font>。 

```
import 'dart:math';

class Point {
  num x;
  num y;
  Point(this.x, this.y);

  num distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
}
```
##### Setter函数和Getter函数

getter 和 setter 是用来<font color=red face="宋体" size=4>设置和访问对象属性</font>的特殊函数。

每个实例变量都隐含的具有一个 getter 函数， 如果变量不是 final 的则还有一个 setter 函数。 

可以通过实行 getter 和 setter 来创建新的属性，<font color=red face="宋体" size=4>使用 get 和 set 关键字</font>来定义 getter 和 setter：

getter 和 setter 的优点：在开始使用实例变量的地方，可以将实例变量用函数包裹起来，而调用实例变量代码的地方不需要修改，做到很好的<font color=red face="宋体" size=4>封装</font>作用。

```
class Rectangle {
  num left;
  num top;
  num width;
  num height;

  Rectangle(this.left, this.top, this.width, this.height);

  // Define two calculated properties: right and bottom.
  num get right             => left + width;
      set right(num value)  => left = value - width;
  num get bottom            => top + height;
      set bottom(num value) => top = value - height;
}
```

##### 抽象函数

抽象函数是只定义<font color=red face="宋体" size=4>函数接口但是没有实现</font>的函数，由<font color=red face="宋体" size=4>子类</font>来实现该函数。

实例函数、getter函数和setter函数可以为抽象函数。

```
abstract class Doer {
    // 抽象函数
    void doSomething(); 
}

class EffectiveDoer extends Doer {
    // 子类实现父类抽象函数
    void doSomething() {
        // todo：
    }
}
```

<font color=red face="宋体" size=4>非抽象类</font>也可以定义抽象函数

```
class SpecializedContainer extends AbstractContainer {

    // 实例函数
    void updateChildren() {
    }

    // 抽象函数
    void doSomething();
}
```

#### 抽象类

使用 <font color=red face="宋体" size=4>abstract</font> 修饰符定义一个抽象类。

抽象类是一个不能被<font color=red face="宋体" size=4>实例化</font>的类。

如果希望抽象类是可实例化的，可以通过定义一个<font color=red face="宋体" size=4>工厂构造函数</font>来实现。

抽象类通常用来定义<font color=red face="宋体" size=4>接口以及部分实现</font>。

抽象类通常具有<font color=red face="宋体" size=4>抽象函数</font>。 

抽象类定义如下：
```
// 抽象类
abstract class AbstractContainer {
    // 抽象函数
    void updateChildren(); 
}
```

#### 隐式接口

Dart 支持一个类可以通过 <font color=red face="宋体" size=4>implements 关键字</font>来实现一个或者多个接口，并实现每个接口定义的 API。

```
class Person {
  final _name;

  Person(this._name);

  String greet(who) => 'Hello, $who. I am $_name.';
}

class Imposter implements Person {
  final _name = "";

  String greet(who) => 'Hi $who. Do you know who I am?';
}
```

下面是实现多个接口的示例：
```
class Point implements Comparable, Location {
  // ...
}
```

#### 继承

使用 <font color=red face="宋体" size=4>extends 关键字</font>定义子类，<font color=red face="宋体" size=4>supper 关键字</font> 引用父类。

```
class Television {
  void turnOn() {
    _illuminateDisplay();
    _activateIrSensor();
  }
}

class SmartTelevision extends Television {
  void turnOn() {
    super.turnOn();
    _bootNetworkInterface();
    _initializeMemory();
    _upgradeApps();
  }
}
```

子类可以<font color=red face="宋体" size=4>重写</font>父类的实例函数、getter函数和setter函数。 

使用 <font color=red face="宋体" size=4>@override</font> 注解来表明子类的函数是想重写父类的函数。

使用 <font color=red face="宋体" size=4>@proxy</font> 注解来避免警告信息。

下面是重写 Object 类的 noSuchMethod() 函数的例子，如果调用了对象上不存在的函数，则就会触发 noSuchMethod() 函数。

```
@proxy 
class A {
  @override
  void noSuchMethod(Invocation mirror) {
  }
}
```

#### mixins

<font color=red face="宋体" size=4>mixins</font> 是面向对象程序设计语言中的类，提供了方法的实现。其他类可以访问 <font color=red face="宋体" size=4>mixins</font> 类的方法、变量而不必成为其子类。

Dart 中 <font color=red face="宋体" size=4>mixins</font> 是一种在多类继承中重用 一个类代码的方法。

使用 <font color=red face="宋体" size=4>with 关键字</font>后面为一个或者多个 mixin 名字来使用 mixin。

```
class Musician extends Performer with Musical {
  // ...
}

class Maestro extends Person
    with Musical, Aggressive, Demented {
  Maestro(String maestroName) {
    name = maestroName;
    canConduct = true;
  }
}
```