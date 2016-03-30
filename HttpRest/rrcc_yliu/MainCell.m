//
//  MainCell.m
//  rrcc_yh
//
//  Created by user on 15/10/21.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "MainCell.h"

@interface MainCell ()

@end

@implementation MainCell
{
    __weak IBOutlet UIImageView *_logoImg;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_specLabel;
    __weak IBOutlet UILabel *_salePriceLabel;
    __weak IBOutlet LineLabel *_priceLabel;
    
    UIButton *_handleBtn;
}

- (void)awakeFromNib {
    
    _nameLabel.font = Font(16);
    _specLabel.font = Font(14);
    _salePriceLabel.font = Font(16);
    _priceLabel.font = Font(14);

    _priceLabel.isWithStrikeThrough = NO;
    
    _handleBtn = [ZZFactory buttonWithFrame:CGRectMake(0, 0, self.width, self.height) title:nil titleColor:nil image:nil bgImage:nil];
    [_handleBtn addTarget:self action:@selector(handle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_handleBtn];
}

- (void)handle {
    ProductsModel *model = self.items.lastObject;
    if (self.handleTypeCB) self.handleTypeCB(model);
}

- (void)updateUIUsingModel:(NSArray *)items complete:(void (^) (ProductsModel *model))handle {
    self.handleTypeCB = handle;
    self.items = items;
    
    ProductsModel *model = items.firstObject;
    sd_image_url(_logoImg, model.imgurl);
    _nameLabel.text = model.skuname;
    _specLabel.text = model.spec;
    if (model.onsale.integerValue == 0) {
        _salePriceLabel.text = [NSString stringWithFormat:@"特价:￥%@",model.price];
        _priceLabel.hidden = YES;
        
    } else {
        _salePriceLabel.text = [NSString stringWithFormat:@"特价:￥%@",model.saleprice];
        _priceLabel.hidden = NO;
        _priceLabel.text = [NSString stringWithFormat:@"市场参考价￥%@",model.price];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
