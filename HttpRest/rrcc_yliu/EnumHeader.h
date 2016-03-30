//
//  EnumHeader.h
//  rrcc_yh
//
//  Created by user on 16/1/4.
//  Copyright © 2016年 ting liu. All rights reserved.
//

#ifndef EnumHeader_h
#define EnumHeader_h

/**网络请求方式*/
typedef NS_ENUM(NSUInteger, DataRequestType) {
    GET = 0,
    POST,
    PUT,
    DELETE,
    OPTIONS,
};

/**支付方式*/
typedef NS_ENUM(NSInteger, PayEngineType) {
    PayEngineTypeNone = 0,
    PayEngineTypeDelivery,
    PayEngineTypeWX,
    PayEngineTypeAli,
    PayEngineTypeBalance,
};

/**是否支付*/
typedef NS_ENUM(NSInteger, ActionButtonType) {
    ActionButtonTypeCancel = 0,
    ActionButtonTypeConfirm
};

#endif /* EnumHeader_h */
