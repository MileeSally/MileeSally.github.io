---
title: 移动跨平台技术选型
---
<font color=black face="黑体" size=10><center>移动跨平台技术选型</center></font>

### 移动跨平台历史
![](./mobile-cross-platform-history.png '移动跨平台历史')

### 移动跨平台技术类型
![](./mobile-cross-platform-type.png '移动跨平台技术类型')
```
1、Web技术：主要依赖于WebView的技术，功能支持受限，性能体验很差，代表有PhoneGap、Cordova、小程序。
2、原生渲染：使用JavaScript作为编程语言，通过中间层转化为原生控件来渲染UI界面，代表有ReactNative、Weex。
3、自渲染技术：自行实现一套渲染框架，可通过调用skia等方式完成自渲染，而不依赖于原生控件，代表有Flutter。
```

### 移动跨平台目标
我们跨平台开发的目标：

```
1、产品快速落地。
2、提升开发效率、缩短开发周期。
3、增加代码复用，减少平台特异性差别。
4、获得与原生相似的体验。 
```

### 原理与特性
#### 一、Hybird
Hybrid 方案的本质还是基于原生的 App 中使用 WebView 作为容器直接承载 Web 页面。最核心的就是 Native 端 与 H5端之间的双向通信层，即完成 Native 与 JavaScript 的通讯。这个方案就是我们所说的 JSBridge，而实现的关键便是作为容器的 WebView，一切的原理都是基于 WebView 的机制。

技术架构如图所示：
![](./hybrid-1.jpg 'hybird-1')
![](./hybrid-2.jpg 'hybird-2')

#### 二、ReactNative
ReactNative 方案本质上是通过中间层转化，使用原生控件来渲染页面。最核心的是提供了一套基于C++的动态链接库作为中间桥接层，实现 JS 与 Native 双向通信。

技术架构如图所示：
![](./react-native-2.png 'react-native-2')
![](./react-native-1.png 'react-native-1')

#### 三、Flutter
Flutter 方案采用的自引擎渲染技术，不依赖与原生控件。Flutter 主要分为 Framework  和 Engine，我们基于Framework 开发 App，运行在 Engine 上。Engine 是 Flutter 的独立虚拟机，由它适配和提供跨平台支持，得益于 Engine 层，Flutter 甚至不使用移动平台的原生控件，而是使用自己 Engine 来渲染，而 Dart 可以通过 AOT 编译为平台的原生代码，所以 Flutter 可以 直接与平台通信，不需要JS 引擎的桥接。

技术架构如图所示：
![](./flutter-1.jpg 'flutter-1')

### 对比分析
类型 | Flutter | ReactNative
- | - |  -
语言 | Dart | JavaScript
环境 |  Flutter Engine | JSCore
性能 |  高 | 一般
发布时间  | 2018 | 2015
star | 81k+ | 83k+
社区 | Google维护、活跃 | FaceBook维护、活跃
最新版本 | 1.12.15 | 0.61.5
框架体积 | Android 5.2M / IOS 10.1M | Android 20M / IOS 1.6M
框架程度 | 重 | 重
学习成本 | 前端同学Dart部分难、平台部分难，客户端同学Dart部分易、平台部分易 | 前端同学JSX部分易、平台部分难，客户端同学JSX部分难、平台部分易
跨平台 | Android、iOS、Web、PC、iot | Android、iOS
使用代表 | 闲鱼、美团B端、QQ、迅雷、饿了么 | 京东、携程、腾讯课堂、阿里巴巴

#### 一、环境搭建
##### 相同点：
无论是 React Native 还是 Flutter ，都需要 Android 和 IOS 的开发环境，都需要 JDK 、Android SDK、Xcode 等环境配置。
##### 不同点：
React Native 需要 npm 、node 、react-native-cli 等配置 。
Flutter 需要 flutter sdk 和 Android Studio / VSCode 上的 Dart 与 Flutter 插件。
##### 结论：
Flutter 的环境搭配相对简单，而 React Native 的环境配置相对复杂。

