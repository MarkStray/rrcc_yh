//
//  CalculatorView.h
//  rrcc_yh
//
//  Created by user on 15/9/20.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalculatorViewDelegate;

@interface CalculatorView : UIView

@property (nonatomic, assign) id<CalculatorViewDelegate> delegate;

@property (nonatomic, assign) int count; //显示数量

@property (nonatomic, assign) BOOL isZeroShow;
@property (nonatomic, assign) BOOL isButtonEnable;

@end

@protocol CalculatorViewDelegate <NSObject>

@required

- (void)CalculatorViewDidClickAddButton:(CalculatorView *)aView;//加
- (void)CalculatorViewDidClickReduceButton:(CalculatorView *)aView;//减

@end