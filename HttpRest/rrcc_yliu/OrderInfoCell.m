//
//  OrderInfoCell.m
//  rrcc_yh
//
//  Created by user on 15/7/13.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "OrderInfoCell.h"

@implementation OrderInfoCell

- (void)awakeFromNib {
    // 鲜店字体没有改
//    self.nameLabel.font = Font(14);
//    self.avgLabel.font = Font(14);
//    self.priceLabel.font = Font(14);
//    self.countLabel.font = Font(14);
    
    [self.brandLbl SetBorderWithcornerRadius:5.f BorderWith:1.f AndBorderColor:GLOBAL_COLOR];
}
- (void)showDataUsingModel:(ProductsModel *)model {
    sd_image_url(self.logoImg, model.imgurl);
    self.nameLabel.text = model.skuname;
    self.avgLabel.text = model.spec;
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.total];
    
//    if (model.onsale.integerValue == 0) {
//        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.total];
//    } else {
//        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.saleprice];
//    }

    self.countLabel.text = [NSString stringWithFormat:@"x%@",model.ordercount];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
