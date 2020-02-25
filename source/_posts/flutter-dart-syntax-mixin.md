---
title: Dart 之 implements, extends, mixin 详解
---

<div style="color:red;font-size:20px;text-align:center">Dart 之 implements, extends, mixin 详解</div>

本文大纲：
![](./flutter-dart-syntax-mixin.jpg '')


### Dart 与 Java
Java:
组成单元：普通类、abstract抽象类，interface接口。
关系连接：implements实现，extends继承。

Dart:
组成单元：普通类，abstract抽象类、mixin。
关系连接：implements实现、extends继承、with混入。

#### 组成单元
##### 普通类
Java和Dart的普通类基本相同，稍有区别，例如 mixin。

##### 抽象类
1.Java和Dart的抽象类定义时大体是一样的，我们可以在其中定义变量、普通方法、抽象方法，它和普通类最大的区别就是抽象类不能实例化。
2.Java和Dart在使用抽象类时有一点不同：Dart在定义抽象方法时，不需要用 abstract修饰。

##### Interface
1.Dart中没有 interface 类。
2.Java中 abstract 和 interface 的一些要点：
* 抽象类和接口都不能被实例化。
* 抽象类要被子类继承，接口要被类实现。
* 接口只能做方法的声明，抽象类可以做方法的声明，也可以做方法的实现。
* 接口里定义的变量只能是公共的静态常量，抽象类中的变量可以是普通变量。
* 抽象类里的抽象方法必须全部被子类实现；接口的接口方法必须全部被子类实现，否则只能为抽象类。
* 抽象类里可以没有抽象方法。
* 如果一个类里有抽象方法，那么这个类只能是抽象类。
* 抽象方法要被实现，所以不能是静态的，也不能是私有的。
* 接口可继承接口，并可多继承接口，但类只能单继承。

#### 关系连接
##### extends
Java和Dart中extends是一致的，只可以单继承，要注意的点是：
* 子类可以继承父类里面 可见的属性和方法。
  * 对于Java来说，可见指的是非private修饰，
  * 对Dart来说，指的是非下划线_开头。
* 子类调用父类的方法，使用super关键字。
* 子类不会 继承 父类的构造函数。

##### implements
Java和Dart中 implements 也是一致的。
implements 后面的类无论它原来是抽象方法还是普通方法，都必须重新实现。


#### Mixin
mixin是Dart中特有的概念。

首先看下下面的类图：
![](./animal-class-diagram.png '')
上面类关系图中有一个Animal超类，它的三个子类Mammal、Bird、Fish，底部还有一些具体的实现子类。
最底部是动物的一些行为特点，这些行为特点有些是共有的，有些是特有的。例如：
紫色的Hypothalamus代表哺乳类动物和鸟类动物共有的行为特点：它们都是恒温动物。
橙色的Streamline代表鸟类动物和鱼类动物共有的行为特点：它们的身体都是流线型的。
红色的Walk代表不同种类的具体的动物自己特有的行走行为特点。
蓝色的Flying代表各种不同种类的具体的动物自己特有的飞翔行为特点。
绿色的Swim代表各种不同种类的具体的动物自己特有的游泳行为特点。

下面是Dart对上面的类进行的定义：
```
abstract class Animal {
  String name();
  String classification();
  void energy() {
    print('需要消耗能量');
  }
}

abstract class Mammal extends Animal {
  @override
  String classification() {
    // TODO: implement classification
    return '哺乳类';
  }
}

abstract class Bird extends Animal {
  @override
  String classification() {
    // TODO: implement classification
    return '鸟类';
  }
}

abstract class Fish extends Animal {
  @override
  String classification() {
    // TODO: implement classification
    return '鱼类';
  }
}

//行走行为
abstract class Walk{
  void walk();
}

//游泳行为
abstract class Swim{
  void swim();
}

//飞翔行为
abstract class FLying {
  void flying();
}

class Hypothalamus {
  void hypothalamus(){
    //哺乳动物和鸟类都是恒温的
    print('是恒温的');
    }
}

class Streamline {
  void streamline(){
    //鸟类和鱼类都具有流线型的
    print('具有流线型的');
    }
}
```

##### Dart中实现类似Java 8以上的 default method 的同样的效果

下面看一下 Dolphin 类定义：
```
class Dolphin extends Mammal implements Swim, Hypothalamus{
  @override
  String name() {
    return '海豚';
  }

  @override
  void swim() {
    // TODO: implement swim
    print('海豚有自己的特有的游泳方式');
    super.energy();
  }

  @override
  void hypothalamus(){
    // TODO: implement hypothalamus
    print('是恒温的');
  }
}
```

