
//
//  rrcc_yliu_define.h
//

#import "EnumHeader.h"

#import "BZ_Tools.h"
#import "LineLabel.h"
#import "ZZFactory.h"

#import "ZZStarRating.h"
#import "BZExpandHeaderView.h"

#import "ModelHeader.h"
#import "ViewHeader.h"

#import "DataEngine.h"
#import "RCHttpServices.h"

#import "SingleShoppingCar.h"
#import "SingleUserInfo.h"

/* 订单操作类型 */
static const int HandleButtonBaseValue  =  1001;

typedef NS_ENUM(NSInteger, HandleButtonType) {
    HandleButtonTypeContactMerchant = 0,
    HandleButtonTypeImmediatePayment,
    HandleButtonTypeCancelOrder,
    HandleButtonTypeConfirmOrder,
    HandleButtonTypeTakeOrder,
};


// 调试开关
#define DEBUG 1

#ifdef DEBUG
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DLog(...)
#   define ELog(err)
#endif


/*alertView*/
#define show_alertView(msg) \
{\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil]; \
[alert show]; \
}\

/*animationAlert*/
#define show_animationAlert(msg) \
{\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil]; \
[alert show]; \
[alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES]; \
}\


/*sd加载图片*/
#define sd_image_url(obj, url) \
[obj sd_setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

#define sd_button_url(obj, url) \
[obj sd_setBackgroundImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal];


/*点击手势*/
#define add_tap_gesture(obj,sel) \
obj.userInteractionEnabled = YES; \
[obj addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sel)]];


/*城市小区列表key*/
#define kHistorySiteListKey                     @"HistorySiteListKey"
#define kDefaultSiteKey                         @"DefaultSiteKey"
#define kDistributerListKey                     @"DistributerListKey"

/*下单保存记录信息 Contact相关key*/
#define kContactName                            @"ContactName"
#define kContactMobile                          @"ContactMobile"
#define kContactAddress                         @"ContactAddress"


/*通知中心key*/
#define kDidSelectSiteNotification              @"DidSelectSiteNotification"

#define kDidLoginStatusNotification             @"DidLoginStatusNotification"// 登录

/*产品详情页清空key*/
#define kShoppingCarDidClearNotification        @"kShoppingCarDidClearNotification"


/*tabbar*/
#define kBZTabbarShoppingCarDidChangeNotification \
                                                @"BZTabbarShoppingCarDidChangeNotification"

#define kTabBarViewControllerWillShowNotification   \
                                                @"TabBarViewControllerWillShowNotification"


#define GLOBAL_COLOR        UIColorFromHEX(0x299C19)    // 绿色
#define BACKGROUND_COLOR    UIColorFromHEX(0xf3f3f3)    // 灰色
#define TEXT_COLOR          UIColorFromHEX(0xff4f00)    // 黄色


#define USERID          ([[[SingleUserInfo sharedInstance] playerInfoModel] userid])
#define PRIVATEKEY      ([[[SingleUserInfo sharedInstance] playerInfoModel] privateKey])














