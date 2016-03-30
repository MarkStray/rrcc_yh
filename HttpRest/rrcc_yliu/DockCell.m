//
//  DockCell.m
//  rrcc_yh
//
//  Created by user on 15/6/29.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "DockCell.h"

@implementation DockCell

- (void)awakeFromNib {
    self.titleLabel.font = Font(14);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.titleLabel.textColor = GLOBAL_COLOR;
    } else {
        self.titleLabel.textColor = [UIColor darkGrayColor];
    }
}

@end
