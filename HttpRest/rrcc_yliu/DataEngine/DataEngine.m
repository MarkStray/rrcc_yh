//
//  DataEngine.m
//  rrcc_yh
//
//  Created by user on 15/6/12.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "DataEngine.h"


@implementation DataEngine
{
    NSString *_privateKey;
    NSString *_userId;
    NSString *_timeStamp;
    NSString *_payload;
    
    //NSTimeInterval _threshold;//定位限制
    BOOL _isClose;
}

+ (id)sharedInstance {
    static id _s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s = [[[self class] alloc] init];
    });
    return _s;
}


- (void)ConfigDataWith:(PlayerInfoModel *)PIModel {
    _privateKey = PIModel.privateKey;
    _userId = PIModel.userid;
}
/*---用户登录---*/
/* 获取&验证 验证码 */
- (void)requestUserCaptchaDataWithMobile:(NSString *)mobile
                                   captcha:(NSString *)captcha
                                   success:(SuccessBlockType)successCallBack
                                    failed:(FailedBlockType)failedCallBack {
    if (captcha == nil) {//获取
        UIDevice *device =[[UIDevice alloc] init];
        NSString *deviceInfo = [NSString stringWithFormat:@"%@%@%@%@%@",@"IOS:",device.model,@"(",device.systemVersion,@")"];
        NSDictionary *captchaDic = [[NSDictionary alloc] initWithObjectsAndKeys:mobile,@"mobile", deviceInfo,@"device",nil];
        DLog(@"UserCaptch--%@",UserCaptch);
        [self requestDataWithBaseUrl:UserCaptch parameter:captchaDic Success:successCallBack failed:failedCallBack requestType:POST];
        return ;
    }
    //验证
    NSDictionary *loginDic = @{@"captcha":captcha,@"mobile":mobile};
    DLog(@"UserCaptch--%@",UserCaptch);
    [self requestDataWithBaseUrl:UserCaptch parameter:loginDic Success:successCallBack failed:failedCallBack requestType:PUT];
}

