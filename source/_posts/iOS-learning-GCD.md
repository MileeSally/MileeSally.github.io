---
title: iOS 多线程 - GCD
---

<font color=black face="黑体" size=6><center>iOS 多线程 - GCD</center></font>
<font color=red size=2><center>花生-sniper</center></font>

#### 1. 任务和队列

**GCD** 中两个核心概念：『**任务**』 和 『**队列**』。
**任务**：就是执行操作的意思，换句话说就是你在线程中执行的那段代码。在 GCD 中是放在 block 中的那段代码。执行任务有两种方式：『**同步执行**』 和 『**异步执行**』。两者的主要区别是：**是否等待队列的任务执行结束，以及是否具备开启新线程的能力**。

* **同步执行（sync）**：
  * 同步添加任务到指定的队列中，在添加的任务执行结束之前，会一直等待，直到队列里面的任务完成之后再继续执行。
  * 只能在当前线程中执行任务，不具备开启新线程的能力。

* **异步执行（async）**：
  * 异步添加任务到指定的队列中，它不会做任何等待，可以继续执行任务。
  * 可以在新的线程中执行任务，具备开启新线程的能力。

> 注意：**异步执行（async）** 虽然具有开启新线程的能力，但是并不一定开启新线程。这跟任务所指定的队列类型有关。

**队列（Dispatch Queue）**：这里的队列指执行任务的等待队列，即用来存放任务的队列。队列是一种特殊的线性表，采用 FIFO（先进先出）的原则，即新任务总是被插入到队列的末尾，而读取任务的时候总是从队列的头部开始读取。每读取一个任务，则从队列中释放一个任务。

在 GCD 中有两种队列：『**串行队列**』 和 『**并发队列**』。两者的主要区别是：**执行顺序不同，以及开启线程数不同**。

* **串行队列（Serial Dispatch Queue）**：
  * 每次只有一个任务被执行。让任务一个接着一个地执行。（只开启一个线程，一个任务执行完毕后，再执行下一个任务）

* **并发队列（Concurrent Dispatch Queue）**：
  * 可以让多个任务并发（同时）执行。（可以开启多个线程，并且同时执行任务）

> 注意：**并发队列** 的并发功能只有在异步方法下才有效。

#### 2. 队列和线程

一个线程内可能有多个队列，这些队列可能是串行的或者是并行的，按照同步或者异步的方式工作。
![](./iOS-learning-GCD-tread-queue.png '')

『**主队列和主线程**』：这两个术语我们可以经常听到，但是不能把这两个概念等同化。『**主队列**』和『**主线程**』是有关联，但是它们是两个不同的概念。简单地说，主队列是主线程上的一个串行队列，是系统自动为我们创建的。换言之，主线程是可以执行除主队列之外其他队列的任务。

#### 3. GCD 创建和使用
##### 3.1 队列的创建和获取
通过 dispatch_queue_create 方法来创建队列，该方法需要传入两个参数：
* 第一个参数表示队列的唯一标识符，用于 DEBUG，可为空。队列的名称推荐使用应用程序 ID 这种逆序全程域名。
* 第二个参数用来识别是串行队列还是并发队列。DISPATCH_QUEUE_SERIAL 表示串行队列，DISPATCH_QUEUE_CONCURRENT 表示并发队列。
```
// 串行队列的创建方法
dispatch_queue_t queue = dispatch_queue_create("com.luohs.serial.queue", DISPATCH_QUEUE_SERIAL);
// 并发队列的创建方法
dispatch_queue_t queue = dispatch_queue_create("com.luohs.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
```

对于『**串行队列**』，GCD 提供了的一种特殊的串行队列：『**主队列（Main Dispatch Queue）**』。
* 所有放在主队列中的任务，都会放到主线程中执行。
* 可使用 dispatch_get_main_queue() 方法获得主队列。
```
// 主队列的获取方法
dispatch_queue_t queue = dispatch_get_main_queue();
```
对于『**并发队列**』，GCD 默认提供了 『**全局并发队列（Global Dispatch Queue）**』。
* 可以使用 dispatch_get_global_queue 方法来获取全局并发队列。
  * 第一个参数表示队列优先级，一般用DISPATCH_QUEUE_PRIORITY_DEFAULT。
  * 第二个参数暂时没用，用 0 即可。
```
// 全局并发队列的获取方法
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
```
##### 3.2 任务的创建
```
// 同步执行任务创建方法
dispatch_sync(queue, ^{
    // 这里放同步执行任务代码
});
// 异步执行任务创建方法
dispatch_async(queue, ^{
    // 这里放异步执行任务代码
});
```

