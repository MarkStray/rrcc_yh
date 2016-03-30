//
//  CityListViewController.m
//  rrcc_yh
//
//  Created by user on 15/6/12.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "CityListViewController.h"

#define kCityCellId @"CityCell"

@interface CityListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *cityTableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation CityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    
    self.cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, self.view.height-64) style:UITableViewStylePlain];
    self.cityTableView.delegate = self;
    self.cityTableView.dataSource = self;
    self.cityTableView.rowHeight = 35*autoSizeScaleY;
    self.cityTableView.sectionHeaderHeight = 30;
    [self.cityTableView registerNib:[UINib nibWithNibName:kCityCellId bundle:nil] forCellReuseIdentifier:kCityCellId];
    self.cityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cityTableView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:self.cityTableView];
}

- (void)startDownLoadCityListData {
    [[DataEngine sharedInstance] requestCityListDataSuccess:^(id responseData) {
        
        NSDictionary *dict = (NSDictionary *)responseData;
        if ([dict[@"Success"] integerValue] == 1) {
            
            [self.dataSource removeAllObjects];
            
            NSDictionary *info = [[dict objectForJSONKey:@"CallInfo"] lastObject];
            NSArray *cityList = [info objectForJSONKey:@"Children"];
            for (NSDictionary *d in cityList) {
                CityListModel *model = [[CityListModel alloc] init];
                [model setValuesForKeysWithDictionary:d];
                [self.dataSource addObject:model];
            }
            [self.cityTableView reloadData];

        }
        
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [ZZFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 30) color:BACKGROUND_COLOR];
    [ZZFactory labelWithFrame:CGRectMake(16, 4, kScreenWidth-16, 21) font:Font(16) color:[UIColor lightGrayColor] text:@"开通城市" superView:headView];
    return headView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityCell *cell = [tableView dequeueReusableCellWithIdentifier:kCityCellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CityListModel *model = self.dataSource[indexPath.row];
    cell.titleLabel.text = model.RegionName;
    cell.titleLabel.font = Font(16);
    
    // 标记以选中的城市
    if ([cell.titleLabel.text isEqualToString:self.selectedCity]) {
        cell.titleLabel.textColor = kGreenColor;
    }else{
        cell.titleLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CityListModel *model = self.dataSource[indexPath.row];
    
    self.selectedCity = model.RegionName;
    
    if (self.updateCity) {
        self.updateCity(model);
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
