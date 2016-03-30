//
//  HomeViewController.m
//  rrcc_yh
//
//  Created by user on 15/9/24.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "HomeViewController.h"
#import "ProductDetailViewController.h"
#import "AddressSearchViewController.h"
#import "SearchViewController.h"
#import "AdView.h"

#import <MapKit/MapKit.h>  // 苹果(高德)

// 民润大厦
// latitude 31.17301295
// longitude 121.39201281


const int base_radion_tag = 101;

NSString * const kMainCell           =   @"MainCell";
NSString * const kMainDoubleCell     =   @"MainDoubleCell";


@interface HomeViewController () <CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
/**
 *  定位管理
 */
@property (nonatomic, strong) CLLocationManager *locationManager;

/**
 *  定位出的小区列表
 */
@property (nonatomic, strong) NSMutableArray *siteList;
@property (nonatomic, strong) SiteListModel *siteListModel;

@property (nonatomic, strong) UIButton *titleButton; // 标题
@property (nonatomic, strong) BZExpandHeaderView *expandHeader;

@property (nonatomic, strong) NSArray *imagesURL;
@property (nonatomic, strong) NSMutableArray *distributerList;// 自提点
@property (nonatomic, assign) BOOL isDistributerActive;// 当前自提点是否可用

@property (nonatomic, strong) UIView *headerADView;

/**
 *  品牌(对应首页的图标)
 */
@property (nonatomic, strong) UIView *hotBrandView;

@property (nonatomic, strong) NSMutableArray *hotBrandList;


@property (nonatomic, assign) NSInteger radioIndex;
@property (nonatomic, strong) NSMutableArray *radioButtonList;
@property (nonatomic, strong) UIView *popView;

@property (nonatomic, strong) UITableView *homeTableView;
@property (nonatomic, strong) NSMutableArray *itemListDataSource;

//@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, copy) PresellModel *presellModel;

@property (nonatomic, assign) BOOL isDetaultSite;//是否已经有默认小区

@end

@implementation HomeViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidSelectSiteNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showCustomTabBar];
    
    self.radioIndex = 0;// 默认自提点选中第一个
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:kDidSelectSiteNotification object:nil];
    
    self.imagesURL = [NSArray array];
    self.itemListDataSource = [NSMutableArray array];
    self.distributerList = [NSMutableArray array];
    self.hotBrandList = [NSMutableArray array];
    self.radioButtonList = [NSMutableArray array];
    self.siteList = [NSMutableArray array];
    
    [self customNavigationBar];
    
    // 默认小区
    self.siteListModel = [[SingleShoppingCar sharedInstance] siteModel];
    
    if (self.siteListModel) {
        self.isDetaultSite = YES;
        
        // 更新为小区名
        [self updateTitleWithText:self.siteListModel.domainname];
        
        self.distributerList = [[SingleShoppingCar sharedInstance] distributerList];

        [self.distributerList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DistributerModel *model = obj;
            if ([model isDefault]) {
                // 更新为自提点名
                [self updateTitleWithText:model.sitename];
                
                // 当前自提点是否关闭
                [self getDistributerActiveStatus:model.id];
                
                *stop = YES;
            }
        }];
        
    } else {
        self.isDetaultSite = NO;
        [self starLocation];
    }
}

- (void)customNavigationBar {
    // custom titleView
    self.titleButton = [ZZFactory buttonWithFrame:CGRectMake(0, 0, kScreenWidth-60, 30) title:@"选择城市/小区" titleColor:[UIColor whiteColor] image:@"down-arrow" bgImage:nil];
    self.titleButton.titleLabel.font = Font(16);
    self.titleButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self updateTitleWithText:@"选择城市/小区"];
    [self.titleButton addTarget:self action:@selector(ShowAddress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.titleButton];
    
    
    //UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //aView.backgroundColor = [UIColor clearColor];// 左边填充
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aView];
    
    [self.view addSubview:self.homeTableView];
}

