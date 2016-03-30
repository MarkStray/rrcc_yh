//
//  AddressListModel.h
//  rrcc_yh
//
//  Created by user on 15/7/23.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "BaseModel.h"

@interface AddressListModel : BaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *cityid;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *contacts;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *siteid;
@property (nonatomic, copy) NSString *isdefault;
@property (nonatomic, copy) NSString *inserttime;
@property (nonatomic, copy) NSString *isdel;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *sitename;

//"id": "47",
//"cityid": "0",
//"address": "阿拉伯",
//"lat": null,
//"lon": null,
//"userid": "209",
//"contacts": "小昭",
//"tel": "13800000000",
//"siteid": "139808",
//"isdefault": "0",
//"inserttime": "2015-07-06 14:34:25",
//"isdel": "0",
//"updatetime": "2015-07-15 15:19:47",
//"sitename": "海尚康庭"

@end
