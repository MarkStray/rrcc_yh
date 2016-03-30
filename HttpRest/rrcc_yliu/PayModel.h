//
//  PayMethodModel.h
//  rrcc_yh
//
//  Created by user on 16/1/7.
//  Copyright © 2016年 ting liu. All rights reserved.
//

#import "BaseModel.h"

//配送方式
@interface DeliveryModel : BaseModel

@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *deliveryTitle;
@property (nonatomic, copy) NSString *checked;
@property (nonatomic, copy) NSString *referTitle;

// 包含今日收获 明日收货的时间数组(多个)
@property (nonatomic, strong) NSMutableArray *deliveryList;

@end

//货物提取方式
@interface TakeDescModel : BaseModel

@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *checked;
@property (nonatomic, copy) NSString *timeArrayDisplay;//wx

@end

//时间
@interface TimeModel : BaseModel

@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *timeTitle;

@end

// 红包
@interface RedPageModel : BaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *discount;
@property (nonatomic, copy) NSString *expired;
@property (nonatomic, copy) NSString *limit;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) BOOL isSelected;//是否选中
@property (nonatomic, assign) BOOL isLastest;//最后一个

//@property (nonatomic, copy) NSString *inserttime;
//@property (nonatomic, copy) NSString *updatetime;
//@property (nonatomic, copy) NSString *ref;
//@property (nonatomic, copy) NSString *openid;
//@property (nonatomic, copy) NSString *nickname;
//@property (nonatomic, copy) NSString *avatar;

@end

// 支付方式
@interface PayMethodModel : BaseModel

@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *checked;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *checkImgStatus;
@property (nonatomic, copy) NSString *balance;

@property (nonatomic, assign) BOOL lineHidden;

@end
