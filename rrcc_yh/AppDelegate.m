//
//  AppDelegate.m
//  rrcc_yh
//
//  Created by lawwilte on 15-5-4.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "AppDelegate.h"
#import "FlashScreenView.h"
#import "RCTabBarViewController.h"

#import "QJCheckVersionUpdate.h"


#import "PayEngine.h"//支付引擎


//#import <objc/runtime.h>

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

//#import <BaiduMapAPI/BMapKit.h>// 百度地图

#import <AlipaySDK/AlipaySDK.h>// 支付宝
#import "AliPayHeader.h"
//
#import "WXApi.h"// 微信
#import "payRequsestHandler.h"

#import "NSString+Hashing.h"

#define UMKEY       @"55ac540f67e58e29c3005d2d"

// tencent
#define TAPP_ID     @"1104847736"  // @"QQ041DAA378"
#define TAPP_KEY    @"d5bGozTV2OCYfUbP"

// sina
#define SAPP_ID     @"1290145605"
#define SAPP_KEY    @"8ef50b6d250db0b3a407ac5c865675ba"

// baidu
#define BAK         @"uemuHM29TgcWW1XVTePga1lp"


@interface AppDelegate () <WXApiDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIAlertView *alertView;

@end 

@implementation AppDelegate

@synthesize manager;

+ (AppDelegate*)Share {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //NSString *path = NSHomeDirectory();
    //NSLog(@"path -> %@",path);
        
    // 获取用户登陆信息 --> 配置下载数据参数
    [[SingleUserInfo sharedInstance] locationPlayerStatus];
    
    [WXApi registerApp:APP_ID withDescription:@"人人菜场"];//微信支付
    
    [UMSocialData setAppKey:UMKEY];//分享

    [UMSocialWechatHandler setWXAppId:APP_ID appSecret:APP_SECRET url:@"http://www.renrencaichang.com"];// 微信分享
    
    [UMSocialQQHandler setQQWithAppId:TAPP_ID appKey:TAPP_KEY url:@"http://www.renrencaichang.com"];// QQ分享
    
    [self initRootViewController];
    [self initWebManager];
    
    [self checkVerionUpdate];

    return YES;
}

/**
 *  检查版本更新
 */
- (void)checkVerionUpdate
{
    QJCheckVersionUpdate *update = [[QJCheckVersionUpdate alloc] init];
    [update showAlertView];
}


#pragma mark - 节日系统停用

- (void)springFestivalMonitor {
    // 第1种方式
    //此种方式创建的timer已经添加至runloop中
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(springFestivalTip) userInfo:nil repeats:YES];
    //保持线程为活动状态，才能保证定时器执行
    //[[NSRunLoop currentRunLoop] run];
    
    //第2种方式
    //此种方式创建的timer没有添加至runloop中
    self.timer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(springFestivalTip) userInfo:nil repeats:YES];
    //将定时器添加到runloop中
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    //保持线程为活动状态，才能保证定时器执行
    [[NSRunLoop currentRunLoop] run];
}

- (void)springFestivalTip {
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    
    NSTimeInterval startTimeInterval = [[Utility Share] GetTimeIntervalSince1970:@"2016-1-31 00:00:00"];
    
    NSTimeInterval endTimeInterval = [[Utility Share] GetTimeIntervalSince1970:@"2016-2-15 00:00:00"];
    
    if (currentTimeInterval >= startTimeInterval && currentTimeInterval < endTimeInterval) {
        
        // 与 UIKit
        dispatch_async(dispatch_get_main_queue(), ^{
            self.alertView = [[UIAlertView alloc] initWithTitle:@"春节放假通知: 本系统将在30s之后不能使用,请谨慎下单" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [self.alertView show];
        });
        
        if (self.timer != nil && [self.timer isValid]) {
            [self.timer invalidate];
        }
        
        [self performSelector:@selector(resetRootViewController) withObject:nil afterDelay:30.f];
    }
}

- (void)resetRootViewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        [self.alertView dismissWithClickedButtonIndex:self.alertView.cancelButtonIndex animated:YES];
        
        //SpringFestivalViewController *festival = [[SpringFestivalViewController alloc] init];
        //[self.window setRootViewController:festival];
    });
}

#pragma mark
#pragma mark 初始化根控制器


-(void)initRootViewController {
    if ([UIScreen mainScreen].bounds.size.height > 480) {
        self.ScaleX = [UIScreen mainScreen].bounds.size.width/320;
        self.ScaleY = [UIScreen mainScreen].bounds.size.height/568;
    } else {
        self.ScaleX = 1.0;
        self.ScaleY = 1.0;
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /**
     *  加载春假 放假通知页面
     */
    UIViewController *rootViewController = nil;
    
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    
    NSTimeInterval startTimeInterval = [[Utility Share] GetTimeIntervalSince1970:@"2016-1-31 00:00:00"];

    NSTimeInterval endTimeInterval = [[Utility Share] GetTimeIntervalSince1970:@"2016-2-15 00:00:00"];
    
    if (currentTimeInterval >= startTimeInterval && currentTimeInterval < endTimeInterval) {
        //SpringFestivalViewController *festival = [[SpringFestivalViewController alloc] init];
        //rootViewController = festival;
    } else {
        // 检测是否在春节期间
        //[self performSelectorInBackground:@selector(springFestivalMonitor) withObject:nil];

        //RCTabBarViewController *tabbar = [[RCTabBarViewController alloc] init];
        //FlashScreenView *rootVC = [[FlashScreenView alloc] initWithRootViewController:tabbar];
        //rootViewController = rootVC;
    }
    
    RCTabBarViewController *tabbar = [[RCTabBarViewController alloc] init];
    FlashScreenView *rootVC = [[FlashScreenView alloc] initWithRootViewController:tabbar];
    rootViewController = rootVC;
    
    [self.window setRootViewController:rootViewController];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (void)initWebManager {
    // 为Manager 对象指定使用HTTP 响应解析器
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        MBProgressHUD *_HUD = [MBProgressHUD  showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        _HUD.mode = MBProgressHUDModeCustomView;
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"failed"]];
                _HUD.labelText = @"当前网络未知";
                break;
            case AFNetworkReachabilityStatusNotReachable:
                _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"failed"]];
                _HUD.labelText = @"当前网络无连接";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
                _HUD.labelText = @"当前网络处于3G状态";
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
                _HUD.labelText = @"当前网络处于WiFi状态";
                break;
            default:
                break;
        }
        _HUD.removeFromSuperViewOnHide = YES;
        [_HUD hide:YES afterDelay:1.5];
        
    }];
}

/* sourceApplication:
 1.com.tencent.xin
 2.com.alipay.safepayclient
 3.com.alipay.iphoneclient
 4.com.tencent.mqq
 */

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    DLog(@"\n-->>>%@ \n-->>>%@ \n-->>>%@ \n-->>>%@",application,url,sourceApplication,annotation);
    if ([url.scheme isEqualToString:APP_ID]) {//微信
        if ([url.host isEqualToString:@"pay"]) {
            return [WXApi handleOpenURL:url delegate:self];// 支付
        }
        return [UMSocialSnsService handleOpenURL:url];// 分享
    } else if ([url.scheme isEqualToString:@"rrcc2015081300213630"]) {// 支付宝
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            // 支付宝 //验证签名成功，交易结果无篡改
        }];
        return YES;
    } else {// 分享
        return [UMSocialSnsService handleOpenURL:url];// QQ Qzone Sina 分享
    }
}

-(void)onResp:(BaseResp *)resp { // 微信
    [[PayEngine sharedPay] setResp:resp];
}



@end