- (UITableView *)homeTableView {
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, self.view.height-64-49)];
        //_homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, self.view.height-64-49) style:UITableViewStylePlain];// 默认plain
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.backgroundColor = BACKGROUND_COLOR;
        _homeTableView.showsVerticalScrollIndicator = NO;
        _homeTableView.separatorColor = [UIColor clearColor];
        
        [_homeTableView registerNib:[UINib nibWithNibName:kMainCell bundle:nil] forCellReuseIdentifier:kMainCell];
        [_homeTableView registerNib:[UINib nibWithNibName:kMainDoubleCell bundle:nil] forCellReuseIdentifier:kMainDoubleCell];
    }
    return _homeTableView;
}

- (void)updateUI:(NSNotification *)notify{
    self.isDetaultSite = NO;

    self.siteListModel = notify.object;
    [[SingleShoppingCar sharedInstance] setSiteModel:self.siteListModel];// 默认小区
    
    [self updateTitleWithText:self.siteListModel.domainname];// 更改标题
    [self downloadSiteShopListDataWithSiteId:self.siteListModel.id];// 下载数据
}

- (void)updateTitleWithText:(NSString *)text {
    [self.titleButton setTitle:text forState:UIControlStateNormal];
    
    [self.titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.titleButton.imageView.bounds.size.width, 0, self.titleButton.imageView.bounds.size.width)];
    [self.titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleButton.titleLabel.bounds.size.width, 0, -self.titleButton.titleLabel.bounds.size.width)];
}

#pragma mark 
#pragma mark 请求数据

- (void)getDistributerActiveStatus:(NSString *)distributerId {
    [[DataEngine sharedInstance] requestCityDistributerActiveDataWithDistributerId:distributerId Success:^(id responseData) {
        
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"%@",dic);
        if ([dic[@"Success"] integerValue] == 1) {
            if ([dic[@"CallInfo"] boolValue]) {
                // 下载数据
                [self downloadSiteShopListDataWithSiteId:self.siteListModel.id];
            } else {
                self.isDetaultSite = NO;
                [self starLocation];
            }
        } else {
            self.isDetaultSite = NO;
            [self starLocation];
        }

    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

- (void)downloadSiteShopListDataWithSiteId:(NSString *)siteId {
    if ([self.view.subviews containsObject:self.lowerFloorView]) {
        [self.lowerFloorView removeFromSuperview];
    }
    [self showLoadingGIF];
    [[DataEngine sharedInstance] requestSiteProductListDataWithSiteId:siteId Success:^(id responseData) {
        [self hideLoadingGIF];
        //@"43914322"
        NSDictionary *dict = (NSDictionary *)responseData;
        DLog(@"%@",dict);
        if ([dict[@"Success"] integerValue] == 1) {

            // 模拟广告数量
//            NSMutableArray *imagesURL = [NSMutableArray arrayWithArray:dict[@"CallInfo"][@"advertise"]];
//            [imagesURL removeLastObject];
//            [imagesURL addObjectsFromArray:imagesURL];
//            [imagesURL addObjectsFromArray:imagesURL];
            
            // 第一步 品牌
            NSArray *imagesURL = [NSMutableArray arrayWithArray:dict[@"CallInfo"][@"advertise"]];
            self.imagesURL = imagesURL;
            
            // 第二步 广告
            [self.hotBrandList removeAllObjects];
            NSArray *hotBrandList = dict[@"CallInfo"][@"hotBrandList"];
            for (NSDictionary *dic in hotBrandList) {
                HotBrandModel *hModel = [HotBrandModel creatWithDictionary:dic];
                [self.hotBrandList addObject:hModel];
            }
            
            if (self.imagesURL.count != 0 || self.hotBrandList.count != 0) {
                [self creatHeaderView];
            }
            
            // 已经有默认的 就不需要再次解析
            if (!self.isDetaultSite) {
                [self.distributerList removeAllObjects];
                NSArray *distributerList = dict[@"CallInfo"][@"distributerList"];
                for (NSDictionary *dic in distributerList) {
                    DistributerModel *dModel = [DistributerModel creatWithDictionary:dic];
                    [self.distributerList addObject:dModel];
                }
                
                if (self.distributerList.count != 0) [self selectDefaultDistributer];
            }
            
            [self.itemListDataSource removeAllObjects];
            NSArray *itemList = dict[@"CallInfo"][@"itemList"];
            for (NSArray *item in itemList) {
                NSMutableArray *itemDataSource = [NSMutableArray array];
                for (NSDictionary *dic in item) {
                    ProductsModel *model = [ProductsModel creatWithDictionary:dic];
                    [itemDataSource addObject:model];
                }
                [self.itemListDataSource addObject:itemDataSource];
            }
            NSArray *presellList = dict[@"CallInfo"][@"presell"];
            self.presellModel = [PresellModel creatWithDictionary:[presellList lastObject]];
            [[SingleShoppingCar sharedInstance] setPresellModel:self.presellModel];// 保存商户
            [self.homeTableView reloadData];
        }
        
        if ([self.view.subviews containsObject:self.lowerFloorView]) {
            [self.lowerFloorView removeFromSuperview];
        }
        
        if (self.itemListDataSource.count == 0 && self.distributerList.count == 0) {
            self.navigationItem.rightBarButtonItem = nil;
            [self.view addSubview:self.lowerFloorView];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"search"] style:UIBarButtonItemStylePlain target:self action:@selector(showSearch:)];
        }
        
    } failed:^(NSError *error) {
        [self hideLoadingGIF];
        [self.view addSubview:self.lowerFloorView];
        DLog(@"%@",error);
    }];
}

