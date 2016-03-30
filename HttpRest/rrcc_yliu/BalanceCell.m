//
//  BalanceCell.m
//  rrcc_yh
//
//  Created by user on 15/12/18.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "BalanceCell.h"

@implementation BalanceCell
{
    __weak IBOutlet UILabel *titleLabel;
    
    __weak IBOutlet UILabel *updateLabel;
    
    
    __weak IBOutlet UILabel *statusLabel;
    
    __weak IBOutlet UILabel *presentLabel;
    
}
- (void)awakeFromNib {
    titleLabel.font = Font(14);
    updateLabel.font = Font(12);
    statusLabel.font = Font(14);
    presentLabel.font = Font(14);
}

- (void)updateUIWithModel:(TopUpModel *)model {
    
    titleLabel.text = model.title;


    if (![model.ordercode isEqualToString:@""]) {
        
        NSString *titleStr = [NSString stringWithFormat:@"%@ (%@)",model.title,model.ordercode];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
        
        [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:Font(12)} range:NSMakeRange(5, titleStr.length-5)];
        
        titleLabel.attributedText = attrStr;
    }
    
    updateLabel.text = model.updatetime;
    
    NSString *status = nil;
    
    // 1.新记录   2.成功   3失败
//    if ([model.status isEqualToString:@"1"]) {
//        statusLabel.textColor = [UIColor darkGrayColor];
//        status = @"新纪录";
//    } else if ([model.status isEqualToString:@"2"]) {
//        statusLabel.textColor = [UIColor redColor];
//        status = @"成功";
//    } else if ([model.status isEqualToString:@"3"]) {
//        statusLabel.textColor = [UIColor lightGrayColor];
//        status = @"失败";
//    }
    
    
    if ([model.status isEqualToString:@"2"]) {
        statusLabel.textColor = [UIColor redColor];
        status = @"成功";
    } else {
        statusLabel.textColor = [UIColor lightGrayColor];
        status = @"失败";
    }
    statusLabel.text = status;
    
    NSString *subStr = @"+";
    
    //1.充值  2.消费  4.退款
    if ([model.type isEqualToString:@"2"]) {
        subStr = @"-";
    }
    
    if ([model.present isEqualToString:@""] ||
        [model.present integerValue] == 0 ||
        model.present == nil) {
        presentLabel.text = [NSString stringWithFormat:@"%@%@",subStr,model.expenditure];
    } else {
        presentLabel.text = [NSString stringWithFormat:@"%@%@(赠%@)",subStr,model.expenditure,model.present];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
