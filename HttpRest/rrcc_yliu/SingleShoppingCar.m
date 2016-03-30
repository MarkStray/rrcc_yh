//
//  PurchaseCar.m
//  rrcc_yh
//
//  Created by user on 15/6/29.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "SingleShoppingCar.h"

@interface SingleShoppingCar ()

{
    SiteListModel *_siteModel;
    
    //保存自提点列表
    NSMutableArray *_distributerList;
}


@property (nonatomic, strong) NSMutableDictionary *purchaseModelDict;//数据源字典
@property (nonatomic, strong) NSMutableDictionary *purchaseTotalPriceDict;//单一商品的总价 price*count

@end

@implementation SingleShoppingCar

+ (SingleShoppingCar *)sharedInstance {
    static SingleShoppingCar *_s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s = [[SingleShoppingCar alloc] init];
    });
    return _s;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _purchaseModelDict = [NSMutableDictionary dictionary];
        _purchaseTotalPriceDict = [NSMutableDictionary dictionary];
        
        _distributerList = [NSMutableArray array];
    }
    return self;
}

#pragma mark settle badge & price

- (BOOL)playerProductsModel:(ProductsModel *)model{
    
    DLog(@"price %@ | count %ld | skuid %@",model.price,(long)model.count,model.skuid);
    
    
    CGFloat totalPrice = 0.f;
    int badge = 0;
    
    if (model != nil) {
        
        NSString *key = model.skuid;
        
        /*
         * 购物车最大容量为 999
         */
        
        NSArray *allKeys = [_purchaseModelDict allKeys];
        
        // 购物车中 未添加过 该 商品
        if (![allKeys containsObject:key]) {
            
            NSUInteger maxCount = allKeys.count;
            
            if (maxCount == 99) {
                NSString *msg = [NSString stringWithFormat:@"亲! 您的购物车已塞满(当前物品99件),结算后才能再次添加!"];
                show_alertView(msg);
                return NO;
            }
        }
        
        
        NSString *temPrice = model.onsale.integerValue == 1 ? model.saleprice : model.price;
        CGFloat price = temPrice.floatValue * model.count;
        
        [_purchaseModelDict setObject:model forKey:key];
        [_purchaseTotalPriceDict setObject:@(price) forKey:key];
        
        NSEnumerator *enumKey = [_purchaseTotalPriceDict keyEnumerator];
        
        for (NSString *key in enumKey) {
            
            CGFloat p = [_purchaseTotalPriceDict[key] floatValue];
            
            totalPrice += p;
            if (p != 0) {
                badge ++;
            }else{// 从字典删除model对象
                [_purchaseModelDict removeObjectForKey:key];
            }
        }
        
        // postNotification
        
        _badge      = badge;
        _totalPrice = totalPrice;
        
        DLog(@"badge %d | count %f",_badge ,_totalPrice );
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBZTabbarShoppingCarDidChangeNotification object:nil userInfo:@{@"badge":@(_badge),@"totalPrice":@(_totalPrice)}];
        
        return YES;
    } else {
        NSAssert(model, @"加入购物车的数据异常!!!");
        return NO;
    }
}

/*
 orderList 订单列表,格式为:
 clientid:skuid,数量; skuid,数量; skuid,数量 | 
 clientid:skuid,数量; skuid,数量;skuid,数量;skuid, 数量
 (例子 1:1,5;2,3|2:5,1;12,7)
 */
- (NSString *)getOrderList{
    NSArray *products = [self productsDataSource];
    //NSMutableString *listStr = [NSMutableString stringWithFormat:@"%@:",self.shopModel.id];
    NSMutableString *listStr = [NSMutableString stringWithFormat:@"%@:",self.presellModel.id];
    for (ProductsModel *model in products) {
        [listStr appendFormat:@"%@,%ld;",model.skuid,(long)model.count];
    }
    if (listStr.length>1) [listStr deleteCharactersInRange:NSMakeRange(listStr.length-1, 1)];
    DLog(@"OrderListStr : %@",listStr);
    return listStr;
}


/* 获取 */
- (NSMutableArray *)productsDataSource{
    return [_purchaseModelDict.allValues mutableCopy];
}

/* 更新 */
- (void)removeModelFromProductsDataSourceWithKey:(NSString *)key{
    [_purchaseModelDict removeObjectForKey:key];
}

/* 清空 */
- (void)clearShoppingCar{
    _badge = 0, _totalPrice = 0.f;
    [[NSNotificationCenter defaultCenter] postNotificationName:kBZTabbarShoppingCarDidChangeNotification object:nil userInfo:@{@"badge":@(_badge),@"totalPrice":@(_totalPrice)}];
    // 产品详情 缓存清空
    [[NSNotificationCenter defaultCenter] postNotificationName:kShoppingCarDidClearNotification object:nil];
    
    NSEnumerator *enumKey = [_purchaseModelDict keyEnumerator];
    for (NSString *key in enumKey) {// 先清空数量
        ProductsModel *model = _purchaseModelDict[key];
        model.count = 0;
    }
    [_purchaseModelDict removeAllObjects];
    [_purchaseTotalPriceDict removeAllObjects];
}

// 本地保存选中小区
- (void)setSiteModel:(SiteListModel *)siteModel {
    _siteModel = siteModel;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:siteModel];
    [ud setObject:data forKey:kDefaultSiteKey];
    [ud synchronize];
}

- (SiteListModel *)siteModel {
    if (_siteModel == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData *data = [ud objectForKey:kDefaultSiteKey];
        SiteListModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        _siteModel = model;
    }
    return _siteModel;
}


// 本地保存自提点列表

- (void)setDistributerList:(NSMutableArray *)distributerList {

    _distributerList = distributerList;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (DistributerModel *model in _distributerList) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [dataArray addObject:data];
    }
    
    [ud setObject:[dataArray copy] forKey:kDistributerListKey];
    [ud synchronize];
}

- (NSMutableArray *)distributerList {
    if (_distributerList.count == 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSArray *dataArray = [ud objectForKey:kDistributerListKey];
        for (NSData *data in dataArray) {
            DistributerModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [_distributerList addObject:model];
        }
    }

    return _distributerList;
}


@end
