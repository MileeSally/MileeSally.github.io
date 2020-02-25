---
title: MAC系统安装和更新ruby环境解决方案
---

<font color=black face="黑体" size=6><center>MAC系统安装和更新ruby环境解决方案</center></font>
<font color=red size=2><center>花生-sniper</center></font>

#### 背景
本来这本是不值得一提的事情，本地ruby环境早已经安装，MAC系统本身也自带了ruby环境。最近由于cocoapods 1.8.0版本支持了CDN，但是我又想继续使用我的cocoapods 1.4.0版本，虽然可以在同一个ruby环境下安装两个版本的 cocoapods，并且在使用上可以这样：
![](./muti-cocoapods-version-usage.png '')
但是我偏要在不同的ruby环境下安装各自的cocoapods，于是 rvm 就发挥作用了， rvm 可以管理多个 ruby 环境。

#### 1. 安装 rvm
![](./install-rvm-01.png '')
![](./install-rvm-02.png '')
![](./install-rvm-03.png '')

#### 2. 安装 ruby
![](./install-ruby-01.png '')
![](./install-ruby-02.png '')
![](./install-ruby-03.png '')

#### 3. 安装报错
![](./ruby-update-error.png '')

解决方案：
```
1、首先执行如下命令升级 rvm
'rvm get master'
2、再次安装
'rvm install 2.4.1'
```

#### 3. 切换 ruby 环境
![](./install-ruby-04.png '')



