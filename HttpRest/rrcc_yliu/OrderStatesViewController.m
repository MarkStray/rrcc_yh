//
//  LYOrderStatesViewController.m
//  rrcc_yh
//
//  Created by user on 15/6/11.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "OrderStatesViewController.h"

//#import "PayEngineView.h"

#import "PayEngine.h"
#import "WXApi.h"// 微信


#define kOrderStatesCell @"OrderStatesCell"

@interface OrderStatesViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate,PayEngineDelegate>

@property (nonatomic, strong) UITableView *orderStateTableView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

// 支付界面
//@property (nonatomic, strong) PayEngineView *payInterfaceView;

@property (nonatomic, copy) NSString *balance;

// 支付过程返回的数据
@property (nonatomic, strong) UserOrderDetailModel *resultOrderModel;


@end

@implementation OrderStatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestBalanceData];
    
    // 初始化线的显示状态
    StatusModel *firstModel = [self.orderModel.statusList firstObject];
    firstModel.upViewHidden = YES;
    
    StatusModel *lastModel = [self.orderModel.statusList lastObject];
    lastModel.downViewHidden = YES;

    [self.view addSubview:self.orderStateTableView];
    [self.view addSubview:self.bottomView];
    [self setupOrderStatus:self.orderModel];
}

//- (PayEngineView *)payInterfaceView {
//    if (!_payInterfaceView) {
//        _payInterfaceView = [[PayEngineView alloc] initWithFrame:CGRectMake(16, 0, kScreenWidth-16*2, 150)];
//        _payInterfaceView.center = CGPointMake(self.view.center.x, self.view.center.y-104);
//        
//        __weak __typeof(self) weakSelf = self;
//        _payInterfaceView.cancelBlock = ^ {
//            [weakSelf pushTipView:weakSelf.payInterfaceView];
//        };
//        _payInterfaceView.confirmBlock = ^ (PayEngineType payType){
//            __strong __typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf pushTipView:strongSelf.payInterfaceView];
//            [strongSelf prePayOnlineType:payType];//发起支付
//        };
//        
//    }
//    return _payInterfaceView;
//}

- (void)requestBalanceData {
    [[DataEngine sharedInstance] requestUserDataSuccess:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"User: %@",dic);
        if ([dic[@"Success"] integerValue] == 1) {
            NSDictionary *userDict = dic[@"CallInfo"][@"User"];
            
            self.balance = userDict[@"balance"];
        }
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}



