//
//  presellModel.h
//  rrcc_yh
//
//  Created by user on 15/10/27.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "BaseModel.h"

@interface PresellModel : BaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *banner;
@property (nonatomic, copy) NSString *payonline;
@property (nonatomic, copy) NSString *payondelivery;
@property (nonatomic, copy) NSString *samedaydelivery;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *shop_desc;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *order_count;
@property (nonatomic, copy) NSString *min_order;
@property (nonatomic, copy) NSString *free_delivery;
@property (nonatomic, copy) NSString *delivery_cost;
@property (nonatomic, copy) NSString *delivery_time;
@property (nonatomic, copy) NSString *discount_limit;
@property (nonatomic, copy) NSString *discount;
@property (nonatomic, copy) NSString *gift_limit;
@property (nonatomic, copy) NSString *gift;
@property (nonatomic, copy) NSString *onsale;
@property (nonatomic, copy) NSString *isopen;

@end
