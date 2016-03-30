//
//  DataEngine.h
//  rrcc_yh
//
//  Created by user on 15/6/12.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//


/*用户端接口定义*/

//#define baseDomain   @"http://rest.renrencaichang.com/"
#define baseDomain   @"http://rest.dev.renrencaichang.com/"
//#define baseDomain   @"http://rest.test.renrencaichang.com/"

#define basePort     @""
#define basePath     @""

/*用户登录*/
//获取验证码
#define UserCaptch          baseDomain@"UserCaptcha"

/*小区切换选择*/
//小区搜索
#define SiteList            baseDomain@"SiteList?cityId=%@&name=%@&lat=%@&lon=%@"
// 民润大厦 lat=31.172844&lon=121.391962

/* 请求区域数据 */
#define DistributerList     baseDomain@"DistributerList?sid=%@"

/* 当前选中的自提点是否关闭 */
#define DistributerActive   baseDomain@"DistributerActive?distributerid=%@"

/* 获取小区附近市场信息 */
#define SiteMarket          baseDomain@"SiteMarket/%@"

//获取城市列表
#define CityList            baseDomain@"CityList?city"

/*用户管理*/
//读取用户信息
#define User                baseDomain@"User/%@?uid=%@&t=%@&k=%@"

//读取用户地址列表
#define UserAddressList     baseDomain@"UserAddressList/%@?uid=%@&t=%@&k=%@"

//修改收货地址
#define UserAddress         baseDomain@"UserAddress/%@?uid=%@&t=%@&k=%@"

/*订单管理*/
//用户订单列表
#define UserOrderList       baseDomain@"UserOrderList/%@?uid=%@&t=%@&k=%@"

//订单预提交
#define UserOrderPreSubmit  baseDomain@"UserOrderPreSubmit/%@?uid=%@&t=%@&k=%@"

//用户订单管理
#define UserOrder           baseDomain@"UserOrder/%@?uid=%@&t=%@&k=%@"

//获取订单详情
#define UserOrderDetails    baseDomain@"UserOrderDetails/%@?uid=%@&t=%@&k=%@"

//提交订单评论
#define UserAppraise        baseDomain@"UserAppraise/%@?uid=%@&t=%@&k=%@"

/*获取商户信息*/
//获取小区附近商户列表
#define SiteShopList        baseDomain@"SiteShopList/%@?o=%ld&l=%ld"

//获取商户产品信息
#define UserShopProductList baseDomain@"UserShopProductList?sid=%@"

//获取产品详情
#define UserProductDetails  baseDomain@"UserProductDetails/%@"

/* 获取商户详情信息 */
#define ShopDetails         baseDomain@"ShopDetails?sid=%@"

/* 获取商户评价列表信息 */
#define ShopAppraiseList    baseDomain@"ShopAppraiseList/%@?orderId=%@&o=%ld&l=%ld"

/* 获取商户活动信息 */
#define RshopPromotionList  baseDomain@"RshopPromotionList?sid=%@"

/*店铺关注管理*/
//获取用户关注店铺列表
#define UserFavoriteList    baseDomain@"UserFavoriteList?uid=%@&t=%@&k=%@"

//店铺关注管理
#define UserFavorite        baseDomain@"UserFavorite/%@?uid=%@&t=%@&k=%@"

/*优惠管理*/
//获取用户红包列表
#define UserVoucherList     baseDomain@"UserVoucherList?uid=%@&t=%@&k=%@"

//用户红包管理
#define UserVoucher         baseDomain@"UserVoucher/%@?uid=%@&t=%@&k=%@"

//红包兑换
#define VoucherIssuer       baseDomain@"VoucherIssuer"

//获取红包领取详情
#define VoucherDetailList   baseDomain@"VoucherDetailList?ref=%@"

//常见问题
#define QAndA               baseDomain@"QAndA"

//余额 充值规则
#define UserTopupRole       baseDomain@"UserTopupRole?uid=%@&roleid=%@"

//余额 明细
#define UserTopupDetail     baseDomain@"UserTopup?uid=%@&topupid=%@"

