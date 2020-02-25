---
title: gradle 介绍
---
<font color=black face="黑体" size=6><center>gradle 介绍</center></font>
<font color=red size=2><center>花生-sniper</center></font>

### 背景
Flutter 编译源码 flutter_tools 中关于 android 端编译产物的生成时用到了 gradle 相关命令，相对于小白稍微介绍下 gradle 目录下的文件以及这些文件在编译时的作用。

### Gradle 介绍
![](./gradle.png '')
Gradle 是个构建系统，能够简化安装、编译、打包、测试过程。
当把一个项目放入到远程版本库的时候，如果这个项目是以 Gradle 构建的，那么其他人从远程仓库拉取代码之后如果本地没有安装过 Gradle 会无法编译运行，如果对 Gradle 不熟悉，会使得无法很好的去快速构建项目代码。Gradle 可以使得即使没有安装 Gradle 也可以自动去安装并且编译项目代码，并且可以自动生成一键运行的脚本，把这些一起上传远程仓库。

### Gradle Wrapper
Gradle Wrapper 的作用是简化 Gradle 本身的安装、部署。不同版本的项目可能需要不同版本的 Gradle，手工部署的话比较麻烦，而且可能产生冲突，所以需要 Gradle Wrapper 可以帮我们搞定这些事情。Gradle Wrapper 是 Gradle 项目的一部分。
在新建的目录下使用命令行输入 "gradle wrapper" 命令时会生成对应的 Gradle Wrapper 文件。在 Flutter 构建中会自动调用该命令生成。

### Gradle Wrapper 文件说明
```
|____gradle
| |____wrapper
| | |____gradle-wrapper.jar  //具体业务逻辑
| | |____gradle-wrapper.properties  //配置文件
|____gradlew  //Linux 下可执行脚本
|____gradlew.bat  //Windows 下可执行脚本
```

* gradlew.bat
gradlew.bat 是 Windows 下可执行脚本，Windows 用户可以通过它执行 Gradle 任务。
* gradlew
gradlew 是 shell 脚本，Unix、Linux 用户可以通过它来执行 Gradle 任务。
* gradle-wrapper.jar
gradle-wrapper.jar 是 Gradle Wrapper 的主体功能包（wrapper 的代码所在）。项目打包必须要有的，不然无法去执行 gradlew。
* gradle-wrapper.properties
gradle-wrapper.properties 文件主要指定了该项目需要什么版本的 Gradle，从哪里下载该版本的 Gradle，下载下来放到哪里。
![](./gradle-wrapper-properties.png '')
使用 gradlew 命令的时候，会根据这个文件来使用对应的 gradle 进行构建。当本地 GRADLE_USER_HOME（当前用户目录，一般指~/.gradle）中的~/.gradle/wrapper/dists 没有安装 gradle 时，将会自动从此地址 distributionUrl 中下载 gradle，之后的执行将不会再次下载安装。如下图：
![](./gradle-wrapper.png '')

### Gradle 文件如何配合使用
当从版本库下载代码之后，如果你本机安装过 gradle，当然直接直接编译运行既可。但是对没有安装 gradle 的用户，可以执行项目根目录下的 gradlew.bat 脚本（Linux是执行gradlew命令），将会在 gradle-wrapper.properties 中的 ~/.gradle/wrapper/dists 目录中首次下载并安装 gradle 并可以编译代码，一个指令可以下载并安装 gradle 来构建项目，由此可见非常方便。大概流程如下：
* 1、解析gradle-wrapper.properties 文件，获取项目需要的 gradle 版本下载地址。
* 2、判断本地用户目录下的 ~/.gradle 目录下是否存在该版本，不存在该版本，走第3点，存在走第4点。
* 3、下载 gradle-wrapper.properties 指定版本，并解压到用户目录的下 ~/.gradle 文件下。
* 4、利用 ~/.gradle 目录下对应的版本的 gradle 进行相应自动编译操作。






