//
//  CityListModel.h
//  rrcc_yh
//
//  Created by user on 15/6/17.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "BaseModel.h"

@interface CityListModel : BaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *RegionCode;
@property (nonatomic, copy) NSString *RegionName;
@property (nonatomic, copy) NSString *Parentid;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *ppCode;
@property (nonatomic, copy) NSString *Children;

@end
/*
 id 区域 ID
 RegionCode 区域编码 RegionName 区域名字
 Parentid 所属区域 ID
 Remark 区域描述
 Parentcode 所属区域代码
 ppCode 简写代码
 Children 下属城市列表
 */