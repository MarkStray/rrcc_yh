//
//  BZTabBar.m
//  rrcc_yh
//
//  Created by user on 15/9/19.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "BZTabBar.h"

const int base_tag = 1001;
const int increment = 10;

const int item_count = 3;
const int right_retain = 80;
const int badge_retain = 20;



@interface BZTabBar ()

@property (nonatomic, strong) UILabel *badgeLabel;
@property (nonatomic, strong) NSMutableArray *animationList;

@property (nonatomic, strong) NSMutableArray *buttonList;
@property (nonatomic, strong) NSMutableArray *labelList;

@end

@implementation BZTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.animationList = [NSMutableArray array];
        self.buttonList = [NSMutableArray array];
        self.labelList = [NSMutableArray array];
        
        // create animation
        CAAnimationGroup *fumeAnimation = [CAAnimationGroup animation];
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.values = @[@1.0 ,@2.0];
        scaleAnimation.duration = 0.5;
        scaleAnimation.calculationMode = kCAAnimationCubic;
        scaleAnimation.fillMode = kCAFillModeRemoved;
        scaleAnimation.removedOnCompletion = YES;
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1.0 ,@0.0];
        opacityAnimation.duration = 0.5;
        opacityAnimation.calculationMode = kCAAnimationCubic;
        opacityAnimation.fillMode = kCAFillModeRemoved;
        opacityAnimation.removedOnCompletion = YES;
        [fumeAnimation setAnimations:@[scaleAnimation,opacityAnimation]];
        [self.animationList addObject:@{@"fumeAnimation":fumeAnimation}];
        
        CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        bounceAnimation.values = @[@1.0 ,@1.4, @0.9, @1.15, @0.95, @1.02, @1.0];
        bounceAnimation.duration = 0.5;
        bounceAnimation.calculationMode = kCAAnimationCubic;
        bounceAnimation.removedOnCompletion = YES;
        [self.animationList addObject:@{@"bounceAnimation":bounceAnimation}];

        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        rotationAnimation.fromValue = @0.0;
        rotationAnimation.toValue = @(-M_PI);
        rotationAnimation.duration = 0.5;
        rotationAnimation.fillMode = kCAFillModeRemoved;
        rotationAnimation.removedOnCompletion = YES;
        [self.animationList addObject:@{@"rotationAnimation":rotationAnimation}];
        NSArray *images = @[@"main",@"category",@"my"];
        NSArray *titles = @[@"首页",@"品类",@"我的"];
        
        CGFloat space = (kScreenWidth-right_retain-33*3) / (item_count+1);
        for (int i=0; i<item_count; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(space+(33+space)*i, 18, 33, 33);
            btn.tag = base_tag + i;
            
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabbar-%@",images[i]]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabbar-%@-selected",images[i]]] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(itemChange:) forControlEvents:UIControlEventTouchUpInside];

            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(space/2+(space+33)*i, 16+33, space+33, 14)];
            lbl.tag = btn.tag + increment;
            lbl.font = Font(13);
            lbl.text = titles[i];
            lbl.textColor = [UIColor grayColor];
            lbl.textAlignment = NSTextAlignmentCenter;
            
            if (i == 0) {// 默认选中第1个
                if ([self.delegate respondsToSelector:@selector(BZTabBarSelectedIndexDidChange:)]) {
                    [self.delegate BZTabBarSelectedIndexDidChange:0];
                }
                btn.selected = YES;
                lbl.textColor = GLOBAL_COLOR;
            }
            [self.buttonList addObject:btn];
            [self.labelList addObject:lbl];
            [self addSubview:btn];
            [self addSubview:lbl];
            
            if (i == item_count-1) {// 购物车
                UIButton *shoppingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                shoppingBtn.frame = CGRectMake(kScreenWidth-80, 0, 80, 65);
                [shoppingBtn addTarget:self action:@selector(goHandle) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:shoppingBtn];
            }
        }
        self.badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-30, 5, 20, 20)];
        self.badgeLabel.backgroundColor = [UIColor redColor];
        self.badgeLabel.textAlignment = NSTextAlignmentCenter;
        self.badgeLabel.font = [UIFont systemFontOfSize:12];
        self.badgeLabel.text = @"0";
        self.badgeLabel.textColor = [UIColor whiteColor];
        [self.badgeLabel SetBorderWithcornerRadius:10.f BorderWith:0.f AndBorderColor:nil];
        self.badgeLabel.hidden = YES;
        [self addSubview:self.badgeLabel];
        
        int deviceWidth = [UIScreen mainScreen].bounds.size.width;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabbar-background-%d",deviceWidth]]];
    }
    return self;
}

- (void)goHandle {// current nav pop controller
    if ([self.delegate respondsToSelector:@selector(BZTabBarGoHandle:)]) {
        [self.delegate BZTabBarGoHandle:self];
    }
}

- (void)setBadgeCount:(int)badgeCount {// override
    self.badgeLabel.text = [NSString stringWithFormat:@"%d",badgeCount];
    if (badgeCount != 0) {
        self.badgeLabel.hidden = NO;
    } else {
        self.badgeLabel.hidden = YES;
    }
}

- (void)itemChange:(UIButton *)button {
    NSInteger index = button.tag - base_tag;
    // 添加点击动画
    NSDictionary *animationDict = self.animationList[index];
    [button.layer addAnimation:animationDict.allValues.firstObject forKey:animationDict.allKeys.firstObject];

    if ([self.delegate respondsToSelector:@selector(BZTabBarSelectedIndexDidChange:)]) {
        [self.delegate BZTabBarSelectedIndexDidChange:index];
    }
    
    for (UIButton *btn in self.buttonList) {
        if (btn.tag == button.tag) {
            btn.selected = YES;//把其他非选中的按钮 置为NO
        }else{
            btn.selected = NO;//选中
        }
    }
    for (UILabel *lbl in self.labelList) {
        if (lbl.tag == button.tag + increment) {
            lbl.textColor = GLOBAL_COLOR;
        }else{
            lbl.textColor = [UIColor grayColor];
        }
    }
}

- (void)skipToItemAction:(NSInteger)index { //跳到某一页
    NSDictionary *animationDict = [self.animationList objectAtIndex:index];
    
    for (UIButton *btn in self.buttonList) {
        if (btn.tag == base_tag+index) {
            btn.selected = YES;//把其他非选中的按钮 置为NO
            [btn.layer addAnimation:animationDict.allValues.firstObject forKey:animationDict.allKeys.firstObject];
        }else{
            btn.selected = NO;//选中
        }
    }
    for (UILabel *lbl in self.labelList) {
        if (lbl.tag == base_tag + index + increment) {
            lbl.textColor = GLOBAL_COLOR;
        }else{
            lbl.textColor = [UIColor grayColor];
        }
    }

}


@end
