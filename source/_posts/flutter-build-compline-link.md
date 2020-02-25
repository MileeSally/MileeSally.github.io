---
title: Flutter 编译原理
---
<font color=black face="黑体" size=6><center>Flutter 编译原理</center></font>
<font color=red size=2><center>花生-sniper</center></font>

### 学习 Flutter 编译原理的目的

* 区分 Flutter 针对不同平台编译后的产物。
* 理解 Flutter Hot Reload 机制。
* 理解 Flutter 跨平台原理。
* Flutter 底层优化提供支持。
* Flutter 二进制文件集成提供支持。
* Flutter 工程化提供支持。


### Flutter 支持的平台简介

![](./flutter-platforms-support.png '')

#### 1、桌面程序

Flutter 目前桌面程序支持平台涵盖 Linux、Windows、macOS。但是根据官方介绍 Flutter 桌面程序支持最好的平台是 macOS。

* Windows 平台，目前阶段 Flutter 还只是支持32位，未来可能计划基于 Windows10 推出的 UWP 的 API 进行开发 Flutter 桌面程序。

* Linux 平台，目前阶段 Flutter 仅支持 基于 GTK+ 版本，未来可能计划推出基于各种版本的 Linux，例如：GLFW、GTK+、Qt、wxWidgets、Motif 等。

* macOS 平台，目前 Flutter 支持最好的平台，得益于 macOS 与 iOS 系统非常接近，并且 Flutter v1.12 已更好的支持 macOS 桌面程序。

