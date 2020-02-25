---
title: gitlab创建私有库
---

<font color=black face="黑体" size=10><center>gitlab创建私有库</center></font>

### 流程简单介绍
* 1. 创建一个项目，留着后面的流程 3 制作私有库。
* 2. 在可以创建私有库的地方创建一个code repository(代码仓库)。
* 3. 在可以创建私有库的地方创建一个spec repository(配置仓库)。所有的配置按照包名、版本号分门别类的存放在这个仓库。(这个仓库只用来存放podspec文件不存放代码) 
* 4. 克隆code repository到本地并添加私有库代码文件，上传所有文件到远端的库中并打tag。
* 5. 创建并编辑三个私有库配置文件:创建和编辑README.md、创建和编辑LICENSE、创建和编辑podspec文件(验证podspec文件是否正确，如果有问题要确保更改完成，否则无法继续进行。 如果没有README和LICENSE文件，pod代码时候会提示警告)
* 6. 将配置文件push到远端专门存储配置文件的仓库中。
* 7. 确认已经制作完成并使用。

### 流程详细介绍

#### 1. 创建一个项目，留着后面的流程 3 制作私有库。

通过XCode手动生成或则通过pod命令自动生成。

#### 2. 在可以创建私有库的地方创建一个code repository(代码仓库), 一个spec repository(配置仓库)。

我们可以选择任何一款我们喜欢的git服务器，诸如：gitlab、github、开源中国、coding、阿里云等，但这里使用gitlab来介绍所有的操作。

###### 2.1 点击绿色按钮，创建代码仓库名为HSNetwork。

![](./4C90E4D9-BF63-4776-9724-744FB8B9D8D3.png '')
![](./D0BC48BE-1F70-49A5-842B-722BBB12637A.png '')

#### 3. 同上面方法，创建配置仓库名为ios-component-spec-repo。

略

#### 4. 克隆code repository到本地并添加步骤 1 中的私有库代码文件，上传所有文件到远端的库中并打tag。

###### 4.1 打开git管理工具SourceTree，点击新建按钮，选择从URL克隆选项，将上面的远程代码仓库地址复制进去，选择好自己的目标路径和名称后点击克隆。

这时候第一次克隆下来的文件夹是没有东西的(这里不算隐藏文件)。

![](./D0EB5E40-1838-48FC-AB6E-B3A392EE05EB.png '')

<font color=red face="黑体" size=3><le>注意！！！如果在配置ssh key时将原始的服务器地址配置了别名的情况下，这是SourceTree(v3.2.1)会报错，如下面几张图所示：</le></font>

![](./2B6682C0-97DA-4964-B1B5-EFD951D4F2F3.png '')
![](./35DE142B-0997-4ECE-9299-D38E9A098890.png '')
![](./7E724C34-5869-427E-8EAD-83B964D267B8.png '')

<font color=red face="黑体" size=3><le>这时候第一次克隆下来的文件夹是没有东西的(这里不算隐藏文件)。</le></font>

###### 4.2 参照gitlab官网尝试提交README文件。按照提示的三种情况看看自己提交的文件属于哪一种情况，本文按照提示的第一种情况进行提交文件。

![](./1F1ECC52-017E-4BA3-9DFA-F07A78751F56.png '')

提交成功之后(如上图所示)，可以通过SourceTree或则网页查看，如下两张图所示：
![](./64F84F2F-A762-4AEA-B7BA-A744283EE40D.png '')
![](./424004EB-7DFE-45F8-B43A-9B195C75D2E2.png '')

###### 4.3 进入SourceTree，拉取远程代码仓库，将我们之前步骤 1 中建立好的整个项目全部拖进这个文件夹并提交、推送到git服务器。

![](./0FFA1A2B-710A-4010-A440-4FA5A57AFD88.png '')

###### 4.4 在刚提交的代码打一个tag 1.0.6，作为一个库的修改版本。
<font color=red face="黑体" size=3><le>注意!!! 勾选上"推送标签"，这个非常重要。</le></font>

![](./F1609722-D086-49AC-AC0F-822A76CF8F06.png '')
![](./FA9B30AB-F030-4616-B93A-A7B9E4B0333B.png '')
![](./254E5E6A-9578-448E-944B-76D24D28EE1D.png '')

#### 5. 创建并编辑三个私有库配置文件

###### 5.1 创建和编辑README、创建和编辑LICENSE文件。

README.md和LICENSE手动添加可以参照上面的 <font color=red face="黑体" size=3><le>4.2</le></font> 节。如果我们的组件库是通过Cocoapods自动生成的话，也会自动生成README.md和LICENSE文件。

###### 5.2 创建和编辑podspec文件。

通过Cocoapods自动生成工程时也会自动生成podspec文件，也可通过pod命令手动生成podspec文件，如下：

    pod spec create EHDNetwork

podspec文件怎么写这里就不详细说明，请参考[Podspec Syntax Reference](https://guides.cocoapods.org/syntax/podspec.html "Podspec Syntax Reference")。下面给出我已经写好的EHDNetwork.podspec，如下图：

![](./B226A274-7570-49AB-A234-A140BF76999F.png '')
![](./854F2C01-C426-4C4E-BF1C-8C85114BC7E7.png '')

###### 5.3 验证podspec文件是否有效。

    pod spec lint EHDNetwork.podspec --allow-warnings

<font color=red face="黑体" size=3><le>我这里有个错误，报错信息是找不到依赖的组件库，这是因为我们以前所有代码仓库是svn托管的。这里只是举例如何使用命令。</le></font>

![](./2BA24B7E-D15C-44FD-AC95-1B6A49BB9316.png '')

#### 6. 将配置文件push到远端专门存储配置文件的仓库中。

配置文件上传gitlab服务器可以参照上面的 <font color=red face="黑体" size=3><le>4.3</le></font> 节。

![](./ED574E69-BDE7-4619-9F85-0FAC464ACD98.png '')

生成本地配置文件的仓库。

    pod repo add ios-component-spec-repo http://gitlab.tf56.lo/ios-components-spec-repo/ios-component-spec-repo.git

查看是否添加成功。

    pod repo list

如下图所示：

![](./50BC9D4F-F4E6-4562-AD6C-25D33DB33BE6.png '')
![](./58E0D5DA-6010-42AF-9484-1DB61D757937.png '')

#### 7. 确认已经制作完成并使用。

![](./00651E14-4674-443A-ACBD-7699C47E87F5.png '')
![](./1B77A77E-5647-4854-A195-CFBB288DD02C.png '')