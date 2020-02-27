---
title: Flutter重构优化需要关注的事情
---

<font color=black face="黑体" size=6><center>Flutter重构优化需要关注的事情</center></font>
<font color=red size=2><center>花生-sniper</center></font>

#### 1. 小部件拆分注意影响渲染性能

Flutter开发过程中的布局太难写了，往往一个简单的布局都要嵌套很多层。所以通常我们都会将其拆分到方法中，但是在Flutter中需要关注什么呢？

例如有如下代码：
```
@override
Widget build(BuildContext context) {
  return Scaffold(
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.title,
        ),
        Center(
          child: Text(result,)
        ),
        Row(
          children: [
          MaterialButton(
            color: Theme.of(context).primaryColor,
            child: Text("1", style: TextStyle(color: Colors.white)),
            onPressed: () => onPressCallback('startActivity'),
          ),
          ]
        )
      ],
    ),
  ),
  );
}
```

首先想到的解决方案是将嵌套部分拆分为单独的方法，如下代码：
```
@override
Widget build(BuildContext context) {
  return Scaffold(
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.title,
        ),
        Center(
          child: Text(result,)
        ),
        this._buildRowBtnWidget() // 拆分为组件方法
      ],
    ),
  ),
  );
}
 
/**
* 组件方法模块
*/
Widget _buildRowBtnWidget() {
return Row(
    children: [
        MaterialButton(
        color: Theme.of(context).primaryColor,
        child: Text("1", style: TextStyle(color: Colors.white)),
        onPressed: () => _incrementCounter,
        ),
    ]
);
}
```

此时看上去很优美了，那这样写会不会存在问题呢？

将小部件拆分为方法的方式，乍一看，将长构建方法拆分为小函数非常有意义。其实我们不应该这样做。假设当前有一个 state 状态值 num，每当我们通过 setState() 去触发 num 数据更新，都会调用 _buildRowBtnWidget()，这会造成一次又一次地重建小部件树。而 _buildRowBtnWidget() 中的组件并不需要做任何更新展示，即为无状态的组件模块。当应用程序较为复杂时，会产生明显的渲染性能影响（CPU调度）。

Flutter 中创建组件分为两种方式：有状态（StatefulWidget）和无状态（StatelessWidget）组件。所以我们不是将构建方法拆分为更小的方法，而是将它们拆分为无状态的小部件，即：StatelessWidgets。

重构之后的代码：
```
@override
Widget build(BuildContext context) {
  return Scaffold(
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.title,
        ),
        Center(
          child: Text(result,)
        ),
        const _RowBtnWidget(onPressed:_incrementCounter), // 拆分为组件方法
      ],
    ),
  ),
  );
}
 
/**
 * 组件
 */
class _RowBtnWidget extends StatelessWidget {
  const _RowBtnWidget({this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          MaterialButton(
            color: Theme.of(context).primaryColor,
            child: Text("1", style: TextStyle(color: Colors.white)),
            onPressed: onPressed,
          ),
        ]
    );
  }
}
```
可以看到上述代码虽然要比拆分为方法显得“臃肿”很多，但这 _RowBtnWidget 只会构建一次，减少了不必要的组件重建的性能开销。 

现在让我们分别看下不同情况下的帧率：
![](./3.png '')
![](./1.png '')
![](./2.png '')