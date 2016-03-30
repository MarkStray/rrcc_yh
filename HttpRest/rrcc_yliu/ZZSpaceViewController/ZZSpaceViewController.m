//
//  ZZSpace
//  详情控制器
//

#import "ZZSpaceViewController.h"

#import "ZZTableViewController.h"

extern NSString *ZZItemDidSelectedNotification;
extern NSString *ZZItemDidSelectedKey;

@interface ZZSpaceViewController ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *selectedBtn;

// 容器
@property (nonatomic, strong) UIView *contentView;

// 背景容器
@property (nonatomic, strong) UIView *contentBgView;

// 明信片控件
@property (nonatomic, strong) UIImageView *cardView;

// 头像控件
@property (nonatomic, strong) UIImageView *iconView;

// item控件
@property (nonatomic, strong) UIView *tabBar;



@property (nonatomic, strong) NSLayoutConstraint *contentBgViewH;

@end

@implementation ZZSpaceViewController

- (void)loadView {
    [super loadView];
    self.contentView = [UIView new];
    self.contentBgView = [UIView new];
    self.cardView = [UIImageView new];
    self.iconView = [UIImageView new];
    self.tabBar = [UIView new];

    [self.view addSubview:self.contentView];
    [self.view addSubview:self.contentBgView];
    [self.contentBgView addSubview:self.cardView];
    [self.contentBgView addSubview:self.iconView];
    [self.view addSubview:self.tabBar];
    
    [self addContentViewConstraint];
    [self addContentBgViewConstraint];
    [self addIconViewConstraint];
    [self addCardViewConstraint];
    [self addTabBarConstraint];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // 不自动添加额外滚动区域
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentBgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tabBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.contentView.bounds = self.view.bounds;
    self.contentBgView.userInteractionEnabled = NO;
    self.tabBar.userInteractionEnabled = NO;
    self.tabBar.backgroundColor = UIColorFromHEX(0x225b14);
    
    self.cardView.clipsToBounds = YES;
    self.cardView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;

    
    // 接收按钮点击通知
    [[NSNotificationCenter defaultCenter] addObserverForName:ZZItemDidSelectedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        UIButton *clickBtnObjc = note.userInfo[ZZItemDidSelectedKey];
        [self btnClick:clickBtnObjc];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 即将显示的时候做一次初始化操作
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setUpNav];
        // 设置子控制器
        [self setUpChildControlller];
        // 设置tabBar
        [self setUpTabBar];
    });
}

// 设置导航条
- (void)setUpNav {
    // 导航条背景透明
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    // 设置导航条中间view
    UILabel *label = [[UILabel alloc] init];
    
    _titleLabel = label;
    
    label.font = [UIFont  boldSystemFontOfSize:18];
    
    label.text = self.title;
    
    [label setTextColor:[UIColor colorWithWhite:1 alpha:0]];
    
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
}

// 设置子控制器
- (void)setUpChildControlller {
    for (ZZTableViewController *personChildVc in self.childViewControllers) {
        
        self.iconView.image = self.personIconImage;
        
        self.cardView.image = self.personCardImage;
        
        // 传递tabBar，用来判断点击了哪个按钮
        personChildVc.tabBar = _tabBar;
        
        // 传递高度约束，用来移动头部视图
        personChildVc.headHCons = _contentBgViewH;
        
        // 传递标题控件，设置文字透明
        personChildVc.titleLabel = _titleLabel;
        
    }
}

 // 设置tabBar
- (void)setUpTabBar {
    // 遍历子控制器

    for (UIViewController *childVc in self.childViewControllers) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = _tabBar.subviews.count;
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btn setTitle:childVc.title forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        if (btn.tag == 0) [self btnClick:btn];
        
        [_tabBar addSubview:btn];
    }
    
}

- (void)btnClick:(UIButton *)btn {
    
    if (btn == _selectedBtn) return;
    
    // 将上一次选中的控制器的view移除内容视图
    UITableView *lastVcView = (UITableView *)[self.childViewControllers[_selectedBtn.tag] view];
    [lastVcView removeFromSuperview];
    
    // 选中按钮
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;

    // 切换内容视图显示
    UITableViewController *vc = self.childViewControllers[btn.tag];
    
    vc.view.frame = _contentView.bounds;
    
    [_contentView addSubview:vc.view];
    
    // 设置tableView的滚动区域
    vc.tableView.contentOffset = lastVcView.contentOffset;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 布局tabBar子控件位置
    NSUInteger count = _tabBar.subviews.count;
    
    CGFloat btnW = self.view.bounds.size.width / count;
    
    CGFloat btnH = _tabBar.bounds.size.height;
    
    CGFloat btnX = 0;
    
    CGFloat btnY = 0;
    
    for (int i = 0; i < count; i++) {
        
        btnX = i * btnW;
        
        UIView *childV = _tabBar.subviews[i];
        
        childV.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
    }
}

