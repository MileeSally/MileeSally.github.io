---
title: iOS 多线程 - NSOperation
---

<font color=black face="黑体" size=6><center>iOS 多线程 - NSOperation</center></font>
<font color=red size=2><center>花生-sniper</center></font>

#### 1. NSOperation
NSOperation 是个抽象类，不能用来封装操作。我们只有使用它的子类来封装操作。我们有三种方式来封装操作。

* NSInvocationOperation
* NSBlockOperation
* 自定义继承自 NSOperation 的子类，通过实现内部相应的方法来封装操作。

##### 1.1 NSInvocationOperation
* 在主线程中单独使用使用子类 NSInvocationOperation 执行一个操作的情况下，操作是在当前线程执行的，并没有开启新线程。
* 在其他线程中单独使用子类 NSInvocationOperation，操作是在当前调用的其他线程执行的，并没有开启新线程。
```
/**
 * 使用子类 NSInvocationOperation
 */
- (void)useInvocationOperation {

    // 1.创建 NSInvocationOperation 对象
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];

    // 2.调用 start 方法开始执行操作
    [op start];
}

/**
 * 任务1
 */
- (void)task1 {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
        NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
    }
}
```

##### 1.2 NSBlockOperation
* 在主线程中单独使用 NSBlockOperation 执行一个操作的情况下，操作是在当前线程执行的，并没有开启新线程。

```
/**
 * 使用子类 NSBlockOperation
 */
- (void)useBlockOperation {

    // 1.创建 NSBlockOperation 对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 2.调用 start 方法开始执行操作
    [op start];
}
```

* 如果添加的操作多的话，blockOperationWithBlock: 中的操作也可能会在其他线程（非当前线程）中执行，这是由系统决定的，并不是说添加到 blockOperationWithBlock: 中的操作一定会在当前线程中执行。（可以使用 addExecutionBlock: 多添加几个操作试试）。

* NSBlockOperation 还提供了一个方法 addExecutionBlock:，通过 addExecutionBlock: 就可以为 NSBlockOperation 添加额外的操作。这些操作（包括 blockOperationWithBlock 中的操作）可以在不同的线程中同时（并发）执行。只有当所有相关的操作已经完成执行时，才视为完成。

* 使用子类 NSBlockOperation，并调用方法 AddExecutionBlock: 的情况下，blockOperationWithBlock: 方法中的操作和 addExecutionBlock: 中的操作是在不同的线程中异步执行的。而且，这次执行结果中 blockOperationWithBlock: 方法中的操作也不是在当前线程（主线程）中执行的。从而印证了 blockOperationWithBlock: 中的操作也可能会在其他线程（非当前线程）中执行。

```
/**
 * 使用子类 NSBlockOperation
 * 调用方法 AddExecutionBlock:
 */
- (void)useBlockOperationAddExecutionBlock {

    // 1.创建 NSBlockOperation 对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 2.添加额外的操作
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"5---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"6---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"7---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"8---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 3.调用 start 方法开始执行操作
    [op start];
}
```

> 一般情况下，如果一个 NSBlockOperation 对象封装了多个操作。NSBlockOperation 是否开启新线程，取决于操作的个数。如果添加的操作的个数多，就会自动开启新线程。当然开启的线程数是由系统来决定的。

##### 1.3 自定义 NSOperation 的子类
可以使用自定义继承自 NSOperation 的子类。可以通过重写 main 或者 start 方法来定义自己的 NSOperation 对象。重写main方法比较简单，我们不需要管理操作的状态属性 isExecuting 和 isFinished。当 main 执行完返回的时候，这个操作就结束了。

* 在主线程单独使用自定义继承自 NSOperation 的子类的情况下，是在主线程执行操作，并没有开启新线程。

```
// YSCOperation.h 文件
#import <Foundation/Foundation.h>

@interface YSCOperation : NSOperation

@end

// YSCOperation.m 文件
#import "YSCOperation.h"

@implementation YSCOperation

- (void)main {
    if (!self.isCancelled) {
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
    }
}

@end

/**
 * 使用自定义继承自 NSOperation 的子类
 */
- (void)useCustomOperation {
    // 1.创建 YSCOperation 对象
    YSCOperation *op = [[YSCOperation alloc] init];
    // 2.调用 start 方法开始执行操作
    [op start];
}
```

#### 2. NSOperationQueue
* 主队列
  * 凡是添加到主队列中的操作，都会放到主线程中执行。
```
// 主队列获取方法
NSOperationQueue *queue = [NSOperationQueue mainQueue];
```

* 自定义队列（非主队列）
  * 添加到这种队列中的操作，就会自动放到子线程中执行。
  * 同时包含了：串行、并发功能。
```
// 自定义队列创建方法
NSOperationQueue *queue = [[NSOperationQueue alloc] init];
```

#### 3. 多线程
NSOperation 需要配合 NSOperationQueue 来实现多线程。
* 3.1 - (void)addOperation:(NSOperation *)op;
  * 使用 NSOperation 子类创建操作，并使用 addOperation: 将操作加入到操作队列后能够开启新线程，进行并发执行。
  
```
/**
 * 使用 addOperation: 将操作加入到操作队列中
 */
- (void)addOperationToQueue {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // 2.创建操作
    // 使用 NSInvocationOperation 创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];

    // 使用 NSInvocationOperation 创建操作2
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];

    // 使用 NSBlockOperation 创建操作3
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op3 addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 3.使用 addOperation: 添加所有操作到队列中
    [queue addOperation:op1]; // [op1 start]
    [queue addOperation:op2]; // [op2 start]
    [queue addOperation:op3]; // [op3 start]
}
```

