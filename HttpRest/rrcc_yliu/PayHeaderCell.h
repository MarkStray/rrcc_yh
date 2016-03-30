//
//  PayHeaderCell.h
//  rrcc_yh
//
//  Created by user on 15/11/5.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayHeaderCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *contactTextField;
@property (nonatomic, weak) IBOutlet UITextField *telTextField;

@property (nonatomic, copy) void (^contactBlock) (NSString *contact);
@property (nonatomic, copy) void (^mobileBlock) (NSString *mobile);

@end
