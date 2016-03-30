//
//  OrderInfoCell.h
//  rrcc_yh
//
//  Created by user on 15/7/13.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *brandLbl;

@property (weak, nonatomic) IBOutlet UIImageView *logoImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *avgLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)showDataUsingModel:(ProductsModel *)model;

@end
