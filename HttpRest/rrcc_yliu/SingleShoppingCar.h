//
//  PurchaseCar.h
//  rrcc_yh
//
//  Created by user on 15/6/29.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CalculateType) {
    CalculateTypeAdd,// 购物车 添加
    CalculateTypeReduce// 购物车 减少
};

typedef void (^CountBlock)(int count);

@interface SingleShoppingCar : NSObject

@property (nonatomic, assign) int badge;
@property (nonatomic, assign) float totalPrice;

@property (nonatomic, strong) SiteListModel *siteModel;// 保存进入的小区

@property (nonatomic, strong) PresellModel *presellModel;// 保存店铺信息

@property (nonatomic, strong) UserOrderDetailModel *orderModel;//保存选中订单列表(show)

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

/**
 *  是否是从购物车进去产品详情界面
 *  防止购物车页面和产品详情页面循环进入
 */
@property (nonatomic, assign) BOOL isCarPushIntoDetailVC;


+ (SingleShoppingCar *) sharedInstance;//购物车单例

/* 用户选购的商品模型 */
/* 返回值 说明 yes 添加成功 no 添加失败*/

- (BOOL)playerProductsModel:(ProductsModel *)model;


/** 更新购物车数据 + 操作数量算法类型 + 返回购物车当前数量*/
/*- (void)updateShoppingCarProducts:(ProductsModel *)model
                    calculateType:(CalculateType)type
                         complete:(CountBlock)countCB;
 */

/* 订单列表字符串 */
- (NSString *)getOrderList;

/* 用户产品数组 */
- (NSMutableArray *)productsDataSource;

/* 更新购物车 */
- (void)removeModelFromProductsDataSourceWithKey:(NSString *)key;

/* 清空购物车 */
- (void)clearShoppingCar;


// 对应的自提点 setter getter
- (void)setDistributerList:(NSMutableArray *)distributerList;

- (NSMutableArray *)distributerList;


@end


