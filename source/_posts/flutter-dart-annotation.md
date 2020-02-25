---
title: dart 注解实现以及代码生成原理
---
<font color=black face="黑体" size=6><center>dart 注解实现以及代码生成原理</center></font>
<font color=red size=2><center>花生-sniper</center></font>

### 注解处理以及代码生成
* 1.创建注解
* 2.创建生成器
* 3.创建构建器
* 4.编写 build.yaml 配置文件
* 5.生成代码

##### 创建注解
dart 中自定义注解很简单，其实现就是一个带有 const 构造函数的类。
```
// 申明一个没有参数的注解
class ARouteRoot {
  const ARouteRoot();
}

// 申明一个有参数的注解
class ARoute {
  final String desc;
  final String url;
  final Map<String, dynamic> params;
  final List<ARouteAlias> alias;
  const ARoute({this.desc, this.url, this.params, this.alias});
}
```

##### 创建生成器
创建一个 Generator，继承于 GeneratorForAnnotation, 并实现：generateForAnnotatedElement 方法。
```
class RouteWriterGenerator extends GeneratorForAnnotation<ARouteRoot> {
  Collector collector() {
    return RouteGenerator.collector;
  }

  @override
  dynamic generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return Writer(collector()).write();
  }
}

class RouteGenerator extends GeneratorForAnnotation<ARoute> {
  static Collector collector = Collector();

  @override
  dynamic generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    collector.collect(element, annotation, buildStep);
    return null;
  }
}
```

##### 创建构建器
```
Builder routeBuilder(BuilderOptions options) => LibraryBuilder(RouteGenerator(),
    generatedExtension: '.internal_invalid.dart');

Builder routeWriteBuilder(BuilderOptions options) =>
    LibraryBuilder(RouteWriterGenerator(),
        generatedExtension: '.internal.dart');
```

##### 编写 build.yaml 配置文件
在项目根目录创建 build.yaml 文件，其意义在于配置构建器的各项参数。
```
# Read about `build.yaml` at https://pub.dartlang.org/packages/build_config
targets:
  $default:
    builders:
      annotation_route|route_builder:
        enabled: true
        generate_for:
          exclude: ['**.internal.dart']
      annotation_route|route_write_builder:
        enabled: true
        options: { 'write': true }
        generate_for:
          exclude: ['**.internal.dart']

builders:
  route_write_builder:
    import: 'package:annotation_route/builder.dart'
    builder_factories: ['routeWriteBuilder']
    build_extensions: { '.route.dart': ['.internal.dart'] }
    auto_apply: root_package
    build_to: source

  route_builder:
    import: 'package:annotation_route/builder.dart'
    builder_factories: ['routeBuilder']
    build_extensions: { '.dart': ['.internal_invalid.dart'] }
    auto_apply: root_package
    runs_before: ['annotation_route|route_write_builder']
    build_to: source
```

##### 生成代码
命令行中执行如下命令生成代码。
```
flutter packages pub run build_runner build --delete-conflicting-outputs
```
删除已生成的代码：
```
flutter packages pub run build_runner clean
```

### source_gen 源码解析
source_gen 是封装自 build 和 analyzer，并在此基础上提供封装。source_gen 将其整合便可以实现一套基于注解的代码生成工具。
source_gen 通过拦截注解获取并解析上下文信息就可以动态的生成代码。
以下就是 source_gen 的类图：
![](./source-gen-class.png '')

##### GeneratorForAnnotation 与 annotation 的对应关系
GeneratorForAnnotation 是单注解处理器，有且只有一个 annotation 作为其泛型参数，也就是说每一个继承自 GeneratorForAnnotation 的生成器只能处理一种注解。

##### 协议接口 generateForAnnotatedElement 参数含义和返回值含义
* Element element：被 annotation 所修饰的元素，通过它可以获取到元素的name、可见性等等。
* ConstantReader annotation：表示注解对象，通过它可以获取到注解相关信息以及参数值。
* BuildStep buildStep：这一次构建的信息，通过它可以获取到一些输入输出信息，例如输入文件名等
* 返回值是一个 String 类型的字符串，即生成的代码，return null 意味着不需要生成文件。

