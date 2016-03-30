//
//  ProductsModel.h
//  rrcc_yh
//
//  Created by user on 15/6/15.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "BaseModel.h"

@interface ProductsModel : BaseModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *skuid;
@property (nonatomic, copy) NSString *skuname;
@property (nonatomic, copy) NSString *clientid;
@property (nonatomic, copy) NSString *ref;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *brandid;
@property (nonatomic, copy) NSString *brandname;
@property (nonatomic, copy) NSString *avgweight;
@property (nonatomic, copy) NSString *avgnum;
@property (nonatomic, copy) NSString *avgprice;
@property (nonatomic, copy) NSString *spec;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *imgurl;
@property (nonatomic, copy) NSString *firstcode;
@property (nonatomic, copy) NSString *onsale;
@property (nonatomic, copy) NSString *saleprice;
@property (nonatomic, copy) NSString *saleamount;
@property (nonatomic, copy) NSString *salestart;
@property (nonatomic, copy) NSString *saleexpired;

//订单详情页
@property (nonatomic, copy) NSString *ordercount;
@property (nonatomic, copy) NSString *feature;
@property (nonatomic, copy) NSString *total;//价格

//产品详情页
@property (nonatomic, strong) NSMutableArray *imageList;

// 购物车相关属性
@property (nonatomic, assign) int count;


@end

@interface ImageModel : BaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *imgurl;
@property (nonatomic, copy) NSString *index;

@end



