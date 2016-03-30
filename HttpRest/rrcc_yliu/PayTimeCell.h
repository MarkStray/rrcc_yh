//
//  PayTimeCell.h
//  rrcc_yh
//
//  Created by user on 16/1/7.
//  Copyright © 2016年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTimeCell : UITableViewCell

// 返回预约时间 //返回 数据源
@property (nonatomic, copy) void (^updateTimeAction) (BOOL isNeedSetUp, NSString *appointment,NSArray *dateTimeArray);

// pop pickerView
@property (nonatomic, copy) void (^selectTimeAction) ();

- (void)showDeliveryTimeWithModel:(DeliveryModel *)model index:(NSInteger)index;

@end
