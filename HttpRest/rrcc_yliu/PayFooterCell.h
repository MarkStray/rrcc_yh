//
//  PayFooterCell.h
//  rrcc_yh
//
//  Created by user on 15/11/5.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayFooterCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic, copy) void (^editingStatusBlock) (BOOL isEdit);

@property (nonatomic, copy) void (^remarkBlock) (NSString *remark);

@end
