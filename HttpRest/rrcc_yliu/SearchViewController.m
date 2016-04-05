//
//  SearchViewController.m
//  rrcc_yh
//
//  Created by user on 15/10/22.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "SearchViewController.h"
#import "ProductDetailViewController.h"
#define kDockTableViewItemCell @"ProductCell"
@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_historytable;
}


@property (nonatomic, strong) UISearchBar *productsSearchBar;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) NSMutableArray *originalProductList;
@property (nonatomic, strong) NSMutableArray *filteredProductList;
@property (nonatomic, strong)NSMutableArray *historysearchList;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.productsSearchBar];
    UIButton *searchBtn = [ZZFactory buttonWithFrame:CGRectMake(0, 0, 60*autoSizeScaleX, 28) title:@"取消" titleColor:GLOBAL_COLOR image:nil bgImage:nil];
    searchBtn.backgroundColor = [UIColor whiteColor];
    [searchBtn SetBorderWithcornerRadius:5.f BorderWith:0.f AndBorderColor:nil];
    [searchBtn addTarget:self action:@selector(showDismiss) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    [self initSearchDataSource];
    if (self.itemList.count<100) {
        [ZZFactory imageViewWithFrame:CGRectMake((kScreenWidth-100)/2, 120, 100, 70) defaultImage:@"Search_Content" superView:self.view];
        
    }else{
//        品类页面搜索
        [self searchHistoryList];
        UIImageView *bgimage=[[UIImageView alloc]initWithFrame:self.view.bounds];
        bgimage.image=[UIImage imageNamed:@"clearrecode"];
        [self.view addSubview:bgimage];
        [self inithotsearchcontrol];
        [self inithistorycontrol];
        
        }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_searchTableView reloadData];
    
}

-(void)inithotsearchcontrol
{
    UILabel *hotsearchlabel=[ZZFactory labelWithFrame:CGRectMake(5+3, 64+5, kScreenWidth-10, 34) font:[UIFont systemFontOfSize:14] color:[UIColor grayColor] text:@"热门搜索"];
    NSMutableArray *hotlist=[NSMutableArray arrayWithObjects:@"崇明绿色",@"鲜店优选",@"龙虾",@"组合", nil];
    for (int i=0; i<hotlist.count; i++) {
        UIButton *hotbutton=[ZZFactory buttonWithFrame:CGRectMake(5+i*75, 64+39, 65, 30) title:hotlist[i] titleColor:[UIColor blackColor] image:nil bgImage:nil];
        hotbutton.backgroundColor=[UIColor whiteColor];
        [hotbutton SetBorderWithcornerRadius:13.f BorderWith:1.f AndBorderColor:[UIColor grayColor]];
        [hotbutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [hotbutton addTarget:self action:@selector(hotsearchclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:hotbutton];
        [self.view addSubview:hotsearchlabel];
        
    }

}
-(void)inithistorycontrol
{
    UILabel *historylabel=[ZZFactory labelWithFrame:CGRectMake(5+3, 130, kScreenWidth-10, 44-10) font:[UIFont systemFontOfSize:14] color:[UIColor grayColor] text:@"历史记录"];
    UIButton *delectbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    delectbtn.frame=CGRectMake(0, kScreenHeight/2+15, kScreenWidth, 30);
    self.view.center=delectbtn.center;
    [delectbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [delectbtn addTarget:self action:@selector(delecthistoarydata:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delectbtn];
    [self.view addSubview:historylabel];
    CGFloat buttonx=0;
    CGFloat buttony=0;
    for (int i=0; i<self.historysearchList.count; i++) {
        NSData *data=self.historysearchList[i];
        NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        CGSize size = [result sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
        if (5+buttonx+size.width+40>kScreenWidth) {
            if (5+size.width>kScreenWidth) {
                buttony=0;
            }else{
                buttony=buttony+35;
                buttonx=0;
            }
        }
        UIButton *hisbutton=[ZZFactory buttonWithFrame:CGRectMake(5+buttonx, 130+34+buttony,size.width+30, 30) title:result titleColor:[UIColor blackColor] image:nil bgImage:nil];
        hisbutton.tag=1000+i;
        hisbutton.backgroundColor=[UIColor whiteColor];
        [hisbutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [hisbutton addTarget:self action:@selector(hotsearchclick:) forControlEvents:UIControlEventTouchUpInside];
        [hisbutton SetBorderWithcornerRadius:13.f BorderWith:1.f AndBorderColor:[UIColor grayColor]];
        buttonx=size.width+40+buttonx;
        [self.view addSubview:hisbutton];
        
    }
}
- (void)initSearchDataSource {
    self.originalProductList = [NSMutableArray array];
    self.filteredProductList = [NSMutableArray array];
    self.historysearchList=[NSMutableArray array];
    if (self.itemList.count<100) {
        for (NSArray *item in self.itemList)
            for (ProductsModel *model in item)
                [self.originalProductList addObject:model];
    }else{
        for (ProductsModel *model in self.itemList)
            [self.originalProductList addObject:model];
    }
}

- (UISearchBar *)productsSearchBar {
    if (!_productsSearchBar) {
        _productsSearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 220*autoSizeScaleX, 40)];
        _productsSearchBar.backgroundImage = [_productsSearchBar imageWithColor:[UIColor clearColor] size:_productsSearchBar.bounds.size];
        _productsSearchBar.tintColor = RGBCOLOR(66, 107, 242);
        _productsSearchBar.placeholder=@"请输入搜索内容";
        _productsSearchBar.delegate=self;
    }
    return _productsSearchBar;
}

- (UITableView *)searchTableView {
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, self.view.height-64) style:UITableViewStylePlain];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.rowHeight = 75*autoSizeScaleY;
        _searchTableView.showsVerticalScrollIndicator = YES;
        _searchTableView.backgroundColor = [UIColor whiteColor];
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_searchTableView registerNib:[UINib nibWithNibName:kDockTableViewItemCell bundle:nil] forCellReuseIdentifier:kDockTableViewItemCell];
    }
    return _searchTableView;
}

