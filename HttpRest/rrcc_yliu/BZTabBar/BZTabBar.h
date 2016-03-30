//
//  BZTabBar.h
//  rrcc_yh
//
//  Created by user on 15/9/19.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BZTabBarDelegate;

@interface BZTabBar : UIView

@property (nonatomic, assign) id<BZTabBarDelegate> delegate;

@property (nonatomic, assign) int badgeCount;

- (void)skipToItemAction:(NSInteger)index; //跳到某一页

@end

@protocol BZTabBarDelegate <NSObject>

@optional
- (void)BZTabBarGoHandle:(BZTabBar *)tabbar;

@required
- (void)BZTabBarSelectedIndexDidChange:(NSInteger)index;

@end