可以看到 Bat 类和 Dolphin 类中对hypothalamus()方法重复实现的问题。这里我们可以通过Dart版本中的Mixin类自带方法实现，从而解决了这个问题。

Mixin类自带方法实现如下。（注意：with 需要在 implements 之前）
```
class Dolphin extends Mammal with Hypothalamus implements Swim{
  @override
  String name() {
    return '海豚';
  }

  @override
  void swim() {
    // TODO: implement swim
    print('海豚有自己的特有的游泳方式');
    super.energy();
  }
}
```

##### 使 Mixin 类无法实例化

如此定义的Hypothalamus类是可以被单独实例化的，这跟我们原意将其设计为Interface的初衷相违背。
```
class Hypothalamus {
  void hypothalamus(){
    //哺乳动物和鸟类都是恒温的
    print('是恒温的');
    }
}
```

可以通过定义为抽象类 abstract 关键字来实现，如下定义：
```
abstract class Hypothalamus {
  void hypothalamus(){
    //哺乳动物和鸟类都是恒温的
    print('是恒温的');
    }
}
```

如果抽象类不想被然扩充，可以给该类定一个private constructor(_代表私有)，并返回 null。定义如下：
```
abstract class Hypothalamus {
  //这样一来Hypothalamus既不能扩充也不能实例化了
  factory Hypothalamus._() => null;

  void hypothalamus(){
    //哺乳动物和鸟类都是恒温的
    print('是恒温的');
    }
}
```

还可以通过 Dart 显式定义 mixin 关键字来实现，如下定义：
```
mixin Hypothalamus {
  void hypothalamus(){
    //哺乳动物和鸟类都是恒温的
    print('是恒温的');
    }
}
```

##### mixin on 语法

假定如果只有哺乳类动物才有恒温特性的化，这是我们可以通过 mixin on 语法进行限定。
```
mixin Hypothalamus on Mammal{
  void hypothalamus(){
    //哺乳动物和鸟类都是恒温的
    print('是恒温的');
    }
}

class Dolphin extends Mammal with Hypothalamus implements Swim{
  @override
  String name() {
    return '海豚';
  }

  @override
  void swim() {
    // TODO: implement swim
    print('海豚有自己的特有的游泳方式');
    super.energy();
  }
}

class Dove extends Bird with Hypothalamus implements FLying, Walk{
  @override
  String name() {
    return '鸽子';
  }

  @override
  void flying() {
    // TODO: implement flying
    print('鸽子会飞翔');
    super.energy();
  }

  @override
  void walk() {
    // TODO: implement walk
    print('鸽子会行走');
  }
}
```

运行之后报错如下：
```
mixin-test-demo.dart:111:7: Error: 'Bird' doesn't implement 'Mammal' so it can't be used with 'Hypothalamus'.
 - 'Bird' is from 'mixin-test-demo.dart'.
 - 'Mammal' is from 'mixin-test-demo.dart'.
 - 'Hypothalamus' is from 'mixin-test-demo.dart'.
class Dove extends Bird with Hypothalamus implements FLying, Walk{
      ^
```

这是因为 Dove 类继承至 Bird 类，但是我们已经限定了 Hypothalamus 类只能用于继承至 Mammal 类的子类。

##### mixin on 语法复杂用法
```
mixin Hypothalamus on Mammal{
  void hypothalamus(){
    //哺乳动物和鸟类都是恒温的
    print('是恒温的');
    }

  void animal() {
    super.animal();
    print('恒温动物');
  }
}

mixin Streamline on Hypothalamus{
  void streamline(){
    //鸟类和鱼类都具有流线型的
    print('具有流线型的');
    }

    void animal() {
      super.animal();
      print('流线型动物');
    }
}
```
如下申明则通过编译：
```
class Dolphin extends Mammal with Hypothalamus, Streamline implements Swim{
  @override
  String name() {
    return '海豚';
  }

  @override
  void swim() {
    // TODO: implement swim
    print('海豚有自己的特有的游泳方式');
    super.energy();
  }
}
```