- (UIView *)lowerFloorView {
    if (!_lowerFloorView) {
        _lowerFloorView = [[UIView alloc] initWithFrame:self.view.bounds];
        _lowerFloorView.backgroundColor = [UIColor whiteColor];
        UIImageView *imgV = [ZZFactory imageViewWithFrame:CGRectMake((kScreenWidth-150)/2, 120, 150, 150) defaultImage:@"radish"];
        [_lowerFloorView addSubview:imgV];
        UILabel *lbl = [ZZFactory labelWithFrame:CGRectMake(0, imgV.bottom+10, kScreenWidth, 21) font:Font(14) color:[UIColor darkGrayColor] text:@"亲,没有找到您要搜索的商品"];
        lbl.textAlignment = NSTextAlignmentCenter;
        [_lowerFloorView addSubview:lbl];
    }
    return _lowerFloorView;
}


#pragma mark - search

- (void)showDismiss {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchBar:searchBar textDidChange:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString *)searchText {
    NSPredicate *predicateStr = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", @"skuname",searchText];
    self.filteredProductList = [[self.originalProductList filteredArrayUsingPredicate:predicateStr] mutableCopy];
    if ([self.view.subviews containsObject:self.lowerFloorView]) {
        [self.lowerFloorView removeFromSuperview];
    }
    if (self.filteredProductList.count == 0) {
        [self.view addSubview:self.lowerFloorView];
        return ;
    }
    [self.view addSubview:self.searchTableView];
    [self.searchTableView reloadData];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if ([searchBar.text isEqualToString:@""]) {
        return;
    }
    NSData *data = [searchBar.text dataUsingEncoding:NSUTF8StringEncoding];
    if (![self.historysearchList containsObject:data]) [self saveDataToLocation:data];//本地不存在保存
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.productsSearchBar resignFirstResponder];
}

#pragma mark - UITableView 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [ZZFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 30) color:BACKGROUND_COLOR];
    NSString *title = [NSString stringWithFormat:@"共找到您需要的\"%ld\"款商品",(unsigned long)self.filteredProductList.count];
    [ZZFactory labelWithFrame:CGRectMake(16, 4, kScreenWidth-16, 21) font:Font(16) color:[UIColor lightGrayColor] text:title superView:headView];
    return headView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredProductList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:kDockTableViewItemCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ProductsModel *model = self.filteredProductList[indexPath.row];
    NSMutableArray *carProducts = [[SingleShoppingCar sharedInstance] productsDataSource];
    for (ProductsModel *carModel in carProducts) {
        if ([model.skuid isEqualToString:carModel.skuid]) {
            model.count = carModel.count;
        }
    }
    [cell updateUIUsingModel:model];
    cell.purchaseBlockCB = ^ BOOL (ProductsModel *model){
        return [[SingleShoppingCar sharedInstance] playerProductsModel:model];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductsModel *model = self.filteredProductList[indexPath.row];
    ProductDetailViewController *pVC = [[ProductDetailViewController alloc] init];
    pVC.detailProductModel = model;
    [[SingleShoppingCar sharedInstance] setIsCarPushIntoDetailVC:NO];
    [self pushNewViewController:pVC];
    
}

- (void)saveDataToLocation:(NSData *)data {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *lSiteList = [ud objectForKey:@"historysearch"];
    NSMutableArray *locArr = [NSMutableArray arrayWithArray:lSiteList];
    
    [locArr insertObject:data atIndex:0];
    if (locArr.count == 6) [locArr removeObjectAtIndex:5];//控制4条数据
    
    [ud setObject:[NSArray arrayWithArray:locArr] forKey:@"historysearch"];
    [ud synchronize];
}
- (void)searchHistoryList {
    NSArray *lSiteList = [[NSUserDefaults standardUserDefaults] objectForKey:@"historysearch"];
    if (!lSiteList) {
        lSiteList = [NSArray array];
        [[NSUserDefaults standardUserDefaults] setObject:lSiteList forKey:@"historysearch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    /*初始化数据源*/
    self.historysearchList = [NSMutableArray arrayWithArray:lSiteList];
}
-(void)delecthistoarydata:(UIButton *)btn
{
    for (int i=0; i<self.historysearchList.count; i++) {
        UIButton *button=[self.view viewWithTag:1000+i];
        [button removeFromSuperview];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"historysearch"];
    
    [self.historysearchList removeAllObjects];
    
}
-(void)hotsearchclick:(UIButton *)btn
{
    self.productsSearchBar.text=btn.titleLabel.text;
    [self searchBar:self.productsSearchBar textDidChange:btn.titleLabel.text];
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