[](https://github.com/flutter/flutter/wiki/Desktop-shells#flutter-application-requirements)

#### 2、Web

Flutter v1.5.4 之后才支持 Web，在 v1.12 之前 Flutter 需要额外安装 flutter_web 工具来支持 Flutter 将 Dart 编译成 js。v1.12 之后 Flutter 对 Web 的支持全部迁移至 Flutter SDK，也就是说以后可以直接基于标准的 Flutter SDK 将 Dart 编译成 Web 程序。

[](https://github.com/flutter/flutter_web)

[](https://flutter.dev/docs/get-started/web)

#### 3、Android 和 iOS 

Flutter 默认支持 Android 和 iOS 平台，所以不需要通过预先设置 flutter config 启用平台参数。

[](https://github.com/flutter/flutter/wiki)

### 编译模式

#### JIT（Just In Time）即时编译运行时编译

指在程序运行中，将热点代码编译成机器码，提高运行效率。常见例子有 V8 引擎和 JVM，JIT 可以充分利用解释型语言的优点，动态执行源码，而不用考虑平台差异性。（这里需要注意的是，对于 JVM 来说，源码指字节码，而不是 Java 源码）

```
这里需要将 JIT 与 解释型语言加以区别，并不是说编译型语言就不能使用 JIT 模式编译，典型的例子如 Java 是编译型语言，但是它可以支持 JIT 编译模式。
```

#### AOT（Ahead Of Time）运行前编译

指在程序运行之前，已经编译成对应平台的机器码，不需要在运行中解释编译，就可以直接运行。常见例子有 C 和 C++。

### Dart 编译模式

类型 | 编译模式 | 平台相关 | 包大小 | 动态性
- | - | - | - | - 
Script | JIT | NO | Small | YES
Kernel Snapshots | JIT | NO | Smallest | YES
JIT Application Snapshots | JIT | YES | Lager | YES
AOT Application Snapshots | AOT | YES | Lagest | NO

* Script： 最常见的 JIT 模式，可以直接在 DartVM 中运行 Dart 源码。
    
    ```
    $ dart hello.dart
    Hello, world!
    ```

* Kernel Snapshot：JIT 模式，不同于 Script 模式，这种模式执行的是一种叫做 Kernel AST 抽象语法树的二进制数据，这里不包含解析后的类、函数和编译后的代码以便这种模式可以在不同的平台之间移植。但是这也就意味着 DartVM 每次运行都必须重新编译函数并且将 AST 转换成平台内部可识别的指令，这就导致执行效率大大降低。

    ```
    $ dart --snapshot-kind=kernel --snapshot=hello.dart.snapshot hello.dart
    $ dart hello.dart.snapshot arguments-for-use
    Hello, world!
    ```

* JIT Application Snapshot (app-jit)：JIT 模式，Dart v1.21 引入该编译模式。这种模式执行的是已经解析过的类和函数。在这种模式下 DartVM 不需要编译和解析类和函数，所以它会运行起来会更快。但是这不是平台无关，它只能针对 x64 架构运行。

    ```
    $ dart --snapshot=hello.dart.snapshot --snapshot-kind=app-jit hello.dart arguments-for-training
    Hello, world!
    $ dart hello.dart.snapshot arguments-for-use
    Hello, world!
    ```

* AOT Application Snapshot (app-aot)：AOT 模式，Dart v2.4 引入该编译模式。在这种模式下，Dart 源码会被提前编译成特定平台的二进制文件。这种模式需要使用 dart2aot 命令编译，使用 dartaotruntime 命令执行。

    ```
    $ dart2aot hello.dart hello.dart.snapshot
    $ dartaotruntime hello.dart.snapshot
    Hello, world! 
    ```

Dart JIT 模式需要配合 DartVM(虚拟机) ，AOT 则会使用 runtime 来执行，如下图所示：
![](./dart-run-with-jit-and-aot.png '')

[](https://github.com/dart-lang/sdk/wiki/Snapshots)

### Flutter 编译模式
Flutter 的构建完全基于 Dart，所以 Flutter 完全继承于 Dart 编译模式，但是由于 Flutter 需要运行在 Android 和 iOS 等不同平台之上，因此 Flutter 也有自己特有的编译模式。

* Script： 与 Dart 的 Script 编译模式一样，Flutter 支持但使用。

* Script Snapshot：与 Dart 的 Kernel Snapshots 编译模式一样，Flutter 支持但未使用。Flutter 有大量的视图渲染逻辑，纯 JIT 模式影响执行速度。

* Kernel Snapshot： Dart 的 bytecode 模式，与 Application Snapshot 不同，bytecode 模式是不区分架构的，bytecode 模式可以归类为 AOT 编译。

* Core JIT：Dart 的一种二进制模式，将指令代码和 heap 数据打包成文件，然后在 VM 和 isolate 启动时载入，直接标记内存可执行，可以说这是一种 AOT 模式。

* AOT Assembly: 即 Dart 的 AOT 模式。直接生成汇编源代码文件，由各平台自行汇编。

### Flutter 构建模式

![](./flutter-build-to-products-mode-aar.png '')

* Debug 模式：对应了 Dart 的 JIT 模式，又称检查模式或者慢速模式。支持设备，模拟器(iOS/Android)，此模式下打开了断言，包括所有的调试信息，服务扩展和 Observatory 等调试辅助。此模式为快速开发和运行做了优化，但并未对执行速度，包大小和部署做优化。Debug模式下，编译使用JIT技术，支持 hot reload。
  
* Release 模式：对应了 Dart的 AOT 模式，此模式目标即为部署到终端用户。只支持真机，不包括模拟器。关闭了所有断言，尽可能多地去掉了调试信息，关闭了所有调试工具。为快速启动，快速执行，包大小做了优化。禁止了所有调试辅助手段，服务扩展。
  
* Profile 模式：类似 Release 模式，只是多了对于 Profile 模式的服务扩展的支持，支持跟踪，以及最小化使用跟踪信息需要的依赖，例如，observatory 可以连接上进程。Profile 并不支持模拟器的原因在于，模拟器上的诊断并不代表真实的性能。

* Flavor 模式：基于 Android Gradle scripts 和 Xcode schemes 配置构建不同的编译产物。可用于构建渠道包、非硬编码构建生产、开发环境的包、SaaS 等。

### Flutter 开发模式（Debug）下的编译模式

在 Debug 构建模式下为了能够支持热更新（hot reload），同时又要获得视图渲染时的高性能。因此在这种模式下 Flutter 选择 Kernel Snapshot 模式编译。

项目/平台 | Android | iOS
- | - | - 
构建模式 | Debug | Debug
编译模式 | Kernel Snapshot | Kernel Snapshot
打包工具 | DartVM | DartVM
打包产物 | flutter_assets/* | App.framework 

打包产物：
* isolate_snapshot_data：用于加速 isolate 启动。业务代码无关。
* platform.dill：Dart runtime 相关的核心代码，仅与 Flutter Engine 有关。
* vm_snapshot_data: 用于加速 Dart VM 启动，业务代码无关。
* kernel_blob.bin：业务代码产物。


### Flutter 生产模式（Release）下的编译模式

在 Release 构建模式下，APP 需要更快速的运行，因此 Flutter 选择 AOT 模式编译。不过由于平台特性不同，打包模式也会有不同，具体差异如下：

项目/平台 | Android | iOS
- | - | - 
构建模式 | Release | Release
编译模式 | Core JIT | AOT Assembly
打包工具 | gen_snapshot | gen_snapshot
打包产物 | flutter_assets/* | App.framework

打包产物：
* isolate_snapshot_data：用于加速 isolate 启动。业务代码无关。
* vm_snapshot_data: 用于加速 Dart VM 启动，业务代码无关。
* isolate_snapshot_instr：isolate 启动后所承载的指令等数据，载入后可直接在内存中执行。
* vm_snapshot_instr：DartVM 启动后所承载的指令等数据，载入后可直接在内存中执行。

在 iOS 上，由于 App Store 审核条例不允许动态下发可执行二进制代码，因此除了 JavaScript，其他语言运行时的实现都选择了 AOT（比如 OpenJDK 在 iOS 实现就是 AOT）。

在 Android 上，Flutter 支持了两种不同的编译模式。
AOT Assembly 打包方式需要支持多平台架构，这无疑增大了代码包，并且该处代码需要从 JNI API 调用，远不如 Core JIT 的基于 Java API 调用方便。所以 Android 上默认使用 Core JIT 打包，而不是 AOT Assembly。

### Flutter engine 对编译模式的支持

Flutter engine 承载了对 Dart runtime 的支持，所以编译出来的 Flutter 程序必须与 Flutter engine 支持的模式相匹配。

项目/平台 | Android | iOS
- | - | - | - | - 
Script | Not Support | Not Support 
Script Snapshot | Support | Support 
Kernel Snapshot | Support | Support 
Core JIT | Support | Not Support 
AOT Assembly | Support | Support 


### Flutter 构建产物
![](./flutter-build-to-products.png '')



### 参考

[Flutter’s Compilation Patterns](https://proandroiddev.com/flutters-compilation-patterns-24e139d14177)
[Just-in-Time (JIT) and Ahead-of-Time (AOT) Compilation in Angular](https://levelup.gitconnected.com/just-in-time-jit-and-ahead-of-time-aot-compilation-in-angular-8529f1d6fa9d)
[Dart Snapshots](https://github.com/dart-lang/sdk/wiki/Snapshots)
[Build flavors in Flutter](https://medium.com/@animeshjain/build-flavors-in-flutter-android-and-ios-with-different-firebase-projects-per-flavor-27c5c5dac10b)
[Flavoring Flutter](https://medium.com/@salvatoregiordanoo/flavoring-flutter-392aaa875f36)
[flutter tools](https://github.com/flutter/flutter/wiki/The-flutter-tool)