交换一下 Hypothalamus、Streamline 顺序，则无法通过编译。
```
class Dolphin extends Mammal with Streamline, Hypothalamus implements Swim{
  @override
  String name() {
    return '海豚';
  }

  @override
  void swim() {
    // TODO: implement swim
    print('海豚有自己的特有的游泳方式');
    super.energy();
  }
}
```
错误信息如下：
```
mixin-test-demo.dart:78:7: Error: 'Mammal' doesn't implement 'Hypothalamus' so it can't be used with 'Streamline'.
 - 'Mammal' is from 'mixin-test-demo.dart'.
 - 'Hypothalamus' is from 'mixin-test-demo.dart'.
 - 'Streamline' is from 'mixin-test-demo.dart'.
class Dolphin extends Mammal with Streamline, Hypothalamus implements Swim{
      ^
```
```
结论：要满足on的要求，除了使用extends之外，还可以在with列表中，在它之前进行声明。
```

##### mixin 线性化

将如下类惊醒改造一番，分别为Hypothalamus类和Streamline类增加一个相同的方法 animal()。
```
class Hypothalamus {
  void hypothalamus(){
    //哺乳动物和鸟类都是恒温的
    print('是恒温的');
    }

  void animal() {
    print('恒温动物');
  }
}

class Streamline {
  void streamline(){
    //鸟类和鱼类都具有流线型的
    print('具有流线型的');
    }

    void animal() {
      print('流线型动物');
    }
}
```

如下调用 animal() 则会打印 “恒温动物”！
```
class Dolphin extends Mammal with Streamline, Hypothalamus implements Swim{
  @override
  String name() {
    return '海豚';
  }

  @override
  void swim() {
    // TODO: implement swim
    print('海豚有自己的特有的游泳方式');
    super.energy();
  }
}
```

如下调用 animal() 则会打印 “流线型动物”！
```
class Dolphin extends Mammal with Hypothalamus, Streamline implements Swim{
  @override
  String name() {
    return '海豚';
  }

  @override
  void swim() {
    // TODO: implement swim
    print('海豚有自己的特有的游泳方式');
    super.energy();
  }
}
```

下面我们将如下调用进行拆解分析：
```
class Dolphin extends Mammal with Streamline, Hypothalamus implements Swim{
  @override
  String name() {
    return '海豚';
  }

  @override
  void swim() {
    // TODO: implement swim
    print('海豚有自己的特有的游泳方式');
    super.energy();
  }
}
```
拆解如下：
```
class A extends Mammal with Streamline {
  @override
  String name() {
    return 'A';
  }
}

class B extends A with Hypothalamus {

}

class Dolphin extends B implements Swim{
  @override
  String name() {
    return '海豚';
  }

  @override
  void swim() {
    // TODO: implement swim
    print('海豚有自己的特有的游泳方式');
    super.energy();
  }
}
```

将代码继续改造如下：
```
abstract class Mammal extends Animal {
  @override
  String classification() {
    // TODO: implement classification
    return '哺乳类';
  }

  void animal () {
    print('哺乳动物');
  }
}

mixin Hypothalamus on Mammal{
  void hypothalamus(){
    //哺乳动物和鸟类都是恒温的
    print('是恒温的');
    }

  void animal() {
    super.animal();
    print('恒温动物');
  }
}

mixin Streamline {
  void streamline(){
    //鸟类和鱼类都具有流线型的
    print('具有流线型的');
    }

    void animal() {
      print('流线型动物');
    }
}
```

分析如下调用的结果：
```
class Dolphin extends Mammal with Streamline, Hypothalamus implements Swim{
  @override
  String name() {
    return '海豚';
  }

  @override
  void swim() {
    // TODO: implement swim
    print('海豚有自己的特有的游泳方式');
    super.energy();
  }
}

void main() {
  Dolphin dolphin = Dolphin();
  dolphin.animal();
}
```

按照上面的拆解，dolphin.animal() 首先调用的是其父类 B 类的 animal() 方法，但是 B 类 没有重写该方法，那么就会继续按照 mixin 线性化特点，调用Hypothalamus类的 animal() 方法，然而 Hypothalamus类的 animal() 方法里面调用了super类的方法。这里的 super 相当于 B 的父类，那么按照上面的拆解过程，B 类的父类就是 A 类，但是 A 类也没有重写该方法，那么就继续按照 mixin 线性化特点，调用Streamline类的 animal() 方法。

打印结果如下：
```
流线型动物
恒温动物
```

下面调试堆栈也证明了我们的观点：
![](./dolphin-class-call-stack-01.png '')

##### 带有 with 时的方法冲突
1.如果同时存在extends, with，并且它们都定义了相同的方法名。
* with修饰的会覆盖extends中修饰的同名方法。
* with列表中后一个的会覆盖之前的。

2.再增加implements，并且它们都定义了相同的方法名。
* 这是因为在这种情况下，识别到我们从with和extends中获得了同名方法的能力，所以此时Dart没让我们实现Implement里的同名方法！
