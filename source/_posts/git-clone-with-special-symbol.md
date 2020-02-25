---
title: git clone 带用户名密码
---

<font color=black face="粗黑体" size=10><center>git clone 带用户名密码</center></font>

git clone 带用户名密码：
```
git clone https://github.com/iissnan/hexo-theme-next themes/next
```

用户名密码中含有特殊符号时需要转码，如“@”转码后变成了“%40”：
```
git clone http://abc%40qq.com:test@git@xxx.com/test.git
```


