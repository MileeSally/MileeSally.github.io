---
title: bash shell 脚本在开头 set -u 和 set -e 作用
---

<div style="color:red;font-size:20px;text-align:center">bash shell 脚本在开头 set -u 和 set -e 作用</div>


#### set -e

设置该选项后，当脚本中任何以一个命令执行返回的状态码不为0时就退出整个脚本（默认脚本运行中某行报错会继续往下执行），这样就不必设置很多的判断条件去判断每个命令是否执行成功，特别那些依赖很强的地方，脚本任何一处执行报错就不应继续执行其他语句的时候就特别有用。

简单的写个脚本测试下：
![](./shell-script.jpg '')

在不使用set -e 的时候执行如下脚本后，查看执行结果，可以看到报错后继续运行，输出了 End 。
![](./shell-script-exec-normal.jpg '')

使用set -e 后执行脚本后，执行结果如下：
![](./shell-script-exec-with-e.jpg '')

#### set -u

设置该选项后，当脚本在执行过程中尝试使用未定义过的变量时，报错并退出运行整个脚本（默认会把该变量的值当作空来处理），这个感觉也非常有用，有些时候可能在脚本中变量很多很长，疏忽了把某个变量的名字写错了，这时候运行脚本不会报任何错误，但结果却不是你想要的，排查起来很是头疼，使用这个选项就完美的解决了这个问题。

简单的写个脚本测试下：
![](./shell-script-02.jpg '')

在不使用set -u 的时候，执行不会有任何问题，会把$GOOD变量当作空值来处理：
![](./shell-script-exec-normal-02.jpg '')

使用set -u 后执行脚本后，执行结果如下：
![](./shell-script-exec-with-u.jpg '')