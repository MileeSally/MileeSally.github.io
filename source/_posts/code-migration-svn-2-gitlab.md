---
title: 代码仓库迁移
---

<font color=black face="黑体" size=10><center>代码仓库迁移</center></font>
<font color=black face="黑体" size=5><center>-----svn迁移到gitlab-----</center></font>

### 1、背景
随着Git服务的优越性，越来越多的公司将代码仓库迁移至Git服务器。这篇文章将介绍如何将代码从svn服务器迁移至Git服务器并且保留原svn仓库的commit的历史记录。
### 2、操作
#### 2.1 获取svn仓库提交者信息
将项目代码check out到本地

    svn co --username "账号" --password "密码" "项目代码svn服务器地址" "本地文件夹"

![](./7EE9C120-77D2-4292-871F-58E2E1D82D01.png '生成ssh-key')

cd 到"本地文件夹"获取代码提交者信息

    svn log --xml | grep author | sort -u | perl -pe 's/.*>(.*?)<.*/$1 = /' > commitor.txt

![](./1CC4FE89-CE95-4B02-860E-F509384CD3DF.png '生成ssh-key')
![](./21D1F26C-2957-4E76-BDAB-992436565419.png '生成ssh-key')


#### 2.2 配置commitor列表格式

打开提交者信息文件"commitor.txt"

![](./6837744B-1E5A-4C07-A375-8EF610A67C6A.png '生成ssh-key')

修改commitor.txt列表格式

![](./5DE83A65-4F9D-43AE-ACE6-6C3E891E2F03.png '生成ssh-key')

#### 2.3 将svn仓库转变成Git仓库

    git svn clone "项目代码svn服务器地址" --authors-file="commitor.txt文件路径" "本地路径"

![](./1605AD66-1E1D-4BA6-A9C3-73D8BC2A41A9.png '生成ssh-key')
![](./DB1B0557-062C-417E-BEC6-533D98E3F95C.png '生成ssh-key')

#### 2.4 创建Gitlab远程仓库
![](./8ABD7A52-B085-44FB-95FA-17EAA7C6489F.png '生成ssh-key')

#### 2.5 将代码推送到Gitlab远程仓库
![](./14359E6B-3814-48B4-8DFC-6BC9BAC495CA.png '生成ssh-key')
![](./65010F70-BE7F-4C4C-8ED4-1CB8E03A6FA0.png '生成ssh-key')
![](./CC2283F7-CC05-42E0-8D5B-EC5E545D0B66.png '生成ssh-key')

### 3、参考
[Git 与其他系统 - 迁移到 Git](https://git-scm.com/book/zh/v1/Git-与其他系统-迁移到-Git)
