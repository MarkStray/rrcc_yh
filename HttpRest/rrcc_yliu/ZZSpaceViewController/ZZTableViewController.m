//
//  ZZSpace
//  详情控制器
//

#import "ZZTableViewController.h"

#import "ZZTableView.h"
#import "UIImage+Image.h"

@interface ZZTableViewController ()

@property (nonatomic, assign) CGFloat lastOffsetY;

@end

@implementation ZZTableViewController

- (void)loadView {
    ZZTableView *tableView = [[ZZTableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lastOffsetY = -(ZZHeadViewH + ZZTabBarH);
    
    // 设置顶部额外滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(ZZHeadViewH + ZZTabBarH , 0, 0, 0);
    
    ZZTableView *tableView = (ZZTableView *)self.tableView;
    tableView.tabBar = _tabBar;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获取当前偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 获取偏移量差值 _lastOffsetY = -200-44
    CGFloat delta = offsetY - _lastOffsetY;
    
    CGFloat headH = ZZHeadViewH - delta;
    
    if (headH < ZZHeadViewMinH) {
        headH = ZZHeadViewMinH;
    }
    
    _headHCons.constant = headH;
    
    // 计算透明度，刚好拖动  200 - 64  ==  136，透明度为1
    CGFloat alpha = delta / (ZZHeadViewH - ZZHeadViewMinH);
    
    // 获取透明颜色
    UIColor *alphaColor = [UIColor colorWithWhite:1 alpha:alpha];
    [_titleLabel setTextColor:alphaColor];
    // 设置导航条背景图片
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:alpha]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:41/255.f green:156/255.f blue:25/255.f alpha:alpha]] forBarMetrics:UIBarMetricsDefault];
}

@end
