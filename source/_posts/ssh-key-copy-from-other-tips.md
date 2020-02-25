---
title: ssh-permissions-are-too-open-error
---

<font color=white face="粗黑体" size=10><center>ssh-permissions-are-too-open-error</center></font>

将ssh-key从一台电脑拷贝到另一台电脑
![](./0F134DB8-2AAB-4D41-8563-11AC0F049EFD.png '')

如果直接执行如下命令：

    ssh -T git@github.com

则会报如下错误：

    Permissions 0644 for '/Users/luohs/.ssh/163.github' are too open.
    It is required that your private key files are NOT accessible by others.
    This private key will be ignored.
    Load key "/Users/luohs/.ssh/163.github": bad permissions
    git@github.com: Permission denied (publickey).

![](./1FC3F3AF-ECE5-468B-9248-A55723B19A30.png '')

需要进行如下操作：

    chmod 600 163.github

或者

    chmod 400 163.github

![](./E0A36E82-1191-4822-813E-9FC7363E0C02.png '')

参考：
[ssh-permissions-are-too-open-error](https://stackoverflow.com/questions/9270734/ssh-permissions-are-too-open-error)
