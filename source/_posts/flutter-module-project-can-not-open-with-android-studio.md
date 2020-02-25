---
title: Flutter module 项目无法打开的一种情况以及解决办法
---
<font color=black face="黑体" size=6><center>Flutter module 项目无法打开的一种情况以及解决办法</center></font>

配置 Git 的 .gitignore 文件时将 *.iml 文件忽略后，导致本地使用 Flutter module 方式创建的项目提交文件时未将项目内的 *.iml 提交到 Git 服务器上。
![](./1.png '')


Flutter module 项目内没有如下两个文件 “项目名称_android.iml，项目名称.iml”时。
![](./2.png '')

此时无法通过 android studio 正常打开 Flutter module 项目，如图所示：
![](./3.png '')

如果能找到之前创建该 Flutter module 项目的两个文件“项目名称_android.iml，项目名称.iml”，可以直接将其拷贝到项目目录下。
如果找不到之前的那两个文件，则可以重新通过 flutter 命令生成一个新的 Flutter module 工程
```
flutter create -t module my_flutter_module
```
然后将 “my_flutter_module_android.iml, my_flutter_module.iml” 文件重新命名成 “项目名称_android.iml，项目名称.iml”。
再通过 android studio 就可以正常打开项目
![](./4.png '')