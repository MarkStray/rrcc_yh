//
//  BZRefreshView.h
//  rrcc_yh
//
//  Created by user on 15/6/15.
//  Copyright (c) 2015年 yuan liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRefreshViewVisibleHeight 50
#define kTextFontSize 17
#define kTextColor [UIColor colorWithRed:61/255.f green:157/255.f blue:34/255.f alpha:1.0]
#define W(obj)   (!obj?0:(obj).frame.size.width)

#ifndef kScreenWidth
    #define kScreenWidth [[UIScreen mainScreen] bounds].size.width
    #define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#endif


typedef NS_ENUM(NSInteger, BZRefreshViewState) {
    BZRefreshViewStatePulling = 0,
    BZRefreshViewStateNormal,
    BZRefreshViewStateLoading
};

@class BZRefreshView;

typedef void (^BZRefreshViewHandler) (BZRefreshView *refreshView);


@interface BZRefreshView : UIView {
    BZRefreshViewState _state;
    CGFloat _angle;//image旋转角度值
}

@property (nonatomic, getter=isLoading) BOOL loading;

@property (nonatomic, assign) BZRefreshViewState state;

@property (nonatomic, strong) UIImageView *asynImageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, assign) UIScrollView *scrollView;

- (void)refreshStateForScroll;

- (void)startLoading;
- (void)stopLoading;

@end