- (void)creatHeaderView {
    if (self.headerADView == nil) {
        self.headerADView = [ZZFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 0) color:[UIColor whiteColor]];
    } else {
        [self.headerADView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    AdView *adView = nil;
    // 广告布局
    if (self.imagesURL.count != 0) {
        
        adView = [AdView adScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 130*autoSizeScaleY) imageLinkURL:self.imagesURL pageControlShowStyle:UIPageControlShowStyleNone];
        
        //adView.contentMode = UIViewContentModeScaleAspectFill;
        //adView.clipsToBounds = YES;
        
        adView.callBack = ^(NSInteger index,NSDictionary *imageURLDic){
            DLog(@"被点中的图片的索引:%ld---地址:%@",(long)index,imageURLDic);
            //点击跳到一个WebView
        };
        //adView.showPageNO = ^(NSInteger currentPage) {
            //self.pageControl.currentPage = currentPage;
        //};
        [self.headerADView addSubview:adView];
    }
    if (self.hotBrandView == nil) {
        self.hotBrandView = [ZZFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 0) color:[UIColor whiteColor]];
    } else {
        [self.hotBrandView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    }
    
    // 品牌行数
    int totalRow = 0;

    // 品牌布局
    if (self.hotBrandList.count != 0) {
        int totalCol = 5;
        CGFloat space = (kScreenWidth-totalCol*36*autoSizeScaleX)/(totalCol+1);
        //NSArray *iconTitles = @[@"蔬菜",@"水产",@"禽蛋",@"豆制品",@"所有"];
        
        for (int i=0; i<self.hotBrandList.count; i++) {
            
            int row = i/totalCol,col = i%totalCol;
            totalRow = row;
            
            HotBrandModel *model =  self.hotBrandList[i];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.icon]];
            UIImage *image = [UIImage imageWithData:data];
            UIButton *btn = [ZZFactory buttonWithFrame:CGRectMake(space+(36*autoSizeScaleX+space)*col, (12+70*row)*autoSizeScaleY, 36*autoSizeScaleX, 36*autoSizeScaleY) title:nil titleColor:nil image:nil bgImage:nil];
            [btn setImage:image forState:UIControlStateNormal];
            btn.tag = 1001+i;
            [btn addTarget:self action:@selector(iconBtnActions:) forControlEvents:UIControlEventTouchUpInside];
            [self.hotBrandView addSubview:btn];
            UILabel *lbl = [ZZFactory labelWithFrame:CGRectMake(space/2+(36*autoSizeScaleX+space)*col, (50+70*row)*autoSizeScaleY, space+36*autoSizeScaleX, 20*autoSizeScaleY) font:Font(14) color:[UIColor lightGrayColor] text:model.title];
            lbl.textAlignment = NSTextAlignmentCenter;
            [self.hotBrandView addSubview:lbl];
        }
        [self.homeTableView addSubview:self.hotBrandView];
    }
    
    CGFloat headerAdViewH = self.imagesURL.count != 0 ? 130*autoSizeScaleY: 0;
    
    CGFloat hotBrandH = self.hotBrandList.count != 0 ? (totalRow+1)*70*autoSizeScaleY: 0;
    
    headerAdViewH += hotBrandH;// 头缩放视图高度
    
    self.hotBrandView.top = -hotBrandH;
    self.hotBrandView.height = hotBrandH;
    self.headerADView.height = headerAdViewH;
    
    // 广告位页面控制器
    //self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(kScreenWidth-self.imagesURL.count*25, -(hotBrandH+25), self.imagesURL.count*25, 25)];
    //self.pageControl.numberOfPages = self.imagesURL.count;
    //[self.homeTableView addSubview:self.pageControl];

    // autoresizing 控制 放在 expandHeader 宽高确定之后 否则 广告位显示不全
    adView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    // 控制广告位下拉缩放效果  expandView 只需要设置宽高
    self.expandHeader = [BZExpandHeaderView expandWithScrollView:self.homeTableView expandView:self.headerADView];
}


