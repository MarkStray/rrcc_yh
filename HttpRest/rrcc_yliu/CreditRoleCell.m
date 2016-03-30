//
//  CreditRoleCell.m
//  rrcc_yh
//
//  Created by user on 15/12/23.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "CreditRoleCell.h"

@implementation CreditRoleCell
{

    __weak IBOutlet UIImageView *creditBackgroundView;
    
    __weak IBOutlet UILabel *giftLabel;
    
    __weak IBOutlet UILabel *giftTitleLabel;
    
    __weak IBOutlet UILabel *giftLimitLabel;
    
    __weak IBOutlet UILabel *expiredLabel;
    
    __weak IBOutlet UILabel *converTabel;
    
    __weak IBOutlet UILabel *giftCreditLabel;
    
}

- (void)awakeFromNib {
//    giftLabel.font = BoldFont(24);
//    giftTitleLabel.font = Font(14);
//    giftLimitLabel.font = Font(14);
//    expiredLabel.font = Font(14);
//    
//    converTabel.font = Font(16);
//    giftCreditLabel.font = Font(10);
}

- (void)updateUIWithModel:(CreditRoleModel *)model
{
    giftLabel.text = model.gift;
    giftTitleLabel.text = [NSString stringWithFormat:@"元 【%@】",model.gift_title];
    giftLimitLabel.text = [NSString stringWithFormat:@"满%@元可用",model.gift_limit];
    
    expiredLabel.text = [NSString stringWithFormat:@"有效期至:%@",model.expired];
    giftCreditLabel.text = [NSString stringWithFormat:@"扣%@分",model.gift_credit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
