//
//  PayTypeCell.h
//  rrcc_yh
//
//  Created by user on 15/11/5.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  去充值
 */
typedef void (^TopUpAction) ();

@interface PayTypeCell : UITableViewCell

@property (nonatomic, copy) TopUpAction topUpAction;

- (void)showPayMethodWithModel:(PayMethodModel *)model;

@end
