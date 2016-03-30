
#import "NSDictionary+expanded.h"
#import <UIKit/UIKit.h>


// 底部tabbar 的tag值
#define _tabbar_tag 9999


typedef void(^XHBarButtonItemActionBlock)(void);

typedef NS_ENUM(NSInteger, XHBarbuttonItemStyle) {
    XHBarbuttonItemStyleSetting = 0,
    XHBarbuttonItemStyleMore,
    XHBarbuttonItemStyleCamera,
    XHBarbuttonItemStyleAdd,
};

@interface XHBaseViewController : UIViewController
{
    UIView *_lowerFloorView;
}
@property (nonatomic, strong) UIView *lowerFloorView;// 底层


- (void)configureBarbuttonItemStyle:(XHBarbuttonItemStyle)style action:(XHBarButtonItemActionBlock)action;
- (void)configureBackBarbuttonAction:(XHBarButtonItemActionBlock)action;

/**
 *  统一设置背景图片
 *
 *  @param backgroundImage 目标背景图片
 */

- (void)setupBackgroundImage:(UIImage *)backgroundImage;

/**
 *  push新的控制器到导航控制器
 *
 *  @param newViewController 目标新的控制器对象
 */
- (void)pushNewViewController:(UIViewController *)newViewController;
- (void)pushReplaceViewController:(UIViewController *)newViewController;
- (void)pushRootViewController:(UIViewController *)newViewController;

/**
 *  显示 tip translucentView
 */

- (void) popTipView:(UIView *)aView;
- (void) pushTipView:(UIView *)aView;

/**
 *  显示加载的loading.gif
 */

- (void)showLoadingGIF;
- (void)hideLoadingGIF;

/**
 *  显示加载的菊花
 */

- (void)showLoadingIndicator;
- (void)showLoadingIndicatorWithText:(NSString *)text;

- (void)hideLoadingIndicator;


/**
 *  显示带有某个文本的hud
 *  @param text 目标文本
 */

- (void)showHUDWithText:(NSString *)text;

- (void)showSuccessHUDWithText:(NSString *)text;

- (void)showErrorHUDWithText:(NSString *)text;

/** costom view */
- (void)showHUDWithText:(NSString *)text onView:(UIView *)aView;

- (void)showSuccessHUDWithText:(NSString *)text onView:(UIView *)aView;

- (void)showErrorHUDWithText:(NSString *)text onView:(UIView *)aView;

- (void)hideHUD;

/**
 *  显示底部的tabbar
 */
- (void)showCustomTabBar;

/**
 *  隐藏底部的tabbar
 */
- (void)hideCustomTabBar;



@end
