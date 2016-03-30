//
//  BZRefreshFooterView.m
//  rrcc_yh
//
//  Created by user on 15/6/15.
//  Copyright (c) 2015年 yuan liu. All rights reserved.
//

#import "BZRefreshFooterView.h"

@implementation BZRefreshFooterView

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame arrowImageName:@"async.png" textColor:kTextColor];
}

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.autoresizingMask  = UIViewAutoresizingFlexibleWidth;
    
    // 文字
    UILabel *label         = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-kTextFontSize, 0, kScreenWidth/2, kRefreshViewVisibleHeight)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font             = [UIFont boldSystemFontOfSize:kTextFontSize];
    label.textColor        = textColor;
    label.backgroundColor  = [UIColor clearColor];
    label.textAlignment    = NSTextAlignmentLeft;
    self.statusLabel  = label;
    [self addSubview:label];
    
    // 箭头
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-kTextFontSize*2-14, (kRefreshViewVisibleHeight-kTextFontSize)/2, kTextFontSize, kTextFontSize)];
    imageView.image = [UIImage imageNamed:arrow];
    self.asynImageView = imageView;
    
    [self addSubview:imageView];
    
    self.state = BZRefreshViewStateNormal;
    return self;
}

- (void)refreshStateForScroll {
    CGPoint contentOffset = self.scrollView.contentOffset;
    if (contentOffset.y < 0) return;
    //DLog(@"------%f-----up------state-----  %ld  %f",self.scrollView.contentSize.height,self.state,contentOffset.y);
    if (self.state == BZRefreshViewStateLoading) {
        
    } else {
        if (self.scrollView.isDragging) {
            
            [self rotateRefreshImage];
            CGSize contentSize = self.scrollView.contentSize;
            if (contentSize.height < self.scrollView.frame.size.height) {
                contentSize.height = self.scrollView.frame.size.height;
            }
            CGFloat contentSizeHeight = contentSize.height;
            if (self.state == BZRefreshViewStatePulling && contentOffset.y < contentSizeHeight-self.scrollView.frame.size.height+65.0 && !self.isLoading) {
                self.state = BZRefreshViewStateNormal;
            } else if (self.state == BZRefreshViewStateNormal && contentOffset.y > contentSizeHeight-self.scrollView.frame.size.height+65 && !self.isLoading) {
                self.state = BZRefreshViewStatePulling;
            }
        } else {
            if (self.state == BZRefreshViewStatePulling) {
                self.state = BZRefreshViewStateLoading;
            }
        }
    }
}

#pragma mark - here may be bug

- (void)refreshFrameForContentSize {
    CGRect frame = self.frame;
    frame.origin.y = MAX(self.scrollView.frame.size.height, self.scrollView.contentSize.height);
    self.frame = frame;
}

- (void)setState:(BZRefreshViewState)state {
    switch (state) {
        case BZRefreshViewStatePulling:
            self.statusLabel.text = @"释放加载";
            break;
        case BZRefreshViewStateNormal:
            if (self.state == BZRefreshViewStatePulling) {
            }
            self.statusLabel.text = @"上拉加载";
            break;
        case BZRefreshViewStateLoading:
            self.statusLabel.text = @"加载中...";
            self.loading = YES;
            [self startLoading];
            break;
        default:
            break;
    }
    _state = state;
}
- (void)stopLoading {
    [super stopLoading];
    [self refreshFrameForContentSize];
}
- (void)startLoading {
    // 1. EdgeInsets
    [UIView animateWithDuration:0.2 animations:^{
        if (self.scrollView.contentSize.height <= self.scrollView.frame.size.height) {// 表格的数据量比较小
            CGFloat extraContentHeight = self.scrollView.frame.size.height-self.scrollView.contentSize.height+kRefreshViewVisibleHeight;
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, extraContentHeight, 0.0f);
        } else {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, kRefreshViewVisibleHeight, 0.0f);
        }
    }];
    // 2. 执行块内容
    if (self.pullUpHandler) {
        self.pullUpHandler(self);
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
