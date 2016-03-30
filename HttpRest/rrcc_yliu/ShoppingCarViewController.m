//
//  ShoppingCarViewController.m
//  rrcc_yh
//
//  Created by user on 15/9/20.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "ProductDetailViewController.h"
#import "PayViewController.h"

@interface ShoppingCarViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *totalPriceLable;
@property (nonatomic, strong) UILabel *attachLabel;
@property (nonatomic, strong) UIButton *handleBtn;

@property (nonatomic, strong) UserOrderDetailModel *orderModel;//订单生成1
@property (nonatomic, assign) CGFloat minOrder;

@end

@implementation ShoppingCarViewController
{
    BOOL _isClose;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataSource = [[SingleShoppingCar sharedInstance] productsDataSource];
    [self.tableView reloadData];
    float totalPrice = [[SingleShoppingCar sharedInstance] totalPrice];
    [self updateUIWithPrice:totalPrice];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShoppingCarDidChange:) name:kBZTabbarShoppingCarDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBZTabbarShoppingCarDidChangeNotification object:nil];
}

- (void)ShoppingCarDidChange:(NSNotification *)notify {
    float totalPrice = [notify.userInfo[@"totalPrice"] floatValue];
    [self updateUIWithPrice:totalPrice];
}

- (void)updateUIWithPrice:(CGFloat)totalPrice {
    float distancePrice = self.minOrder-totalPrice;
    NSString *text = [NSString stringWithFormat:@"合计:￥%.2f",totalPrice];
    
    self.totalPriceLable.text = text;
    self.totalPriceLable.width = [BZ_Tools widthForTextString:text height:21 fontSize:16];
    text = [NSString stringWithFormat:@"差%.2f元起订",distancePrice];
    self.attachLabel.text = text;
    self.attachLabel.left = self.totalPriceLable.right + 5;
    self.attachLabel.width = [BZ_Tools widthForTextString:text height:21 fontSize:14];
    if (totalPrice >= self.minOrder) {
        self.attachLabel.hidden = YES;
        self.handleBtn.hidden = NO;
    } else {
        self.attachLabel.hidden = NO;
        self.handleBtn.hidden = YES;
    }
    if (totalPrice == 0) {
        [self.view addSubview:self.lowerFloorView];
        [[NSNotificationCenter defaultCenter] postNotificationName:kShoppingCarDidClearNotification object:nil];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed: @"dustbin"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(clearShoppingCar)];
    
    self.minOrder = [[[[SingleShoppingCar sharedInstance] presellModel] min_order] floatValue];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, self.view.height-64-49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 75*autoSizeScaleY;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.backgroundColor = BACKGROUND_COLOR;
        [self.tableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:@"ProductCellId"];
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-49, kScreenWidth, 49)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        float totalPrice = [[SingleShoppingCar sharedInstance] totalPrice];
        NSString *text = [NSString stringWithFormat:@"合计:￥%.2f",totalPrice];
        self.totalPriceLable = [ZZFactory labelWithFrame:CGRectMake(16, 14, 0, 21) font:Font(16) color:[UIColor darkGrayColor] text:text];
        self.totalPriceLable.width = [BZ_Tools widthForTextString:text height:21 fontSize:16];
        [_bottomView addSubview:self.totalPriceLable];
        
        text = [NSString stringWithFormat:@"差%.2f元起订",self.minOrder-totalPrice];
        self.attachLabel = [ZZFactory labelWithFrame:CGRectMake(_totalPriceLable.right+5, 14, 0, 21) font:Font(14) color:[UIColor lightGrayColor] text:text];
        self.attachLabel.width = [BZ_Tools widthForTextString:text height:21 fontSize:14];
        [_bottomView addSubview:self.attachLabel];
        
        self.handleBtn = [ZZFactory buttonWithFrame:CGRectMake(kScreenWidth-100, 10, 80, 30) title:@"去结算" titleColor:[UIColor whiteColor] image:nil bgImage:nil];
        self.handleBtn.backgroundColor = GLOBAL_COLOR;
        [self.handleBtn SetBorderWithcornerRadius:5.f BorderWith:0.f AndBorderColor:nil];
        [self.handleBtn addTarget:self action:@selector(settle) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:self.handleBtn];
        if (totalPrice >= self.minOrder) {
            self.attachLabel.hidden = YES;
            self.handleBtn.hidden = NO;
        } else {
            self.attachLabel.hidden = NO;
            self.handleBtn.hidden = YES;
        }
    }
    return _bottomView;
}

