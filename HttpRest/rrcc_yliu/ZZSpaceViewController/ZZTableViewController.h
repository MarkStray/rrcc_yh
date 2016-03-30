//
//  ZZSpace
//  详情控制器
//

#import <UIKit/UIKit.h>

// 默认头高度
#define ZZHeadViewH     180
// 最小头高度
#define ZZHeadViewMinH  64
// tabbar高度
#define ZZTabBarH       44
// 头像高度
#define ZZIconWH        100

@interface ZZTableViewController : UITableViewController

@property (nonatomic, strong)   UIView *tabBar;

@property (nonatomic, strong)  NSLayoutConstraint *headHCons;

@property (nonatomic, strong) UILabel *titleLabel;

@end
