//
//  NSObject+NULL.m
//  rrcc_yh
//
//  Created by user on 16/3/2.
//  Copyright © 2016年 yuan liu. All rights reserved.
//

#import "NSObject+NULL.h"

@implementation NSObject (NSObject_NULL)

- (BOOL)isNotNullObject {
    if (   self == nil
        || self == [NSNull null]
        || [self isEqual:[NSNull null]]
        || [self isEqual:@"null"]
        || [self isEqual:@"<null>"]
        || [self isEqual:@"(null)"]
        || [self isEqual:@"NULL"]
        || [self isEqual:@""]) {
        
        return NO;
    } else {
        return YES;
    }
}


@end
