//
//  BZ_Tools.h
//  rrcc_yh
//
//  Created by user on 15/6/18.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromHEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

/* UIButton imageView.size {24,24} font 18.00pt */

@interface BZ_Tools : NSObject 

/* 动态计算String高度 */
+ (CGFloat)heightForTextString:(NSString *)tStr width:(CGFloat)tWidth fontSize:(CGFloat)tSize;

/* 动态计算String宽度 */
+ (CGFloat)widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize;

/* 获取设备相关字符串1 */
+ (NSString*)deviceString;

/* 获取设备相关字符串2 */
+ (NSString *)getCurrentDeviceModel;

/* 16进制表示的颜色 转为 UIColor 对象 */
+ (UIColor *)stringWithUIColor:(NSString *)str;

/* 获取当前的日期组件 */
+ (NSDateComponents *)dateComponentsToDate:(NSDate *)date isCurrentDate:(BOOL)isNow;

// 获取ip地址
+ (NSString *)getDeviceIPAddress;// sample

+ (NSString *)getIPAddress:(BOOL)preferIPv4;
+ (NSDictionary *)getIPAddresses;

// Show the tree
+ (void)recursiveDescription:(UIView *)sView;

+ (void)logViewTreeForMainWindow;

@end
