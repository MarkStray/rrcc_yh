//
//  BZRefreshView.m
//  rrcc_yh
//
//  Created by user on 15/6/15.
//  Copyright (c) 2015年 yuan liu. All rights reserved.
//

#import "BZRefreshView.h"

static void *RefreshView = (void *)&RefreshView;


@implementation BZRefreshView

@synthesize state = _state;

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentOffset" context:RefreshView];
}

- (void)startLoading {
    @throw [NSException exceptionWithName:@"BZRefreshViewException" reason:@"method startLoading should be happen in subclass object" userInfo:nil];
}

//- (void)stopLoading {
//    @throw [NSException exceptionWithName:@"BZRefreshViewException" reason:@"method stopLoading should be happen in subclass object" userInfo:nil];
//}

- (void)stopLoading {
    [UIView animateWithDuration:.2f animations:^{
        [self.scrollView setContentInset:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)];
    }];

    self.loading = NO;
    self.state = BZRefreshViewStateNormal;
}
- (void)refreshStateForScroll {
    @throw [NSException exceptionWithName:@"BZRefreshViewException" reason:@"method refreshStateForScroll should be happen in subclass object" userInfo:nil];
}

- (void)setState:(BZRefreshViewState)state {
    @throw [NSException exceptionWithName:@"BZRefreshViewException" reason:@"method setState: should be happen in subclass object" userInfo:nil];
}

// 原理：KVO监听值的变化

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:RefreshView];
    if (newSuperview) {
        self.scrollView = (UIScrollView *)newSuperview;
        [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:RefreshView];
    }
}

// KVO回调方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == RefreshView) {
        if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
        if (self.isLoading) return;
        if (self.state == BZRefreshViewStateLoading) return;
        if ([keyPath isEqualToString:@"contentOffset"]) [self refreshStateForScroll];
    }
}


@end
