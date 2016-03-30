//
//  OrderStatesCell.m
//  rrcc_yh
//
//  Created by user on 15/6/11.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "OrderStatesCell.h"

@implementation OrderStatesCell

- (void)awakeFromNib {
    self.orderStateLabel.font = Font(16);
    self.orderTimeLabel.font = Font(12);
    self.orderDetailLabel.font = Font(14);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
