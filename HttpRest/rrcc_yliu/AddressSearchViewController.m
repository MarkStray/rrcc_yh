//
//  AddressSearchViewController.m
//  rrcc_yh
//
//  Created by user on 15/6/12.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "AddressSearchViewController.h"
#import "SearchResultsViewController.h"
#import "CityListViewController.h"

#import <MapKit/MapKit.h>// 苹果(高德)

#define kSiteCellId @"SiteCell"


@interface AddressSearchViewController () <CLLocationManagerDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIButton *titleButton;//title
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) UITableView *historyTableView;
@property (nonatomic, strong) NSMutableArray *historyList;//本地
@property (nonatomic, strong) NSMutableArray *locationList;//网络

@property (nonatomic, strong) NSMutableArray *regionList;

@property (nonatomic, strong) CityListViewController *CLVC;
@property (nonatomic, strong) SearchResultsViewController *SRVC;

@property (nonatomic, strong) CityListModel *cityListmodel;// 保存传过来的model


@property (nonatomic, strong) SiteListModel *siteListModel;


@end

@implementation AddressSearchViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.locationManager.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customUI];
    [self searchHistorySiteList];
    [self downloadRegionData];
}

- (void)searchHistorySiteList {
    NSArray *lSiteList = [[NSUserDefaults standardUserDefaults] objectForKey:kHistorySiteListKey];
    if (!lSiteList) {
        lSiteList = [NSArray array];
        [[NSUserDefaults standardUserDefaults] setObject:lSiteList forKey:kHistorySiteListKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    /*初始化数据源*/
    self.historyList = [NSMutableArray arrayWithArray:lSiteList];
    self.locationList = [NSMutableArray array];
    self.regionList = [NSMutableArray array];//header
}

- (void)downloadRegionData {
    [[DataEngine sharedInstance] requestCityDistrictListDataWithCityId:@"25" Success:^(id responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        NSArray *info = dict[@"CallInfo"];
        for (NSDictionary *dic in info) {
            RegionModel *model = [RegionModel creatWithDictionary:dic];
            [self.regionList addObject:model];
        }
        if (self.regionList.count != 0) [self updateTableHeaderView];
        
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}


- (void)customUI{
    self.titleButton = [ZZFactory buttonWithFrame:CGRectMake(0, 0, kScreenWidth-88, 30) title:@"上海市" titleColor:[UIColor whiteColor] image:@"down-arrow" bgImage:nil];
    self.titleButton.titleLabel.font = Font(16);

    [self.titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.titleButton.imageView.bounds.size.width, 0, self.titleButton.imageView.bounds.size.width)];
    [self.titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleButton.titleLabel.bounds.size.width, 0, -self.titleButton.titleLabel.bounds.size.width)];
    
    [self.titleButton addTarget:self action:@selector(selecteCity) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.titleButton;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"locate"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(beginLocation)];
    
    UIView *searchBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 44)];
    searchBGView.backgroundColor = GLOBAL_COLOR;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-100, 44)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入小区或自提点";
    self.searchBar.backgroundColor = BACKGROUND_COLOR;
    self.searchBar.backgroundImage = [self.searchBar imageWithColor:GLOBAL_COLOR size:self.searchBar.frame.size];
    [searchBGView addSubview:self.searchBar];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.titleLabel.font = Font(16);
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:GLOBAL_COLOR forState:UIControlStateNormal];
    searchBtn.backgroundColor = [UIColor whiteColor];
    searchBtn.frame = CGRectMake(self.searchBar.right+8, 8, 80, 28);
    [searchBtn SetBorderWithcornerRadius:5.f BorderWith:0.f AndBorderColor:nil];
    [searchBtn addTarget:self action:@selector(showSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchBGView addSubview:searchBtn];
    [self.view addSubview:searchBGView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+44, kScreenWidth, self.view.height-64-44)];
    self.contentView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.historyTableView];
}

