//
//  ZZHttpRequest.m
//  rrcc_yh
//
//  Created by user on 15/11/10.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "ZZHttpRequest.h"

@interface ZZHttpRequest ()

@property (nonatomic, copy) CompleteCB handler;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZZHttpRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}
#define method 1
- (void)downloadImageData:(NSArray *)urlArray complete:(CompleteCB)handler {
    
    self.handler = handler;
#if method == 0
    
    // 创建一个异步 gcd
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0; i<urlArray.count; i++) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                NSString *URLEncoding = [urlArray[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLEncoding]];
                
                [self.dataArray addObject:data];
                
            });
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if (self.handler) self.handler(self.dataArray);
        });
        
    });

#elif method == 1
    // 返回一个全局并行队列(共有3中)
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 创建一个组
    dispatch_group_t group = dispatch_group_create();
    
    
    for (NSString *urlStr in urlArray) {
        
        // 把一个组放在队列里面
        dispatch_group_async(group, queue, ^{
            
            NSString *URLEncoding = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            //从网络上下载数据
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLEncoding]];
            
            [self.dataArray addObject:data];
            
        });

    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{//全部加载完毕后 执行block
        
        if (self.handler) self.handler(self.dataArray);
        
    });
    
#endif
        
}

@end
