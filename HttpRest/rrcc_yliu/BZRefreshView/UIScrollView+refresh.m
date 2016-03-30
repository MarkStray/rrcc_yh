//
//  UIScrollView+refresh.m
//  rrcc_yh
//
//  Created by user on 15/6/15.
//  Copyright (c) 2015年 yuan liu. All rights reserved.
//

#import "UIScrollView+refresh.h"
#import <objc/runtime.h>

#define kRefreshViewBackgroundColor [UIColor colorWithRed:239/255.f green:239/255.f blue:239/255.f alpha:1.0]


@implementation UIScrollView (refresh)

- (void)setRefreshHeaderView:(BZRefreshHeaderView *)refreshHeaderView {
    objc_setAssociatedObject(self, "refreshHeaderView", refreshHeaderView, OBJC_ASSOCIATION_RETAIN);
    [self addSubview:refreshHeaderView];
}

- (BZRefreshHeaderView *)refreshHeaderView {
    BZRefreshHeaderView *headerView = objc_getAssociatedObject(self, "refreshHeaderView");
    return headerView;
}

- (void)setRefreshFooterView:(BZRefreshFooterView *)refreshFooterView {
    objc_setAssociatedObject(self, "refreshFooterView", refreshFooterView, OBJC_ASSOCIATION_RETAIN);
    [self addSubview:refreshFooterView];
}

- (BZRefreshFooterView *)refreshFooterView {
    BZRefreshFooterView *footerView = objc_getAssociatedObject(self, "refreshFooterView");
    return footerView;
}

- (void)setPullDownHandler:(BZRefreshViewHandler)pullDownHandler {
    if (!self.refreshHeaderView) {
        BZRefreshHeaderView *headerView = [[BZRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        DLog(@"%@",NSStringFromCGRect(headerView.frame));
        headerView.backgroundColor      = kRefreshViewBackgroundColor;
        headerView.pullDownHandler      = pullDownHandler;
        self.refreshHeaderView          = headerView;
    }
}

- (void)setPullUpHandler:(void (^)(BZRefreshView *))pullUpHandler {
    if (!self.refreshFooterView) {
        CGFloat originY = MAX(self.contentSize.height, self.frame.size.height);
        BZRefreshFooterView *footerView = [[BZRefreshFooterView alloc] initWithFrame:CGRectMake(0, originY, self.frame.size.width, self.frame.size.height)];
         DLog(@"%@",NSStringFromCGRect(footerView.frame));
        footerView.pullUpHandler        = pullUpHandler;
        footerView.backgroundColor      = kRefreshViewBackgroundColor;
        self.refreshFooterView          = footerView;
    }
}


- (void (^)(BZRefreshView *))pullDownHandler {
    return self.refreshHeaderView.pullDownHandler;
}

- (void (^)(BZRefreshView *))pullUpHandler {
    return self.refreshFooterView.pullUpHandler;
}

- (void)stopHeaderViewLoading {
    [self.refreshHeaderView stopLoading];
}

- (void)stopFooterViewLoading {
    [self.refreshFooterView stopLoading];
}


@end
