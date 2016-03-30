//
//  BZ_Tools.m
//  rrcc_yh
//
//  Created by user on 15/6/18.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "BZ_Tools.h"
#import "sys/utsname.h"
#import <sys/sysctl.h>

#import <ifaddrs.h>// ip relate
#import <arpa/inet.h>
#include <net/if.h>

#ifndef kScreenWidth
    #define kScreenWidth [[UIScreen mainScreen] bounds].size.width
    #define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#endif

#define kCurrentIOS [[[UIDevice currentDevice] systemVersion] doubleValue]

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation BZ_Tools


/**
*  根据字符串的实际内容的多少 在固定的宽度和字体的大小，动态的计算出实际的高度
*
*  @param tStr   待计算的字符串
*  @param tWidth 给定的宽度值
*  @param tSize  给定的字体大小
*
*  @return 字符串字体(label)高度
*/

+ (CGFloat) heightForTextString:(NSString *)tStr width:(CGFloat)tWidth fontSize:(CGFloat)tSize {
    if (kCurrentIOS >= 7.0) {// iOS7之后
        /**
         *  第一个参数: 预设空间 宽度固定  高度预设 一个最大值
         *  第二个参数: 行间距 如果超出范围是否截断
         *  第三个参数: 属性字典 可以设置字体大小
         */
        NSDictionary *dict = @{NSFontAttributeName:Font(tSize)};
        CGRect rect = [tStr boundingRectWithSize:CGSizeMake(tWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        return rect.size.height;
        
    }else{// iOS7之前
        /**
         *  1.第一个参数  设置的字体固定大小
         *  2.预设 宽度和高度 宽度是固定的 高度一般写成最大值
         *  3.换行模式 字符换行
         */
        CGSize textSize = [tStr sizeWithFont:Font(tSize) constrainedToSize:CGSizeMake(tWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        return textSize.height;
    }
}
/**
 *  动态的计算出实际的宽度
 *
 *  @param tStr    待计算的字符串
 *  @param tHeight 给定的高度值
 *  @param tSize   给定的字号
 *
 *  @return 字符串字体(label)宽度
 */
+ (CGFloat) widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize{
    if (kCurrentIOS >= 7.0) {
        NSDictionary *dict = @{NSFontAttributeName:Font(tSize)};
        CGRect rect = [tStr boundingRectWithSize:CGSizeMake(MAXFLOAT, tHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        return rect.size.width;
    }else{
        CGSize textSize = [tStr sizeWithFont:Font(tSize) constrainedToSize:CGSizeMake(MAXFLOAT, tHeight) lineBreakMode:NSLineBreakByCharWrapping];
        return textSize.width;
    }
}

+ (NSString*)deviceString {
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

+ (NSString *)getCurrentDeviceModel {
    
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6S Plus";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6S";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G ";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G ";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G ";
    
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3 ";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3 ";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3 ";
    
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4 WiFi  ";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4 WiFi+Cellular ";
    
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air2 ";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air2 ";
    
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro WiFi ";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro WiFi+Cellular";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

/**
 *  16进制表示的颜色 转为 UIColor 对象
 *
 *  @param str 16进制字符串
 *
 *  @return UIColor对象
 */

// 0x12345678

+ (UIColor *) stringWithUIColor:(NSString *)str{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    unsigned alpha = 255.0f;
    int alphaLen = 0;
    range.length = 2;
    
    if (str.length > 8){
        alphaLen = 2;
        range.location = 1;
        [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&alpha];
    }
    
    range.location = 1 + alphaLen;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3 + alphaLen;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5 + alphaLen;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
    
    return color;
}

/* 获取当前的日期组件 */
+ (NSDateComponents *)dateComponentsToDate:(NSDate *)date isCurrentDate:(BOOL)isNow {
    NSCalendar *calender = [NSCalendar currentCalendar];//日历
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ;
    if (isNow) {
        NSDateComponents *d = [calender components:unitFlags fromDate:[NSDate date]];
        return d;
    }
    NSDateComponents *d = [calender components:unitFlags fromDate:date];
    return d;
}

///////////////////////////-IPAddress-/////////////////////////

+ (NSString *)getDeviceIPAddress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) { // 0 表示获取成功
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    
    // The dictionary keys have the form "interface" "/" "ipv4 or ipv6"
    return [addresses count] ? addresses : nil;
}


+ (void)recursiveDescription:(UIView *)sView {
    NSLog(@"\n%@", [sView performSelector:@selector(recursiveDescription)]);// 私有方法
}

// Recursively travel down the view tree, increasing the indentation level for children

+ (void)dumpView:(UIView *)aView atIndent:(int)indent into:(NSMutableString *)outstring {//step 3
    for (int i = 0; i < indent; i++) [outstring appendString:@"--"];
    [outstring appendFormat:@"[%2d] %@\n", indent, [[aView class] description]];
    for (UIView *view in [aView subviews])
        [self dumpView:view atIndent:indent + 1 into:outstring];
}
// Start the tree recursion at level 0 with the root view
+ (NSString *) displayViews: (UIView *) aView {//step 2
    NSMutableString *outstring = [[NSMutableString alloc] init];
    [self dumpView: aView atIndent:0 into:outstring];
    return outstring;
}
// Show the tree
+ (void)logViewTreeForMainWindow {//step 1
    //  CFShow([self displayViews: self.window]);
    NSLog(@"The view tree:\n%@", [self displayViews:[UIApplication sharedApplication].keyWindow]);
}

///////////////////////////---log-view-end---/////////////////////////

/* xib link xib */
//- (id) awakeAfterUsingCoder:(NSCoder*)aDecoder {
//    BOOL theThingThatGotLoadedWasJustAPlaceholder = ([[self subviews] count] == 0);
//    if (theThingThatGotLoadedWasJustAPlaceholder) {
//        //SubView* theRealThing = [[self class] loadFromNibNoOwner];
//        SubView *theRealThing = [[[NSBundle mainBundle] loadNibNamed:@"SubView" owner:nil options:nil] lastObject];
//        // pass properties through
//        [self copyUIPropertiesTo:theRealThing];
//        
//        //auto layout
//        self.translatesAutoresizingMaskIntoConstraints = NO;
//        theRealThing.translatesAutoresizingMaskIntoConstraints = NO;
//        
//        return theRealThing;
//    }
//    return self;
//}

//-(void) copyUIPropertiesTo:(UIView *)view
//{
//    // reflection did not work to get those lists, so I hardcoded them
//    // any suggestions are welcome here
//    
//    NSArray *properties =
//    [NSArray arrayWithObjects: @"frame",@"bounds", @"center", @"transform", @"contentScaleFactor", @"multipleTouchEnabled", @"exclusiveTouch", @"autoresizesSubviews", @"autoresizingMask", @"clipsToBounds", @"backgroundColor", @"alpha", @"opaque", @"clearsContextBeforeDrawing", @"hidden", @"contentMode", @"contentStretch", nil];
//    
//    // some getters have 'is' prefix
//    NSArray *getters =
//    [NSArray arrayWithObjects: @"frame", @"bounds", @"center", @"transform", @"contentScaleFactor", @"isMultipleTouchEnabled", @"isExclusiveTouch", @"autoresizesSubviews", @"autoresizingMask", @"clipsToBounds", @"backgroundColor", @"alpha", @"isOpaque", @"clearsContextBeforeDrawing", @"isHidden", @"contentMode", @"contentStretch", nil];
//    
//    for (int i=0; i<[properties count]; i++)
//    {
//        NSString * propertyName = [properties objectAtIndex:i];
//        NSString * getter = [getters objectAtIndex:i];
//        
//        SEL getPropertySelector = NSSelectorFromString(getter);
//        
//        // config setters e.g. setFrame, setBounds
//        NSString *setterSelectorName =
//        [propertyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[propertyName substringToIndex:1] capitalizedString]];
//        
//        setterSelectorName = [NSString stringWithFormat:@"set%@:", setterSelectorName];
//        
//        SEL setPropertySelector = NSSelectorFromString(setterSelectorName);
//        
//        if ([self respondsToSelector:getPropertySelector] && [view respondsToSelector:setPropertySelector])
//        {// replace by kvc
//            NSObject * propertyValue = [self valueForKey:propertyName];
//            
//            [view setValue:propertyValue forKey:propertyName];
//        }
//    }
//}


@end









