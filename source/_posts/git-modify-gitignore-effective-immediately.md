---
title: 修改 .gitignore 文件如何立即生效
---

<font color=black face="黑体" size=10><center>修改 .gitignore 文件如何立即生效</center></font>

```
# 有时候需要突然修改 .gitignore 文件，随后要立即生效
# 注意后面的 "."，它代表当前目录的根目录。

git rm -r --cached .  #清除缓存， 
git add . #重新trace file  
git commit -m "update .gitignore" #提交和注释  
git push origin master #可选，如果需要同步到remote上的话  
```

如果是通过 SourceTree 工具，则前面两个 rm 命令和 add 命令需要通过终端执行。后面两个 commit 命令和 push 命名可以通过 SourceTree 工具执行，也可以通过命令行执行。

![](./1.png '')

![](./2.png '')