//余额 充值
#define UserTopup           baseDomain@"UserTopup/%@?uid=%@&t=%@&k=%@"

//积分兑换规则
#define UserCreditRole      baseDomain@"UserCreditRole?uid=%@&roleid=%@"

//积分兑换 红包
#define UserCreditConsume   baseDomain@"UserCreditConsume?uid=%@&t=%@&k=%@"


////////////////////////////////////////////////////////////////////
/* 数据引擎类  处理网络下载 */
////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>


typedef void(^SuccessBlockType) (id responseData);
typedef void(^FailedBlockType) (NSError *error);

@interface DataEngine : NSObject

+ (id)sharedInstance;

- (void)cancleAllRequest;//取消请求

- (void)ConfigDataWith:(PlayerInfoModel *)PIModel;//登录成功 配置数据

/* 获取&验证 验证码 */
- (void)requestUserCaptchaDataWithMobile:(NSString *)mobile
                                 captcha:(NSString *)captcha
                                 success:(SuccessBlockType)successCallBack
                                  failed:(FailedBlockType)failedCallBack;
    
/* 请求城市列表数据 */
- (void)requestCityListDataSuccess:(SuccessBlockType)successCallBack
                            failed:(FailedBlockType)failedCallBack;

/* 请求小区列表数据 */
- (void)requestSiteListDataWithCityId:(NSString *)cityId
                                 name:(NSString *)name
                             latitude:(NSString *)lat
                            longitude:(NSString *)lon
                              success:(SuccessBlockType) successCallBack
                               failed:(FailedBlockType) failedCallBack;

/* 请求区域数据 */
- (void)requestCityDistrictListDataWithCityId:(NSString *)cityId
                                      Success:(SuccessBlockType) successCallBack
                                       failed:(FailedBlockType) failedCallBack;

/* 判断自提点是否关闭数据 */
- (void)requestCityDistributerActiveDataWithDistributerId:(NSString *)distributerId
                                                  Success:(SuccessBlockType) successCallBack
                                                   failed:(FailedBlockType) failedCallBack;

/* 小区产品数据 */
- (void)requestSiteProductListDataWithSiteId:(NSString *)siteId
                                      Success:(SuccessBlockType) successCallBack
                                       failed:(FailedBlockType) failedCallBack;

/* 请求小区商户列表数据 */
- (void)requestSiteShopListDataWithSiteId:(NSString *)siteId
                                   offset:(NSInteger)offset
                                    limit:(NSInteger)limit
                                  success:(SuccessBlockType)successCallBack
                                   failed:(FailedBlockType)failedCallBack;

/* 获取商户产品信息 */
- (void)requestUserShopProductListDataWithSiteShopId:(NSString *)shopId
                                             success:(SuccessBlockType)successCallBack
                                              failed:(FailedBlockType)failedCallBack;

/* 获取产品详情 */
- (void)requestUserProductDetailsDataWithSiteProductId:(NSString *)productId
                                             success:(SuccessBlockType)successCallBack
                                              failed:(FailedBlockType)failedCallBack;

/* 获取商户详情信息 */
- (void)requestShopDetailsDataWithShopId:(NSString *)shopId
                                 success:(SuccessBlockType)successCallBack
                                  failed:(FailedBlockType)failedCallBack;

/* 获取商户评价列表信息 */
- (void)requestShopAppraiseListDataWithShopId:(NSString *)shopId
                                      orderId:(NSString *)orderId
                                       offset:(NSInteger)offset
                                        limit:(NSInteger)limit
                                      success:(SuccessBlockType)successCallBack
                                       failed:(FailedBlockType)failedCallBack;

/* 获取商户活动信息 */
- (void)requestRshopPromotionListDataWithShopId:(NSString *)shopId
                                        success:(SuccessBlockType)successCallBack
                                         failed:(FailedBlockType)failedCallBack;

/* 读取用户信息 */
- (void)requestUserDataSuccess:(SuccessBlockType)successCallBack
                        failed:(FailedBlockType)failedCallBack;

