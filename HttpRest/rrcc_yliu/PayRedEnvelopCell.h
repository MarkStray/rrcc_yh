//
//  PayRedEnvelopCell.h
//  rrcc_yh
//
//  Created by user on 15/11/5.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayRedEnvelopCell : UITableViewCell 

@property (nonatomic, copy) void (^openBlock) (BOOL isOpen);

- (void)updateUIUsingArray:(NSMutableArray *)array
                  tolPrice:(NSString *)price
                  complete:(void (^) (RedPageModel *model))completeCB;

@end