- (UITableView *)historyTableView {
    if (!_historyTableView) {
        _historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.contentView.height) style:UITableViewStylePlain];
        _historyTableView.delegate = self;
        _historyTableView.dataSource = self;
        _historyTableView.rowHeight = 50*autoSizeScaleY;
        _historyTableView.sectionHeaderHeight = 30;
        _historyTableView.backgroundColor = BACKGROUND_COLOR;
        _historyTableView.separatorColor = [UIColor clearColor];
        _historyTableView.showsVerticalScrollIndicator = YES;
        [_historyTableView registerNib:[UINib nibWithNibName:kSiteCellId bundle:nil] forCellReuseIdentifier:kSiteCellId];
    }
    return _historyTableView;
}

- (void)selecteCity {
    if (!self.CLVC) {
        self.CLVC = [[CityListViewController alloc] init];
        [self.view addSubview:self.CLVC.view];
        
        __weak __typeof(self) weakSelf = self;
        self.CLVC.updateCity = ^(CityListModel *model){// 修改城市标题
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf.view sendSubviewToBack:strongSelf.CLVC.view];
            
            if (model.id != strongSelf.cityListmodel.id) {// 选中的不是是同一个城市
                
                [strongSelf.historyList removeAllObjects];// 清空历史记录
                [strongSelf.historyTableView reloadData];
                
                strongSelf.cityListmodel = model;
                
                [strongSelf.titleButton setTitle:model.RegionName forState:UIControlStateNormal];
                [strongSelf.titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -strongSelf.titleButton.imageView.bounds.size.width, 0, strongSelf.titleButton.imageView.bounds.size.width)];
                [strongSelf.titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, strongSelf.titleButton.titleLabel.bounds.size.width, 0, -strongSelf.titleButton.titleLabel.bounds.size.width)];

            }
        };
    }
    [self.view bringSubviewToFront:self.CLVC.view];
    self.CLVC.selectedCity = self.titleButton.titleLabel.text;
    [self.CLVC startDownLoadCityListData];
}

#pragma mark - UISearchBarDelegate

- (void)showSearch {
    [self searchBarSearchButtonClicked:self.searchBar];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchBar:searchBar textDidChange:searchBar.text];
    [searchBar resignFirstResponder];
}
// 监听 searchBar text 变化
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];// 去除空格

    if (searchText.length == 0) {
        if (self.SRVC.view.hidden == NO) {
            self.SRVC.view.hidden = YES;
        }
        return ;
    }
    
    if (!self.SRVC) {
        self.SRVC = [[SearchResultsViewController alloc] init];
        self.SRVC.addrSearchBar = self.searchBar;
        __weak typeof(self) weakSelf = self;
        self.SRVC.updateSite = ^(SiteListModel *model){
            __strong __typeof(weakSelf) strongSelf = weakSelf;

            strongSelf.SRVC.view.hidden = YES;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
            if (![strongSelf.historyList containsObject:data]) {
                [strongSelf saveDataToLocation:data];
            }
            [strongSelf postNotification:model];
        };
    }
    if (![self.contentView.subviews containsObject:self.SRVC.view]) {
        [self.contentView addSubview:self.SRVC.view];
    }
    self.SRVC.view.hidden = NO;
    self.SRVC.cityListmodel = self.cityListmodel;
    self.SRVC.searchText = searchText;
    [self.SRVC startDownLoadSearchResultData];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (void)updateTableHeaderView {
    
    UIView *tableBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    tableBGView.backgroundColor = BACKGROUND_COLOR;
    UILabel *regionTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, kScreenWidth-16, 21)];
    regionTitle.text = @"行政区域";
    regionTitle.font = Font(16);
    regionTitle.textColor = [UIColor lightGrayColor];
    [tableBGView addSubview:regionTitle];
    
    int totalCol = 4; // 一排4个
    int totalRow = 0; // 需计算
    CGFloat width = (kScreenWidth-16*2-10*3)/totalCol; // 中间间距10 左右间距16
    
    for (int i=0; i<self.regionList.count; i++) {// item (width, 30)
        int row = i/totalCol,col = i%totalCol;
        totalRow = row;
        RegionModel *model = self.regionList[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(16+(width+10)*col, 35+(30+12)*row, width, 30); // 上下间距12 高度30
        btn.tag = 101+i;
        btn.titleLabel.font = Font(14);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:model.RegionName forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(chooseRegion:) forControlEvents:UIControlEventTouchUpInside];
        [tableBGView addSubview:btn];
    }
    tableBGView.height = 35+(totalRow+1)*(12+30);
    self.historyTableView.tableHeaderView = tableBGView;
}