* 3.2 - (void)addOperationWithBlock:(void (^)(void))block;
  * 使用 addOperationWithBlock: 将操作加入到操作队列后能够开启新线程，进行并发执行。

```
/**
 * 使用 addOperationWithBlock: 将操作加入到操作队列中
 */
- (void)addOperationWithBlockToQueue {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // 2.使用 addOperationWithBlock: 添加操作到队列中
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
}
```

#### 4. NSOperationQueue 串行、并行控制

* maxConcurrentOperationCount 默认情况下为-1，表示不进行限制，可进行并发执行。
* maxConcurrentOperationCount 为1时，队列为串行队列。只能串行执行。
* maxConcurrentOperationCount 大于1时，队列为并发队列。操作并发执行，当然这个值不应超过系统限制，即使自己设置一个很大的值，系统也会自动调整为 min{自己设定的值，系统设定的默认最大值}。

> 注意：这里 maxConcurrentOperationCount 控制的不是并发线程的数量，而是一个队列中同时能并发执行的最大操作数。而且一个操作也并非只能在一个线程中运行。

```
/**
 * 设置 MaxConcurrentOperationCount（最大并发操作数）
 */
- (void)setMaxConcurrentOperationCount {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // 2.设置最大并发操作数
    queue.maxConcurrentOperationCount = 1; // 串行队列
    // queue.maxConcurrentOperationCount = 2; // 并发队列
    // queue.maxConcurrentOperationCount = 8; // 并发队列

    // 3.添加操作
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
}
```

#### 5. NSOperation 操作依赖

NSOperation、NSOperationQueue 最吸引人的地方是它能添加操作之间的依赖关系。通过操作依赖，我们可以很方便的控制操作之间的执行先后顺序。NSOperation 提供了3个接口供我们管理和查看依赖。

* -(void)addDependency:(NSOperation *)op; 添加依赖，使当前操作依赖于操作 op 的完成。
* -(void)removeDependency:(NSOperation *)op; 移除依赖，取消当前操作对操作 op 的依赖。
* @property (readonly, copy) NSArray<NSOperation *> *dependencies; 在当前操作开始执行之前完成执行的所有操作对象数组。

```
/**
 * 操作依赖
 * 使用方法：addDependency:
 */
- (void)addDependency {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // 2.创建操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 3.添加依赖
    [op2 addDependency:op1]; // 让op2 依赖于 op1，则先执行op1，在执行op2

    // 4.添加操作到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
}
```

#### 6. NSOperation 优先级
NSOperation 提供了 queuePriority（优先级）属性，queuePriority 属性适用于同一操作队列中的操作，不适用于不同操作队列中的操作。默认情况下，所有新创建的操作对象优先级都是 NSOperationQueuePriorityNormal。但是我们可以通过 setQueuePriority: 方法来改变当前操作在同一队列中的执行优先级。

```
// 优先级的取值
typedef NS_ENUM(NSInteger, NSOperationQueuePriority) {
    NSOperationQueuePriorityVeryLow = -8L,
    NSOperationQueuePriorityLow = -4L,
    NSOperationQueuePriorityNormal = 0,
    NSOperationQueuePriorityHigh = 4,
    NSOperationQueuePriorityVeryHigh = 8
};
```

**就绪状态**：当一个操作的所有依赖都已经完成时，操作对象通常会进入准备就绪状态，等待执行。

* queuePriority 属性决定了进入准备就绪状态下的操作之间的开始执行顺序。并且，优先级不能取代依赖关系。
* 如果一个队列中既包含高优先级操作，又包含低优先级操作，并且两个操作都已经准备就绪，那么队列先执行高优先级操作。
* 如果一个队列中既包含了准备就绪状态的操作，又包含了未准备就绪的操作，未准备就绪的操作优先级比准备就绪的操作优先级高。那么，虽然准备就绪的操作优先级低，也会优先执行。优先级不能取代依赖关系。如果要控制操作间的启动顺序，则必须使用依赖关系。

#### 7. NSOperation、NSOperationQueue 线程间的通信

```
/**
 * 线程间通信
 */
- (void)communication {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];

    // 2.添加操作
    [queue addOperationWithBlock:^{
        // 异步进行耗时操作
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }

        // 回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 进行一些 UI 刷新等操作
            for (int i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
            }
        }];
    }];
}
```

#### 8. NSOperation、NSOperationQueue 线程同步和线程安全

* 在考虑了线程安全，使用 NSLock 加锁、解锁机制解决了多个线程同步的问题。

```
/**
 * 线程安全：使用 NSLock 加锁
 * 初始化火车票数量、卖票窗口(线程安全)、并开始卖票
 */
- (void)initTicketStatusSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]); // 打印当前线程

    self.ticketSurplusCount = 50;

    self.lock = [[NSLock alloc] init];  // 初始化 NSLock 对象

    // 1.创建 queue1,queue1 代表北京火车票售卖窗口
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;

    // 2.创建 queue2,queue2 代表上海火车票售卖窗口
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    queue2.maxConcurrentOperationCount = 1;

    // 3.创建卖票操作 op1
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf saleTicketSafe];
    }];

    // 4.创建卖票操作 op2
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf saleTicketSafe];
    }];

    // 5.添加操作，开始卖票
    [queue1 addOperation:op1];
    [queue2 addOperation:op2];
}

/**
 * 售卖火车票(线程安全)
 */
- (void)saleTicketSafe {
    while (1) {
        // 加锁
        [self.lock lock];

        if (self.ticketSurplusCount > 0) {
            //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数:%d 窗口:%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        }

        // 解锁
        [self.lock unlock];

        if (self.ticketSurplusCount <= 0) {
            NSLog(@"所有火车票均已售完");
            break;
        }
    }
}
```