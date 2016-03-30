//
//  UIScrollView+refresh.h
//  rrcc_yh
//
//  Created by user on 15/6/15.
//  Copyright (c) 2015年 yuan liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZRefreshView.h"
#import "BZRefreshHeaderView.h"
#import "BZRefreshFooterView.h"

/*------------------UIScrollView+refresh------------------*/


@interface UIScrollView (refresh)
/* set get 运行时变量 */
- (void)setRefreshHeaderView:(BZRefreshHeaderView *)refreshHeaderView;
- (void)setRefreshFooterView:(BZRefreshFooterView *)refreshFooterView;
- (BZRefreshHeaderView *)refreshHeaderView;
- (BZRefreshFooterView *)refreshFooterView;

/* set get 非本类中得变量 */
- (void)setPullDownHandler:(BZRefreshViewHandler)pullDownHandler;//下拉刷新
- (void)setPullUpHandler:(BZRefreshViewHandler)pullUpHandler;//上拉加载
- (BZRefreshViewHandler)pullDownHandler;
- (BZRefreshViewHandler)pullUpHandler;

/* 类别添加方法 */
- (void)stopHeaderViewLoading;
- (void)stopFooterViewLoading;

@end

