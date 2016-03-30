//
//  SingleUserInfo.h
//  rrcc_yh
//
//  Created by user on 15/7/23.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XHBaseNavigationController;

@interface SingleUserInfo : NSObject
{
    BOOL _locationPlayerStatus;
    PlayerInfoModel *_playerInfoModel;
}

@property (nonatomic, strong) XHBaseNavigationController *nav;
@property (nonatomic, strong) XHBaseNavigationController *logNav;


@property (nonatomic, assign) BOOL locationPlayerStatus;// 用户状态
@property (nonatomic, strong) PlayerInfoModel *playerInfoModel;//用户信息

+ (SingleUserInfo *) sharedInstance;

- (void)savePlayerInfoLocationWithDictionary:(NSDictionary *)loginSuccessDic;// 初始化

- (void)showLoginView;//登录
- (void)loginDissmiss;//..

@end