/* 读取用户地址列表 */
- (void)requestUserAddressListDataSuccess:(SuccessBlockType)successCallBack
                                   failed:(FailedBlockType)failedCallBack;

/* 收货地址管理 */
- (void)requestUserAddressDataAddressId:(NSString *)addressId
                              parameter:(id)param
                                   type:(DataRequestType)type
                                success:(SuccessBlockType)successCallBack
                                 failed:(FailedBlockType)failedCallBack;

/* 读取用户订单列表 */
- (void)requestUserOrderListDataSuccess:(SuccessBlockType)successCallBack
                                 failed:(FailedBlockType)failedCallBack;

/* 用户订单管理 */
- (void)requestUserOrderDataOrderId:(NSString *)orderId
                          parameter:(id)param
                               type:(DataRequestType)type
                            success:(SuccessBlockType)successCallBack
                             failed:(FailedBlockType)failedCallBack;

/* 订单预提交 */
- (void)requestUserOrderPreSubmitOrderId:(NSString *)orderId
                                 success:(SuccessBlockType)successCallBack
                                  failed:(FailedBlockType)failedCallBack;

/* 获取订单详情 */
- (void)requestUserOrderDetailsDataOrderId:(NSString *)orderId
                                   success:(SuccessBlockType)successCallBack
                                    failed:(FailedBlockType)failedCallBack;

/* 提交订单评论 */
- (void)requestUserAppraiseDataClientId:(NSString *)clientId
                              parameter:(id)param
                                success:(SuccessBlockType)successCallBack
                                 failed:(FailedBlockType)failedCallBack;

//获取用户关注店铺列表
- (void)requestUserFavoriteListDataSuccess:(SuccessBlockType)successCallBack
                                    failed:(FailedBlockType)failedCallBack;

//店铺关注管理
- (void)requestUserFavoriteDataClientID:(NSString *)clientId
                              parameter:(id)param
                                   type:(DataRequestType)type
                                success:(SuccessBlockType)successCallBack
                                 failed:(FailedBlockType)failedCallBack;

//获取用户红包列表
- (void)requestUserVoucherListDataSuccess:(SuccessBlockType)successCallBack
                                   failed:(FailedBlockType)failedCallBack;

//用户红包管理
- (void)requestuserVoucherDataVoucherId:(NSString *)voucherId
                            parameter:(id)param
                                 type:(DataRequestType)type
                              success:(SuccessBlockType)successCallBack
                               failed:(FailedBlockType)failedCallBack;

/* 红包兑换 */
- (void)requestVoucherIssuerDataParameter:(id)param
                                  success:(SuccessBlockType)successCallBack
                                   failed:(FailedBlockType)failedCallBack;

/* 获取红包领取详情 */
- (void)requestVoucherDetailListDataWithRef:(NSString *)ref
                                    success:(SuccessBlockType)successCallBack
                                     failed:(FailedBlockType)failedCallBack;

/* 常见问题 */
- (void)requestQAndADataSuccess:(SuccessBlockType)successCallBack
                         failed:(FailedBlockType)failedCallBack;

/* 余额 充值规则 */
- (void)requestUserTopupRoleid:(NSString *)roleid
                        success:(SuccessBlockType)successCallBack
                         failed:(FailedBlockType)failedCallBack;

/* 余额 明细 */
- (void)requestUserTopupDetailTopupid:(NSString *)topupid
                              success:(SuccessBlockType)successCallBack
                               failed:(FailedBlockType)failedCallBack;

/* 余额 充值 */
- (void)requestUserTopupResourceId:(NSString *)resourceId
                         parameter:(id)param
                              type:(DataRequestType)type
                           success:(SuccessBlockType)successCallBack
                            failed:(FailedBlockType)failedCallBack;

/* 积分兑换规则 */
- (void)requestUserCreditRoleid:(NSString *)roleid
                        success:(SuccessBlockType)successCallBack
                         failed:(FailedBlockType)failedCallBack;

/* 积分兑换 红包 */
- (void)requestUserCreditConsumeParameter:(id)param
                                  success:(SuccessBlockType)successCallBack
                                   failed:(FailedBlockType)failedCallBack;
@end