- (UIView *)lowerFloorView {
    if (!_lowerFloorView) {
        _lowerFloorView = [[UIView alloc] initWithFrame:self.view.bounds];
        _lowerFloorView.backgroundColor = BACKGROUND_COLOR;
        UIImageView *imgV= [ZZFactory imageViewWithFrame:CGRectMake(0, 0, 60, 60) defaultImage:@"ShoppingCar"];
        imgV.center = CGPointMake(self.view.center.x, self.view.center.y-64);
        [_lowerFloorView addSubview:imgV];
        
        UILabel *label = [ZZFactory labelWithFrame:CGRectMake(0, imgV.bottom+10, kScreenWidth, 21) font:Font(16) color:[UIColor lightGrayColor] text:@"您的购物车还是空的"];
        label.textAlignment = NSTextAlignmentCenter;
        [_lowerFloorView addSubview:label];
        
        UIButton *button = [ZZFactory buttonWithFrame:CGRectMake((kScreenWidth-150)/2, label.bottom+10, 150, 35) title:@"去首页购物" titleColor:[UIColor whiteColor] image:nil bgImage:nil];
        [button addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:GLOBAL_COLOR];
        [button SetBorderWithcornerRadius:15.f BorderWith:0.f AndBorderColor:nil];
        [_lowerFloorView addSubview:button];
    }
    return _lowerFloorView;

}

- (void)goHome {
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabBarViewControllerWillShowNotification object:nil userInfo:@{@"index":@(0)}];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)clearShoppingCar {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要清空购物车?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[SingleShoppingCar sharedInstance] clearShoppingCar];
        
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        [self.view addSubview:self.lowerFloorView];
    }
}

- (void)settle {
    
    if (![[SingleUserInfo sharedInstance] locationPlayerStatus]) {//检测用户是否登录
        [[SingleUserInfo sharedInstance] showLoginView];
    } else {
        if (!_isClose) {
            _isClose = YES;
            NSString *siteId = [[SingleShoppingCar sharedInstance] siteModel].id;
            NSString *orderList = [[SingleShoppingCar sharedInstance] getOrderList];
            NSString *param = [NSString stringWithFormat:@"siteId=%@&orderList=%@&channel=IOS",siteId,orderList];
            DLog(@"param: %@",param);
            [[DataEngine sharedInstance] requestUserOrderDataOrderId:nil parameter:param type:POST success:^(id responseData) {// 下订单
                NSDictionary *dic = (NSDictionary *)responseData;
                DLog(@"订单一： %@",dic);
                if ([dic[@"Success"] integerValue] == 1) {
                    
                    id obj = [dic[@"CallInfo"] lastObject];
                    if (obj == nil || obj == [NSNull null]) { // [obj isKindOfClass:[NSNull class]]
                        [self showErrorHUDWithText:@"订单提交失败"];
                    } else {
                        NSDictionary *order = obj;
                        self.orderModel = [[UserOrderDetailModel alloc] initWithDictionary:order];
                        if ([dic[@"Success"] integerValue] == 1) {
                            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
                            [self.view addSubview:hud];
                            hud.labelText = @"正在提交购物车...";
                            [hud showAnimated:YES whileExecutingBlock:^{
                                sleep(1.5);
                            } completionBlock:^{
                                _isClose = NO;
                                
                                [hud removeFromSuperview];
                                
                                [self showSuccessHUDWithText:@"成功提交,请选择支付方式"];
                                PayViewController *pay = [[PayViewController alloc] init];
                                pay.orderModel = self.orderModel;
                                [self pushNewViewController:pay];
                            }];
                        } else {
                            _isClose = NO;
                        }
                    }
                } else {
                    [self showErrorHUDWithText:@"订单提交失败"];
                }
            } failed:^(NSError *error) {
                _isClose = NO;
                DLog(@"%@",error);
            }];
        } else {
            _isClose = NO;
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    ProductsModel *model = self.dataSource[indexPath.row];
    [cell updateUIUsingModel:model];
    cell.purchaseBlockCB = ^ BOOL (ProductsModel *model) {
        if (model.count == 0) {
            [self.dataSource removeObject:model];
        } else {
            [self.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        }
        [self.tableView reloadData];
        return [[SingleShoppingCar sharedInstance] playerProductsModel:model];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 展示产品详情
    ProductsModel *model = self.dataSource[indexPath.row];
    ProductDetailViewController *pVC = [[ProductDetailViewController alloc] init];
    pVC.detailProductModel = model;
    
    [[SingleShoppingCar sharedInstance] setIsCarPushIntoDetailVC:YES];
    [self pushNewViewController:pVC];
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
