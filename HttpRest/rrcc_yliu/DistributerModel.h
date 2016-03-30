//
//  distributerModel.h
//  rrcc_yh
//
//  Created by user on 15/10/8.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "BaseModel.h"

//配送(自提点)
@interface DistributerModel : BaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *sitename;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *distance;

@property (nonatomic, assign) BOOL isDefault;

@end

// 区域
@interface RegionModel : BaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *RegionCode;
@property (nonatomic, copy) NSString *RegionName;
@property (nonatomic, copy) NSString *Parentid;
@property (nonatomic, copy) NSString *IsDel;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *Parentcode;
@property (nonatomic, copy) NSString *ppCode;
@property (nonatomic, copy) NSString *active;

@end


//热销
@interface HotBrandModel : BaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;

@end

//QA
@interface QAModel : BaseModel

@property (nonatomic, copy) NSString *q;
@property (nonatomic, copy) NSString *a;

@end

//订单 操作action
@interface ActionModel : BaseModel

@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *title;

@end

//订单 状态status
@interface StatusModel : BaseModel

@property (nonatomic, copy) NSString *inserttime;
@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, assign) BOOL upViewHidden;
@property (nonatomic, assign) BOOL downViewHidden;

@end

//充值对象 (规则) 模型（描述一次充值）
@interface TopUpModel : BaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *has_paid;

@property (nonatomic, copy) NSString *expenditure;
@property (nonatomic, copy) NSString *referid;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *inserttime;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *transactionid;
@property (nonatomic, copy) NSString *transaction_id;

@property (nonatomic, copy) NSString *ordercode;

@property (nonatomic, copy) NSString *userid;

// 余额明细
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *present;

// 充值(规则)数额
@property (nonatomic, copy) NSString *isdel;
@property (nonatomic, copy) NSString *creator;

@property (nonatomic, assign) BOOL isSelected;

@end

//积分兑换规则 模型
@interface CreditRoleModel : BaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *gift_type;
@property (nonatomic, copy) NSString *gift_credit;
@property (nonatomic, copy) NSString *gift;
@property (nonatomic, copy) NSString *gift_title;
@property (nonatomic, copy) NSString *gift_limit;

@property (nonatomic, copy) NSString *gift_starttime;
@property (nonatomic, copy) NSString *gift_expired;
@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, copy) NSString *expired;

@property (nonatomic, copy) NSString *isdel;

@end







