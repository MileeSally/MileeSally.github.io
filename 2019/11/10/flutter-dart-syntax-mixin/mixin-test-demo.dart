
//Dart代码
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

  void animal () {
    print('哺乳动物');
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

  // @override
  // void hypothalamus(){
  //   // TODO: implement hypothalamus
  //   print('是恒温的');
  // }
}

class Bat extends Mammal implements Walk, FLying, Streamline{
  @override
  String name() {
    // TODO: implement name
    return '蝙蝠';
  }

  @override
  void walk() {
    // TODO: implement walk
    print('蝙蝠会行走');
    super.energy();
  }
  @override
  void flying() {
    // TODO: implement flying
    print('蝙蝠会飞翔');
    super.energy();
  }

  @override
  void hypothalamus(){
    // TODO: implement hypothalamus
    print('是恒温的');
  }

  @override
  void streamline() {
    // TODO: implement streamline
  }
}

class Dove extends Bird implements FLying, Walk{
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

class Duck extends Bird implements Walk{
  @override
  String name() {
    return '鸭子';
  }

  @override
  void walk() {
    // TODO: implement walk
    print('鸭子会行走');
    super.energy();
  }
}

class Shark extends Fish implements Swim{
  @override
  String name() {
    return '鲨鱼';
  }

@override
  void swim() {
    // TODO: implement swim
    print('鲨鱼会游泳');
    super.energy();
  }
}

class FlyingFish extends Fish implements FLying, Swim{
  @override
  String name() {
    return '飞鱼';
  }

  @override
  void flying() {
    // TODO: implement flying
    print('飞鱼会飞翔');
    super.energy();
  }

  @override
  void swim() {
    // TODO: implement swim
    print('飞鱼有自己的特有的游泳方式');
    super.energy();
  }

  @override
  void streamline() {
    // TODO: implement streamline
    print('具有流线型的');
  }
}

void main() {
  Dolphin dolphin = Dolphin();
  // String name = dolphin.name();
  // String classification = dolphin.classification();
  // print('${name}');
  // print('${classification}');
  // dolphin.hypothalamus();
  // dolphin.swim();
  dolphin.animal();

  // FlyingFish flyfish = FlyingFish();
  // print('${flyfish.name()}');
  // print('${flyfish.classification()}');
  // flyfish.streamline();
  // flyfish.swim();
}


//BindingBase
abstract class BindingBase {
  void initInstances() {
    print("BindingBase——initInstances");
  }
}
//GestureBinding
mixin GestureBinding on BindingBase{
@override
void initInstances() {
  print("GestureBinding——initInstances");
  super.initInstances();
}
}
//RendererBinding
mixin RendererBinding on BindingBase{
@override
void initInstances() {
  print("RendererBinding——initInstances");
  super.initInstances();
}
}
// WidgetsBinding
mixin WidgetsBinding on BindingBase
{

@override
void initInstances() {
  print("WidgetsBinding——initInstances");
  super.initInstances();
}
}
//WidgetsFlutterBinding
class WidgetsFlutterBinding extends BindingBase
    with GestureBinding, RendererBinding, WidgetsBinding {
  static WidgetsBinding ensureInitialized() {
    return WidgetsFlutterBinding();
  }
}
//main
// main(List<String> arguments) {
//   var binding = WidgetsFlutterBinding();
//   binding.initInstances();
// }







