//
//  Tools_Utils.m
//  MyStyle
//
//  Created by kangylk on 14-4-2.
//  Copyright (c) 2014年 Kevin Kang. All rights reserved.
//

#import "Tools_Utils.h"
#import <AVFoundation/AVFoundation.h>
#import "sys/utsname.h"
//#import "EETools_Infor.h"


@implementation Tools_Utils
+ (Tools_Utils*)creat{
    static Tools_Utils *instance = nil;
    @synchronized(self){
        if (!instance) {
            instance = [[Tools_Utils alloc] init];
        }
    }
    
    return instance;
}


+(UIButton*) createBackButton
{
    UIImage* image= [UIImage imageNamed:@"Arrow_Normal"];
    UIImage* imagef = [UIImage imageNamed:@"Arrow_Press"];
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 60, 44);
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    if (IOS7) {
        [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    }else{
        [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    }
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:imagef forState:UIControlStateHighlighted];
    return backButton;
}

+(UIButton*) createRightButton:(NSString*)str
{
    UIButton *rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 80, 44)];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    if (IOS7) {
        [rightButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    }else{
        [rightButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    }
    [rightButton setTitle:str forState:UIControlStateNormal];
    return rightButton;
    
}

+ (NSString *)nullString:(NSString*)str
{
    if ([self isNullString:str]) {
        str = @"";
    }
    return str;
}

+ (BOOL)isNullString:(id)str
{
    if(str == nil || [str isEqual:@"<null>"] || [str isEqual:[NSNull null]] || [str isEqual:@"null"] || [str isEqual:@"(null)"] || [str isEqual:@"NULL"]) return YES;
    return NO;
}

+ (BOOL)isNullOrSpaceString:(id)str
{
    if(str == nil || [str isEqual:@"<null>"] || [str isEqual:[NSNull null]] || [str isEqual:@"null"] || [str isEqual:@"(null)"] || [str isEqual:@"NULL"] || [str isEqual:@""])
        return YES;
    if ([str isKindOfClass:[NSString class]] && [str rangeOfString:@"null null"].length>1) {
        return YES;
    }
    return NO;
}




+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
         
     }];
    return returnValue;
}

#define UUID_KEY (@"MobileUUID")
+ (NSString *)UUIDString
{
    NSString *uuidString = [[NSUserDefaults standardUserDefaults] objectForKey:UUID_KEY];
    
    if(uuidString && [uuidString length])
    {
        return uuidString;
    }
    else
    {
        CFUUIDRef uuidRef = CFUUIDCreate(nil);
        CFStringRef stringRef = CFUUIDCreateString(nil, uuidRef);
        uuidString = (NSString *)CFBridgingRelease(CFStringCreateCopy(nil, stringRef));
        CFRelease(uuidRef);
        CFRelease(stringRef);
        
        [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:UUID_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    return nil;
}

+ (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    NSString *C11 = @"^1([3-9])\\d{9}$";
    NSPredicate *regextest11 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",C11];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextest11 evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])   return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])   return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])   return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])   return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])
        return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])   return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])   return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])   return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])   return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])   return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])   return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])   return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])   return @"iPhone 6";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])     return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])     return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])     return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])     return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])     return @"iPod Touch 5";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])     return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])     return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])     return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])     return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,5"])     return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad3,1"])     return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,2"])     return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,3"])     return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])     return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,5"])     return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])     return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad4,1"])     return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])     return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])     return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,1"])     return @"iPad Air2";
    if ([deviceString isEqualToString:@"iPad5,2"])     return @"iPad Air2";
    if ([deviceString isEqualToString:@"iPad5,3"])     return @"iPad Air2";
    
    //iPad mini
    if ([deviceString isEqualToString:@"iPad2,5"])     return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,6"])     return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])     return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad4,4"])     return @"iPad Mini2";
    if ([deviceString isEqualToString:@"iPad4,5"])     return @"iPad Mini2";
    if ([deviceString isEqualToString:@"iPad4,6"])     return @"iPad Mini2";
    if ([deviceString isEqualToString:@"iPad4,7"])     return @"iPad Mini3";
    if ([deviceString isEqualToString:@"iPad4,8"])     return @"iPad Mini3";
    if ([deviceString isEqualToString:@"iPad4,9"])     return @"iPad Mini3";
    
    //Simulator
    if ([deviceString isEqualToString:@"i386"])        return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])      return @"Simulator";
    
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

+ (BOOL)isIPhone5S
{
    if ([[Tools_Utils deviceString] isEqualToString:@"iPhone 5S"]) {
        return YES;
    }
    return NO;
}

+ (UIViewController *)parentController:(UIView*)view
{
    for (UIView* next = [view superview]; next; next =
         next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                         class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
+ (UINavigationController *)parentNavController:(UIView*)view
{
    for (UIView* next = [view superview]; next; next =
         next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController
                                          class]]) {
            return (UINavigationController*)nextResponder;
        }
    }
    return nil;
}


+ (UIImageView *)addBgDefaultViewIn:(UIView*)pView
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:pView.bounds];
    UIImage *img = [UIImage imageNamed:@"photo_viewbg"];
    [imageView setImage:img];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [imageView setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
    [pView insertSubview:imageView atIndex:0];
    return imageView;
}






+(NSDate *)getDateFromStr:(NSString *)str
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *data = [dateFormatter dateFromString:str];
    return data;
}






+ (NSString *)getCurrentTime
{
    NSDate *data = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *bornStr = [dateFormatter stringFromDate:data];
    return bornStr;
}

+(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}



@end
