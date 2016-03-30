//
//  LYOrderDetailViewController.m
//  rrcc_yh
//
//  Created by user on 15/6/11.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//
#import "OrderDetailViewController.h"

#import "OrderInfoViewController.h"
#import "OrderStatesViewController.h"

#import "OrderJudgeViewController.h"

@interface OrderDetailViewController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *orderStatusBtn;
@property (nonatomic, strong) UIButton *orderInfoBtn;
@property (nonatomic, strong) UIView *indicateView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UserOrderDetailModel *orderModel;

@property (nonatomic, strong) OrderInfoViewController *orderInfoVC;
@property (nonatomic, strong) OrderStatesViewController *orderStatusVC;

@end

@implementation OrderDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderModel = [[SingleShoppingCar sharedInstance] orderModel];

    self.navigationItem.title = @"订单详情";

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 44);
    [button setTitle: @"评价" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ContactMerchant) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    // override
    UIButton *barButton = [Tools_Utils createBackButton];
    [barButton addTarget:self action:@selector(onNavBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    
    [self.view addSubview:self.topView];
    
    // 此页面下载数据 直接传给下面的两个页面
    [self downloadOrderDetailData];

}

- (void)downloadOrderDetailData {
    if (self.orderModel.orderid) {
        [[DataEngine sharedInstance] requestUserOrderDetailsDataOrderId:self.orderModel.orderid success:^(id responseData) {
            NSDictionary *dic = (NSDictionary *)responseData;
            DLog(@"顶单详情 %@",dic);
            if ([dic[@"Success"] integerValue] == 1) {
                NSDictionary *CallInfo = dic[@"CallInfo"];
                
                DLog(@"CallInfo 是%@",CallInfo);
                self.orderModel = [UserOrderDetailModel creatWithDictionary:CallInfo];
                // 产品List
                NSArray *items = CallInfo[@"itemList"];
                NSMutableArray *itemsArray = [NSMutableArray array];
                for (NSDictionary *d in items) {
                    ProductsModel *model = [ProductsModel creatWithDictionary:d];
                    [itemsArray addObject:model];
                }
                self.orderModel.productItemList = itemsArray;
                
                // 状态List
                NSArray *status = CallInfo[@"statusList"];
                NSMutableArray *statusArray = [NSMutableArray array];
                for (NSDictionary *d in status) {
                    StatusModel *model = [StatusModel creatWithDictionary:d];
                    [statusArray addObject:model];
                }
                self.orderModel.statusList = statusArray;
                
                // 操作List
                NSArray *actions = CallInfo[@"actionList"];
                NSMutableArray *actionsArray = [NSMutableArray array];
                for (NSDictionary *d in actions) {
                    ActionModel *model = [ActionModel creatWithDictionary:d];
                    [actionsArray addObject:model];
                }
                self.orderModel.actionList = actionsArray;
                
                // 数据下载好 创建页面
                [self.view addSubview:self.contentView];

            }
        } failed:^(NSError *error) {
            DLog(@"%@",error);
        }];
    } else {
        show_alertView(@"缺少资源ID!");
    }

}

- (void)ContactMerchant{
    //[[Utility Share] makeCall:@"4000-222-555"];
    OrderJudgeViewController *judge = [[OrderJudgeViewController alloc] init];
    [self pushNewViewController:judge];
}


-(void)onNavBack {
    [self back:self.isCheckOrder];
}

- (void)back:(BOOL)isCheckOrder {
    if (isCheckOrder) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTabBarViewControllerWillShowNotification object:nil userInfo:@{@"index":@(0)}];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (UIView *)topView {
    if (!_topView) {
        _topView = [ZZFactory viewWithFrame:CGRectMake(0, 64, kScreenWidth, 40) color:[UIColor whiteColor]];
        [ZZFactory viewWithFrame:CGRectMake(kScreenWidth/2, 10, 1, 20) color:BACKGROUND_COLOR superView:_topView];
        
        self.orderStatusBtn = [ZZFactory buttonWithFrame:CGRectMake(0, 0, _topView.width/2, _topView.height) title:@"订单状态" titleColor:RGBCOLOR(56, 184, 1) image:nil bgImage:nil];
        [self.orderStatusBtn addTarget:self action:@selector(orderStatusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:self.orderStatusBtn];
        
        self.orderInfoBtn = [ZZFactory buttonWithFrame:CGRectMake(_topView.width/2, 0, _topView.width/2, _topView.height) title:@"订单信息" titleColor:[UIColor darkGrayColor] image:nil bgImage:nil];
        [self.orderInfoBtn addTarget:self action:@selector(orderInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:self.orderInfoBtn];
        
        self.indicateView = [ZZFactory viewWithFrame:CGRectMake(0, 39, kScreenWidth/2, 1) color:GLOBAL_COLOR];
        [_topView addSubview:self.indicateView];
    }
    return _topView;
}


- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [ZZFactory viewWithFrame:CGRectMake(1, 64+40, kScreenWidth, self.view.height-64-40) color:BACKGROUND_COLOR];
        self.orderStatusVC = [[OrderStatesViewController alloc] init];
        // 传递数据 订单状态页面
        self.orderStatusVC.orderModel = self.orderModel;

        __weak __typeof(self) weakSelf = self;
        self.orderStatusVC.OnNavBackBlock = ^ (BOOL isRelateCheckOrder){
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (isRelateCheckOrder) {
                [strongSelf back:strongSelf.isCheckOrder];
            } else {
                [strongSelf back:NO];
            }
        };
        self.orderStatusVC.view.hidden = NO;
        [_contentView addSubview:self.orderStatusVC.view];
        
        
        self.orderInfoVC = [[OrderInfoViewController alloc] init];
        // 传递数据 订单详情页面
        self.orderInfoVC.orderModel = self.orderModel;

        self.orderInfoVC.view.hidden = YES;
        [_contentView addSubview:self.orderInfoVC.view];
    }
    return _contentView;
}

- (void)orderStatusBtnClick:(id)sender {
    [self.orderStatusBtn setTitleColor:RGBCOLOR(56, 184, 1) forState:UIControlStateNormal];
    [self.orderInfoBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.indicateView.frame = CGRectMake(0, 39, kScreenWidth/2, 1);
    }];
    
    self.orderStatusVC.view.hidden = NO;
    self.orderInfoVC.view.hidden = YES;
}

- (void)orderInfoBtnClick:(id)sender {
    [self.orderStatusBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.orderInfoBtn setTitleColor:RGBCOLOR(56, 184, 1) forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.indicateView.frame = CGRectMake(kScreenWidth/2, 39, kScreenWidth/2, 1);
    }];
    
    self.orderStatusVC.view.hidden = YES;
    self.orderInfoVC.view.hidden = NO;
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
