//
//  CategoryViewController.m
//  rrcc_yh
//
//  Created by user on 15/9/18.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "CategoryViewController.h"
#import "ProductDetailViewController.h"
#import "SearchViewController.h"
#import "PayViewController.h"

#define kDockTableViewCell @"DockCell"
#define kDockTableViewItemCell @"ProductCell"

@interface CategoryViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *dockTableView;
@property (nonatomic, strong) UITableView *itemTableView;

@property (nonatomic, strong) NSMutableArray *dockList;//brandId
@property (nonatomic, strong) NSMutableArray *shadowDockList; //brandName
@property (nonatomic, strong) NSMutableDictionary *itemListDict;//products
@property (nonatomic,strong)NSMutableArray *
    searcharray;
@end

static void *dockTableView = (void *)&dockTableView;
static void *itemTableView = (void *)&itemTableView;
static void *searchview    = (void *)&searchview;

@implementation CategoryViewController
{
    BOOL _isRelate;// 控制左右滚动不会受影响
    BOOL _isInitItem;//标记是否过进入页面
    BOOL _isShowDetail;//是否展示商品详情
    NSInteger _initSelected;//默认首页快捷位置
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTabBarViewControllerWillShowNotification object:nil];
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selecteBrandAction:) name:kTabBarViewControllerWillShowNotification object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showCustomTabBar];

    [self downloadCategoryData];
}

- (void)selecteBrandAction:(NSNotification *)notify {
    HotBrandModel *model = notify.object;
    for (int i=0; i<self.dockList.count; i++) {
        NSString *brandId = self.dockList[i];
        if ([model.id isEqualToString: brandId]) {
            _initSelected = i;
            return ;
        }
    }
    _initSelected = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品类";
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed: @"Search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(searchProduct)];
    
    self.dockList = [NSMutableArray array];
    self.shadowDockList = [NSMutableArray array];
    self.searcharray=[NSMutableArray array];
    self.itemListDict = [NSMutableDictionary dictionary];
    [self.view addSubview:self.dockTableView];
    [self.view addSubview:self.itemTableView];
    [self.view addSubview:self.searchview];
}
-(UIButton *)searchview
{
    UIButton *searchbtn=[ZZFactory buttonWithFrame:CGRectMake(10, 64+5, kScreenWidth-20, 35-10) title:@"搜索本店铺内商品名称" titleColor:[UIColor grayColor] image:nil bgImage:nil];
    searchbtn.titleLabel.font = Font(14);
    searchbtn.layer.cornerRadius=12;
    searchbtn.layer.masksToBounds=YES;
    searchbtn.layer.borderWidth=1;
    searchbtn.layer.borderColor=[UIColor grayColor].CGColor;
    [searchbtn addTarget:self action:@selector(searchviewclick:) forControlEvents:UIControlEventTouchUpInside];
    return searchbtn;
}

- (UITableView *)dockTableView {
    if (!_dockTableView) {
        _dockTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+35, kScreenWidth/4, self.view.height-64-35-49) style:UITableViewStylePlain];
        _dockTableView.delegate = self;
        _dockTableView.dataSource = self;
        _dockTableView.rowHeight = 50*autoSizeScaleY;
        _dockTableView.showsVerticalScrollIndicator = NO;
        _dockTableView.backgroundColor = BACKGROUND_COLOR;
        _dockTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_dockTableView registerNib:[UINib nibWithNibName:kDockTableViewCell bundle:nil] forCellReuseIdentifier:kDockTableViewCell];
    }
    return _dockTableView;
}

- (UITableView *)itemTableView {
    if (!_itemTableView) {
        _itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth/4, 64+35, kScreenWidth/4*3, self.view.height-64-35-49) style:UITableViewStylePlain];
        _itemTableView.delegate = self;
        _itemTableView.dataSource = self;
        _itemTableView.rowHeight = 75*autoSizeScaleY;
        _itemTableView.showsVerticalScrollIndicator = YES;
        _itemTableView.backgroundColor = [UIColor whiteColor];
        _itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_itemTableView registerNib:[UINib nibWithNibName:kDockTableViewItemCell bundle:nil] forCellReuseIdentifier:kDockTableViewItemCell];
    }
    return _itemTableView;
}

