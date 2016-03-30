//
//  BZRefreshHeaderView.m
//  rrcc_yh
//
//  Created by user on 15/6/15.
//  Copyright (c) 2015年 yuan liu. All rights reserved.
//

#import "BZRefreshHeaderView.h"

@implementation BZRefreshHeaderView

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame arrowImageName:@"async.png" textColor:kTextColor];
}

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.autoresizingMask  = UIViewAutoresizingFlexibleWidth;
    
    // 文字
    UILabel *label         = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-kTextFontSize, frame.size.height-kRefreshViewVisibleHeight, kScreenWidth/2, kRefreshViewVisibleHeight)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font             = [UIFont boldSystemFontOfSize:kTextFontSize];
    label.textColor        = textColor;
    self.statusLabel  = label;
    [self addSubview:label];
    
    // 箭头
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-kTextFontSize*2-14, (kRefreshViewVisibleHeight-kTextFontSize)/2+frame.size.height-kRefreshViewVisibleHeight, kTextFontSize, kTextFontSize)];
    imageView.image = [UIImage imageNamed:arrow];
    self.asynImageView = imageView;
    
    [self addSubview:imageView];
    
    self.state = BZRefreshViewStateNormal;
    return self;
}

- (void)refreshStateForScroll {
    CGPoint contentOffset = self.scrollView.contentOffset;
    if (contentOffset.y > 0) return;
    
    if (self.state == BZRefreshViewStateLoading) {
        self.scrollView.contentInset = UIEdgeInsetsMake(kRefreshViewVisibleHeight, 0.0f, 0.0f, 0.0f);
    } else {
        if (self.scrollView.isDragging) {
            [self rotateRefreshImage];
            if (self.state == BZRefreshViewStatePulling && contentOffset.y > -65.0 && !self.isLoading) {
                self.state = BZRefreshViewStateNormal;
            } else if (self.state == BZRefreshViewStateNormal && contentOffset.y < -65.0 && !self.isLoading) {
                // 这里...
                //CGFloat rate = point.y/scrollView.contentSize.height;
                self.state = BZRefreshViewStatePulling;
            }
            
        } else {// Pulling 松手刷新
            if (self.state == BZRefreshViewStatePulling) {
                self.state = BZRefreshViewStateLoading;// 调用setState://触发刷新状态
            }
        }
    }
}

- (void)setState:(BZRefreshViewState)state {
    switch (state) {
        case BZRefreshViewStatePulling:
            self.statusLabel.text = @"释放更新";
            break;
        case BZRefreshViewStateNormal:
            if (self.state == BZRefreshViewStatePulling) {
                //松手的时候偏移量 < 65
            }
            self.statusLabel.text = @"下拉更新";
            break;
        case BZRefreshViewStateLoading:
            self.statusLabel.text = @"更新中...";
            self.loading = YES;
            [self startLoading];
            break;
        default:
            break;
    }
    _state = state;
}

- (void)startLoading {
    // 1. EdgeInsets
    [UIView animateWithDuration:0.2 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(kRefreshViewVisibleHeight, 0.0f, 0.0f, 0.0f);
    }];
    // 2. 执行块内容
    if (self.pullDownHandler) {
        self.pullDownHandler(self);
    }
    // 3. asynImageView
    _angle = 0;
    [self rotateRefreshImage];
}
- (void)rotateRefreshImage{
    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.asynImageView.transform = CGAffineTransformMakeRotation(-_angle * (M_PI / 180.0f));
    } completion:^(BOOL finished) {
        _angle += 15;
        if (self.loading) [self rotateRefreshImage];
    }];
}


@end
