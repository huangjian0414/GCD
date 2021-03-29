//
//  ViewController.m
//  GCD多线程
//
//  Created by huangjian on 17/6/2.
//  Copyright © 2017年 huangjian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self demo3];
    //});
//    NSLog(@"---00000--%@",[NSThread currentThread]);
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        for (int i=0; i<3; i++) {
//            NSLog(@"---%d--%@",i,[NSThread currentThread]);
//        }
//    });
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        for (int i=3; i<6; i++) {
//            NSLog(@"---%d--%@",i,[NSThread currentThread]);
//        }
//    });
//    NSLog(@"---aa--%@",[NSThread currentThread]);
    
//    [self maxTaskAsync];
}

/// 并发限制
-(void)maxTaskAsync{
    
    dispatch_queue_t serialQueue = dispatch_queue_create("sssssssss",DISPATCH_QUEUE_SERIAL);

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);

    for (int i = 0; i < 10; i++) {
        dispatch_async(serialQueue, ^{///放入串行队列
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);///信号量-1
            dispatch_async(dispatch_get_global_queue(0, 0), ^{

                NSLog(@"start  %@  --  %d",[NSThread currentThread],i);
                sleep(3);
                NSLog(@"end  %@  --  %d",[NSThread currentThread],i);

                dispatch_semaphore_signal(semaphore);/// 信号量+1

            });
            NSLog(@"666- %d",i);
        });
        NSLog(@"777- %d",i);
    }
    NSLog(@"888- ");
//    dispatch_queue_t serialQueue = dispatch_queue_create("sssssssss",DISPATCH_QUEUE_CONCURRENT);
//
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
//
//    for (int i = 0; i < 10; i++) {
//        dispatch_sync(serialQueue, ^{
//            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//                NSLog(@"start  %@  --  %d",[NSThread currentThread],i);
//                sleep(3);
//                NSLog(@"end  %@  --  %d",[NSThread currentThread],i);
//
//                dispatch_semaphore_signal(semaphore);
//
//            });
//
//        });
//    }
    
}

