//
//  SiteCell.m
//  rrcc_yh
//
//  Created by user on 15/6/17.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "SiteCell.h"

@implementation SiteCell {
    __weak IBOutlet UILabel *_titleLabel;
    
    __weak IBOutlet UILabel *_detailLabel;
}

- (void)updateUIUsingModel:(SiteListModel *)model{
    _titleLabel.text = model.domainname;
    _titleLabel.font = Font(16);
    _detailLabel.text = model.address;
    _detailLabel.font = Font(14);
}
- (IBAction)posButtonClick:(id)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