- (void)chooseRegion:(UIButton *)btn {
    DLog(@"%ld",btn.tag-101);
}


#pragma mark - CLLocationManagerDelegate

- (void)beginLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        if (self.locationManager == nil) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            if (IOS8) {
                [self.locationManager requestAlwaysAuthorization];
            }
        }
    } else {
        [self showHUDWithText:@"定位服务不可用!!"];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSString *latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    if ([self.contentView.subviews containsObject:self.SRVC.view]) {
        [self.SRVC.view removeFromSuperview];
    }
    [self showLoadingGIF];
    [[DataEngine sharedInstance] requestSiteListDataWithCityId:@"" name:@"" latitude:latitude longitude:longitude success:^(id responseData) {
        [self hideLoadingGIF];
        NSDictionary *dict = (NSDictionary *)responseData;
        
        if ([dict[@"Success"] integerValue] == 1) {
            
            [self.locationList removeAllObjects];//再次定位
            
            NSArray *arr = dict[@"CallInfo"];
            for (NSDictionary *dic in arr) {
                SiteListModel *model = [SiteListModel creatWithDictionary:dic];
                if ([arr indexOfObject:dic] == 0) {// 第一个 距离最近
                    model.isNearest = YES;
                }
                [self.locationList addObject:model];
            }
            [self.historyTableView reloadData];
        }
    } failed:^(NSError *error) {
        [self hideLoadingGIF];
        DLog(@"%@",error);
    }];
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self showErrorHUDWithText:@"定位失败"];
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.locationList.count;
    }
    return self.historyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SiteCell *cell = [tableView dequeueReusableCellWithIdentifier:kSiteCellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SiteListModel *model = nil;
    if (indexPath.section == 0) {
        NSData *data = self.historyList[indexPath.row];
        model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }else{
        model = self.locationList[indexPath.row];
    }
    [cell updateUIUsingModel:model];
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [ZZFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 30) color:BACKGROUND_COLOR];
    [ZZFactory labelWithFrame:CGRectMake(16, 0, kScreenWidth-16, 30) font:Font(16) color:[UIColor lightGrayColor] text:section==0?@"历史记录":@"你附近的小区" superView:headView];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SiteListModel *model = nil;
    if (indexPath.section == 1) {
        model = self.locationList[indexPath.row];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        if (![self.historyList containsObject:data]) [self saveDataToLocation:data];//本地不存在保存
    }else{// 第一分区点击的时候不更新数据 直接跳转
        model = [NSKeyedUnarchiver unarchiveObjectWithData:self.historyList[indexPath.row]];
    }
    [self postNotification:model];
}

- (void)postNotification:(SiteListModel *)model {
    // 切换地址 清空购物车
    
    [[SingleShoppingCar sharedInstance] clearShoppingCar];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidSelectSiteNotification object:model];
}

- (void)saveDataToLocation:(NSData *)data {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *lSiteList = [ud objectForKey:kHistorySiteListKey];
    NSMutableArray *locArr = [NSMutableArray arrayWithArray:lSiteList];
    
    [locArr insertObject:data atIndex:0];
    if (locArr.count == 4) [locArr removeObjectAtIndex:3];//控制3条数据
    
    [ud setObject:[NSArray arrayWithArray:locArr] forKey:kHistorySiteListKey];
    [ud synchronize];
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
