//
//  PayManager.m
//  rrcc_yh
//
//  Created by user on 15/10/30.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "PayEngine.h"

#import <AlipaySDK/AlipaySDK.h>// 支付宝
#import "AliPayHeader.h"

#import "WXApi.h"// 微信
#import "payRequsestHandler.h"

@interface PayEngine ()

@end

@implementation PayEngine

+ (instancetype)sharedPay {
    static id _s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s = [[PayEngine alloc] init];
    });
    return _s;
}

#pragma mark - 发起支付
////////////////////////////////////////////////////////////////////////


// 发起支付
- (void)sendPayType:(PayEngineType)payType totalPrice:(NSString *)totalPrice orderModel:(UserOrderDetailModel *)orderModel {
    DLog(@"支付金额: %@",totalPrice);
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TestSwitch" ofType:@"plist"];
    NSDictionary *testDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    BOOL isTest = [(NSNumber *)testDict[@"isTest"] boolValue];

    if (payType == PayEngineTypeWX) {/*微信支付*/
        
        if (isTest) {
            [self sendWXPayTotalPrice:@"1" orderModel:orderModel];
        } else {
            NSString *WxpayPrice = [NSString stringWithFormat:@"%.f",totalPrice.floatValue * 100];//参数值不能带小数点 默认为分
            [self sendWXPayTotalPrice:WxpayPrice orderModel:orderModel];
        }
        
    } else if (payType == PayEngineTypeAli) { /*支付宝支付*/
        
        
        if (isTest) {
            [self sendAliPayTotalPrice:@"0.01" orderModel:orderModel];
        } else {
            [self sendAliPayTotalPrice:totalPrice orderModel:orderModel];
        }
        
    }

}


//////////////////////////generateTradeNO////////////////////////////

- (NSString *) generateTradeNO {// 交易流水号
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand( (unsigned) time(NULL));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

//////////////////////////Alipay////////////////////////////
#pragma mark - 支付宝支付

- (void)sendAliPayTotalPrice:(NSString *)totalPrice orderModel:(UserOrderDetailModel *)orderModel {
    /* 1.生成订单信息 */
    Order *order = [[Order alloc] init];
    order.partner = aPartnerID;
    order.seller = aSellerID;
    
    order.tradeNO = orderModel.transaction_id;//[self generateTradeNO];// 订单ID(由商家自行制定)
    order.productName = orderModel.clientname; // 商品名称
    order.productDescription = orderModel.clientid; // 商品描述
    order.amount = totalPrice;
    
    order.notifyURL = @"http://shop.renrencaichang.com/order/zfbnotifydiff";
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";// 支付时间
    order.showUrl = @"m.alipay.com";
    order.appID = aAppId;
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"rrcc2015081300213630";// 用appId作为 URLScheme
    /* 2.签名 */
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(aPrivateKey);
    // 使用私钥描述字符串
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        // 3.调用 支付宝客户端 进行支付 传入我们的 appSchema
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if ([self.delegate respondsToSelector:@selector(PayEngineType:result:)]) {
                [self.delegate PayEngineType:PayEngineTypeAli result:resultDic];
            }
        }];
    }
}
/*
 memo = "";
 result = "partner=\"2088911426319321\"&seller_id=\"Shirley@renrencaichang.com\"&out_trade_no=\"Z1LLNWQD9R27508\"&subject=\"\U5546\U54c1\U540d\U79f0\"&body=\"\U5546\U54c1\U63cf\U8ff0\"&total_fee=\"0.01\"&notify_url=\"http://www.baidu.com\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"&success=\"true\"&sign_type=\"RSA\"&sign=\"ZZqZLqq6BE3KDfL+DNBWKKxbuDEtHA7Acs38uSZAqlAXMNrma/MShkh+iWydHSSIDKUENBYOPZU/pJYLftUoobucld4Hdo3q1ZuX8na4z7LwjiV4UDyN755iG4ADRmFgJgWPTNPgwTDtSAsOM3+hvQBf+ffM9lD9siF3IbZH0To=\"";
 resultStatus = 9000;
 */

//////////////////////////WXpay////////////////////////////
#pragma mark - 微信支付

// 回调在 appDelegate 中
- (void)sendWXPayTotalPrice:(NSString *)totalPrice orderModel:(UserOrderDetailModel *)orderModel {
    DLog(@"%@",orderModel);
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req initWithAppId:APP_ID mch_id:MCH_ID orderName:orderModel.clientname orderPrice:totalPrice orderNO:orderModel.transaction_id];
    //设置密钥
    [req setKey:PARTNER_KEY];
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay];
    
    if(dict){
        
        PayReq *pay             = [[PayReq alloc] init];//调起微信支付
        pay.openID              = [dict objectForKey:@"appid"];
        pay.partnerId           = [dict objectForKey:@"partnerid"];
        pay.prepayId            = [dict objectForKey:@"prepayid"];
        pay.nonceStr            = [dict objectForKey:@"noncestr"];
        pay.timeStamp           = [[dict objectForKey:@"timestamp"] intValue];
        pay.package             = [dict objectForKey:@"package"];
        pay.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:pay];
    }
}

- (void)setResp:(BaseResp *)resp {
    _resp = resp;
    if ([self.delegate respondsToSelector:@selector(PayEngineType:result:)]) {
        [self.delegate PayEngineType:PayEngineTypeWX result:resp];
    }
}

@end
