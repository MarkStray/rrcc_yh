//
//  LYOrderStatesViewController.h
//  rrcc_yh
//
//  Created by user on 15/6/11.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "XHBaseViewController.h"

@interface OrderStatesViewController : XHBaseViewController

@property (nonatomic, copy) void (^OnNavBackBlock) (BOOL isRelateCheckOrder);// 是否和checkOrder(bool 有关)

@property (nonatomic, strong) UserOrderDetailModel *orderModel;

@end
