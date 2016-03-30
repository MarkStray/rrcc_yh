//
//  CalculatorView.m
//  rrcc_yh
//
//  Created by user on 15/9/20.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "CalculatorView.h"

@interface CalculatorView ()


@property (nonatomic, strong) UIButton *reduceBtn;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UIButton *opaqueBtn;

@end

@implementation CalculatorView

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"count" context:NULL];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customInitWithFrame:CGRectMake(0, 0, 100, 50)];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customInitWithFrame:CGRectMake(0, 0, 100, 50)];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInitWithFrame:frame];
    }
    return self;
}

- (void)customInitWithFrame:(CGRect)frame {
    
    //self.bounds = CGRectMake(0, 0, 100, 50); // size(100,50)
    
    self.opaqueBtn = [ZZFactory buttonWithFrame:frame title:nil titleColor:nil image:nil bgImage:nil];
    
    CGFloat width = frame.size.width/2;
    CGFloat height = frame.size.height;
    
    self.count = 0;
    
    self.reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reduceBtn.frame = CGRectMake(0, 0, width, height);
    self.reduceBtn.hidden = YES;
    [self.reduceBtn setBackgroundImage:[UIImage imageNamed:@"reduce"] forState:UIControlStateNormal];
    [self.reduceBtn addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.reduceBtn];
    
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-40)/2, (frame.size.height-20)/2, 40, 20)];
    self.countLabel.text = [NSString stringWithFormat:@"%d",self.count];
    self.countLabel.hidden = YES;
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.textColor = TEXT_COLOR;
    self.countLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.countLabel];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(width, 0, width, height);
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addBtn];
    
    [self addObserver:self forKeyPath:@"count" options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"count"]) {
        self.countLabel.text = [NSString stringWithFormat:@"%d",self.count];
        if (self.count == 0) {
            if (self.isZeroShow) {
                self.countLabel.hidden = NO;
                self.reduceBtn.hidden = NO;
            } else {
                self.countLabel.hidden = YES;
                self.reduceBtn.hidden = YES;
            }
        }else {
            self.countLabel.hidden = NO;
            self.reduceBtn.hidden = NO;
        }
    }
}

//button 禁用

- (void)setIsButtonEnable:(BOOL)isButtonEnable {
//    self.addBtn.enabled = isButtonEnable;
//    self.reduceBtn.enabled = isButtonEnable;
    if (isButtonEnable) {
        [self.opaqueBtn removeFromSuperview];
    } else {
        [self addSubview:self.opaqueBtn];
    }
}


// 加减操作
- (void)reduce {
    if (self.count == 0)  return;
    
    int reduceCount = self.count - 1;
    
    if (reduceCount == 0) {
        if (self.isZeroShow) {
            self.countLabel.hidden = NO;
            self.reduceBtn.hidden = NO;
        } else {
            self.countLabel.hidden = YES;
            self.reduceBtn.hidden = YES;
        }
    }else {
        self.countLabel.hidden = NO;
        self.reduceBtn.hidden = NO;
    }
    if ([self.delegate respondsToSelector:@selector(CalculatorViewDidClickReduceButton:)]) {
        [self.delegate CalculatorViewDidClickReduceButton:self];
    }
}

- (void)add {
    if ([self.delegate respondsToSelector:@selector(CalculatorViewDidClickAddButton:)]) {
        [self.delegate CalculatorViewDidClickAddButton:self];
    }
}

@end
