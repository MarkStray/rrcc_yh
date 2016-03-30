//
//  SiteListModel.h
//  rrcc_yh
//
//  Created by user on 15/6/13.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "BaseModel.h"

@interface SiteListModel : BaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *cityid;
@property (nonatomic, copy) NSString *provinceid;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *searchkeyname;
@property (nonatomic, copy) NSString *domainname;

@property (nonatomic, assign) BOOL isNearest;

@end