- (void)iconBtnActions:(UIButton *)btn {
    HotBrandModel *hModel = [self.hotBrandList objectAtIndex:btn.tag-1001];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabBarViewControllerWillShowNotification object:hModel userInfo:@{@"index":@(1)}];
}

- (UIView *)lowerFloorView {
    if (!_lowerFloorView) {
        _lowerFloorView = [[UIView alloc] initWithFrame:self.view.bounds];
        _lowerFloorView.backgroundColor = [UIColor whiteColor];
        UIImageView *imgV = [ZZFactory imageViewWithFrame:CGRectMake(0, 0, 150, 150) defaultImage:@"radish"];
        imgV.center = self.view.center;
        [_lowerFloorView addSubview:imgV];
        UILabel *lbl = [ZZFactory labelWithFrame:CGRectMake(0, imgV.bottom, kScreenWidth, 21) font:Font(14) color:[UIColor darkGrayColor] text:@"亲,该地区暂未开通哦,\"切换地址\"看看"];
        lbl.textAlignment = NSTextAlignmentCenter;
        [_lowerFloorView addSubview:lbl];
    }
    return _lowerFloorView;
}

- (UIView *)popView {
    if (!_popView) {
        _popView = [ZZFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth-16*2, 0) color:[UIColor darkGrayColor]];
    }
    return _popView;
}