##### 3.3 任务和队列不同组合方式的区别

在『**主线程**』环境下，『**不同队列**』+『**不同任务**』简单组合的区别：
区别 | 并发队列 | 串行队列 | 主队列
- | - | - | -
同步任务 | 没有开启新线程，串行执行任务	| 没有开启新线程，串行执行任务 | 死锁卡住不执行
异步任务 | 有开启新线程，并发执行任务 | 有开启新线程（1条），串行执行任务 | 没有开启新线程，串行执行任务

> 注意：从上边可看出：『**主线程**』中调用『**主队列**』+『**同步执行**』会导致死锁问题。
> 这是因为 **主队列中追加的同步任务** 和 **主线程本身的任务** 两者之间相互等待，阻塞了 『**主队列**』，最终造成了主队列所在的线程（主线程）死锁问题。
> 而如果在『**其他线程**』调用『**主队列**』+『**同步执行**』，则不会阻塞『**主队列**』，自然也不会造成死锁问题。最终的结果是：不会开启新线程，串行执行任务。

##### 3.4 队列嵌套情况下不同组合方式的区别
除了在『**主线程**』中调用『**主队列**』+『**同步执行**』会导致死锁问题。实际在使用『**串行队列**』的时候，也可能出现阻塞『**串行队列**』所在线程的情况发生，从而造成死锁问题。这种情况多见于同一个串行队列的嵌套使用。例如：在『**异步执行**』+『**串行队列**』的任务中，又嵌套了『**当前的串行队列**』，然后进行『**同步执行**』。
```
dispatch_queue_t queue = dispatch_queue_create("com.luohs.serial.queue", DISPATCH_QUEUE_SERIAL);
dispatch_async(queue, ^{    // 异步执行 + 串行队列
    dispatch_sync(queue, ^{  // 同步执行 + 当前串行队列
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
});
```
> 执行上面的代码会导致 **串行队列中追加的任务** 和 **串行队列中原有的任务** 两者之间相互等待，阻塞了『**串行队列**』，最终造成了串行队列所在的线程（子线程）死锁问题。

『**不同队列**』+『**不同任务**』 组合，以及 『**队列中嵌套队列**』 使用的区别：
区别 |『异步执行+并发队列』嵌套『同一个并发队列』|『同步执行+并发队列』嵌套『同一个并发队列』|『异步执行+串行队列』嵌套『同一个串行队列』|『同步执行+串行队列』嵌套『同一个串行队列』
- | - | - | - | -
同步任务 | 没有开启新的线程，串行执行任务 | 没有开启新线程，串行执行任务 | 死锁卡住不执行 | 死锁卡住不执行
异步任务 | 有开启新线程，并发执行任务 | 有开启新线程，并发执行任务 | 有开启新线程（1 条），串行执行任务 | 有开启新线程（1 条），串行执行任务

#### 4. GCD 线程间的通信
```
- (void)communication {
    // 获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 异步追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        
        // 回到主线程
        dispatch_async(mainQueue, ^{
            // 追加在主线程中执行的任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
}
```

#### 5. GCD 其他方法

##### 5.1 栅栏方法：dispatch_barrier_async

* 我们有时需要异步执行两组操作，而且第一组操作执行完之后，才能开始执行第二组操作。这样我们就需要一个相当于 **栅栏** 一样的一个方法将两组异步执行的操作组给分割起来，当然这里的操作组里可以包含一个或多个任务。这就需要用到 dispatch_barrier_async 方法在两个操作组间形成栅栏。
* 在执行完栅栏前面的操作之后，才执行栅栏操作，最后再执行栅栏后边的操作。

```
/**
 * 栅栏方法 dispatch_barrier_async
 */
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("com.luohs.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_async(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
    });
    
    dispatch_async(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_async(queue, ^{
        // 追加任务 4
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
    });
}
```

##### 5.2 延时执行方法：dispatch_after
* 在指定时间（例如 3 秒）之后执行某个任务。可以用 GCD 的dispatch_after 方法来实现。
> 注意：dispatch_after 方法并不是在指定时间之后才开始执行处理，而是在指定时间之后将任务追加到主队列中。严格来说，这个时间并不是绝对准确的。

```
/**
 * 延时执行方法 dispatch_after
 */
- (void)after {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2.0 秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after---%@",[NSThread currentThread]);  // 打印当前线程
    });
}
```

