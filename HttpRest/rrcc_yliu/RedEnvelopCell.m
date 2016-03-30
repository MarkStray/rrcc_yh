//
//  RedEnvelopCell.m
//  rrcc_yh
//
//  Created by user on 15/11/6.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "RedEnvelopCell.h"

@interface RedEnvelopCell ()
@property (nonatomic, strong) UIView *giveUpUseView;
@end

@implementation RedEnvelopCell
{
    __weak IBOutlet UIImageView *bgImageView;
    __weak IBOutlet UILabel *fullLabel;
    __weak IBOutlet UILabel *subtractLabel;
    __weak IBOutlet UILabel *shareLabel;
    __weak IBOutlet UILabel *dateLabel;
}

- (void)awakeFromNib {
//    fullLabel.font = Font(14);
//    subtractLabel.font = Font(20);
//    shareLabel.font = Font(13);
//    dateLabel.font = Font(10);
}

- (UIView *)giveUpUseView {
    if (!_giveUpUseView) {
        _giveUpUseView = [ZZFactory viewWithFrame:self.bounds color:[UIColor whiteColor]];
        [ZZFactory imageViewWithFrame:self.bounds defaultImage:@"grayBox" superView:_giveUpUseView];
        UIButton *button = [ZZFactory buttonWithFrame:CGRectMake(0, 0, self.width, 30) title:@"放弃使用红包" titleColor:[UIColor darkGrayColor] image:nil bgImage:nil];
        button.enabled = NO;
        button.titleLabel.font = Font(20);
        button.center = _giveUpUseView.center;
        [button SetBorderWithcornerRadius:0.f BorderWith:1.f AndBorderColor:BACKGROUND_COLOR];
        [_giveUpUseView addSubview:button];
        [self addSubview:_giveUpUseView];
    }
    return _giveUpUseView;
}

- (void)updateUIUsingModel:(RedPageModel *)model {
    if (model.isLastest) {
        self.giveUpUseView.hidden = NO;
    } else {
        self.giveUpUseView.hidden = YES;
        
        NSString *imageN = [model.status isEqualToString:@"1"] ? @"redBox": @"grayBox";
        
        NSTimeInterval interval1 = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval interval2 = [[NSString stringToDate_yMd:model.start] timeIntervalSince1970];
        // 红包有效 未到使用时间
        if (interval1 < interval2) imageN = @"grayBox";
        // 选中的某个红包
        if (model.isSelected) imageN = @"redBoxSelected";
        
        bgImageView.image = [UIImage imageNamed:imageN];
        
        fullLabel.text = [NSString stringWithFormat:@"满%@元减",model.limit];
        subtractLabel.text = [NSString stringWithFormat:@"￥%@",model.discount];
        shareLabel.text = model.title;
        dateLabel.text = [NSString stringWithFormat:@"%@至%@",model.start,model.expired];
    }
}

@end
