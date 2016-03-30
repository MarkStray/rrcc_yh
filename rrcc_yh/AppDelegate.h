//
//  AppDelegate.h
//  rrcc_yh
//
//  Created by lawwilte on 15-5-4.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, assign) CGFloat ScaleX;
@property (nonatomic, assign) CGFloat ScaleY;

@property (strong, nonatomic) UIWindow *window;

+(AppDelegate*)Share;

@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;

@end

