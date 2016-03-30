//
//  SalaryCell.m
//  rrcc_yh
//
//  Created by user on 15/9/20.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "SalaryCell.h"

@implementation SalaryCell


- (void)awakeFromNib {
    self.priceLbl.font = Font(25);
    self.validLbl.font = Font(14);
    
    self.titleLbl.font = Font(14);
    self.reguLbl.font = Font(14);
    self.deadLineLbl.font = Font(14);
}

- (void)updateUIUsingModel:(RedPageModel *)model {
    self.priceLbl.text = [NSString stringWithFormat:@"￥%.1f",model.discount.floatValue];
    self.titleLbl.text = model.title;
    
    NSTimeInterval interval1 = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval interval2 = [[NSString stringToDate_yMd:model.start] timeIntervalSince1970];
    if (interval1 < interval2) {//不可用颜色
        self.validLbl.textColor = [UIColor lightGrayColor];
    } else {//可用颜色
        self.validLbl.textColor = [UIColor redColor];
    }

    self.reguLbl.text = [NSString stringWithFormat:@"· 满%@元可用",model.limit];
    self.deadLineLbl.text = [NSString stringWithFormat:@"· %@至%@",model.start,model.expired];
}

@end
