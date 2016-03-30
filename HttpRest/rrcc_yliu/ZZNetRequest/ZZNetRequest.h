//
//  ZZNetRequest.h
//  rrcc_yh
//
//  Created by user on 15/10/23.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZNetRequest : NSObject

- (void)downloadJpgImageWithUrlString:(NSString *)urlStr complete:(void (^) (CGSize size))completeCB;

@end
