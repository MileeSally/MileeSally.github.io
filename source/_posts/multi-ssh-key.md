---
title: ssh配置多个账号
---

<font color=black face="粗黑体" size=10><center>ssh配置多个账号</center></font>

## 1 背景
随着Git的火热，相信每个Coder都会有好几个Git服务器用来管理不同的资料、博客、代码等。如果在一台电脑上通过ssh key在一个Git服务器上提交代码很容易管理，但是如果有上面提到的情况需要在同一台电脑上分别向不同的Git服务器提交代码时我们就需要配置多个ssh key。
## 2 操作
### 2.1 清空默认全局的username和email
查看已配置的git列表

    git config --list

清空默认的用户名和邮箱

    git config --global --unset user.name
    git config --global --unset user.email
    
### 2.2 给不同的Git账号分别生成ssh-key（例如：公司账号、个人账号）
    ssh-keygen -t rsa -b 4096 -C "Git账号"
![](./80E13A4D-D912-4237-A95D-6161455B6885.png '生成ssh-key')
![](./77AB29E7-0E46-4AC4-82E7-DF052C405804.png '生成ssh-key')
### 2.3 将ssh-key添加到ssh-agent信任列表
    ssh-add ~/.ssh/163.github

通过如下命令检查是否添加成功

    ssh -T git@Git服务器
![](./27CF05D6-3139-4DFE-9028-7852D1FCA8C9.png '生成ssh-key')
如果在添加过程中遇到如下错误:

    Could not open a connection to your authentication agent.

那么请先输入

    ssh-agent bash

 然后重复以下操作:

    ssh-add ~/.ssh/163.github
 
直到出现如下信息：

    Identitiy added: ~/.ssh/163.github

如下图:
![](./6CE5B81C-6CF0-47EB-BCBB-0DFA39B37309.png '生成ssh-key')

### 2.4 将ssh-key公钥配置到Git服务器
找到ssh-key公钥
![](./77AB29E7-0E46-4AC4-82E7-DF052C405804.png '生成ssh-key')
打开并复制
![](./73FED1B8-5F77-481E-A31C-532B8B90E631.png '生成ssh-key')
配置到Git服务器（gitlab.tf56.lo）
![](./2B364C18-2C64-4826-8AD1-BD769AEE4660.png '生成ssh-key')

### 2.5 在config文件中配置多个ssh-key
5.1、打开.ssh文件夹，看看有没有config文件，没有就新建一个取名为config
![](./48B4A72B-0F42-48EA-846C-DB120CF27571.png '生成ssh-key')

配置多个ssh-key

<!--
表格剧中写法
:-: | :-: | :-:
-->
[//]:# (表格剧中写法 :-: | :-: | :-:)
键值 | 规则
- | - 
Host | 主机随意写，有点关联就行了
Hostname |  主机名，Git服务器地址
IdentityFile  | 身份文件，你的rsa具体路径地址
User | 用户   可随意写，建议使用Host的前面部分，后面具体clone操作都会用到这个user
如下图：

![](./29BB4551-710F-4B43-BDF1-80A27BB490A4.png '生成ssh-key')

### 2.6 测试连接
如果单个账户情况一般就是

    ssh -T git@xxx

如果配置了config文件

    ssh -T git@{config里面的user}.xxx主机名
![](./0DF52DCD-4E4D-4643-AD18-5FDFDD1C2E11.png '生成ssh-key')

### 3 使用

使用有两种情况，一种情况是从远端拉取代码到本地，一种是本地已有仓库需要与远程仓库关联。

#### 3.1 如果是从远端拉取代码

选择SSH协议的复制命令，如对于GitLab上代码库test，其复制命令为
```
git clone git@gitlab.com:luohs/test.git
```
由于使用了别名gitlab，所以实际使用的复制命令应当为：
```
git clone git@gitlab:luohs/test.git
```
这种方法较为简单，修改后的代码无需额外配置，可以直接 push

#### 3.2 如果是本地已有的仓库

这种情况适用于本地新建的仓库需要与远端进行关联，或者之前已经使用sourceTree 等图形界面软件拷贝的仓库。进入本地仓库文件夹，需要单独配置该仓库的用户名和邮箱
```
git config user.name "luohs"
git config user.email "luohuasheng0225@163.com"
```
然后，进入本地仓库的git目录，打开config文件
```
cd .git // 该目录是隐藏的，ls命令不可见，但是可以直接进入，如果是新建的文件夹需要先执行 git init
vim config
```
在config文件中，修改（config文件中已有remote “origin”信息）或者添加（config文件中不包含remote “origin”信息）分支信息：
```
[remote "origin"]
        url = git@gitlab:luohs/test.git
        fetch = +refs/heads/*:refs/remotes/origin/*
```
主要是URL部分，原生的信息一般是`git@gitlab.com:luohs/test.git`，需要将 gitlab.com 使用别名 gitlab 代替。

可以看到，仓库中的关键是要配置好用户名和邮箱，以及使用别名。使用别名的目的是为了通过别名，将本地仓库与密钥目录.ssh文件夹下的密钥进行管理，这样就完成了本地仓库使用的私钥与托管网站使用的公钥的配对，而用户名和邮箱是该仓库使用SSH协议时需要用到的信息。

### 补充 
=====================（2019-12-06）======================  

使用过程中需要注意的是通过 ssh 配置的多账号只适用于 git，而不是适用于 http。
当仓库远程地址为 http 则会报错，如下图所示：
![](./git-https-error.png '')

解决办法就是将仓库地址 http 改为 git，如下图所示更改：
![](./git-config.png '')
![](./git-config-http.png '')

======================（2020-01-01）======================

补充一下 Coding 仓库使用：
在关联 coding 上托管的代码时，遇到了一点麻烦，主要是因为别名的修改不正确，以及20端口禁用的问题导致的，所以单独记录下，.ssh 目录下的 config 文件中的密钥信息应该为：
```
Host coding
HostName git-ssh.coding.net //这个域名使用coding官网获取的，不能写 coding.net
User luohs
IdentityFile ~/.ssh/id_rsa_coding
Port 443 // 20端口可能被禁用，需要使用443端口
```

## 4 参考
https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
