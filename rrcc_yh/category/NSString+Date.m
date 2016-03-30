//
//  WMString-Utilities.m
//  Wonderful Moment
//
//  Created by 江志磊 on 11/9/09.
//

#import "NSString+Date.h"

#define MINUTES		60
#define HOURS		3600
#define DAYS		86400
#define MONTHS		(86400 * 30)
#define YEARS		(86400 * 30 * 12)

@implementation NSString (Date)

/*!
 @function   string2Date:
 @abstract   Change given string to NSDate
 @discussion If the given str is wrong, should return the current system date
 @param      dateStr A string include the date like "2009-11-09 11:14:41"
 @result     The NSDate object with given format
 */
+ (NSDate *)string2Date:(NSString *)dateStr {

	if (10 > [dateStr length]) {
	
		return [NSDate date];
	}
	NSRange range;
	NSString *year, *month, *day, *hr, *mn, *sec;
	range.location = 0;
	range.length = 4;
	year = [dateStr substringWithRange:range];
	
	range.location = 5;
	range.length = 2;
	month = [dateStr substringWithRange:range];
	
	range.location = 8;
	range.length = 2;
	day = [dateStr substringWithRange:range];
	
	if (11 < [dateStr length]) {
		
		range.location = 11;
		range.length = 2;
		hr = [dateStr substringWithRange:range];
	} else {
		hr = @"0";
	}
	
	if (14 < [dateStr length]) {
		
		range.location = 14;
		range.length = 2;
		mn = [dateStr substringWithRange:range];
	} else {
		mn = @"0";
	}
	
	if (17 < [dateStr length]) {
		
		range.location = 17;
		range.length = 2;
		sec = [dateStr substringWithRange:range];
	} else {
		sec = @"0";
	}
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:		[year integerValue]];
	[comps setMonth:	[month integerValue]];
	[comps setDay:		[day integerValue]];
	[comps setHour:		[hr integerValue]];
	[comps setMinute:	[mn integerValue]];
	[comps setSecond:	[sec integerValue]];

	NSCalendar *gregorian = [NSCalendar autoupdatingCurrentCalendar];
	NSDate *returnDate = [gregorian dateFromComponents:comps];	
	//[comps release];
	return returnDate;
}

+ (NSDate *)dateToLocation:(NSDate *)date isCurrent:(BOOL)isCurrent{//转化为本地时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDate *flagDate = isCurrent?[NSDate date]:date;
    NSInteger interval = [zone secondsFromGMTForDate: flagDate];
    NSDate *localeDate = [flagDate  dateByAddingTimeInterval: interval];
    return localeDate;
}

/*!
 @function   stringFromCurrent:
 @abstract   Change given date string to "xxx ago" format
 @discussion If the given str is wrong, should return the current date
 @param      dateStr A string include the date like "2009-11-09 11:14:41" at least 10 characters
 @result     The string with "xxx ago", xxx: years, months, days, hours, minutes, seconds
 */
+ (NSString *)stringFromCurrent:(NSString *)dateStr {
	
	NSDate *earlierDate = [NSString string2Date:dateStr];
	
	NSDate *sysDate = [NSDate date];
//	 //NSLog(@"now from System [%@]", [sysDate description]);
	double timeInterval = [sysDate timeIntervalSinceDate:earlierDate];
//	 //NSLog(@"[%f]", timeInterval);
	
	NSInteger yearsAgo = timeInterval / YEARS;
	if (1 < yearsAgo) {
		
		return [NSString stringWithFormat:@"%ld 年以前", yearsAgo];
	} else if (1 == yearsAgo) {
		
		return @"1 年以前";
	}	
	
	NSInteger monthsAgo = timeInterval / MONTHS;
	if (1 < monthsAgo) {
		
		return [NSString stringWithFormat:@"%ld 月以前", monthsAgo];;
	} else if (1 == monthsAgo) {
		
		return [NSString stringWithFormat:@"1 月以前"];
	}	
	
	NSInteger daysAgo = timeInterval / DAYS;
	if (1 < daysAgo) {
		
		return [NSString stringWithFormat:@"%ld 天以前", daysAgo];
	} else if (1 == daysAgo) {

		return @"1 天以前";
	}
	
	NSInteger hoursAgo = timeInterval / HOURS;
	if (1 < hoursAgo) {
		
		return [NSString stringWithFormat:@"%ld 小时以前", hoursAgo];
	} else if (1 == hoursAgo) {
		
		return @"1小时以前";
	}

	NSInteger minutesAgo = timeInterval / MINUTES;
	if (1 < minutesAgo) {

		return [NSString stringWithFormat:@"%ld 分钟以前", minutesAgo];
	} else if (1 == minutesAgo) {
		
		return @"1 分钟以前";
	}
	// 1 sceond ago? we ignore this time
	return [NSString stringWithFormat:@"%ld 秒以前", (NSInteger)timeInterval];
}

//时间戳字符串转化为 格式化时间戳字符串(- yMdHms)
+(NSString *)timeStamp:(NSString *)stamp {
    NSTimeInterval time = [stamp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:detaildate];
}

//时间戳字符串转化为 格式化时间戳字符串(- yMd)
+ (NSString *)timeStampWithYMD:(NSString *)stamp {
    NSTimeInterval time=[stamp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:detaildate];
}

//当前时间转化为 格式化时间戳字符串(- yMd)
+ (NSString *)timeStampWithNowYMD {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}


////////////////////////////////////////////////////////////

// 格式化时间字符串转化为时间
//yMd Hms
+ (NSDate *)stringToDate_yMdHms:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateStr];
    return date;
}
// yMd
+ (NSDate *)stringToDate_yMd:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateStr];
    return date;
}
// 自定义
+ (NSDate *)stringToDate:(NSString *)dateStr dateFormatter:(NSString *)dateFormatter{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormatter];
    NSDate *date = [formatter dateFromString:dateStr];
    return date;
}





@end
