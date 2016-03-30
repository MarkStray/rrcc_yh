//
//  WMString-Utilities.h
//  Wonderful Moment
//
//  Created by 江志磊  on 11/9/09.
//

#import <Foundation/Foundation.h>


@interface NSString (Date)

/*!
 @function   string2Date:
 @abstract   Change given string to NSDate
 @discussion If the given str is wrong, should return the current system date
 @param      dateStr A string include the date like "2009-11-09 11:14:41"
 @result     The NSDate object with given format
 */

+ (NSDate *)string2Date:(NSString *)dateStr;

+ (NSDate *)dateToLocation:(NSDate *)date isCurrent:(BOOL)isCurrent;

/*!
 @function   stringFromCurrent:
 @abstract   Change given date string to "xxx ago" format
 @discussion If the given str is wrong, should return the current date
 @param      dateStr A string include the date like "2009-11-09 11:14:41" at least 10 characters
 @result     The string with "xxx ago", xxx: years, months, days, hours, minutes, seconds
 */
+ (NSString *)stringFromCurrent:(NSString *)dateStr;

//时间戳字符串转化为 格式化时间戳字符串(- yMdHms)
+ (NSString *)timeStamp:(NSString *)stamp;

//时间戳字符串转化为 格式化时间戳字符串(- yMd)
+ (NSString *)timeStampWithYMD:(NSString *)stamp;

//当前时间转化为 格式化时间戳字符串(- yMd)
+ (NSString *)timeStampWithNowYMD;

////////////////////////////////////////////////////////////

// 格式化时间字符串转化为时间
//yMd Hms
+ (NSDate *)stringToDate_yMdHms:(NSString *)dateStr;

// yMd
+ (NSDate *)stringToDate_yMd:(NSString *)dateStr;

// 自定义
+ (NSDate *)stringToDate:(NSString *)dateStr dateFormatter:(NSString *)dateFormatter;

@end
