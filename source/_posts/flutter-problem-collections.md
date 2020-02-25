---
title: Flutter 问题集景
---
<font color=black face="黑体" size=6><center>Flutter 问题集景</center></font>

##### 1、解决升级 Flutter 第三方库版本的问题 (2019-12-10)
在项目目录下的 pubspec.yaml 增加对 'flutter_luban: ^0.1.9' 库的引用时报错提示其依赖的 image 库需要升级到最低 2.1.9 版本。
![](./package-get-dependencies-problem-01.png '')
在项目目录下的 pubspec.yaml  中 增加 'image: ^2.1.10' 又报如下错误：
![](./package-get-dependencies-problem-02.png '')
这是因为项目引用了 flutter_test，而flutter_test 中引用了 image 2.1.4 版本，所以需要修改 flutter_test 项目，但是 flutter_test 在哪里？
看到提示 “flutter_test from sdk” ,应该猜到跟flutter sdk 目录相关。
如果忘记 Flutter SDK 安装路径，敲命令'flutter doctor'
![](./package-get-dependencies-problem-04.png '')

在 Flutter SDK 中找到 flutter_test 项目，修改它的 pubspec.yaml 文件。
![](./package-get-dependencies-problem-03.png '')
![](./package-get-dependencies-problem-05.png '')

##### 2、image_picker v0.6.2 版本报错问题解决 (2019-12-25)
![](./flutter-image-picker-error-01.png '')
原本按照 Flutter 官方文档集成后，在demo中使用 image_picker 插件可以正常调起原生的照片应用，今天移植到正经项目中却报如上图错误。百思不解为什么 demo 中是好的，移植到项目中却出现问题。
赶紧去 image_picker 官方找有没有相同或则相似的 issue，果然找到了相似的问题 [#22476](https://github.com/flutter/flutter/issues/22476)并且已经 close 了，心中大喜！
虽然该 issue 已经在 0.4.1 版本解决了，但是还是顺着大佬给出的解决方案去解决，结果可想而知，我的问题依然存在。
随着进一步查看 image_picker 源码，出现问题的原因如下图所示：
![](./flutter-image-picker-error-02.png '')
随着问题原因的找到，顺藤摸瓜查找问题的根本原因，其实根本原因注册plugin的顺序导致。
![](./flutter-image-picker-error-03.png '')
因为在 demo 中，engine 和 plugin 都是放在 finishLaunching 最后，这样的情况下，APP 所有的参数和 widow、rootController 都已经初始化完成，image_picker 源码中使用到的 rootController 实例也就存在了。
至于为什么项目中集成时将 engine 和 plugin 移到了 finishLaunching 开始部分，原因是因为初始化 rootController 的时候调用了 FlutterController，而 FlutterController 初始化用到了 engine ，这样没多想就参照官方文档，一起将其移到了 finishLaunching 开始部分。
<font color=red face="黑体" size=3>综合以上问题原因，所以我们在实际开发集成 Flutter 时，对于 engine 和 plugin 的注册时机需要综合考虑自己 APP 执行逻辑。</font>

##### 3、"Waiting for another flutter command to release the startup lock ..." 问题解决 (2019-12-29)

执行 Flutter 某些操作时偶尔会出现如下错误：
![](./Waiting-for-another-flutter-command-to-release-the-startup-lock-01.png '')
![](./Waiting-for-another-flutter-command-to-release-the-startup-lock-02.png '') 
通常网上给出的方案如下：
```
1、删除 flutter SDK 下的 /bin/cache/lockfile 文件
2、重启 Android Studio
```
然而我操作的时候然而并没有什么卵用，可通过以下解决方法解决：
```
macOS 系统下终端内输入以下命令：
killall -9 dart
```

