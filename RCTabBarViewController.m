//
//  RCTabBarViewController.m
//  rrcc_yh
//
//  Created by user on 15/9/16.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "RCTabBarViewController.h"
#import "BZTabBar.h"

#import "HomeViewController.h"
#import "CategoryViewController.h"
#import "MineViewController.h"

#import "ShoppingCarViewController.h"

@interface RCTabBarViewController () <BZTabBarDelegate>

@property (nonatomic, strong) NSMutableArray *NavigationList;
@property (nonatomic, strong) BZTabBar *BZTabBar;

//@property (nonatomic, assign) BOOL tabbarStatus;

@end

@implementation RCTabBarViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShoppingCarDidChange:) name:kBZTabbarShoppingCarDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TabBarVCWillShow:) name:kTabBarViewControllerWillShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBZTabbarShoppingCarDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTabBarViewControllerWillShowNotification object:nil];

}

- (void)ShoppingCarDidChange:(NSNotification *)notify {
    int badge = [notify.userInfo[@"badge"] intValue];
    self.BZTabBar.badgeCount = badge;
}

- (void)TabBarVCWillShow:(NSNotification *)notify {
    NSInteger index = [notify.userInfo[@"index"] integerValue];
    self.selectedIndex = index;// 切换至首页视图
    XHBaseNavigationController *nav = self.NavigationList[index];
    [SingleUserInfo sharedInstance].nav = nav;
    [self.BZTabBar skipToItemAction:index];// 按钮动画
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSArray *controllers = @[@"MainViewController",@"CategoryViewController",@"MineViewController"];
    NSArray *controllers = @[@"HomeViewController",@"CategoryViewController",@"MineViewController"];
    
    self.NavigationList = [NSMutableArray array];
    for (NSInteger i=0; i<3; i++) {
        Class class = NSClassFromString(controllers[i]);
        XHBaseViewController *bvc = [[class alloc] init];
        XHBaseNavigationController *nav = [[XHBaseNavigationController alloc] initWithRootViewController:bvc];
        [self.NavigationList addObject:nav];
    }
    self.viewControllers = [self.NavigationList copy];
    [SingleUserInfo sharedInstance].nav = [self.NavigationList firstObject];
    
    self.BZTabBar = [[BZTabBar alloc] initWithFrame:CGRectMake(0, kScreenHeight-65, kScreenWidth, 65)];//49
    self.BZTabBar.delegate = self;
    self.BZTabBar.tag = _tabbar_tag;
    [self.view addSubview:self.BZTabBar];
    self.tabBar.hidden = YES;
    self.selectedIndex = 0;
}

#pragma mark BZTabBarDelegate

- (void)BZTabBarSelectedIndexDidChange:(NSInteger)index {
    self.selectedIndex = index;// 切换视图
    XHBaseNavigationController *nav = self.NavigationList[self.selectedIndex];
    [SingleUserInfo sharedInstance].nav = nav;
}

- (void)BZTabBarGoHandle:(BZTabBar *)tabbar {
    NSInteger count = [[SingleShoppingCar sharedInstance] productsDataSource].count;
    if (count == 0) {
        show_alertView(@"亲，您的购物车空空如也!");
    } else {
        XHBaseNavigationController *nav = self.NavigationList[self.selectedIndex];
        // 获取到当前的 nav
        [SingleUserInfo sharedInstance].nav = nav;

        if ([[SingleShoppingCar sharedInstance] isCarPushIntoDetailVC]) {
            [[SingleUserInfo sharedInstance].nav popViewControllerAnimated:YES];
            [[SingleShoppingCar sharedInstance] setIsCarPushIntoDetailVC:NO];
        } else {
            ShoppingCarViewController *shoppingCar = [[ShoppingCarViewController alloc] init];
            [[SingleUserInfo sharedInstance].nav pushViewController:shoppingCar animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
