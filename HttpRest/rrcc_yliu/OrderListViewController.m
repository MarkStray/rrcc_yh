//
//  LYOrderListViewController.m
//  rrcc_yh
//
//  Created by user on 15/6/11.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderDetailViewController.h"

#define kOrderListCellId @"OrderListCell"

@interface OrderListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *orderDataSource;

@property (nonatomic, strong) UserOrderDetailModel *orderModel;

@end

@implementation OrderListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self downloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的订单";
    
    self.orderDataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = YES;
        [_tableView registerNib:[UINib nibWithNibName:kOrderListCellId bundle:nil] forCellReuseIdentifier:kOrderListCellId];
        _tableView.rowHeight = 120*autoSizeScaleY;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)downloadData{
    [self showLoadingGIF];
    [[DataEngine sharedInstance] requestUserOrderListDataSuccess:^(id responseData) {
        [self hideLoadingGIF];
        NSDictionary *dict = (NSDictionary *)responseData;
        DLog(@"订单列表：%@",dict);
        if ([dict[@"Success"] integerValue] == 1) {
            
            [self.orderDataSource removeAllObjects];

            NSArray *arr = dict[@"CallInfo"];
            for (NSDictionary *d in arr) {
                UserOrderDetailModel *model = [UserOrderDetailModel creatWithDictionary:d];
                [self.orderDataSource addObject:model];
            }
            [self.tableView reloadData];
        }
        if (self.orderDataSource.count == 0) [self.view addSubview:self.lowerFloorView];
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
        imgV.center = self.view.center;
        [_lowerFloorView addSubview:imgV];
        UILabel *lbl = [ZZFactory labelWithFrame:CGRectMake(0, imgV.bottom, kScreenWidth, 21) font:Font(14) color:[UIColor darkGrayColor] text:@"亲,你还没有下过单,赶快下一单试试"];
        lbl.textAlignment = NSTextAlignmentCenter;
        [_lowerFloorView addSubview:lbl];
    }
    return _lowerFloorView;
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderListCellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UserOrderDetailModel *model = self.orderDataSource[indexPath.section];
    [cell showDataUsingModel:model];    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailViewController *detailOrder = [[OrderDetailViewController alloc] init];
    detailOrder.isCheckOrder = YES;//其他地方都是 NO
    
    UserOrderDetailModel *model = self.orderDataSource[indexPath.section];//中间界面复杂
    model.id = model.orderid;
    [[SingleShoppingCar sharedInstance] setOrderModel:model];//保存在购物车单例中
    [self pushNewViewController:detailOrder];
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
