//
//  SingleUserInfo.m
//  rrcc_yh
//
//  Created by user on 15/7/23.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "SingleUserInfo.h"
#import "LoginPhoneView.h"

@implementation SingleUserInfo

+ (SingleUserInfo *)sharedInstance {
    static SingleUserInfo *_s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s = [[SingleUserInfo alloc] init];
    });
    return _s;
}

/* override */
- (BOOL)locationPlayerStatus {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL status = [ud boolForKey:@"LocationPlayerStatusKey"];
    if (status) {// 本地有数据才会配置
        [[DataEngine sharedInstance] ConfigDataWith:self.playerInfoModel];//config data
    }
    DLog(@"%@",status==0?@"NO":@"YES");
    return status;
}

- (void)setLocationPlayerStatus:(BOOL)locationPlayerStatus {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:locationPlayerStatus forKey:@"LocationPlayerStatusKey"];
    [ud synchronize];
    if (!locationPlayerStatus) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginStatusNotification object:nil userInfo:@{@"loginStatus":@NO}];
        
        MBProgressHUD *_HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        _HUD.mode = MBProgressHUDModeText;
        _HUD.labelText = @"请重新登录";
        _HUD.detailsLabelText = @"您已经在其他设备上登录";
        _HUD.removeFromSuperViewOnHide = YES;
        [_HUD hide:YES afterDelay:2.f];
    }
}

/* override */
- (PlayerInfoModel *)playerInfoModel {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = [ud objectForKey:@"PlayerInfoModelKey"];
    PlayerInfoModel *PIModel =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return PIModel;
}

- (void)setPlayerInfoModel:(PlayerInfoModel *)playerInfoModel {
    _playerInfoModel = playerInfoModel;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:playerInfoModel];
    [ud setObject:data forKey:@"PlayerInfoModelKey"];
    if (![ud synchronize]) {//不成功重新登录
        MBProgressHUD *_HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"failed"]];
        _HUD.labelText = @"由于系统原因,数据出错,请重新登录";
        _HUD.removeFromSuperViewOnHide = YES;
        [_HUD hide:YES afterDelay:1.5];
        [self setLocationPlayerStatus:NO];
    }
}

- (void)savePlayerInfoLocationWithDictionary:(NSDictionary *)loginSuccessDic {
    PlayerInfoModel *PIModel = [[PlayerInfoModel alloc] initWithDictionary:loginSuccessDic];
    self.playerInfoModel = PIModel;
    self.locationPlayerStatus = YES;
    [[DataEngine sharedInstance] ConfigDataWith:PIModel];//config data
}

- (void)showLoginView {
    LoginPhoneView *vc = [[LoginPhoneView alloc] init];
    XHBaseNavigationController *loginNav = [[XHBaseNavigationController alloc] initWithRootViewController:vc];
    self.logNav = loginNav;
    [self.nav presentViewController:loginNav animated:YES completion:nil];
}

- (void)loginDissmiss {
    if (self.logNav) [self.logNav dismissViewControllerAnimated:YES completion:nil];
}
@end