- (void)downloadCategoryData {
    if ([self.view.subviews containsObject:self.lowerFloorView]) {
        [self.lowerFloorView removeFromSuperview];
    }
    
    [self showLoadingGIF];
    
    PresellModel *presellModel = [[SingleShoppingCar sharedInstance] presellModel];
    [[DataEngine sharedInstance] requestUserShopProductListDataWithSiteShopId:presellModel.id success:^(id responseData) {
        [self hideLoadingGIF];
        
        // 购物车已加入数据
        NSMutableArray *carProducts = [[SingleShoppingCar sharedInstance] productsDataSource];

        NSDictionary *dict = (NSDictionary *)responseData;
        DLog(@"品类 %@",dict);
        
        if ([dict[@"Success"] integerValue] == 1) {
            
            [self.shadowDockList removeAllObjects];
            [self.dockList removeAllObjects];
            [self.itemListDict removeAllObjects];
            [self.searcharray removeAllObjects];
            NSArray *arr = dict[@"CallInfo"];
            for (NSDictionary *d in arr) {
                ProductsModel *model = [ProductsModel creatWithDictionary:d];
                [self.searcharray addObject:model];
                if (![self.dockList containsObject:model.brandid]) {
                    [self.dockList addObject:model.brandid];
                    
                    //dock数据源展示brandName
                    [self.shadowDockList addObject:model.brandname];
                }
                
                NSMutableArray *arr = self.itemListDict[model.brandid];
                if (arr == nil) {
                   arr = [NSMutableArray array];
                }
                
                /* 对数据源进行过滤 */
                for (ProductsModel *carModel in carProducts) {
                    if ([model.skuid isEqualToString:carModel.skuid]) {
                        //只替换对应数量
                        model.count = carModel.count;
                    }
                }

                [arr addObject:model];
                
                [self.itemListDict setObject:arr forKey:model.brandid];//item数据源
            }
            
            _isInitItem = YES;
            [self.dockTableView reloadData];
            [self.itemTableView reloadData];
        }
        
        if ([self.view.subviews containsObject:self.lowerFloorView]) {
            [self.lowerFloorView removeFromSuperview];
        }

        if (self.itemListDict.count == 0 && self.dockList.count == 0) {
            [self.view addSubview:self.lowerFloorView];
        }
    } failed:^(NSError *error) {
        [self hideLoadingGIF];
        [self.view addSubview:self.lowerFloorView];
        DLog(@"%@",error);
    }];
}

