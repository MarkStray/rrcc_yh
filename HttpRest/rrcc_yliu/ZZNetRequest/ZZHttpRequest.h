//
//  ZZHttpRequest.h
//  rrcc_yh
//
//  Created by user on 15/11/10.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompleteCB) (NSArray *dataArray);
@interface ZZHttpRequest : NSObject

- (void)downloadImageData:(NSArray *)urlArray complete:(CompleteCB)handler;

@end
