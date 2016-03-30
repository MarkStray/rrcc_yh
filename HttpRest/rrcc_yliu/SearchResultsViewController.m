//
//  SearchResultsViewController.m
//  rrcc_yh
//
//  Created by user on 15/9/22.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "SearchResultsViewController.h"

#define kSiteCellId @"SiteCell"

@interface SearchResultsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *searchResultTableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.searchResultTableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.addrSearchBar resignFirstResponder];
}

- (UITableView *)searchResultTableView {
    if (!_searchResultTableView) {
        _searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height-64-49) style:UITableViewStylePlain];
        _searchResultTableView.delegate = self;
        _searchResultTableView.dataSource = self;
        _searchResultTableView.rowHeight = 50*autoSizeScaleY;
        _searchResultTableView.sectionHeaderHeight = 30;
        [_searchResultTableView registerNib:[UINib nibWithNibName:kSiteCellId bundle:nil] forCellReuseIdentifier:kSiteCellId];
        _searchResultTableView.separatorColor = [UIColor clearColor];
        //_searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchResultTableView.backgroundColor = BACKGROUND_COLOR;
    }
    return _searchResultTableView;
}

- (void)startDownLoadSearchResultData {
    
    [[DataEngine sharedInstance] requestSiteListDataWithCityId:self.cityListmodel==nil? @"25":self.cityListmodel.id name:self.searchText latitude:@"" longitude:@"" success:^(id responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        
        if ([dict[@"Success"] integerValue] == 1) {
            
            [self.dataSource removeAllObjects];

            NSArray *arr = dict[@"CallInfo"];            
            for (NSDictionary *dic in arr) {
                SiteListModel *model = [[SiteListModel alloc] initWithDictionary:dic];
                [self.dataSource addObject:model];
            }
            [self.searchResultTableView reloadData];
        }
        if ([self.view.subviews containsObject:self.lowerFloorView]) {
            [self.lowerFloorView removeFromSuperview];
        }
        
        if (self.dataSource.count == 0) {
            [self.view addSubview:self.lowerFloorView];
        }
    } failed:^(NSError *error) {
        [self.view addSubview:self.lowerFloorView];
        DLog(@"%@",error);
    }];
}

- (UIView *)lowerFloorView {
    if (!_lowerFloorView) {
        _lowerFloorView = [[UIView alloc] initWithFrame:self.view.bounds];
        _lowerFloorView.backgroundColor = [UIColor whiteColor];
        UIImageView *imgV = [ZZFactory imageViewWithFrame:CGRectMake(0, 0, 150, 150) defaultImage:@"radish"];
        imgV.center = CGPointMake(self.view.center.x, self.view.center.y-64-44);
        [_lowerFloorView addSubview:imgV];
        UILabel *lbl = [ZZFactory labelWithFrame:CGRectMake(0, imgV.bottom, kScreenWidth, 21) font:Font(14) color:[UIColor darkGrayColor] text:@"亲,没有找到您要搜索的内容"];
        lbl.textAlignment = NSTextAlignmentCenter;
        [_lowerFloorView addSubview:lbl];
        [_lowerFloorView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder)]];
    }
    return _lowerFloorView;
}
- (void)resignResponder {
    [self.addrSearchBar resignFirstResponder];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headView.backgroundColor = BACKGROUND_COLOR;
    [ZZFactory labelWithFrame:CGRectMake(16, 0, kScreenWidth-16, 30) font:Font(16) color:[UIColor lightGrayColor] text:@"你是不是要找:" superView:headView];
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SiteCell *cell = [tableView dequeueReusableCellWithIdentifier:kSiteCellId forIndexPath:indexPath];
    SiteListModel *model = self.dataSource[indexPath.row];
    [cell updateUIUsingModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SiteListModel *model = self.dataSource[indexPath.row];
    if (self.updateSite) {
        self.updateSite(model);
    }
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
