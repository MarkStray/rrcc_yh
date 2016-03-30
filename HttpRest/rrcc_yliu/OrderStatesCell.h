//
//  OrderStatesCell.h
//  rrcc_yh
//
//  Created by user on 15/6/11.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStatesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *upView;

@property (weak, nonatomic) IBOutlet UIView *downView;

@property (weak, nonatomic) IBOutlet UIImageView *orderStateImageView;

@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;

@end
