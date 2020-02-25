---
title: 已有原生项目集成 flutter 源码混合开发指南
---

<font color=black face="黑体" size=10><center>已有原生项目集成 flutter 混合开发指南</center></font>

[Flutter.io]: https://flutter.io/sdk-archive/#macos "Flutter.io"
[Flutter.github]: https://github.com/flutter/flutter/releases "Flutter.github"

### 1、Flutter 环境配置
#### 1.1 Flutter 安装
一、直接下载安装包
[Flutter 官网][Flutter.io]
[Flutter Github][Flutter.github]
解压安装包到你想安装的目录，如： 
![](./dowload_sdk.png '')

二、直接通过 git 命令下载安装包
![](./dowload_sdk_git.png '')

#### 1.2 Flutter 环境设置
一、环境变量设置
![](./setup_path2.png '')

二、设置镜像（可选）
![](./setup_path.png '')

<font color=red>注意</center></font>: 此镜像为临时镜像，并不能保证一直可用，读者可以参考详情请参考 [Using Flutter in China](https://github.com/flutter/flutter/wiki/Using-Flutter-in-China) 以获得有关镜像服务器的最新动态。

#### 1.3 Flutter 环境检测
```
flutter doctor
```
第一次运行 flutter doctor 时会下载一些依赖项并自行编译，以后再运行就会快得多。
![](./flutter_setup_1.png '')
![](./flutter_setup_2.png '')
![](./flutter_setup_3.png '')

### 2、创建 Flutter module 项目
一、Flutter 版本
![](./flutter_version.png '')

二、将 Flutter 切换到 master
![](./flutter_channel.png '')

三、创建 Flutter module 项目
```
flutter create -t module “项目名称”
```
![](./flutter_module_project.png '')

四、将 Flutter module 项目使用git管理起来
使用默认自动生成的 “.gitignore” 文件即可，“.android” 和 “.ios” 目录在每次执行 <font color=red>flutter packages get</font> 命令或则直接编译运行项目会自动生成（团队其他成员拉取代码后没有 “.android” 和 “.ios” 执行一下 <font color=red>flutter packages get</font> 即可）
![](./flutter_module_gitignore.png '')

### 3、iOS 项目集成 Flutter（CocoaPods）
一、通过在原生项目中添加 git submodule 方式引用 flutter module 项目源码。
```
git submodule add {Flutter module repo}
git submodule update
```
二、修改 iOS 项目的 Podfile 文件配置
```
# 添加如下两行代码，路径修改为我们的 fluter module 的路径。
flutter_application_path = "../../flutter_module"
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')
```
```
eval(File.read(File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')), binding)
```
![](./flutter_podfile.png '')

三、项目的配置完成现在需要生成一些配置文件
a. 进入原生项目的flutter模块目录中执行 <font color=red>flutter packages get</font> 命令。
b. 回到 iOS 原生项目根目录执行 <font color=red>pod install</font> 命令。

### 4、Android 项目集成 Flutter（gradle）
一、通过在原生项目中添加 git submodule 方式引用 flutter module 项目源码。
```
git submodule add “Flutter module repo”
git submodule update
```
二、修改 Android 项目 settings.gradle 文件配置
```
setBinding(new Binding([gradle: this]))
evaluate(new File(
  '{Flutter module repo}/.android/include_flutter.groovy'
))
```
三、添加 build.gradle 文件的 Flutter 库的依赖
```
dependencies {
  implementation project(':flutter')
}
```
### 5、协同开发
a. 拉取项目源码 git clone {原生项目地址}。
b. 初始化项目中的子模块 git submodule init && git submodule update。
c. 执行 flutter packages get (有时候可能出现无法运行可以进入 .ios 和 .android 中分别执行 pod install 和 gradle assembleDebug，或者 flutter build ios，flutter build apk 等命令构建一次)。
d. 运行原生项目。

======================= 补充 =================================
### 6、Flutter 版本管理
在开发过程中遇到了一个问题，就是各个开发者使用的 Flutter sdk 版本不一致，导致一些库无法运行，于是我根据自己的需要写了一个 [flutter_wrapper](https://github.com/zakiso/flutterw.git) 的小工具。它的主要作用是统一开发人员的本地 Flutter 环境。
#### 使用说明
1、在你的项目根目录中执行命令下载脚本
```
curl -O https://raw.githubusercontent.com/zakiso/flutterw/master/flutterw && chmod 755 flutterw
```
2、下载好脚本后在根目录中使用
```
./flutterw init
```
该命令会收集你当前系统中的 flutter 版本，并将相关信息写入flutter_wrapper.properties 文件中，团队中所有成员都会以该版本号做为该项目的标准版本。
3、将flutterw文件和flutter_wrapper.properties文件添加到git中提交到仓库里。
4、其他成员拉取代码后在项目中使用 flutter 命令的地方使用 <font color=red>./flutterw</font> 代替，如果使用 IDEA 请选择 home 目录下对应版本的 sdk 包。

[参考]:https://juejin.im/post/5c6eba82518825626b76f0eb

