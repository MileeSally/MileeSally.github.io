---
title: dart 导包介绍
---
<font color=black face="黑体" size=6><center>dart 导包介绍</center></font>
<font color=red size=2><center>花生-sniper</center></font>


##### 1.导入 dart 库里面的包
```
import 'dart:html';
```
##### 2.导入 pubspec.yaml 的 dependencies 依赖的包
```
import 'package:test/test.dart';
```
##### 3.导入路径包 base 为 flutter 根目录
```
import 'package:base/components/swiper.dart';
```
##### 4.部分导包

```
import 'package:lib1/lib1.dart' show foo, bar; //只导入 lib1 中的 foo 和 bar 这两个函数。
import 'package:lib2/lib2.dart' hide foo; //导入 lib2 中除了 foo 之外的所有函数。
```
##### 5.别名导包（包里面存在标识符冲突）
```
import 'package:lib1/lib1.dart';
import 'package:lib2/lib2.dart' as lib2;
```
##### 6.延迟加载（也称为延迟加载）允许应用程序在需要时加载库。
```
import 'package:greetings/hello.dart' deferred as hello;
```
##### 7.条件导包

```
// ignore: uri_does_not_exist
import 'client_stub.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'browser_client.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'io_client.dart';
```
##### 8. export 包导出
可以用于将多个小库导出成一个大库。
如果使用 show 参数，则代表只导出show所表明的函数；
如果使用 hide 参数，则代表导出除了hide 所表明的函数外的所有函数。
```
export 'french.dart' show hello; //只导出 hello。
export 'french.dart' hide goodbye; //导出除goodbye之外的所有函数。
```
##### 9. library 和 part 
使用 library 加上一个标示符定义当前库的名字:
```
library box2d;
```
库允许把代码写在多个文件中，只写在一个文件不利于维护。一般库都是写在多个文件中。
如果库的代码写在多个文件中，库的主文件就只用来包含其他文件，仅仅充当一个文件管理者，不包含任何方法。通过 part 语句指定子文件的路径，子文件通过 part of 语句表明属于哪个库。import 也只能写在主库文件中。
注意：所有的 import 和 part 都只能写在主库文件中。子库文件使用 part of 关键字，表明属于哪个库。
```
import /**...*/					// 所有的导包只能写在主库文件中

/**meth.dart库文件*/
library math;		

// 所有的 part 碎片要在主库中声明，并指定路径
part 'base.dart';			// base.dart文件名
part 'random.dart';			// random.dart文件名
```
```
/**base.dart 子文件*/
part of math;

...
```
```
/**random.dart 子文件*/
part of math;

...
```
库文件仅用于管理 import 和 part 子文件，子文件通过 part of 指定属于哪个主库文件，并包含具体的实现方法。