- (void)selectDefaultDistributer {
    [self.popView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *title = [ZZFactory labelWithFrame:CGRectMake(0, 10, self.popView.width, 20) font:Font(16) color:[UIColor whiteColor] text:[NSString stringWithFormat:@"请选择自提点(%@)",self.siteListModel.domainname]];
    title.textAlignment = NSTextAlignmentCenter;
    [self.popView addSubview:title];
    CGFloat totalH = 10.f+20.f+15.f;
    for (int i=0; i<self.distributerList.count; i++) {
        UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, totalH, self.popView.width, 42)];
        totalH += 30.f + 15.f;
        
        UIButton *radioBtn = [ZZFactory buttonWithFrame:CGRectMake(10, 4, 30, 30) title:nil titleColor:nil image:@"radio_unchecked" bgImage:nil];
        [radioBtn setImage:[UIImage imageNamed:@"radio_checked"] forState:UIControlStateSelected];
        [radioBtn addTarget:self action:@selector(radioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        radioBtn.tag = base_radion_tag + i;
        [self.radioButtonList addObject:radioBtn];
        [rowView addSubview:radioBtn];
        
        DistributerModel *model = self.distributerList[i];
        if (i == 0) {
            radioBtn.selected = YES;
            model.isDefault = YES;
        }
        
        //NSString *distributerStr = [NSString stringWithFormat:@"%@ (%@)",model.sitename,model.address];
        UILabel *titleLabel = [ZZFactory labelWithFrame:CGRectMake(radioBtn.right+5, 4, rowView.width-45-10-60, 0) font:Font(14) color:[UIColor whiteColor] text:model.sitename];
        titleLabel.numberOfLines = 0;
//        CGFloat height = [BZ_Tools heightForTextString:distributerStr width:titleLabel.width fontSize:14];
//        titleLabel.height = height;//height/18*20;
        titleLabel.height = [BZ_Tools heightForTextString:model.sitename width:titleLabel.width fontSize:14]>21?42:21;
        
        [rowView addSubview:titleLabel];
        
        NSString *distance = [NSString stringWithFormat:@"%.2f",model.distance.floatValue];
        if (model.distance.floatValue < 1.f) {
            distance = [NSString stringWithFormat:@"%.fm",distance.floatValue*1000];
        } else {
            distance = [NSString stringWithFormat:@"%@km",distance];
        }
        UILabel *distanceLabel = [ZZFactory labelWithFrame:CGRectMake(rowView.width-60, 4,60, 21) font:Font(14) color:[UIColor orangeColor] text:distance];
        [rowView addSubview:distanceLabel];
        
        [self.popView addSubview:rowView];
    }
    UIButton *leftBtn = [ZZFactory buttonWithFrame:CGRectMake(30, totalH+10, 60, 30) title:@"取消" titleColor:[UIColor whiteColor] image:nil bgImage:nil];
    [leftBtn addTarget:self action:@selector(popLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightBtn = [ZZFactory buttonWithFrame:CGRectMake(self.popView.width-30-60, totalH+10, 60, 30) title:@"确定" titleColor:[UIColor whiteColor] image:nil bgImage:nil];
    [rightBtn addTarget:self action:@selector(popRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:leftBtn];
    [self.popView addSubview:rightBtn];
    
    self.popView.height =  totalH+50;
    
    self.popView.center = self.view.center;
    [self popTipView:self.popView];
    [[SingleShoppingCar sharedInstance] setDistributerList:self.distributerList];
}

- (void)radioBtnClick:(UIButton *)button {
    for (UIButton *btn in self.radioButtonList) {
        if (btn.tag == button.tag) {
            self.radioIndex = button.tag-base_radion_tag;
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
}
- (void)updateDefaultDistributer {
    
    self.distributerList = [[SingleShoppingCar sharedInstance] distributerList];
    [self.distributerList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DistributerModel *model = obj;
        if (idx == self.radioIndex) {
            model.isDefault = YES;
            [self updateTitleWithText:model.sitename];
        } else {
            model.isDefault = NO;
        }
    }];
    /**
     *  一般不需要重修赋值 因为这里我们重写了该存取方法 进行了本地保存
     *  所以在这里要进行重修赋值 保存最新的数据
     */
    [[SingleShoppingCar sharedInstance] setDistributerList:self.distributerList];
    
    [self pushTipView:self.popView];
}

- (void)popLeftBtnClick:(UIButton *)button {
    self.radioIndex = 0;
    [self updateDefaultDistributer];
}

- (void)popRightBtnClick:(UIButton *)button {
    [self updateDefaultDistributer];
}

#pragma mark - addressSearch

-(void)ShowAddress:(id)sender {
    AddressSearchViewController *AddressSearchView = [[AddressSearchViewController alloc] init];
    [self pushNewViewController:AddressSearchView];
}

-(void)showSearch:(UIBarButtonItem*)bar {
    SearchViewController *searchProduct = [[SearchViewController alloc] init];
    searchProduct.itemList = self.itemListDataSource;
    [self pushNewViewController:searchProduct];
}

#pragma mark - CLLocationManagerDelegate

- (void)starLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        if (self.locationManager == nil) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [self.locationManager startUpdatingLocation];
            if (IOS8) {
                [self.locationManager requestAlwaysAuthorization];
                //[self.locationManager requestWhenInUseAuthorization];
            }
        }
    } else {
        [self showHUDWithText:@"定位服务不可用!!"];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSString *latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    [self showLoadingGIF];
    [[DataEngine sharedInstance] requestSiteListDataWithCityId:@"" name:@"" latitude:latitude longitude:longitude success:^(id responseData) {
        [self hideLoadingGIF];
        NSDictionary *dict = (NSDictionary *)responseData;
        if ([dict[@"Success"] integerValue] == 1) {
            NSArray *arr = dict[@"CallInfo"];
            for (NSDictionary *dic in arr) {
                SiteListModel *model = [SiteListModel creatWithDictionary:dic];
                [self.siteList addObject:model];
            }
            self.siteListModel = self.siteList.firstObject;
            [[SingleShoppingCar sharedInstance] setSiteModel:self.siteListModel];//默认小区
            [self updateTitleWithText:self.siteListModel.domainname];// 更新标题
            [self downloadSiteShopListDataWithSiteId:self.siteListModel.id];// 下载数据
        }
    } failed:^(NSError *error) {
        [self hideLoadingGIF];
        [self.view addSubview:self.lowerFloorView];
        //if (error.code == -1001) show_alertView(@"网络请求超时");
        DLog(@"%@",error);
    }];
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self showErrorHUDWithText:@"定位失败"];
    [self.view addSubview:self.lowerFloorView];

    [self.locationManager stopUpdatingLocation];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemListDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *items = self.itemListDataSource[indexPath.row];
    if (items.count == 1) {
        MainCell *cell = [tableView dequeueReusableCellWithIdentifier:kMainCell forIndexPath:indexPath];
        [cell updateUIUsingModel:items complete:^(ProductsModel *model) {
            model.count = 0;// 首页初始化为0
            
            NSMutableArray *productsModel = [[SingleShoppingCar sharedInstance] productsDataSource];
            ProductDetailViewController *pVC = [[ProductDetailViewController alloc] init];
            
            for (ProductsModel *mdl in productsModel) {
                if ([model.skuid isEqualToString:mdl.skuid]) {
                    model.count = mdl.count;
                    break ;
                }
            }
            pVC.detailProductModel = model;
            
            [[SingleShoppingCar sharedInstance] setIsCarPushIntoDetailVC:NO];
            [self pushNewViewController:pVC];
        }];
        return cell;
    } else if (items.count == 2) {
        MainDoubleCell *cell = [tableView dequeueReusableCellWithIdentifier:kMainDoubleCell forIndexPath:indexPath];
        [cell updateUIUsingModel:items complete:^(ProductsModel *model) {
            model.count = 0;// 首页初始化为0

            NSMutableArray *productsModel = [[SingleShoppingCar sharedInstance] productsDataSource];
            ProductDetailViewController *pVC = [[ProductDetailViewController alloc] init];
            
            for (ProductsModel *mdl in productsModel) {
                if ([model.skuid isEqualToString:mdl.skuid]) {
                    model.count = mdl.count;
                    break ;
                }
            }
            pVC.detailProductModel = model;
            
            [[SingleShoppingCar sharedInstance] setIsCarPushIntoDetailVC:NO];
            [self pushNewViewController:pVC];
        }];
        return cell;

    }
    return nil;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    CATransform3D rotation;
//    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
//    rotation.m34 = 1.0/ -600;
//    
//    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha = 0;
//    cell.layer.transform = rotation;
//    cell.layer.anchorPoint = CGPointMake(0, 0.5);
//    
//    
//    [UIView beginAnimations:@"rotation" context:NULL];
//    [UIView setAnimationDuration:0.8];
//    cell.layer.transform = CATransform3DIdentity;
//    cell.alpha = 1;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    [UIView commitAnimations];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *items = self.itemListDataSource[indexPath.row];
    if (items.count == 1) {
        return 120*autoSizeScaleY;
    } else if (items.count == 2) {
        return 200*autoSizeScaleY;
    }
    return 0;
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