/////////////////////////////// - 视图 - 约束 - //////////////////////////////

- (void)addContentViewConstraint {
    //指定上边的约束
    NSLayoutConstraint *contentViewT = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    //指定左边的约束
    NSLayoutConstraint *contentViewL = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    //指定下边约束
    NSLayoutConstraint *contentViewB = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    //指定右边约束
    NSLayoutConstraint *contentViewR = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    //把约束添加到自己的父视图上
    [self.view addConstraint:contentViewT];
    [self.view addConstraint:contentViewL];
    [self.view addConstraint:contentViewB];
    [self.view addConstraint:contentViewR];
}

- (void)addContentBgViewConstraint {
    //指定上边的约束
    NSLayoutConstraint *contentViewT = [NSLayoutConstraint constraintWithItem:self.contentBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    //指定左边的约束
    NSLayoutConstraint *contentViewL = [NSLayoutConstraint constraintWithItem:self.contentBgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    //指定高度约束
    NSLayoutConstraint *contentViewH = [NSLayoutConstraint constraintWithItem:self.contentBgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:ZZHeadViewH];
    self.contentBgViewH = contentViewH;
    
    //指定右边约束
    NSLayoutConstraint *contentViewR = [NSLayoutConstraint constraintWithItem:self.contentBgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    //把约束添加到自己的父视图上
    
    [self.view addConstraint:contentViewT];
    [self.view addConstraint:contentViewL];
    [self.view addConstraint:contentViewH];
    [self.view addConstraint:contentViewR];
}

- (void)addCardViewConstraint {
    //指定上边的约束
    NSLayoutConstraint *contentViewT = [NSLayoutConstraint constraintWithItem:self.cardView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentBgView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    //指定左边的约束
    NSLayoutConstraint *contentViewL = [NSLayoutConstraint constraintWithItem:self.cardView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentBgView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    //指定下边约束
    NSLayoutConstraint *contentViewB = [NSLayoutConstraint constraintWithItem:self.cardView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    //指定右边约束
    NSLayoutConstraint *contentViewR = [NSLayoutConstraint constraintWithItem:self.cardView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentBgView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    //把约束添加到自己的父视图上
    [self.contentBgView addConstraint:contentViewT];
    [self.contentBgView addConstraint:contentViewL];
    [self.contentBgView addConstraint:contentViewB];
    [self.contentBgView addConstraint:contentViewR];
}



- (void)addIconViewConstraint {
    //指定高度约束
    NSLayoutConstraint *contentViewH = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:ZZIconWH];
    
    //指定宽度约束
    NSLayoutConstraint *contentViewW = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:ZZIconWH];
    
    //指定水平约束
    NSLayoutConstraint *contentViewX = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentBgView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    //指定竖直约束
    NSLayoutConstraint *contentViewB = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:-ZZHeadViewMinH];
    
    //把约束添加到自己的父视图上
    [self.contentBgView addConstraint:contentViewH];
    [self.contentBgView addConstraint:contentViewW];
    [self.contentBgView addConstraint:contentViewX];
    [self.contentBgView addConstraint:contentViewB];
}


- (void)addTabBarConstraint {
    //指定上边的约束
    NSLayoutConstraint *contentViewT = [NSLayoutConstraint constraintWithItem:self.tabBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    //指定左边的约束
    NSLayoutConstraint *contentViewL = [NSLayoutConstraint constraintWithItem:self.tabBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    //指定高度约束
    NSLayoutConstraint *contentViewH = [NSLayoutConstraint constraintWithItem:self.tabBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:ZZTabBarH];
    
    //指定右边约束
    NSLayoutConstraint *contentViewR = [NSLayoutConstraint constraintWithItem:self.tabBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    //把约束添加到自己的父视图上
    [self.view addConstraint:contentViewT];
    [self.view addConstraint:contentViewL];
    [self.view addConstraint:contentViewH];
    [self.view addConstraint:contentViewR];
}




@end