- (UIView *)lowerFloorView {
    if (!_lowerFloorView) {
        _lowerFloorView = [[UIView alloc] initWithFrame:self.view.bounds];
        _lowerFloorView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imgV = [ZZFactory imageViewWithFrame:CGRectMake(0, 0, 150, 150) defaultImage:@"radish"];
        imgV.center = CGPointMake(self.view.center.x, self.view.center.y-64);
        [_lowerFloorView addSubview:imgV];
        UILabel *lbl = [ZZFactory labelWithFrame:CGRectMake(0, imgV.bottom, kScreenWidth, 21) font:Font(14) color:[UIColor darkGrayColor] text:@"加载数据失败"];
        lbl.textAlignment = NSTextAlignmentCenter;
        [_lowerFloorView addSubview:lbl];
        
        UIButton *button = [ZZFactory buttonWithFrame:CGRectMake((kScreenWidth-150)/2, lbl.bottom+10, 150, 35) title:@"点击刷新" titleColor:[UIColor whiteColor] image:nil bgImage:nil];
        [button addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:GLOBAL_COLOR];
        [button SetBorderWithcornerRadius:15.f BorderWith:0.f AndBorderColor:nil];
        [_lowerFloorView addSubview:button];

    }
    return _lowerFloorView;
}
-(void)searchviewclick:(UIButton *)btn
{
    SearchViewController *searchProduct = [[SearchViewController alloc] init];
    searchProduct.itemList = self.searcharray;
    [self pushNewViewController:searchProduct];
    
}
- (void)refresh {
    [self.lowerFloorView removeFromSuperview];
    [self downloadCategoryData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.dockTableView) return 1;
    return self.dockList.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.dockTableView) return self.dockList.count;
    if (section == self.dockList.count) {
        return 1;//底部留白cell
    } else {
        NSMutableArray *arr = self.itemListDict[self.dockList[section]];
        return arr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.dockTableView) {
        DockCell *cell = [tableView dequeueReusableCellWithIdentifier:kDockTableViewCell forIndexPath:indexPath];
        cell.titleLabel.text = self.shadowDockList[indexPath.row];
        UIImageView *bgImg = [ZZFactory imageViewWithFrame:cell.bounds defaultImage:@"CellSelectedBack"];
        cell.selectedBackgroundView = bgImg;
        return cell;
    }
    
    if (indexPath.section == self.dockList.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bottomCell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selected = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = Font(12);
        
        NSString *str = @"人人菜场 · 生态健康 低价方便";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttributes:@{NSForegroundColorAttributeName:GLOBAL_COLOR,NSFontAttributeName:BoldFont(14)} range:NSMakeRange(0, 4)];
        
        cell.textLabel.attributedText = attrStr;

        return cell;//底部留白cell
    }

    
    NSMutableArray *arr = self.itemListDict[self.dockList[indexPath.section]];
    ProductsModel *model = arr[indexPath.row];
    
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:kDockTableViewItemCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateUIUsingModel:model];
    
    cell.purchaseBlockCB = ^ BOOL (ProductsModel *model){
        //[arr replaceObjectAtIndex:indexPath.row withObject:model];
        //self.itemListDict[self.dockList[indexPath.section]] = arr;//替换对应左侧分区的右侧数据源1
        //[self.itemTableView reloadData];
        return [[SingleShoppingCar sharedInstance] playerProductsModel:model];
        
        //_isShowDetail = YES;
        //[[SingleShoppingCar sharedInstance] setLastIndexPath:indexPath];// 记录下最后添加产品宝贝的位置
    };

    if (_isInitItem) { // 主页跳进来
        _isInitItem = NO;
        [self.itemTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_initSelected] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        [self.dockTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_initSelected inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        
        _initSelected = 0;// 清零
    }
    
    if (_isShowDetail){ // 展示商品详情
        _isShowDetail = NO;
        NSIndexPath *lastIndexPath = [[SingleShoppingCar sharedInstance] lastIndexPath];
        [self.itemTableView selectRowAtIndexPath:lastIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        
        [self.dockTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:lastIndexPath.section inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    return cell;
}


#pragma mark -  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.dockTableView) return 0;
    return 35;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.dockTableView) return 0;
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.dockTableView) return nil;
    
    if (section == self.dockList.count) {
        UIView *hView = [ZZFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 35) color:[UIColor whiteColor]];
        return hView;
    }

    UIView *hView = [ZZFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 35) color:[UIColor whiteColor]];
    [ZZFactory viewWithFrame:CGRectMake(8, 0, hView.width-8, 35) color:BACKGROUND_COLOR superView:hView];
    [ZZFactory labelWithFrame:CGRectMake(20, 0, hView.width-8, hView.height) font:Font(14) color:[UIColor darkGrayColor] text:self.shadowDockList[section] superView:hView];
    return hView;
}


-(void)tableView:(UITableView*)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (_isRelate) {
        NSInteger topCellSection = [[[tableView indexPathsForVisibleRows] firstObject] section];
        if (tableView == self.itemTableView){
            [self.dockTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:topCellSection inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
    }
}

-(void)tableView:(UITableView*)tableView didEndDisplayingFooterView:(nonnull UIView *)view forSection:(NSInteger)section {
    if (_isRelate){
        NSInteger topCellSection = [[[tableView indexPathsForVisibleRows] firstObject] section];
        if (tableView == self.itemTableView){
            [self.dockTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:topCellSection inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.dockTableView) {// 修改 itemTableView 的偏移量
        _isRelate = NO;
        [self.dockTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

        [self.itemTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else {
        
        if (indexPath.section == self.dockList.count) return;
        
        
        NSIndexPath *lastIndexPath = [[SingleShoppingCar sharedInstance] lastIndexPath];
        [tableView deselectRowAtIndexPath:lastIndexPath animated:NO];
        
        [[SingleShoppingCar sharedInstance] setLastIndexPath:indexPath];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        _isShowDetail = YES;

        // 展示产品详情
        NSMutableArray *arr = self.itemListDict[self.dockList[indexPath.section]];
        ProductsModel *model = arr[indexPath.row];
        
        ProductDetailViewController *pVC = [[ProductDetailViewController alloc] init];
        pVC.detailProductModel = model;
        
        [[SingleShoppingCar sharedInstance] setIsCarPushIntoDetailVC:NO];
        [self pushNewViewController:pVC];

    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _isRelate = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isRelate = YES;
}

/**
 *  @brief 一定要区分是否是拖着滚动 !!!
 *  上面两个方法等价 拖着滚动
 *  下面这个方法 是直接滚动 直接滚动 不让左侧选中
 */

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    _isRelate = YES;
//}


@end
