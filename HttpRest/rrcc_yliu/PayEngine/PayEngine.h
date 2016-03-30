//
//  PayManager.h
//  rrcc_yh
//
//  Created by user on 15/10/30.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PayEngineDelegate;
@class BaseResp;

@interface PayEngine : NSObject

@property (nonatomic, assign) id<PayEngineDelegate> delegate;

//从 AppDelegate 微信获取支付结果
@property (nonatomic, strong) BaseResp *resp;

// 初始化
+ (instancetype)sharedPay;

// 发起支付
- (void)sendPayType:(PayEngineType)payType totalPrice:(NSString *)totalPrice orderModel:(UserOrderDetailModel *)orderModel;

@end


/**支付协议*/
@protocol PayEngineDelegate <NSObject>

// 处理支付结果
@required

- (void)PayEngineType:(PayEngineType)payType result:(id)resultData;

@end
