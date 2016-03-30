//
//  MainDoubleCell.m
//  rrcc_yh
//
//  Created by user on 15/10/21.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "MainDoubleCell.h"

@implementation MainDoubleCell
{
    __weak IBOutlet UIImageView *_left_logoImg;
    __weak IBOutlet UILabel *_left_nameLabel;
    __weak IBOutlet UILabel *_left_salePriceLabel;
    __weak IBOutlet LineLabel *_left_priceLabel;
    
    __weak IBOutlet UIImageView *_right_logoImg;
    __weak IBOutlet UILabel *_right_nameLabel;
    __weak IBOutlet UILabel *_right_salePriceLabel;
    __weak IBOutlet LineLabel *_right_priceLabel;
    
    UIButton *_left_handleBtn;
    UIButton *_right_handleBtn;
}
- (void)awakeFromNib {
    
    _left_nameLabel.font = Font(14);
    _left_salePriceLabel.font = Font(14);
    _left_priceLabel.font = Font(14);
    
    _right_nameLabel.font = Font(14);
    _right_salePriceLabel.font = Font(14);
    _right_priceLabel.font = Font(14);

    
    _left_priceLabel.isWithStrikeThrough = YES;
    _right_priceLabel.isWithStrikeThrough = YES;

    _left_handleBtn = [ZZFactory buttonWithFrame:CGRectMake(0, 0, self.width/2, self.height) title:nil titleColor:nil image:nil bgImage:nil];
    [_left_handleBtn addTarget:self action:@selector(leftHandle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_left_handleBtn];
    
    _right_handleBtn = [ZZFactory buttonWithFrame:CGRectMake(self.width/2, 0, self.width/2, self.height) title:nil titleColor:nil image:nil bgImage:nil];
    [_right_handleBtn addTarget:self action:@selector(rightHandle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_right_handleBtn];
}

- (void)leftHandle {
    ProductsModel *model = self.items.firstObject;
    if (self.handleTypeCB) self.handleTypeCB(model);
}

- (void)rightHandle {
    ProductsModel *model = self.items.lastObject;
    if (self.handleTypeCB) self.handleTypeCB(model);
}

- (void)updateUIUsingModel:(NSArray *)items complete:(void (^) (ProductsModel *model))handle {
    self.handleTypeCB = handle;
    self.items = items;
    
    ProductsModel *leftModel = items.firstObject;
    sd_image_url(_left_logoImg, leftModel.imgurl);
    _left_nameLabel.text = [NSString stringWithFormat:@"%@ %@g",leftModel.skuname,leftModel.avgweight];

    if (leftModel.onsale.integerValue == 0) {
        _left_salePriceLabel.text = [NSString stringWithFormat:@"￥%@",leftModel.price];

        _left_priceLabel.hidden = YES;
        
    } else {
        _left_salePriceLabel.text = [NSString stringWithFormat:@"￥%@",leftModel.saleprice];

        _left_priceLabel.hidden = NO;
        _left_priceLabel.text = [NSString stringWithFormat:@"￥%@",leftModel.price];

    }
    
    ProductsModel *rightModel = items.lastObject;
    sd_image_url(_right_logoImg, rightModel.imgurl);
    _right_nameLabel.text = [NSString stringWithFormat:@"%@ %@g",rightModel.skuname,rightModel.avgweight];

    if (rightModel.onsale.integerValue == 0) {
        _right_salePriceLabel.text = [NSString stringWithFormat:@"￥%@",rightModel.price];

        _right_priceLabel.hidden = YES;
        
    } else {
        _right_salePriceLabel.text = [NSString stringWithFormat:@"￥%@",rightModel.saleprice];

        _right_priceLabel.hidden = NO;
        _right_priceLabel.text = [NSString stringWithFormat:@"￥%@",rightModel.price];

    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