#### 二、编程语言
##### 相同点：
Dart 语言诞生于 2011 年，2018 年发布了 2.0，原本就是为了 Web 领域，Dart 和 JS 在一定程度上有很大的通识性。
##### 不同点：
作为动态语言的代表 JS 开发便捷度明显会高于 Dart ，而非动态语言的 Dart 在类型安全和重构代码等方面又会比 JS 更稳健。
##### 学习成本：
由于 Dart 和 JS 在一定程度上有大的通识性，所以相对于前端开发的同学来说比较容易上手。
由于 Dart 具有强类型概念，所以相对客户端开发的同学来说也比较容易上手，因为客户端开发的同学一直都在跟强类型语言打交道。
##### 结论：
Flutter 的开发语言 Dart 学习难度相对前端开发的同学和客户端开发的同学都比较容易上手。

#### 二、界面开发
React Native 在界面开发上支持 scss/sass 、样式代码分离，函数式编程等让整个代码结构更为简洁。
![](./react-native-3.png 'react-native-3')

Flutter 是一套平台无关的 UI 框架，在界面开发中一般是通过继承无状态 StatelessWidget 控件或者有状态 StatefulWidget 控件来实现页面，然后在对应的 Widget build(BuildContext context) 方法内实现布局，利用不同 Widget 的 child / children 去做嵌套，对布局里的每个控件设置样式等也使得这个代码看上去也比较整洁。
![](./flutter-2.png 'flutter-2')
##### 结论：
React Native 和 Flutter 都有着非常好的界面开发风格和简洁代码结构。

#### 三、原生控件
React Native 原本就是利用原生控件进行渲染，所以 React Native 整个渲染过程都在原生层中完成，所以接入原有平台控件非常方便。

Flutter 的整体渲染脱离了原生层面，直接和 GPU 交互，导致了原生的控件无法直接插入其中，但是 Flutter 提供 plugin 方式调用原生平台控件。

##### 结论：
相比较 React Native 原生控件渲染，Flutter 明显趋于弱势，但是 Flutter 的 plugin 模式稍微弥补了这方便的不足。

换个角度看 React Native 正式因为基于原生控件渲染，所以具有平台相关性，无法做到真正的风格统一。而 Flutter 则是平台无关，则能够做到风格统一。

#### 四、性能
##### 框架设计：
从下面 React Native 和 Flutter 框架设计可以看到 Flutter 在少了 Bridge 和 OEM Widget ，直接与 CPU / GPU 交互的特性，决定了它先天性能的优势。

React Native 框架设计如下：
![](./react-native-4.png 'react-native-4')

Flutter 框架设计如下：
![](./flutter-3.png 'flutter-3')

##### 多线程支持：
React Native 由于 JS 的单线程特性注定了 React Native 本身只具备单线程操作能力，React Native 是通过桥接方式利用 Native 端的多线程能力来处理多线程任务。

isolate 是 Dart 平台对线程的实现方案，所以 Flutter 框架本身就支持多线程，而无需依赖 Native 端提供多线程能力。

##### 结论：
React Native 虽然在自身支持多线程方面存在劣势，但是通过框架桥接很好的利用了 Native 端的多线程能力，同样很好的支持开发者调用多线程处理事务。
Flutter 由于本身框架就支持多线程，在线程性能、渲染性能、事务处理方面存在优势。


### 最终结论
通过比较分析 React Native 和 Flutter 量大最受欢迎的移动端跨平台方案，Flutter 都略胜于 React Native，但是两者都非常受欢迎，大厂商基本上对这两者技术的技术栈都运用了。

首先，由于移动端跨平台技术栈既有夸平台技术栈，也有平台特异性技术栈，所有目前要想推进移动端跨平台技术栈在我们公司发展优先落在客户端开发的小伙伴肩上。

此次，在前面分析也提到，在语言学习成本方面，Dart 语言虽然比较陌生，但是由于 Dart 语言兼有动态性和非动态性语言的特性，所以无论对于前端小伙伴还是客户端小伙伴来说在学习成本上都是最优的。

最后，从未来发展来看，Flutter UI 平台的无关能力，让 Flutter 在跨平台的拓展上更为迅速，Flutter 不仅对 Android、iOS、Web 支持，甚至拓展到 PC 和嵌入式设备当中。