//并发队列 同步
-(void)demo
{
    NSLog(@"---00000--%@",[NSThread currentThread]);
    dispatch_queue_t queue=dispatch_queue_create("aaa", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        for (int i=0; i<3; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
        
    });
    dispatch_sync(queue, ^{
        for (int i=3; i<6; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
    });
    NSLog(@"---aa--%@",[NSThread currentThread]);
}
//并发队列 异步
-(void)demo1
{
    NSLog(@"---00000--%@",[NSThread currentThread]);
    dispatch_queue_t queue=dispatch_queue_create("bbb", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i=0; i<3; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i=3; i<6; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
    });
    //[NSThread sleepForTimeInterval:1.0];
    NSLog(@"---bb--%@",[NSThread currentThread]);
}
//串行队列 同步
-(void)demo2
{
    NSLog(@"---00000--%@",[NSThread currentThread]);
    dispatch_queue_t queue=dispatch_queue_create("cc", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        for (int i=0; i<3; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i=3; i<6; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
    });
    
    NSLog(@"---cc--%@",[NSThread currentThread]);
    
}
//串行队列 异步
-(void)demo3
{
    NSLog(@"---00000--%@",[NSThread currentThread]);
    dispatch_queue_t queue=dispatch_queue_create("dd", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        for (int i=0; i<3; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i=3; i<6; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
    });
    //[NSThread sleepForTimeInterval:1.0];
    NSLog(@"---dd--%@",[NSThread currentThread]);
}
//主队列 同步(死锁)。不开辟新线程，使用同步 互相等待 死锁  ， 如果demo4在子线程执行，则可以，没有互相等待,顺序执行
-(void)demo4
{
    NSLog(@"---00000--%@",[NSThread currentThread]);//只打印这句
    dispatch_queue_t queue=dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        for (int i=0; i<3; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i=3; i<6; i++) {
            //sleep(1);
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
    });
    NSLog(@"---ee--%@",[NSThread currentThread]);
}
//主队列 异步  在主线程，不开辟新的线程 顺序执行 0-5 ，如果外层(h00000)也在主线程，则外层主线程先执行完，再执行主队列里的
// 如果外层(h00000)在子线程， 那么（h ee）可能插在 0-5 中间输出
-(void)demo5
{
    NSLog(@"---h00000--%@",[NSThread currentThread]);
    dispatch_queue_t queue=dispatch_get_main_queue();
    dispatch_async(queue, ^{
        for (int i=0; i<3; i++) {
            NSLog(@"---h%d--%@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i=3; i<6; i++) {
//            sleep(1);
            NSLog(@"---h%d--%@",i,[NSThread currentThread]);
        }
    });
//    sleep(1);
    NSLog(@"---h ee--%@",[NSThread currentThread]);
}
//异步请求数据，回主线程刷新
-(void)demo6
{
    NSLog(@"---00000--%@",[NSThread currentThread]);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i=0; i<3; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"---刷新ui--%@",[NSThread currentThread]);
        });
    });
    NSLog(@"---ff--%@",[NSThread currentThread]);
}
//栅栏方法(将两组异步分割开来)
-(void)demo7
{
    NSLog(@"---00000--%@",[NSThread currentThread]);
    dispatch_queue_t queue=dispatch_queue_create("hehe", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i=0; i<3; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i=3; i<6; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
    });
    dispatch_barrier_async(queue, ^{
        for (int i=6; i<9; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i=9; i<12; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i=12; i<15; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
    });
    NSLog(@"---ff--%@",[NSThread currentThread]);
}
//延时操作
-(void)demo8
{
    NSLog(@"---hello");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //2s后异步执行
        NSLog(@"---h---come !");
    });
    NSLog(@"---h end");
}
//快速迭代
-(void)demo9
{
    dispatch_apply(6, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSLog(@"--%zd---%@",index,[NSThread currentThread]);
    });
}
//队列组 (分别执行两个耗时操作，等这两个耗时操作执行完，再做别的操作)
-(void)demo10
{
    NSLog(@"---hello");
    dispatch_group_t group=dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        for (int i=0; i<3; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        for (int i=3; i<6; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        for (int i=6; i<9; i++) {
            NSLog(@"---%d--%@",i,[NSThread currentThread]);
        }
        /*
         //类似栅栏
         dispatch_async(dispatch_get_global_queue(0, 0), ^{
         for (int i=9; i<12; i++) {
         NSLog(@"---%d--%@",i,[NSThread currentThread]);
         }
         });
         dispatch_async(dispatch_get_global_queue(0, 0), ^{
         for (int i=12; i<15; i++) {
         NSLog(@"---%d--%@",i,[NSThread currentThread]);
         }
         });
         */
        
    });
    NSLog(@"---end");
}

-(void)demo11
{
    NSLog(@"---hello");
    dispatch_group_t group=dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:5.0];
            NSLog(@"---h1--%@",[NSThread currentThread]);
            dispatch_group_leave(group);
        });
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
  
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:8.0];
            NSLog(@"---h2--%@",[NSThread currentThread]);
        
            dispatch_group_leave(group);
        });
        
    });
  
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
            NSLog(@"---h3--%@",[NSThread currentThread]);
        
    });
    NSLog(@"---h end");
}
-(void)demo12
{
    NSLog(@"---hello");
    dispatch_group_t group=dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        
            NSLog(@"---h1--%@",[NSThread currentThread]);
        });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        
            [NSThread sleepForTimeInterval:8.0];
            NSLog(@"---h2--%@",[NSThread currentThread]);
            
        });
    
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"---h3--%@",[NSThread currentThread]);
        
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5*NSEC_PER_SEC)));
        NSLog(@"---h4---%@",[NSThread currentThread]);
    });
    NSLog(@"---h end");

}
@end
