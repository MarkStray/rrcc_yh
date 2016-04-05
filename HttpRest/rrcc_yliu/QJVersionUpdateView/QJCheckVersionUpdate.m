//
//  QJCheckVersionUpdate.m
//  QJVersionUpdateView
//
//  Created by Justin on 16/3/8.
//  Copyright © 2016年 Justin. All rights reserved.
//

#import "QJCheckVersionUpdate.h"
#import "QJVersionUpdateVIew.h"

#define kVersionUpdateNoticeKey  @"VersionUpdateNotice"

#define GetUserDefaut [[NSUserDefaults standardUserDefaults] objectForKey:kVersionUpdateNoticeKey]
#define OLDVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APPID  @"987197457"


@interface QJCheckVersionUpdate ()

@property (nonatomic, strong) QJVersionUpdateVIew *versionUpdateView;

@end

@implementation QJCheckVersionUpdate

/**
 *  demo
 */
+ (void)CheckVerion_demo:(UpdateBlock)updateblock
{
    NSString *currentAppStoreVersion = @"5.0.0";
    if ([QJCheckVersionUpdate versionlessthan:[GetUserDefaut isKindOfClass:[NSString class]] && GetUserDefaut ? GetUserDefaut : OLDVERSION Newer:currentAppStoreVersion])
    {
        NSLog(@"暂不更新");
    }else{
        NSLog(@"请到appstore更新%@版本",currentAppStoreVersion);
         NSString *describeStr = @"1.修正了部分单词页面空白的问题修正了部分单词页面空白的问题\n2.修正了部分单词页面空白的问题去够呛够呛\n3.修正了部分单词页面空白的问题";
        NSLog(@"修复问题描述:%@",describeStr);
        NSArray *dataArr = [QJCheckVersionUpdate separateToRow:describeStr];
        if (updateblock) {
            updateblock(currentAppStoreVersion,dataArr);
        }
    }
}

/**
 *  正式
 */

+ (void)CheckVerion:(UpdateBlock)updateblock
{
    //NSString *storeString = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?bundleId=%@",OLDVERSION];
    
    NSString *storeString = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",APPID];
    
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        if ( [data length] > 0 && !error ) {
            // Success
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            DLog(@"appData : %@",appData);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                /**
                 *  以上网络请求可以改成自己封装的类
                 */
                if(![versionsInAppStore count]) {
                    DLog(@"No versions of app in AppStore");
                    return;
                } else {
                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                    DLog(@"%@",OLDVERSION);
                    if ([QJCheckVersionUpdate versionlessthan:[GetUserDefaut isKindOfClass:[NSString class]] && GetUserDefaut ? GetUserDefaut : OLDVERSION Newer:currentAppStoreVersion])
                    {
                        DLog(@"暂不更新");
                    }else{
                        DLog(@"请到appstore更新%@版本",currentAppStoreVersion);
                        /**
                         *  修复问题描述
                         */
                        NSString *describeStr = [[[appData valueForKey:@"results"] valueForKey:@"releaseNotes"] objectAtIndex:0];
                        DLog(@"修复问题描述:%@",describeStr);
                        NSArray *dataArr = [QJCheckVersionUpdate separateToRow:describeStr];
                        if (updateblock) {
                            updateblock(currentAppStoreVersion,dataArr);
                        }
                    }
                }
                
            });
        }
        
    }];
}


+ (BOOL)versionlessthan:(NSString *)oldOne Newer:(NSString *)newver
{
    if ([oldOne isEqualToString:newver]) {
        return YES;
    }else{
        if ([oldOne compare:newver options:NSNumericSearch] == NSOrderedDescending)
        {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}


+ (NSArray *)separateToRow:(NSString *)describe
{
    NSArray *array= [describe componentsSeparatedByString:@"\n"];
    return array;
}

- (void)showAlertView
{
    [QJCheckVersionUpdate CheckVerion:^(NSString *str, NSArray *DataArr) {
        if (!_versionUpdateView) {
            _versionUpdateView = [[QJVersionUpdateVIew alloc] initWith:[NSString stringWithFormat:@"版本:%@",str] Describe:DataArr];
            _versionUpdateView.goTOAppstoreBlock = ^{
                
                //NSString *urlStr = [NSString stringWithFormat:@"itms://itunes.apple.com/cn/app/ren-ren-cai-chang/id%@?mt=8",APPID];
                
                NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/%@",APPID];

                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            };
            _versionUpdateView.removeUpdateViewBlock = ^{
                // TODO
            };
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:kVersionUpdateNoticeKey];
        }
    }];
}


/**

 
 ******* 互连社区

#pragma mark -检测版本更新

- (void)checkTheUpdate
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[ACHttpSevices services] requestWithURLPost:@"http://itunes.apple.com/lookup?id=961510323" finishBlock:^(id object) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSArray *infoArray = [object objectForKey:@"results"];
        if ([infoArray count])
        {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *lastVersion = [releaseInfo objectForKey:@"version"];
            
            if (![lastVersion isEqualToString:appVersion])
            {
                trackViewURL = [releaseInfo objectForKey:@"trackViewUrl"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                [alert show];
            }else
            {
                if (self.shouldShowCheckUpdateAlert) {
                    
                    HUD = [[MBProgressHUD alloc] initWithView:self.window];
                    [self.window addSubview:HUD];
                    HUD.labelText = @"已是最新版本";
                    //                    HUD.detailsLabelText = @"提示";
                    HUD.mode = MBProgressHUDModeText;
                    
                    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
                    //    HUD.yOffset = 150.0f;
                    //    HUD.xOffset = 100.0f;
                    
                    [HUD showAnimated:YES whileExecutingBlock:^{
                        sleep(2);
                    } completionBlock:^{
                        [HUD removeFromSuperview];
                        HUD = nil;
                    }];
                    
                    //                    UIAlertView *alert = nil;
                    //                    alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已是最新版本" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                    //                    [alert show];
                    
                }
                //                UIAlertView *alert = nil;
                //                alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已是最新版本" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                //                [alert show];
            }
        }
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}
 */

@end
