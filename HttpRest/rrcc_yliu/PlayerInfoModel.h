//
//  PlayerInfo.h
//  rrcc_yh
//
//  Created by user on 15/7/23.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "BaseModel.h"

@interface PlayerInfoModel : BaseModel

@property (nonatomic, copy) NSString *privateKey;//用户私钥

@property (nonatomic, copy) NSString *mobile;// 手机号
@property (nonatomic, copy) NSString *captcha;// 验证码
//@property (nonatomic, copy) NSString *newuser;// 用户类型
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *uuid;

@end
