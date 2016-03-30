//
//  BZExpandHeaderView.m
//  rrcc_yh
//
//  Created by user on 15/9/12.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "BZExpandHeaderView.h"

/*  if customView 
 //关键步骤 设置可变化背景view属性
 imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
 imageView.clipsToBounds = YES;
 imageView.contentMode = UIViewContentModeScaleAspectFill;
 */

@implementation BZExpandHeaderView{
    __weak UIScrollView *_scrollView; //scrollView或者其子类
    __weak UIView *_expandView; //背景可以伸展的View
    
    CGFloat _expandHeight;
}

- (void)dealloc{
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:NULL];
        _scrollView = nil;
    }
    _expandView = nil;
}

+ (id)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView{
    BZExpandHeaderView *expandHeader = [BZExpandHeaderView new];
    [expandHeader expandWithScrollView:scrollView expandView:expandView];
    return expandHeader;
}

- (void)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView{
    
    _expandHeight = CGRectGetHeight(expandView.frame);
    
    _scrollView = scrollView;
    _expandView = expandView;
    
//    if ([_scrollView isKindOfClass:[UICollectionView class]]) { // collection
//        UICollectionView *collectionView = (UICollectionView *)_scrollView;
//        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
//        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    }
    
    _scrollView.contentInset = UIEdgeInsetsMake(_expandHeight, 0, 0, 0);

    [_scrollView insertSubview:expandView atIndex:0];
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    
    //使View可以伸展效果  重要属性
    _expandView.contentMode= UIViewContentModeScaleAspectFill;
    _expandView.clipsToBounds = YES;
    //重置_expandView位置
    [_expandView setFrame:CGRectMake(0, -_expandHeight, CGRectGetWidth(_expandView.frame), _expandHeight)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {  // resizeFrame
        CGFloat offsetY = _scrollView.contentOffset.y;
        if(offsetY < -_expandHeight) {
            CGRect currentFrame = _expandView.frame;
            currentFrame.origin.y = offsetY;
            currentFrame.size.height = -offsetY;
            _expandView.frame = currentFrame;
        }
    }
}

@end