##### 5.3 只执行一次：dispatch_once
* 在创建单例、或者有整个程序运行过程中只执行一次的代码时，可以用 GCD 的 dispatch_once 方法。使用 dispatch_once 方法能保证某段代码在程序运行过程中只被执行 1 次，并且即使在多线程的环境下，dispatch_once 也可以保证线程安全。

```
/**
 * 一次性代码（只执行一次）dispatch_once
 */
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行 1 次的代码（这里面默认是线程安全的）
    });
}
```

##### 5.4 快速迭代方法：dispatch_apply

* 串行队列中使用 dispatch_apply，那么就和 for 循环一样，按顺序同步执行。
* 并发队列中使用 dispatch_apply 可以在多个线程中同时（异步）遍历多个数字。
* 无论是在串行队列，还是并发队列中，dispatch_apply 都会等待全部任务执行完毕。

```
/**
 * 快速迭代方法 dispatch_apply
 */
- (void)apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"apply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd---%@",index, [NSThread currentThread]);
    });
    NSLog(@"apply---end");
}
```

##### 5.5 队列组：dispatch_group
有时候我们会有这样的需求：分别异步执行2个耗时任务，然后当2个耗时任务都执行完毕后再回到主线程执行任务。这时候我们可以用到 GCD 的队列组。

* 调用队列组的 dispatch_group_async 先把任务放到队列中，然后将队列放入队列组中。或者使用队列组的 dispatch_group_enter、dispatch_group_leave 组合来实现 dispatch_group_async。
* 调用队列组的 dispatch_group_notify 回到指定线程执行任务。或者使用 dispatch_group_wait 回到当前线程继续向下执行（会阻塞当前线程）。

###### 5.5.1 dispatch_group_notify
* 监听 group 中任务的完成状态，当所有的任务都执行完成后，追加任务到 group 中，并执行任务。

```
/**
 * 队列组 dispatch_group_notify
 */
- (void)groupNotify {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务 1、任务 2 都执行完毕后，回到主线程执行下边任务
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程

        NSLog(@"group---end");
    });
}
```

###### 5.5.2 dispatch_group_wait
* 暂停当前线程（阻塞当前线程），等待指定的 group 中的任务执行完成后，才会往下继续执行。
  
```
/**
 * 队列组 dispatch_group_wait
 */
- (void)groupWait {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group---end");
}
```

###### 5.5.3 dispatch_group_enter、dispatch_group_leave
* dispatch_group_enter 标志着一个任务追加到 group，执行一次，相当于 group 中未执行完毕任务数 +1
* dispatch_group_leave 标志着一个任务离开了 group，执行一次，相当于 group 中未执行完毕任务数 -1。
* 当 group 中未执行完毕任务数为0的时候，才会使 dispatch_group_wait 解除阻塞，以及执行追加到 dispatch_group_notify 中的任务。

```
/**
 * 队列组 dispatch_group_enter、dispatch_group_leave
 */
- (void)groupEnterAndLeave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程

        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程.
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    
        NSLog(@"group---end");
    });
}
```

##### 5.6 信号量：dispatch_semaphore
* dispatch_semaphore_create：创建一个 Semaphore 并初始化信号的总量
* dispatch_semaphore_signal：发送一个信号，让信号总量加 1
* dispatch_semaphore_wait：可以使总信号量减 1，信号总量小于 0 时就会一直等待（阻塞所在线程），否则就可以正常执行。

###### 5.6.1 线程同步
```
/**
 * semaphore 线程同步
 */
- (void)semaphoreSync {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        
        number = 100;
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphore---end,number = %zd",number);
}
```

###### 5.6.2 线程安全
```
/**
 * 线程安全：使用 semaphore 加锁
 * 初始化火车票数量、卖票窗口（线程安全）、并开始卖票
 */
- (void)initTicketStatusSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    semaphoreLock = dispatch_semaphore_create(1);
    
    self.ticketSurplusCount = 50;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("com.luohs.serial.queue-1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("com.luohs.serial.queue-2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketSafe];
    });
}

/**
 * 售卖火车票（线程安全）
 */
- (void)saleTicketSafe {
    while (1) {
        // 相当于加锁
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        
        if (self.ticketSurplusCount > 0) {  // 如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { // 如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            
            // 相当于解锁
            dispatch_semaphore_signal(semaphoreLock);
            break;
        }
        
        // 相当于解锁
        dispatch_semaphore_signal(semaphoreLock);
    }
}
```