//
//  MineCell.m
//  rrcc_yh
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "MineCell.h"

@implementation MineCell
{
    __weak IBOutlet UIImageView *logoImg;
    
    __weak IBOutlet UILabel *titleLabel;
    
    __weak IBOutlet UILabel *detailLabel;
    
    __weak IBOutlet UIView *bottomView;
}
- (void)awakeFromNib {
    titleLabel.font = Font(14);
    detailLabel.font = Font(12);
}

- (void)updateUIUsingImage:(NSString *)imageN
            lineViewHidden:(BOOL)hidden
                     title:(NSString *)title
                    detail:(NSString *)detail
                     color:(UIColor *)detailColor {
    logoImg.image = [UIImage imageNamed:imageN];
    titleLabel.text = title;
    detailLabel.text = detail;
    detailLabel.textColor = detailColor;
    bottomView.hidden = hidden;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