/*---首页---*/
/* 请求城市列表数据 */
- (void)requestCityListDataSuccess:(SuccessBlockType)successCallBack
                            failed:(FailedBlockType)failedCallBack {
    DLog(@"CityListUrl--%@",CityList);
    [self requestDataWithBaseUrl:CityList parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/* 请求小区列表数据 */
- (void)requestSiteListDataWithCityId:(NSString *)cityId
                                 name:(NSString *)name
                             latitude:(NSString *)lat
                            longitude:(NSString *)lon
                              success:(SuccessBlockType) successCallBack
                               failed:(FailedBlockType) failedCallBack {
    
//    _threshold = [[NSDate date] timeIntervalSince1970];
//    DLog(@"%f",_threshold);
    if (!_isClose) {  // !_isOpen 默认不关闭  打开  防重入开关
        _isClose = YES;
        NSString *url = [NSString stringWithFormat:SiteList,cityId,name,lat,lon];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        DLog(@"SiteListUrl--%@",url);
        [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
    }
}

/* 请求区域数据 */
- (void)requestCityDistrictListDataWithCityId:(NSString *)cityId
                                      Success:(SuccessBlockType) successCallBack
                                       failed:(FailedBlockType) failedCallBack {
    NSString *url = [NSString stringWithFormat:DistributerList,cityId];
    DLog(@"CityDistrictList--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/* 判断自提点是否关闭数据 */
- (void)requestCityDistributerActiveDataWithDistributerId:(NSString *)distributerId
                                                  Success:(SuccessBlockType) successCallBack
                                                   failed:(FailedBlockType) failedCallBack {
    NSString *url = [NSString stringWithFormat:DistributerActive,distributerId];
    DLog(@"DistributerActive--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}


/* 小区产品数据 */
- (void)requestSiteProductListDataWithSiteId:(NSString *)siteId
                                     Success:(SuccessBlockType) successCallBack
                                      failed:(FailedBlockType) failedCallBack {
    NSString *url = [NSString stringWithFormat:SiteMarket,siteId];
    DLog(@"SiteMarket--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}



/* 请求小区商户列表数据 */
- (void)requestSiteShopListDataWithSiteId:(NSString *)siteId
                                   offset:(NSInteger)offset
                                    limit:(NSInteger)limit
                                  success:(SuccessBlockType)successCallBack
                                   failed:(FailedBlockType)failedCallBack {
    NSString *url = [NSString stringWithFormat:SiteShopList,siteId,(long)offset,(long)limit];
    DLog(@"SiteShopListUrl--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/* 获取商户产品信息 */
- (void)requestUserShopProductListDataWithSiteShopId:(NSString *)shopId
                                             success:(SuccessBlockType)successCallBack
                                              failed:(FailedBlockType)failedCallBack {
    NSString *url = [NSString stringWithFormat:UserShopProductList,shopId];
    DLog(@"UserShopProductList--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/* 获取产品详情 */
- (void)requestUserProductDetailsDataWithSiteProductId:(NSString *)productId
                                            success:(SuccessBlockType)successCallBack
                                             failed:(FailedBlockType)failedCallBack {
    NSString *url = [NSString stringWithFormat:UserProductDetails,productId];
    DLog(@"UserProductDetails--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/* 获取商户详情信息 */
- (void)requestShopDetailsDataWithShopId:(NSString *)shopId
                                 success:(SuccessBlockType)successCallBack
                                  failed:(FailedBlockType)failedCallBack {
    NSString *url = [NSString stringWithFormat:ShopDetails,shopId];
    DLog(@"ShopDetails--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/* 获取商户评价列表信息 */
- (void)requestShopAppraiseListDataWithShopId:(NSString *)shopId
                                      orderId:(NSString *)orderId
                                       offset:(NSInteger)offset
                                        limit:(NSInteger)limit
                                      success:(SuccessBlockType)successCallBack
                                       failed:(FailedBlockType)failedCallBack {
    NSString *url = [NSString stringWithFormat:ShopAppraiseList,shopId,orderId,(long)offset,(long)limit];
    DLog(@"ShopAppraiseList--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/* 获取商户活动信息 */
- (void)requestRshopPromotionListDataWithShopId:(NSString *)shopId
                                        success:(SuccessBlockType)successCallBack
                                         failed:(FailedBlockType)failedCallBack {
    NSString *url = [NSString stringWithFormat:RshopPromotionList,shopId];
    DLog(@"RshopPromotionList--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/*---用户管理---*/
/* 读取用户信息 */
- (void)requestUserDataSuccess:(SuccessBlockType)successCallBack
                        failed:(FailedBlockType)failedCallBack {
    _timeStamp = [[Utility Share] GetUnixTime];
    NSString *publicKey = [self publicKeyWithResourceId:_userId timestamp:_timeStamp payload:@""];
    NSString *url = [NSString stringWithFormat:User,_userId,_userId,_timeStamp,publicKey];
    DLog(@"User--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/* 读取用户地址列表 */
- (void)requestUserAddressListDataSuccess:(SuccessBlockType)successCallBack
                                   failed:(FailedBlockType)failedCallBack {
    _timeStamp = [[Utility Share] GetUnixTime];
    NSString *publicKey = [self publicKeyWithResourceId:_userId timestamp:_timeStamp payload:@""];
    
    publicKey = [NSString stringWithFormat:@"%@%@%@",_privateKey,_timeStamp,@""].md5;//motify
    
    NSString *url = [NSString stringWithFormat:UserAddressList,_userId,_userId,_timeStamp,publicKey];
    DLog(@"UserAddressList--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/* 收货地址管理 */
- (void)requestUserAddressDataAddressId:(NSString *)addressId
                              parameter:(id)param
                                   type:(DataRequestType)type
                                success:(SuccessBlockType)successCallBack
                                 failed:(FailedBlockType)failedCallBack {
    _timeStamp = [[Utility Share] GetUnixTime];
    if (type == GET || type == DELETE) {// non payload
        NSString *resourceId = type == GET ? @"" : addressId;// non resourceId
        NSString *publicKey = [self publicKeyWithResourceId:resourceId timestamp:_timeStamp payload:@""];
        NSString *url = [NSString stringWithFormat:UserAddress,resourceId,_userId,_timeStamp,publicKey];
        DLog(@"type:(%@)--UserAddress--%@",type==GET?@"GET":@"DELETE",url);
        [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:type];
    } else {
        _payload = [[Utility Share] base64Encode:param];
        NSString *resourceId = type == POST ? @"" : addressId;
        NSString *publicKey = [self publicKeyWithResourceId:resourceId timestamp:_timeStamp payload:_payload];
        NSString *url = [NSString stringWithFormat:UserAddress,resourceId,_userId,_timeStamp,publicKey];
        DLog(@"type:(%@)--UserAddress--%@",type==POST?@"POST":@"PUT",url);
        [self requestDataWithBaseUrl:url parameter:@{@"payload":_payload} Success:successCallBack failed:failedCallBack requestType:type];
    }
}

/*---订单管理---*/
/* 请求用户订单列表数据 */
- (void)requestUserOrderListDataSuccess:(SuccessBlockType)successCallBack
                                 failed:(FailedBlockType)failedCallBack {
    _timeStamp = [[Utility Share] GetUnixTime];
    NSString *publicKey = [self publicKeyWithResourceId:_userId timestamp:_timeStamp payload:@""];
    NSString *url = [NSString stringWithFormat:UserOrderList,_userId,_userId,_timeStamp,publicKey];
    DLog(@"UserOrderList--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/* 用户订单管理 */
- (void)requestUserOrderDataOrderId:(NSString *)orderId
                          parameter:(id)param
                               type:(DataRequestType)type
                            success:(SuccessBlockType)successCallBack
                             failed:(FailedBlockType)failedCallBack {
    _timeStamp = [[Utility Share] GetUnixTime];
    _payload = [[Utility Share] base64Encode:param];
    NSString *resourceId = type == POST?@"":orderId;
    NSString *publicKey = [self publicKeyWithResourceId:resourceId timestamp:_timeStamp payload:_payload];
    NSString *url = [NSString stringWithFormat:UserOrder,resourceId,_userId,_timeStamp,publicKey];
    DLog(@"type:(%@)--UserOrder--%@",type==POST?@"POST":@"PUT",url);
    [self requestDataWithBaseUrl:url parameter:@{@"payload":_payload} Success:successCallBack failed:failedCallBack requestType:type];
}

/* 订单预提交 */
- (void)requestUserOrderPreSubmitOrderId:(NSString *)orderId
                                 success:(SuccessBlockType)successCallBack
                                  failed:(FailedBlockType)failedCallBack {
    _timeStamp = [[Utility Share] GetUnixTime];
    NSString *publicKey = [self publicKeyWithResourceId:orderId timestamp:_timeStamp payload:@""];
    NSString *url = [NSString stringWithFormat:UserOrderPreSubmit,orderId,_userId,_timeStamp,publicKey];
    DLog(@"UserOrderPreSubmit--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/* 获取订单详情 */
- (void)requestUserOrderDetailsDataOrderId:(NSString *)orderId
                                   success:(SuccessBlockType)successCallBack
                                    failed:(FailedBlockType)failedCallBack {
    _timeStamp = [[Utility Share] GetUnixTime];
    NSString *publicKey = [self publicKeyWithResourceId:orderId timestamp:_timeStamp payload:@""];
    NSString *url = [NSString stringWithFormat:UserOrderDetails,orderId,_userId,_timeStamp,publicKey];
    DLog(@"UserOrderDetail--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];

}

/* 提交订单评论 */
- (void)requestUserAppraiseDataClientId:(NSString *)clientId
                              parameter:(id)param
                                success:(SuccessBlockType)successCallBack
                                 failed:(FailedBlockType)failedCallBack {
    _timeStamp = [[Utility Share] GetUnixTime];
    _payload = [[Utility Share] base64Encode:param];
    NSString *publicKey = [self publicKeyWithResourceId:clientId timestamp:_timeStamp payload:_payload];
    NSString *url = [NSString stringWithFormat:UserAppraise,clientId,_userId,_timeStamp,publicKey];
    DLog(@"UserAppraise--%@",url);
    [self requestDataWithBaseUrl:url parameter:@{@"payload":_payload} Success:successCallBack failed:failedCallBack requestType:POST];
}

/*店铺关注管理*/
/* 获取用户关注店铺列表 */
- (void)requestUserFavoriteListDataSuccess:(SuccessBlockType)successCallBack
                                      failed:(FailedBlockType)failedCallBack {
    _timeStamp = [[Utility Share] GetUnixTime];
    NSString *publicKey = [self publicKeyWithResourceId:@"" timestamp:_timeStamp payload:@""];
    NSString *url = [NSString stringWithFormat:UserFavoriteList,_userId,_timeStamp,publicKey];
    DLog(@"UserFavoriteList--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/* 店铺关注管理 */
- (void)requestUserFavoriteDataClientID:(NSString *)clientId
                              parameter:(id)param
                                   type:(DataRequestType)type
                                success:(SuccessBlockType)successCallBack
                                 failed:(FailedBlockType)failedCallBack {
    _timeStamp = [[Utility Share] GetUnixTime];
    _payload = [[Utility Share] base64Encode:param];
    
    NSString *resourceId = type == POST?@"":clientId;
    NSDictionary *parameter = type == POST? @{@"payload":_payload} : nil ;
    
    NSString *publicKey = [self publicKeyWithResourceId:resourceId timestamp:_timeStamp payload:type == POST?_payload:@""];
    NSString *url = [NSString stringWithFormat:UserFavorite,resourceId,_userId,_timeStamp,publicKey];
    
    DLog(@"type:(%@)--UserFavorite--%@",type==POST?@"POST":@"DELETE",url);
    [self requestDataWithBaseUrl:url parameter:parameter Success:successCallBack failed:failedCallBack requestType:type];
}

/*优惠管理*/
/* 获取用户红包列表 */
- (void)requestUserVoucherListDataSuccess:(SuccessBlockType)successCallBack
                                   failed:(FailedBlockType)failedCallBack {
    _timeStamp = [[Utility Share] GetUnixTime];
    NSString *publicKey = [self publicKeyWithResourceId:@"" timestamp:_timeStamp payload:@""];
    NSString *url = [NSString stringWithFormat:UserVoucherList,_userId,_timeStamp,publicKey];
    DLog(@"UserVoucherList--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/* 用户红包管理 */
- (void)requestuserVoucherDataVoucherId:(NSString *)voucherId
                              parameter:(id)param
                                   type:(DataRequestType)type
                                success:(SuccessBlockType)successCallBack
                                 failed:(FailedBlockType)failedCallBack {
    _timeStamp = [[Utility Share] GetUnixTime];
    _payload = [[Utility Share] base64Encode:param];
    
    NSString *resourceId = type == POST ? @"" : voucherId;
    NSDictionary *parameter = type == POST? @{@"payload":_payload} : nil ;

    NSString *publicKey = [self publicKeyWithResourceId:resourceId timestamp:_timeStamp payload:type==POST?_payload:@""];
    NSString *url = [NSString stringWithFormat:UserVoucher,resourceId,_userId,_timeStamp,publicKey];
    
    DLog(@"type:(%@)--UserAddress--%@",type==POST?@"POST":type==GET?@"GET":@"PUT",url);
    [self requestDataWithBaseUrl:url parameter:parameter Success:successCallBack failed:failedCallBack requestType:type];
}

/* 红包兑换 */
- (void)requestVoucherIssuerDataParameter:(id)param
                                  success:(SuccessBlockType)successCallBack
                                   failed:(FailedBlockType)failedCallBack {
    DLog(@"VoucherIssuer--%@",VoucherIssuer);
    [self requestDataWithBaseUrl:VoucherIssuer parameter:param Success:successCallBack failed:failedCallBack requestType:POST];//开放权限
}

/* 获取红包领取详情 */
- (void)requestVoucherDetailListDataWithRef:(NSString *)ref // ref 红包参考码
                                    success:(SuccessBlockType)successCallBack
                                     failed:(FailedBlockType)failedCallBack {
    NSString *url = [NSString stringWithFormat:VoucherDetailList,ref];
    DLog(@"VoucherDetailList--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];//开放权限
}

/* QAndA */
- (void)requestQAndADataSuccess:(SuccessBlockType)successCallBack
                            failed:(FailedBlockType)failedCallBack {
    DLog(@"QAndA--%@",QAndA);
    [self requestDataWithBaseUrl:QAndA parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/* 余额 充值规则 */
- (void)requestUserTopupRoleid:(NSString *)roleid
                        success:(SuccessBlockType)successCallBack
                         failed:(FailedBlockType)failedCallBack {
    NSString *url = [NSString stringWithFormat:UserTopupRole,_userId,roleid];
    DLog(@"UserTopupRole--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/* 余额 明细 */
- (void)requestUserTopupDetailTopupid:(NSString *)topupid
                              success:(SuccessBlockType)successCallBack
                               failed:(FailedBlockType)failedCallBack {
    NSString *url = [NSString stringWithFormat:UserTopupDetail,_userId,topupid];
    DLog(@"UserTopupDetail--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}


/* 余额 充值 */
- (void)requestUserTopupResourceId:(NSString *)resourceId
                         parameter:(id)param
                              type:(DataRequestType)type
                           success:(SuccessBlockType)successCallBack
                            failed:(FailedBlockType)failedCallBack {
    
    _timeStamp = [[Utility Share] GetUnixTime];
    _payload = [[Utility Share] base64Encode:param];
    
    resourceId = type == POST? @"": resourceId;
    
    NSString *publicKey = [self publicKeyWithResourceId:resourceId timestamp:_timeStamp payload:_payload];
    NSString *url = [NSString stringWithFormat:UserTopup,resourceId,_userId,_timeStamp,publicKey];
    DLog(@"type:(%@)--UserTopup--%@",type==POST?@"POST":@"PUT",url);
    
    [self requestDataWithBaseUrl:url parameter:@{@"payload":_payload} Success:successCallBack failed:failedCallBack requestType:type];
}

/* 积分兑换规则 */
- (void)requestUserCreditRoleid:(NSString *)roleid
                        success:(SuccessBlockType)successCallBack
                         failed:(FailedBlockType)failedCallBack {
    NSString *url = [NSString stringWithFormat:UserCreditRole,_userId,roleid];
    DLog(@"UserCreditRole--%@",url);
    [self requestDataWithBaseUrl:url parameter:nil Success:successCallBack failed:failedCallBack requestType:GET];
}

/* 积分兑换 红包 */
- (void)requestUserCreditConsumeParameter:(id)param
                                  success:(SuccessBlockType)successCallBack
                                   failed:(FailedBlockType)failedCallBack {
    _timeStamp = [[Utility Share] GetUnixTime];
    _payload = [[Utility Share] base64Encode:param];

    NSString *publicKey = [self publicKeyWithResourceId:@"" timestamp:_timeStamp payload:_payload];
    
    NSString *url = [NSString stringWithFormat:UserCreditConsume,_userId,_timeStamp,publicKey];
    
    DLog(@"UserCreditConsume--%@",url);
    [self requestDataWithBaseUrl:url parameter:@{@"payload":_payload} Success:successCallBack failed:failedCallBack requestType:POST];
}


///////////////////////////////////////////////////////////////////////////////////////////////
//#define kSuccessCB      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil]; \
//if (successCallBack) successCallBack(dictionary);


#define kSuccessCB      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil]; \
                    if ([dictionary[@"ErrorCode"] integerValue] == 2002) { \
                        [[SingleUserInfo sharedInstance] setLocationPlayerStatus:NO]; \
                    } \
                    if (successCallBack) successCallBack(dictionary);

#define kFailedCB       MBProgressHUD *_HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES]; \
                    _HUD.mode = MBProgressHUDModeText; \
                    _HUD.labelText = @"网络异常,请检查您的网络状态"; \
                    _HUD.removeFromSuperViewOnHide = YES; \
                    [_HUD hide:YES afterDelay:1.5]; \
                    if (failedCallBack) failedCallBack(error);

// 取消请求

- (void)cancleAllRequest {
    [[AppDelegate Share].manager.operationQueue cancelAllOperations];
}

/* 请求基类 */
- (void)requestDataWithBaseUrl:(NSString *)url
                     parameter:(id)param
                       Success:(SuccessBlockType)successCallBack
                        failed:(FailedBlockType)failedCallBack
                   requestType:(DataRequestType)type {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    switch (type) {
        case GET:{
            [[AppDelegate Share].manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                _isClose = NO;
                kSuccessCB;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                _isClose = NO;
                kFailedCB;
            }];
        }
            break;
        case POST:{
            [[AppDelegate Share].manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                kSuccessCB;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

                kFailedCB;
            }];
        }
            break;
        case PUT:{
            [[AppDelegate Share].manager PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                kSuccessCB;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                kFailedCB;
            }];
        }
            break;
        case DELETE:{
            [[AppDelegate Share].manager DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                kSuccessCB;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                kFailedCB;
            }];
        }
            break;
        case OPTIONS:
            break;
        default:
            break;
    }
}

/* 公钥 */
- (NSString *)publicKeyWithResourceId:(NSString *)ResourceId timestamp:(NSString *)Timestamp payload:(NSString *)Payload{
    DLog(@"//////////////////////////////////////////////////");
    DLog(@"_privateKey      :   %@",_privateKey);
    DLog(@"ResourceId       :   %@",ResourceId);
    DLog(@"Timestamp        :   %@",Timestamp);
    DLog(@"Payload          :   %@",Payload);
    DLog(@"//////////////////////////////////////////////////");
    NSString *dataStr = [NSString stringWithFormat:@"%@%@%@%@",_privateKey,ResourceId,Timestamp,Payload];
    return dataStr.md5;
}


@end