###### Element
下面代码使用了 @ARoute 这个注解
```
class ARoute {
  final String desc;
  final String url;
  final Map<String, dynamic> params;
  final List<ARouteAlias> alias;
  const ARoute({this.desc, this.url, this.params, this.alias});
}
```
```
@ARoute(url: 'myapp://pagea')
class A {
  int a;
  String b;
  A(ARouteOption option) : super();
}
```
通过 Element 参数获取 annotation 的一些信息：
```
element.toString: class A
element.name: A
element.metadata: [@ARoute(url: 'myapp://pagea')] 
element.kind: CLASS
element.displayName: A
element.documentationComment: null
element.enclosingElement: flutter_annotation|lib/demo_class.dart
element.hasAlwaysThrows: false
element.hasDeprecated: false
element.hasFactory: false
element.hasIsTest: false
element.hasLiteral: false
element.hasOverride: false
element.hasProtected: false
element.hasRequired: false
element.isPrivate: false
element.isPublic: true
element.isSynthetic: false
element.nameLength: 1
element.runtimeType: ClassElementImpl
...
```
由于 GeneratorForAnnotation 的域仅限于 class, 通过 element 只能拿到 A 的类信息，那类内部的 Field 和 method 信息如何获取呢？
注意 "element.kind: CLASS"，kind 标识 Element 的类型，可以是 CLASS、FIELD、FUNCTION 等等。
对应这些类型，还有相应的 Element 子类：ClassElement、FieldElement、FunctionElement等等，可以这样：
```
if(element.kind == ElementKind.CLASS){
  for (var e in ((element as ClassElement).fields)) {
    print("$e \n");
  }
  for (var e in ((element as ClassElement).methods)) {
	print("$e \n");
  }
}

输出：
int a 
String b 
A(ARouteOption option) → void
```
###### ConstantReader
注解携带的参数，可以通过 annotation 获取：
```
annotation.runtimeType: _DartObjectConstant
annotation.read("url"): 'myapp://pagea'
annotation.peek("url"): 'myapp://pagea'
annotation.objectValue: ARoute (url = String ('myapp://pagea'))
```
annotation 的类型是 ConstantReader，read 方法与 peek方法，不同之处在于，如果read方法读取了不存在的参数名，会抛出异常，peek 则不会，而是返回null。

###### BuildStep
buildStep 提供的是该次构建的输入输出信息:
```
buildStep.runtimeType: BuildStepImpl
buildStep.inputId.path: lib/demo_class.dart
buildStep.inputId.extension: .dart
buildStep.inputId.package: flutter_annotation
buildStep.inputId.uri: package:flutter_annotation/demo_class.dart
buildStep.inputId.pathSegments: [lib, demo_class.dart]
buildStep.expectedOutputs.path: lib/demo_class.g.dart
buildStep.expectedOutputs.extension: .dart
buildStep.expectedOutputs.package: flutter_annotation
```

##### build.yaml 配置文件字段含义
```
# Read about `build.yaml` at https://pub.dartlang.org/packages/build_config
targets:
  $default:
    builders:
      annotation_route|route_builder:
        enabled: true
        generate_for:
          exclude: ['**.internal.dart']
      annotation_route|route_write_builder:
        enabled: true
        options: { 'write': true }
        generate_for:
          exclude: ['**.internal.dart']

builders:
  route_write_builder:
    import: 'package:annotation_route/builder.dart'
    builder_factories: ['routeWriteBuilder']
    build_extensions: { '.route.dart': ['.internal.dart'] }
    auto_apply: root_package
    build_to: source

  route_builder:
    import: 'package:annotation_route/builder.dart'
    builder_factories: ['routeBuilder']
    build_extensions: { '.dart': ['.internal_invalid.dart'] }
    auto_apply: root_package
    runs_before: ['annotation_route|route_write_builder']
    build_to: source
```
* import 关键字用于导入 return Builder 的方法所在包 （必须）
* builder_factories 填写的是我们 return Builder 的方法名（必须）
* build_extensions  指定输入扩展名到输出扩展名的映射，比如接受 *.dart文件的输入，最终输出 *.g.dart 文件（必须）
* auto_apply 指定builder作用于，可选值（可选，默认为 none）
  * "none"：除非手动配置，否则不要应用此Builder
  * "dependents"：将此Builder应用于包，直接依赖于公开构建器的包。
  * "all_packages"：将此Builder应用于传递依赖关系图中的所有包。
  * "root_package"：仅将此Builder应用于顶级包。
* build_to 指定输出位置,可选值（可选，默认为 cache）
  * "source": 输出到其主要输入的源码树上
  * "cache": 输出到隐藏的构建缓存上
* required_inputs 指定一个或一系列文件扩展名，表示在任何可能产生该类型输出的Builder之后运行（可选）
* runs_before 保证在指定的 Builder 之前运行







