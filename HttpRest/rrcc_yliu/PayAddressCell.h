//
//  PayAddressCell.h
//  rrcc_yh
//
//  Created by user on 16/1/6.
//  Copyright © 2016年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayAddressCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *deliveryTitleLabel;

@property (nonatomic, weak) IBOutlet UILabel *referTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *cheakButton;

@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

@property (nonatomic, copy) void (^addressBlock) (NSString *address);

@end
