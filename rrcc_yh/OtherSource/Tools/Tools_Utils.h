//
//  Tools_Utils.h
//  MyStyle
//
//  Created by kangylk on 14-4-2.
//  Copyright (c) 2014年 Kevin Kang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools_Utils : NSObject

+(void)setExtraCellLineHidden: (UITableView *)tableView;
+(void)setUISegmentedControlDefault: (UISegmentedControl *)seg;



+ (Tools_Utils*)creat;

+(UIButton*) createBackButton;
+(UIButton*) createRightButton:(NSString*)str;

+(NSString *)nullString:(NSString*)str;
+(BOOL)isNullString:(id)str;
+ (BOOL)isNullOrSpaceString:(id)str;
+(NSString*)UrlValueEncode:(NSString*)str;

+(NSString *)getFullImagePath:(NSString *)ss;
+(NSString *)get160ImagePath:(NSString*)ss;
+(NSString *)get320ImagePath:(NSString*)ss;
+(NSString *)get640ImagePath:(NSString*)ss;

+ (BOOL)stringContainsEmoji:(NSString *)string;

+ (NSString *)UUIDString;

+ (BOOL)validateMobile:(NSString *)mobileNum;
+ (NSString*)deviceString;
+(BOOL)isIPhone5S;
+ (UIViewController *)parentController:(UIView*)view;
+ (UINavigationController *)parentNavController:(UIView*)view;

+ (UIImageView *)addBgDefaultViewIn:(UIView*)pView;
+ (int)convertStringToInt:(NSString*)strtemp;

+ (NSString *)phonetic:(NSString*)sourceString;
+(NSDate *)getDateFromStr:(NSString *)str;
+ (NSString *)getTimeStrFromStr:(NSString *)str;
+ (NSString *)getCurrentTime;

@end
