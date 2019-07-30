//
//  ViewController.m
//  GCD队列组
//
//  Created by 赵鹏 on 2019/7/30.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    
    //创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    /**
     添加异步函数：
     根据上面的代码，系统会先创建一个并发队列，然后把“任务1”和“任务2”不分顺序地放到这个并发队列中，由于下面又调用了异步函数（异步函数+并发队列），所以系统就会新创建两个子线程，然后把“任务1”和“任务2”不分先后、几乎同时地分别放到这两个新创建的子线程中执行。当创建的是串行队列的时候，系统会把多个任务按照先后顺序放到这个串行队列中，因为是串行队列，不具备开启新线程的能力，所以系统会把串行队列中的任务按照FIFO（先进先出，后进后出）的原则把它们一个一个地放到当前的线程中执行。
     */
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 5; i++)
        {
            NSLog(@"任务1 - %@", [NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 5; i++)
        {
            NSLog(@"任务2 - %@", [NSThread currentThread]);
        }
    });
    
    //等前面的任务都执行完了以后，系统会自动执行这个任务
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        for (int i = 0; i < 5; i++)
        {
            NSLog(@"任务3 - %@", [NSThread currentThread]);
        }
    });
}

@end