- (void)setupOrderStatus:(UserOrderDetailModel *)orderModel {
    [self.bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (orderModel.actionList.count == 1) {
        ActionModel *model = orderModel.actionList.lastObject;
        if ([model.action isEqualToString:@"telreminder"]) {
            self.bottomBtn.tag = HandleButtonBaseValue + HandleButtonTypeContactMerchant;
        } else if ([model.action isEqualToString:@"promptlypay"]) {
            self.bottomBtn.tag = HandleButtonBaseValue + HandleButtonTypeImmediatePayment;
        } else if ([model.action isEqualToString:@"again"]) {
            self.bottomBtn.tag = HandleButtonBaseValue + HandleButtonTypeTakeOrder;
        } else if ([model.action isEqualToString:@"cancel"]) {
            self.bottomBtn.tag = HandleButtonBaseValue + HandleButtonTypeCancelOrder;
        } else if ([model.action isEqualToString:@"confirm"]) {
            self.bottomBtn.tag = HandleButtonBaseValue + HandleButtonTypeConfirmOrder;
        }
        
        [self.bottomBtn setTitle:model.title forState:UIControlStateNormal];
        [self.bottomView addSubview:self.bottomBtn];
    } else if (orderModel.actionList.count == 2){
        ActionModel *leftModel = orderModel.actionList.firstObject;
        if ([leftModel.action isEqualToString:@"telreminder"]) {
            self.leftBtn.tag = HandleButtonBaseValue + HandleButtonTypeContactMerchant;
        } else if ([leftModel.action isEqualToString:@"promptlypay"]) {
            self.leftBtn.tag = HandleButtonBaseValue + HandleButtonTypeImmediatePayment;
        } else if ([leftModel.action isEqualToString:@"again"]) {
            self.leftBtn.tag = HandleButtonBaseValue + HandleButtonTypeTakeOrder;
        } else if ([leftModel.action isEqualToString:@"cancel"]) {
            self.leftBtn.tag = HandleButtonBaseValue + HandleButtonTypeCancelOrder;
        } else if ([leftModel.action isEqualToString:@"confirm"]) {
            self.leftBtn.tag = HandleButtonBaseValue + HandleButtonTypeConfirmOrder;
        }

        [self.leftBtn setTitle:leftModel.title forState:UIControlStateNormal];
        [self.bottomView addSubview:self.leftBtn];
        
        
        ActionModel *rightModel = orderModel.actionList.lastObject;
        if ([rightModel.action isEqualToString:@"telreminder"]) {
            self.rightBtn.tag = HandleButtonBaseValue + HandleButtonTypeContactMerchant;
        } else if ([rightModel.action isEqualToString:@"promptlypay"]) {
            self.rightBtn.tag = HandleButtonBaseValue + HandleButtonTypeImmediatePayment;
        } else if ([rightModel.action isEqualToString:@"again"]) {
            self.rightBtn.tag = HandleButtonBaseValue + HandleButtonTypeTakeOrder;
        } else if ([rightModel.action isEqualToString:@"cancel"]) {
            self.rightBtn.tag = HandleButtonBaseValue + HandleButtonTypeCancelOrder;
        } else if ([rightModel.action isEqualToString:@"confirm"]) {
            self.rightBtn.tag = HandleButtonBaseValue + HandleButtonTypeConfirmOrder;
        }

        [self.rightBtn setTitle:rightModel.title forState:UIControlStateNormal];
        [self.bottomView addSubview:self.rightBtn];
    } else {
        //[self showErrorHUDWithText:@"订单状态错误"];
    }
}

- (void)handleButtonAction:(UIButton *)btn {

    if (btn.tag == HandleButtonBaseValue + HandleButtonTypeImmediatePayment) {// 立即支付
        
        [PayEngine sharedPay].delegate = self;
        
        //[self popTipView:self.payInterfaceView];
        
        [self goPay];
        
    } else if (btn.tag == HandleButtonBaseValue + HandleButtonTypeCancelOrder) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否取消此订单" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }  else if (btn.tag == HandleButtonBaseValue + HandleButtonTypeConfirmOrder) {// 确认
        [self confirmOrder];
    } else if (btn.tag == HandleButtonBaseValue + HandleButtonTypeTakeOrder) {// 重下
        if (self.OnNavBackBlock) self.OnNavBackBlock(NO);// popVC
    } else if (btn.tag == HandleButtonBaseValue + HandleButtonTypeContactMerchant) {// 联系商家
        [[Utility Share] makeCall:@"4000-285-927"];
    }
}

#pragma mark UIAlertView Delegate

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) [self cancelOrder];
}

// 确认订单
- (void)confirmOrder {
    [[DataEngine sharedInstance] requestUserOrderDataOrderId:self.orderModel.id parameter:@"action=confirm" type:PUT success:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        if ([dic[@"Success"] integerValue] == 1 ) {
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
            [[UIApplication sharedApplication].keyWindow addSubview:hud];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"订单确认成功";
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1.5);
            } completionBlock:^{
                [hud removeFromSuperview];
                if (self.OnNavBackBlock) self.OnNavBackBlock(YES);
            }];
        }
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

// 取消订单
- (void)cancelOrder {
    [[DataEngine sharedInstance] requestUserOrderDataOrderId:self.orderModel.id parameter:@"action=cancel" type:PUT success:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        if ([dic[@"Success"] integerValue] == 1) {
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
            [[UIApplication sharedApplication].keyWindow addSubview:hud];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"订单取消成功";
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1.5);
            } completionBlock:^{
                [hud removeFromSuperview];
                if (self.OnNavBackBlock) self.OnNavBackBlock(YES);
            }];

        }
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

- (UITableView *)orderStateTableView {
    if (!_orderStateTableView) {
        _orderStateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64-40-60) style:UITableViewStyleGrouped];
        _orderStateTableView.delegate = self;
        _orderStateTableView.dataSource = self;
        _orderStateTableView.rowHeight = 70 * autoSizeScaleY;
        _orderStateTableView.backgroundColor = BACKGROUND_COLOR;
        _orderStateTableView.showsVerticalScrollIndicator = YES;
        _orderStateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_orderStateTableView registerNib:[UINib nibWithNibName:kOrderStatesCell bundle:nil] forCellReuseIdentifier:kOrderStatesCell];
    }
    return _orderStateTableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-64-40-60, kScreenWidth, 60)];
        _bottomView.backgroundColor = BACKGROUND_COLOR;
    }
    return _bottomView;
}

- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [ZZFactory buttonWithFrame:CGRectMake(16, 5, kScreenWidth-16*2, 35) title:nil titleColor:[UIColor whiteColor] image:nil bgImage:nil];
        _bottomBtn.backgroundColor = GLOBAL_COLOR;
        [_bottomBtn SetBorderWithcornerRadius:5.f BorderWith:0.f AndBorderColor:nil];
        [_bottomBtn addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [ZZFactory buttonWithFrame:CGRectMake(16, 0, (kScreenWidth-16*2-20)/2, 35) title:nil titleColor:[UIColor whiteColor] image:nil bgImage:nil];
        _leftBtn.backgroundColor = GLOBAL_COLOR;
        [_leftBtn SetBorderWithcornerRadius:5.f BorderWith:0.f AndBorderColor:nil];
        [_leftBtn addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [ZZFactory buttonWithFrame:CGRectMake(_leftBtn.right+20, 0, (kScreenWidth-16*2-20)/2, 35) title:nil titleColor:[UIColor whiteColor] image:nil bgImage:nil];
        _rightBtn.backgroundColor = GLOBAL_COLOR;
        [_rightBtn SetBorderWithcornerRadius:5.f BorderWith:1.f AndBorderColor:nil];
        [_rightBtn addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderModel.statusList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
     return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *hView = [ZZFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 30) color:BACKGROUND_COLOR];
    NSString *orderCode = [NSString stringWithFormat:@"订单号: %@",self.orderModel.ordercode];
    [ZZFactory labelWithFrame:CGRectMake(16, 0, kScreenWidth-16*2, 30) font:Font(16) color:GLOBAL_COLOR text:orderCode superView:hView];
    return hView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderStatesCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderStatesCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = BACKGROUND_COLOR;
        
    StatusModel *model = self.orderModel.statusList[indexPath.row];
    
    sd_image_url(cell.orderStateImageView, model.img_url);
    
    cell.orderStateLabel.text = model.title;
    cell.orderDetailLabel.text = model.subTitle;
    cell.orderTimeLabel.text = model.inserttime;
    
    cell.upView.hidden = model.upViewHidden;
    cell.downView.hidden = model.downViewHidden;

    return cell;
}

#pragma mark -
#pragma mark - goPay

/**
 *  二次支付
 */
- (void)goPay {
    
    NSString *balanceStr = [NSString stringWithFormat:@"余额支付(%@元)",self.balance];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信支付", @"支付宝支付", balanceStr, nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0://微信
        {
            [self prePayOnlineType:PayEngineTypeWX];
        }
            break;
        case 1://支付宝
        {
            [self prePayOnlineType:PayEngineTypeAli];
        }
            break;
        case 2://余额
        {
            if (self.orderModel.custprice.floatValue > self.balance.floatValue) {
                show_animationAlert(@"当前余额不足请充值!");
            }  else {
                [self balancePay];
            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark
#pragma mark - 余额支付

- (void)balancePay {
    NSString *payPrice = [NSString stringWithFormat:@"%.2f",self.orderModel.custprice.floatValue];
    
    NSString  *param = [NSString stringWithFormat:@"type=2&expenditure=%@&title=%@&referid=%@",payPrice,@"订单消费",self.orderModel.id];
    DLog(@"param: %@",param);
    
    [[DataEngine sharedInstance] requestUserTopupResourceId:@"" parameter:param type:POST success:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"余额支付： %@",dic);
        if ([dic[@"Success"] integerValue] == 1) {
            NSString *topupid = dic[@"CallInfo"][@"topupid"];
            
            [self balancePayUpdateWithTopUpId:topupid];
        } else {
            show_alertView(@"操作失败");
        }
        
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
    
}

- (void)balancePayUpdateWithTopUpId:(NSString *)topupid {
    NSString  *param = [NSString stringWithFormat:@"action=orderpay&platform=wxapp&orderid=%@",self.orderModel.id];
    DLog(@"param: %@",param);
    
    [[DataEngine sharedInstance] requestUserTopupResourceId:topupid parameter:param type:PUT success:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"余额支付结果： %@",dic);
        if ([dic[@"Success"] integerValue] == 1) {
//            [self showSuccessHUDWithText:@"余额支付成功"];
//            
//            self.orderModel = [UserOrderDetailModel creatWithDictionary:dic[@"CallInfo"]];
//            [self setupOrderStatus:self.orderModel];
//            [self.orderStateTableView reloadData];
            
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
            [[UIApplication sharedApplication].keyWindow addSubview:hud];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"余额支付成功";
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1.5);
            } completionBlock:^{
                [hud removeFromSuperview];
                if (self.OnNavBackBlock) self.OnNavBackBlock(YES);
            }];

        } else {
            [self showErrorHUDWithText:@"余额支付失败"];
        }
        
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

#pragma mark - payEngineDelegate

- (void)PayEngineType:(PayEngineType)payType result:(id)resultData {

    if (payType == PayEngineTypeAli) {
        NSDictionary *resultDic = (NSDictionary *)resultData;
        DLog(@"AliResult --> %@",resultDic);
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            [self handlePayResult];
        } else if ([resultDic[@"resultStatus"] isEqualToString:@"8000"]) {
            [self showHUDWithText:@"正在处理中..."];
        } else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
            [self showHUDWithText:@"订单支付失败"];
        } else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
            [self showHUDWithText:@"用户取消支付"];
        } else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
            [self showHUDWithText:@"网络连接出错"];
        } else {
            [self showHUDWithText:@"订单支付失败"];
        }
        
    } else if (payType == PayEngineTypeWX) {
        BaseResp *resp = (BaseResp *)resultData;
        DLog(@"WXResult --> %d %@",resp.errCode,resp.errStr);
        if ([resp isKindOfClass:[PayResp class]]) {
            PayResp *response = (PayResp *)resp;
            if (response.errCode == WXSuccess) {
                [self handlePayResult];
            } else if (response.errCode == WXErrCodeUserCancel) {
                [self showHUDWithText:@"用户取消支付"];
            } else {
                [self showHUDWithText:@"订单支付失败"];
            }
        }
        
    } else {
        show_alertView(@"参数错误!!!");
    }
}

