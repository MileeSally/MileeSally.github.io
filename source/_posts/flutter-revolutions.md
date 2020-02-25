---
title: Flutter 的革命性
---
<font color=black face="黑体" size=10><center>Flutter 的革命性</center></font>

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

### 框架对比

#### Native
![](./architecture-native.png 'architecture-native')

Native 方案是通过直接调用系统本身提供的 UI 组件和 Local Service。但是这些系统组件是由不同的语言实现的，所以不得不为每个平台开发单独的 APP。这也是为什么移动跨平台为什么受欢迎的根本原因了。

#### Hybird
![](./architecture-hybird.png 'architecture-hybird')

Hybird 方案是通过创建 HTML 并将其显示在平台的 WebView 上，但是像 JavaScript 这样的语言很难直接与本地代码（Local Service）进行通信，因此需要一个 JavaScript 代码和 Native 代码进行上下文切换的“桥梁（Bridge）”，所以这会导致很大的性能问题，WebView 体验也很差。

#### ReactNative
![](./architecture-react-native.png 'architecture-react-native')

React Native 方案则是改进了 Hybird 方案， 通过 JavaScript 访问原生 UI 组件 和 Local Service，因此也必须经过 JavaScript 代码和 Native 代码进行上下文切换的“桥梁（Bridge）”，因此导致很大的性能问题。

#### Flutter
![](./architecture-flutter.png 'architecture-react-native')

Flutter 方案采用的自引擎渲染技术而不依赖与原生控件，因此避免了由 JavaScript 桥接器引起的性能问题，界面也更加流畅。
目前 Flutter 也是唯一提供响应式视图而不需要 JavaScript 桥接器的移动 SDK，这就足以让 Flutter 变得有趣而值得一试。


### Flutter 的革命性

#### 组件（Widget）
Widget 是影响和控制应用程序的视图和界面的元素，说这些组件是移动应用中最重要的部分之一，事实上 UI 表现如何足可以成就或毁掉一款 APP。这也是为什么 Hybird 方案 UI 体验差，React Native 采用原生 UI 的原因。

Widget 需要有以下特性
```
1、Widget 的外观和给人的感觉是至关重要的。
2、Widget 必须快速执行，创建或扩展 UI 控件、渲染和动画。
3、Widget 应该是可扩展和可定制的，开发人员自定义所有 Widget 来适应各种效果。
```

<font color=red face="黑体">Flutter 包含大量赏心悦目、快速、可定制、可扩展的 Widget。这些 Widget 不需要使用系统 UI 组件（或 DOM WebViews），因为 Flutter 自带 Widget。</font>

让我们看一下 Flutter 自带的 Widget 渲染的效果吧：

![](./1.gif '移动跨平台')

#### 布局（Layout）
传统布局使用大量可以应用于任何 UI 组件的规则。这些规则实现多种布局方法。以 CSS 为例：CSS 包含大量的布局模型，如多种箱模型、浮动元素、表、多列文本、分页媒介等，还有像 flexbox 和 grid 的布局模型。

传统布局的另一个问题是规则可以相互影响甚至发生冲突，通常有几十种规则元素的规则应用于他们，这使得布局变慢，布局性能通常为指数性下降，因此，随着元件数量的增加，布局变得更慢。

Android 中的 XML 和 iOS 中的 Storyboard、Xib 等也同样存在这些问题。

传统布局最大的缺点就是提供了可以应用于任何 UI 组件的一整套布局规则，这样大大影响渲染性能。

<font color=red face="黑体">Flutter 最大的改进之一就是它的布局也是 UI 组件：</font>

```
1、每个 UI 组件都将指定自己简单的布局模型。
2、因为每个 UI 组件都有一个更小的一套布局需要考虑，所以布局可以大量优化。
3、为了进一步简化布局，几乎将所有内容都转换为 UI 组件。
```

#### 私人定制（Custom design）
Flutter 中可以添加新的 UI 组件，并且可以自定义现有的 UI 组件，以使其达到定制化目标。

<font color=red face="黑体">Flutter 拥有丰富的可定制的 Android、 iOS 和 Material Design 组件，我们可以使用 Flutter 的可定制特点来构建这些组件库，以匹配多个平台上的原生组件的外观和感觉。</font>


#### 响应式视图（Reactive Views）
##### 一、响应式 Web
![](./reactive-web.png 'reactive-web')

现有的响应式 web 视图库都引入了 virtual DOM，在响应式 Web 视图中，virtual DOM 是不可变的，每次更改，所有的东西都得重建。

重建过程如下：
```
1、系统将 virtual DOM 与 real DOM 进行比较，生成一组最小的更改。
2、然后执行这些更改，以更新真正的 DOM。
3、最后，平台重新绘制真实的DOM 到画布中。
```
这看起来增加了很多额外的工作，但它是值得的，因为操纵 HTML DOM 是非常耗费系统资源的。

##### 二、React Native
![](./reactive-react-native.png 'reactive-react-native')

React Native 也做类似的工作，但是是在移动应用程序当中进行的。它会操控移动平台上的原生组件而不是 DOM。它构建一个 UI 组件的虚拟树，与原生组件进行比较，并只更新已更改的部件。

但是 React Native 必须通过桥接器与原生部件进行通信，因此，UI 组件的虚拟树可以帮助保持传递桥的最小值，同时还允许使用原生部件。最后，一旦更新了本机部件，平台就会将它们渲染到画布上。

##### 三、Flutter
![](./reactive-flutter.png 'reactive-flutter')

React Native 是移动开发的一大进步，并且是 Flutter 的灵感来源，但 Flutter 更进一步。

在 Flutter 中，UI 组件和渲染器已经从平台中集成到用户的应用程序中。没有系统 UI 组件可以操作，所以原来虚拟控件树的地方现在是真实的控件树，既简单又快。此外，动画发生在用户空间中，因此应用程序（开发人员）可以对其进行更多的控制。

Flutter 渲染器它使用几个内部树结构来渲染只需要在屏幕上更新的 UI 组件。例如，渲染器使用“ 使用合成的结构重绘”(这意味着比使用屏幕上的矩形区域更有效）。不变的 UI 控件，即使是那些已经移动的 UI 控件，仅需在内存中做极其细微的改动，速度当然超级快。<font color=red face="黑体">这就是为什么Flutter 即使在很复杂的滚动场景中的滚动性能也是如此之高。</font>

#### 热重载（Hot reload）

#### 兼容性（Compatibility）
由于 Flutter 不使用原生 UI 组件，因此，当新的 iOS 或 Android 版本出现时，Flutter UI 组件是不需要更新才能支持新的部件的。

#### 未来优势（Future benefits）
从未来发展来看，Flutter UI 平台的无关能力，让 Flutter 在跨平台的拓展上更为迅速，Flutter 不仅对 Android、iOS、Web 支持，甚至拓展到 PC 和嵌入式设备当中。

#### 总结
Flutter 优势如下：
```
1、响应式视图的优点，不需要 JavaScript 的桥接器。
2、快速，流畅，可预测。
3、支持AOT 和 JIT 编译为本机（ARM）代码。
4、开发人员完全控制 UI 组件和布局。
5、配有美观，可定制的 UI 组件。
6、强大的开发者工具，惊人的热重新加载。
7、性能更好，兼容性更好，开发起来更有乐趣。
8、更广泛的跨平台支持。
```

<font color=red face="黑体" size=6>Flutter 是美观，高性能，移动跨平台体验的绝佳选择，让我们一起加入革命吧！</font>