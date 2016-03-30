//
//  NSObject_system.h
//  AFDFramework
//
//  Created by thomas on 13-7-9.
//  Copyright (c) 2013年 thomas. All rights reserved.
//

#ifdef _foundation_defines
#else

// 去除 时间日期
//#ifdef DEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#else
//#define NSLog(...) {}
//#endif


#define docPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define docDataPath [docPath stringByAppendingPathComponent:@"data.db"]
//#define docDataInfoPath [docPath stringByAppendingPathComponent:@"Data/info"]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define kGreenColor  RGBCOLOR(56, 184, 1)
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//判断系统是否是iOS7
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)


#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

//#define kScreenWidth    320
//#define kScreenHeight   [UIScreen mainScreen].bounds.size.height > 480 ? 568 : 480

#define kApplicationFrameHeight [UIScreen mainScreen].applicationFrame.size.height

/* 快速兼容iPhone6/6 Plus */

#define autoSizeScaleX  [[AppDelegate Share] ScaleX]

#define autoSizeScaleY  [[AppDelegate Share] ScaleY]

CG_INLINE CGRect
ZZRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x * autoSizeScaleX; rect.origin.y = y * autoSizeScaleY;
    rect.size.width = width * autoSizeScaleX; rect.size.height = height * autoSizeScaleY;
    return rect;
}


//#define CGRectMake(x, y, width, height) \
        CGRectMake(x*autoSizeScaleX, y*autoSizeScaleY, width*autoSizeScaleX, height*autoSizeScaleY)
//#define CGPointMake(x, y) \
        CGPointMake(x*autoSizeScaleX, y*autoSizeScaleY)


#define BoldFont(x) [UIFont boldSystemFontOfSize:x*autoSizeScaleX]
#define Font(x) [UIFont systemFontOfSize:x*autoSizeScaleX]


#define W(obj)   (!obj?0:(obj).frame.size.width)
#define H(obj)   (!obj?0:(obj).frame.size.height)
#define X(obj)   (!obj?0:(obj).frame.origin.x)
#define Y(obj)   (!obj?0:(obj).frame.origin.y)
#define XW(obj) X(obj)+W(obj)
#define YH(obj) Y(obj)+H(obj)


#define CGRectMakeXY(x,y,size) CGRectMake(x,y,size.width,size.height)
#define CGRectMakeWH(origin,w,h) CGRectMake(origin.x,origin.y,w,h)

#define S2N(x) [NSNumber numberWithInt:[x intValue]]
#define I2N(x) [NSNumber numberWithInt:x]
#define F2N(x) [NSNumber numberWithFloat:x]


#define CN 1
#define UI_language(cn,us) CN?cn:us

#define UI_btn_back CN?@"返回":@"back"

#define UI_btn_search CN?@"搜索":@"Search"

#define UI_btn_upload CN?@"上传":@"Upload"
#define UI_btn_submit CN?@"提交":@"Submit"
#define UI_btn_cancel CN?@"取消":@"cancel"
#define UI_btn_confirm CN?@"确定":@"OK"
#define UI_btn_delete CN?@"删除":@"Delete"
#define UI_tips_load CN?@"正在加载...":@"Loading..."

#define alertErrorTxt @"服务器异常"


#endif