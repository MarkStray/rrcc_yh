//
//  MyOrderCell.m
//  rrcc_yh
//
//  Created by user on 15/7/13.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "OrderListCell.h"

@implementation OrderListCell
{
    __weak IBOutlet UILabel *orderID;

    __weak IBOutlet UILabel *orderStatesLabel;
    
    __weak IBOutlet UILabel *shopName;
    
    __weak IBOutlet UILabel *goodsNum;
    
    __weak IBOutlet UILabel *totalPrice;
    
    __weak IBOutlet UILabel *dateTime;
    
}

- (void)awakeFromNib {
    
    orderID.font = Font(14);
    orderStatesLabel.font = Font(14);
    shopName.font = Font(14);
    goodsNum.font = Font(14);
    totalPrice.font = Font(14);
    dateTime.font = Font(14);
    
}

- (void)showDataUsingModel:(UserOrderDetailModel *)model{
    orderID.text = [NSString stringWithFormat:@"订单号:%@",model.ordercode];
    
    orderStatesLabel.text = model.status_title;
    
    shopName.text = [[model.address componentsSeparatedByString:@" "] firstObject];
    
    goodsNum.text = [NSString stringWithFormat:@"共%@件商品",model.ordercount];
    
    totalPrice.text = [NSString stringWithFormat:@"合计:￥%@",model.tolprice];
    
    dateTime.text = model.inserttime;
}

@end
