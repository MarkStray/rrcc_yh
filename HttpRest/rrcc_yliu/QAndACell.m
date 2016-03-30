//
//  QAndACell.m
//  rrcc_yh
//
//  Created by user on 15/10/23.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "QAndACell.h"

@implementation QAndACell


- (void)awakeFromNib {
    // Initialization code
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
//    // need to use to set the preferredMaxLayoutWidth below.
//    [self.contentView setNeedsLayout];
//    [self.contentView layoutIfNeeded];
//    
//    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
//    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
//    self.qLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.qLabel.frame);
//    self.aLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.aLabel.frame);
//}

- (CGFloat)updateUIUsingModel:(QAModel *)model {
    CGFloat _cellHeight = 40.f;
    self.qLabel.text = model.q;
    self.qLabel.font = Font(16);
    
    _cellHeight += [BZ_Tools heightForTextString:model.q width:kScreenWidth-16*2-24 fontSize:16];
    
    self.aLabel.text = model.a;
    self.aLabel.font = Font(16);
    _cellHeight += [BZ_Tools heightForTextString:model.a width:kScreenWidth-16*2-24 fontSize:16];

    return  _cellHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