#pragma mark - 预支付

- (void)prePayOnlineType:(PayEngineType)payType {
    
    if (payType == PayEngineTypeWX) {// 检测是否安装微信
        if (![WXApi isWXAppInstalled]) {
            show_alertView(@"检测到您的设备没有安装微信,请选择支付宝支付,或安装微信后再来支付!!")
            return ;
        }
    }
    
    NSString  *param = [NSString stringWithFormat:@"action=prepay&platform=%@",payType==PayEngineTypeWX?@"wxapp":@"taobao"];
    DLog(@"param: %@",param);
    
    [[DataEngine sharedInstance] requestUserOrderDataOrderId:self.orderModel.id parameter:param type:PUT success:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"预支付： %@",dic);
        if ([dic[@"Success"] integerValue] == 1) {
            self.resultOrderModel = [UserOrderDetailModel creatWithDictionary:dic[@"CallInfo"]];
            
            //构造支付参数
            NSString *payPrice = [NSString stringWithFormat:@"%.2f",self.resultOrderModel.custprice.floatValue];
            //调第三方支付
            [[PayEngine sharedPay] sendPayType:payType totalPrice:payPrice orderModel:self.resultOrderModel];
        } else {
            show_alertView(@"操作失败");
        }
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
    
}


#pragma mark - 支付成功

- (void)handlePayResult {// 通知服务器支付成功
    
    NSString  *param = [NSString stringWithFormat:@"action=pay&transactionId=%@&platformId=",self.orderModel.transaction_id];// 这里没有拿不到第三方的交易流水号
    DLog(@"param: %@",param);
    
    [[DataEngine sharedInstance] requestUserOrderDataOrderId:self.orderModel.id parameter:param type:PUT success:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"支付成功: %@",dic);
        if ([dic[@"Success"] integerValue] == 1) { // 第三方 支付
//            [self showSuccessHUDWithText:@"支付成功"];
//            self.orderModel = [UserOrderDetailModel creatWithDictionary:dic[@"CallInfo"]];
//            [self setupOrderStatus:self.orderModel];
//            [self.orderStateTableView reloadData];
            
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
            [[UIApplication sharedApplication].keyWindow addSubview:hud];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"订单支付成功";
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1.5);
            } completionBlock:^{
                [hud removeFromSuperview];
                if (self.OnNavBackBlock) self.OnNavBackBlock(YES);
            }];

        }
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}


@end

