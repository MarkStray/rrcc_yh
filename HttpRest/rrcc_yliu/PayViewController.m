//
//  PayViewController.m
//  rrcc_yh
//
//  Created by user on 15/11/5.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "PayViewController.h"
#import "BalanceViewController.h"
#import "OrderDetailViewController.h"
#import "OrderSuccessedViewController.h"

#import "PayEngine.h"
#import "WXApi.h"// 微信

#define kPayHeaderCellIndetifier            @"PayHeaderCell"
#define kPayAddressCellIndetifier           @"PayAddressCell"
#define kPayTimeCellIndetifier              @"PayTimeCell"
#define kPayRedEnvelopCellIndetifier        @"PayRedEnvelopCell"
#define kPayTypeCellIndetifier              @"PayTypeCell"
#define kPayDetailCellIndetifier            @"PayDetailCell"
#define kPayFooterCellIndetifier            @"PayFooterCell"

@interface PayViewController () <UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,PayEngineDelegate>

@property (nonatomic, strong) UITableView *payTableView;

@property (nonatomic, assign) NSInteger sectionCount;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UITextField *hideTextField;//启动键盘
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIPickerView *timePicker;
@property (nonatomic, strong) NSArray *dateTimeList;//日期数据源

@property (nonatomic, assign) NSInteger dateTimeIndex;// 选择的日期下标
@property (nonatomic, assign) NSInteger buffDataTimeIndex;// 缓存日期下标
@property (nonatomic, assign) BOOL isNeedResetIndex;// 是否需要重置下标

// 配送方式model
@property (nonatomic, strong) DeliveryModel *deliveryModel;

@property (nonatomic, copy) NSString *descTitle;//收货时间标题
@property (nonatomic, strong) NSMutableArray *timeList;

// 红包
@property (nonatomic, strong) NSMutableArray *voucherList;

// 支付方式数组
@property (nonatomic, strong) NSMutableArray *payMethodList;

//订单详情
@property (nonatomic, strong) NSMutableArray *orderDetailList;


@property (nonatomic, strong) RedPageModel *hasRedModel;// 有红包

@property (nonatomic, strong) NSMutableArray *distributerList;//自提点
@property (nonatomic, copy) NSString *distributerId;//自提点ID


// 订单联系人信息
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *distributeAddress;//自提地址
@property (nonatomic, copy) NSString *inputAddress;//输入地址

@property (nonatomic, copy) NSString *appointment;
@property (nonatomic, copy) NSString *payment;
@property (nonatomic, copy) NSString *delivery;
@property (nonatomic, copy) NSString *remark;
//支付方式
@property (nonatomic, assign) PayEngineType payType;


@property (nonatomic, assign) CGFloat offsetY;

@end

@implementation PayViewController

{
    BOOL _isSelectDistributer;//是否是选择自提点
    BOOL _isOpen;// 红包是否展开
    BOOL _isClose;//是否已经发起支付
    
    BOOL _isTextViewEditing;//textView 是否在编辑状态
}

#pragma mark
#pragma mark - 去支付
/**确认支付*/
- (void)goPay:(UIButton *)sender {// 1订单 2支付
    // 去除空格
    //NSString *contact  = [self.contact stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *contact  = [self.contact stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *mobile   = [self.mobile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *address  = [self.delivery intValue] == 2 ? self.inputAddress: self.distributeAddress;
    address = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];


    if (contact.length < 1) {
        show_alertView(@"请输入有效的联系人姓名!!");
        return ;
    } else if (![Tools_Utils validateMobile:self.mobile]) {
        show_alertView(@"请输入正确的手机号码!!");
        return ;
    }  else if (address.length < 1) {
        show_alertView(@"请输入有效的地址!!");
        return ;
    } else {
        
        if (self.payType==PayEngineTypeWX && ![WXApi isWXAppInstalled]) {// 是否安装微信
            show_alertView(@"检测到您的设备没有安装微信,请选择支付宝支付,或安装微信后再来支付!!")
            return ;
        }
        
        // 本地保存相关信息 contact mobile (address)
        
        [[NSUserDefaults standardUserDefaults] setObject:contact forKey:kContactName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:mobile forKey:kContactMobile];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([self.delivery intValue] == 2) {
            [[NSUserDefaults standardUserDefaults] setObject:address forKey:kContactAddress];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }


        if (!_isClose) {
            _isClose = YES;
            
            contact = [contact stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString *remark = self.remark == nil? @"":[self.remark stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            /*
             * payment    1 货到付款 (2) 在线支付
             * delivery   (1) 到店自提 2 配送
             */
            NSString *param = [NSString stringWithFormat:@"action=update&distributerId=%@&contact=%@&mobile=%@&address=%@&payment=%@&delivery=%@&appointment=%@&voucherId=%@&remark=%@",self.distributerId,contact,mobile,address,self.payment,self.delivery,self.appointment,self.hasRedModel==nil?@"":self.hasRedModel.id,remark];
            DLog(@"param: %@",param);
            
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
            [[UIApplication sharedApplication].keyWindow addSubview:hud];
            hud.labelText = @"正在进入支付...";
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1.5);
                [[DataEngine sharedInstance] requestUserOrderDataOrderId:self.orderModel.id parameter:param type:PUT success:^(id responseData) {//确认订单
                    _isClose = NO;
                    NSDictionary *dic = (NSDictionary *)responseData;
                    DLog(@"订单二： %@",dic);
                    if ([dic[@"Success"] integerValue] == 1) {//下单成功 预支付
                        self.orderModel = [UserOrderDetailModel creatWithDictionary:dic[@"CallInfo"]];
                        self.orderModel.orderid = self.orderModel.id;
                        [[SingleShoppingCar sharedInstance] setOrderModel:self.orderModel];// 状态0
                        
                        if (self.orderModel.status.integerValue == 1) { //订单更新成功
                            
                            if (self.orderModel.payment.integerValue == 2) {
                                
                                if (self.payType == PayEngineTypeBalance) {
                                    [self balancePay];// 余额支付
                                } else {
                                    [self prePayOnline];//预支付
                                }
                                
                            } else {// 下单成功 到付 // 跳订单界面
                                [[SingleShoppingCar sharedInstance] clearShoppingCar];
                                
                                OrderSuccessedViewController *orderSuccess = [[OrderSuccessedViewController alloc] init];
                                [self pushNewViewController:orderSuccess];
                            }

                        } else {
                            [self showHUDWithText:@"服务器异常"];
                        }
                        
                    } else {
                        show_alertView(@"操作失败");
                    }
                } failed:^(NSError *error) {
                    _isClose = NO;
                    DLog(@"%@",error);
                }];
                
            } completionBlock:^{
                [hud removeFromSuperview];
            }];
        }
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
            
            [[SingleShoppingCar sharedInstance] clearShoppingCar];
            
            OrderSuccessedViewController *orderSuccess = [[OrderSuccessedViewController alloc] init];
            [self pushNewViewController:orderSuccess];

        } else {
            show_alertView(@"余额支付失败");
        }

    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

#pragma mark
#pragma mark - 预支付

- (void)prePayOnline {
    
    NSString  *param = [NSString stringWithFormat:@"action=prepay&platform=%@",self.payType==PayEngineTypeWX? @"wxapp": @"taobao"];
    DLog(@"param: %@",param);
    
    [[DataEngine sharedInstance] requestUserOrderDataOrderId:self.orderModel.id parameter:param type:PUT success:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"预支付： %@",dic);
        if ([dic[@"Success"] integerValue] == 1) {
            self.orderModel = [UserOrderDetailModel creatWithDictionary:dic[@"CallInfo"]];
            self.orderModel.orderid = self.orderModel.id;
            [[SingleShoppingCar sharedInstance] setOrderModel:self.orderModel];// 状态1
            

            //构造支付参数
            
            // custprice = price - discount
            NSString *payPrice = [NSString stringWithFormat:@"%.2f",self.orderModel.custprice.floatValue];
            
            //if (self.hasRedModel != nil) {
            //    payPrice = [NSString stringWithFormat:@"%.2f",self.orderModel.custprice.floatValue-self.hasRedModel.discount.floatValue];
            //}
            
            //调第三方支付
            [PayEngine sharedPay].delegate = self;
            [[PayEngine sharedPay] sendPayType:self.payType totalPrice:payPrice orderModel:self.orderModel];
        } else {
            show_alertView(@"操作失败");
        }
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
    
}

#pragma mark
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
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:hud];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"用户取消支付";
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1.5);
            } completionBlock:^{
                [hud removeFromSuperview];
                
                [[SingleShoppingCar sharedInstance] clearShoppingCar];
                
                OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
                [self pushNewViewController:orderDetail];
            }];
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
                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:hud];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"用户取消支付";
                [hud showAnimated:YES whileExecutingBlock:^{
                    sleep(1.5);
                } completionBlock:^{
                    [hud removeFromSuperview];
                    
                    [[SingleShoppingCar sharedInstance] clearShoppingCar];
                    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
                    [self pushNewViewController:orderDetail];
                }];

            } else {
                [self showHUDWithText:@"订单支付失败"];
            }
        }
        
    } else {
        show_alertView(@"参数错误!!!");
    }
}

#pragma mark
#pragma mark - 支付成功

- (void)handlePayResult {// 通知服务器支付成功
    
    NSString  *param = [NSString stringWithFormat:@"action=pay&transactionId=%@&platformId=",self.orderModel.transaction_id];// 这里没有拿不到第三方的交易流水号
    DLog(@"param: %@",param);
    
    [[DataEngine sharedInstance] requestUserOrderDataOrderId:self.orderModel.id parameter:param type:PUT success:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"支付成功: %@",dic);
        if ([dic[@"Success"] integerValue] == 1) { // 第三方 支付
            self.orderModel = [UserOrderDetailModel creatWithDictionary:dic[@"CallInfo"]];
            self.orderModel.orderid = self.orderModel.id;// 订单 ID 转换 用于跳转
            [[SingleShoppingCar sharedInstance] setOrderModel:self.orderModel];// 状态2
        }
        
        [[SingleShoppingCar sharedInstance] clearShoppingCar];
        
        OrderSuccessedViewController *orderSuccess = [[OrderSuccessedViewController alloc] init];
        [self pushNewViewController:orderSuccess];
        
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
    
}

#pragma mark
#pragma mark - UIKeyboard Events

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.sectionCount = 0;
    [self requestPreSubmitData];// 刷新界面数据
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardShow:(NSNotification *)notify {
    NSDictionary *userInfo = notify.userInfo;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardHeight = CGRectGetHeight([aValue CGRectValue]);
    
    NSTimeInterval timeInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:timeInterval animations:^{
        self.offsetY = self.payTableView.contentOffset.y;
        if (_isTextViewEditing) {
            self.payTableView.contentOffset = CGPointMake(0, self.offsetY + keyBoardHeight - 50);
        }
    } completion:nil];
}

- (void)keyboardHide:(NSNotification *)notify {
    NSDictionary *userInfo = notify.userInfo;
    NSTimeInterval timeInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:timeInterval animations:^{
        self.payTableView.contentOffset = CGPointMake(0, self.offsetY);
    } completion:nil];
}

- (void)resignTTFirstResponder {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResignFirstResponder" object:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self resignTTFirstResponder];
}


#pragma mark
#pragma mark - 初始化UI

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单结算";
    
    [self.view addSubview:self.payTableView];
    [self.view addSubview:self.bottomView];
    
    //启动键盘
    [self.view addSubview:self.hideTextField];

    
    [self initUIDataContainer];
}
- (UITableView *)payTableView {
    if (!_payTableView) {
        _payTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, self.view.height-64-50) style:UITableViewStyleGrouped];
        _payTableView.backgroundColor = BACKGROUND_COLOR;
        _payTableView.delegate = self;
        _payTableView.dataSource = self;
        
        _payTableView.separatorColor = [UIColor clearColor];
        _payTableView.showsVerticalScrollIndicator = YES;
        
        [_payTableView registerNib:[UINib nibWithNibName:kPayHeaderCellIndetifier bundle:nil] forCellReuseIdentifier:kPayHeaderCellIndetifier];
        [_payTableView registerNib:[UINib nibWithNibName:kPayAddressCellIndetifier bundle:nil] forCellReuseIdentifier:kPayAddressCellIndetifier];
        [_payTableView registerNib:[UINib nibWithNibName:kPayTimeCellIndetifier bundle:nil] forCellReuseIdentifier:kPayTimeCellIndetifier];
        [_payTableView registerNib:[UINib nibWithNibName:kPayTypeCellIndetifier bundle:nil] forCellReuseIdentifier:kPayTypeCellIndetifier];
        [_payTableView registerNib:[UINib nibWithNibName:kPayRedEnvelopCellIndetifier bundle:nil] forCellReuseIdentifier:kPayRedEnvelopCellIndetifier];
        [_payTableView registerNib:[UINib nibWithNibName:kPayDetailCellIndetifier bundle:nil] forCellReuseIdentifier:kPayDetailCellIndetifier];
        [_payTableView registerNib:[UINib nibWithNibName:kPayFooterCellIndetifier bundle:nil] forCellReuseIdentifier:kPayFooterCellIndetifier];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTTFirstResponder)];
        tap.cancelsTouchesInView = NO;
        [_payTableView addGestureRecognizer:tap];
    }
    return _payTableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [ZZFactory viewWithFrame:CGRectMake(0, self.view.height-50, kScreenWidth, 50) color:BACKGROUND_COLOR];
        UIButton *payBtn = [ZZFactory buttonWithFrame:CGRectMake(16, 7, kScreenWidth-16*2, 35) title:@"确认订单" titleColor:[UIColor whiteColor] image:nil bgImage:nil];
        payBtn.backgroundColor = GLOBAL_COLOR;
        [payBtn SetBorderWithcornerRadius:5.f BorderWith:0.f AndBorderColor:nil];
        [payBtn addTarget:self action:@selector(goPay:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:payBtn];
    }
    return _bottomView;
}

#pragma mark
#pragma mark - 初始化数据容器

- (void)initUIDataContainer {
    
    // 数组初始化
    self.timeList = [NSMutableArray array];
    self.payMethodList = [NSMutableArray array];
    self.voucherList = [NSMutableArray array];

    // 联系人
    self.contact = @"";
    NSString *contact = [[NSUserDefaults standardUserDefaults] objectForKey:kContactName];
    if (contact)    self.contact = contact;
    
    // 手机号
    self.mobile = [[[SingleUserInfo sharedInstance] playerInfoModel] mobile];
    NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:kContactMobile];
    if (mobile)    self.mobile = mobile;
    
    self.distributerList = [[SingleShoppingCar sharedInstance] distributerList];
    // 地址
    self.inputAddress = @"";
    NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:kContactAddress];
    if (address)    self.inputAddress = address;

    
    self.distributeAddress = @"";
    [self.distributerList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DistributerModel *model = (DistributerModel *)obj;
        if ([model isDefault]) {
            self.distributerId = model.id;
            self.distributeAddress = [NSString stringWithFormat:@"%@(%@)",model.sitename,model.address];
        }
    }];

    

    NSString *price = self.orderModel.price;
    NSString *discount = [NSString stringWithFormat:@"-￥%@",self.orderModel.discount==nil? @"0.00": self.orderModel.discount];
    NSString *redEnvelopGift = [NSString stringWithFormat:@"-￥%@",@"0.00"];
    NSString *gift = [NSString stringWithFormat:@"%@",self.orderModel.gift==nil?@"暂无赠品":self.orderModel.gift];
    NSString *payAdd = [NSString stringWithFormat:@"￥%.2f",self.orderModel.custprice.floatValue];
    
    self.orderDetailList = [NSMutableArray arrayWithArray:@[@{@"title":@"商品总额",@"detail":price,@"hidden":@YES},
                                                          @{@"title":@"满减活动",@"detail":discount,@"hidden":@YES},
                                                          @{@"title":@"红包优惠",@"detail":redEnvelopGift,@"hidden":@NO},
                                                          @{@"title":@"满增活动",@"detail":gift,@"hidden":@NO},
                                                          @{@"title":@"还需支付",@"detail":payAdd,@"hidden":@YES}]];
}

- (void)requestPreSubmitData {
    
    [self showLoadingIndicator];//
    [[DataEngine sharedInstance] requestUserOrderPreSubmitOrderId:self.orderModel.id success:^(id responseData) {
        [self hideLoadingIndicator];//
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"订单预提交: %@",dic);
        if ([dic[@"Success"] integerValue] == 1) {
            
            NSDictionary *orderInfo = dic[@"CallInfo"];
            
            // 配送方式 & 预约时间
            NSDictionary *deliverys = orderInfo[@"deliverys"];
            
            self.deliveryModel = [DeliveryModel creatWithDictionary:deliverys];
            
            NSArray *deliveryArray = deliverys[@"delivery"];
            
            // 存放对应的配送模型
            NSMutableArray *deliveryList = [NSMutableArray array];
            
            [deliveryArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *deliveryDict = (NSDictionary *)obj;
                
                TakeDescModel *descModel = [TakeDescModel creatWithDictionary:deliveryDict[@"desc"]];
                
                NSArray *timeArray = deliveryDict[@"timeArray"][descModel.value];
                
                // 存放对应的时间模型
                NSMutableArray *timeList = [NSMutableArray array];
                
                for (NSDictionary *d in timeArray) {
                    TimeModel *timeModel = [TimeModel creatWithDictionary:d];
                    [timeList addObject:timeModel];
                }
                
                // 存放对应的 日期 时间 字典模型
                NSMutableDictionary *deliveryDescDict = [NSMutableDictionary dictionary];
                
                [deliveryDescDict setObject:descModel forKey:@"desc"];
                [deliveryDescDict setObject:timeList forKey:@"timeArray"];

                // 添加到外部的配送模型中
                [deliveryList addObject:deliveryDescDict];
                
                //--测试--
//                TakeDescModel *descpModel = [[TakeDescModel alloc] init];
//                descpModel.title = @"后日收货";
//                descpModel.checked = @"0";
//                
//                NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:deliveryDescDict];
//                [newDict setObject:descpModel forKey:@"desc"];
//                
//                [deliveryList addObject:newDict];

            }];
            
            // 配送模型
            self.deliveryModel.deliveryList = deliveryList;
            
            // 配置 配送方式 默认值 // 1 到店自提 2 送货上门
            self.delivery = [self.deliveryModel.value intValue] == 1? @"1": @"2";
            
            // 配置支付方式
            NSArray *payMethodArray = [deliverys[@"payMethod"] allValues];
            
            [self.payMethodList removeAllObjects];
            [payMethodArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PayMethodModel *model = [PayMethodModel creatWithDictionary:obj];
                if (payMethodArray.count == idx + 1) {
                    // 隐藏最后一个cell的 bottomLine
                    [model setLineHidden:YES];
                }
                [self.payMethodList addObject:model];
            }];
            
            // 配置红包
            NSArray *voucherList = deliverys[@"voucherList"];

            [self.voucherList removeAllObjects];
            for (NSDictionary *d in voucherList) {
                RedPageModel *model = [RedPageModel creatWithDictionary:d];
                [self.voucherList addObject:model];
            }
            
            if (self.voucherList.count > 0) {
                RedPageModel *lastModel = [[RedPageModel alloc] init];
                lastModel.isLastest = YES;
                [self.voucherList addObject:lastModel];
            }
            
            self.sectionCount = 7;
            [self.payTableView reloadData];

        } else {
            [self showErrorHUDWithText:@"订单信息获取失败"];
        }
    } failed:^(NSError *error) {
        [self hideLoadingIndicator];//
        DLog(@"%@",error);
    }];
}

#pragma mark -
#pragma mark - UITableView


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 4) return self.payMethodList.count;
    if (section == 5) return self.orderDetailList.count;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0? CGFLOAT_MIN: 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 35*2;
    if (indexPath.section == 1) {
        if ([self.delivery intValue] == 2) {
            CGFloat height = [self.inputAddress boundingRectWithSize:CGSizeMake(kScreenWidth-16*2-65-10-10, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+60;
            return height < 35+45? 35+45: height;
        } else {
            CGFloat height = [self.distributeAddress boundingRectWithSize:CGSizeMake(kScreenWidth-16*2-65-10-10, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+60;
            return height < 35+45? 35+45: height;
        }
    }
    
    // 收货 取货 日期~时间
    if (indexPath.section == 2) {
        return 35*self.deliveryModel.deliveryList.count+35;
    }
    
    // 红包分区
    if (indexPath.section == 3) {
        if (_isOpen) {
            return (35 + (self.voucherList.count+1)/2 * 75);
        } else {
            return 35;
        }
    }
    
    if (indexPath.section == 4) return 35;
    if (indexPath.section == 5) return 35;
    
    return 44; // 最后 留言 分区
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        PayHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kPayHeaderCellIndetifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 联系人 & 手机号
        
        // 展示相关信息(本地保存)
        cell.contactTextField.text = self.contact;
        cell.telTextField.text = self.mobile;

        // 修改
        cell.contactBlock = ^ (NSString *contact) {
            self.contact = contact;
        };
        
        cell.mobileBlock = ^ (NSString *mobile) {
            self.mobile = mobile;
        };
        
        return cell;
    } else if (indexPath.section == 1) {
        PayAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:kPayAddressCellIndetifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.deliveryTitleLabel.text = self.deliveryModel.deliveryTitle;
        cell.referTitleLabel.text = self.deliveryModel.referTitle;
        
        //地址
        
        // 配置 配送方式 默认值 // 1 到店自提 2 送货上门
        
        if ([self.delivery intValue] == 2) {
            self.distributerId = @"";

            cell.addressTextView.text = self.inputAddress;//手动输入
            cell.addressTextView.editable = YES;
            cell.addressTextView.backgroundColor = [self.inputAddress isEqual:@""] || self.inputAddress==nil? [UIColor clearColor]:[UIColor whiteColor];
        } else {
            cell.addressTextView.text = self.distributeAddress;
            cell.addressTextView.editable = NO;
            cell.addressTextView.backgroundColor = [UIColor whiteColor];
        }
        
        cell.addressBlock = ^ (NSString *address) {
            if ([self.delivery intValue] == 2) {
                self.inputAddress = address;
            }
        };
        
        return cell;
    } else if (indexPath.section == 2) {
        PayTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:kPayTimeCellIndetifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.selectTimeAction = ^ {
            [self.hideTextField becomeFirstResponder];
        };

        cell.updateTimeAction = ^ (BOOL isNeedSetUp, NSString *appointment,NSArray *dateTimeArray){
            if (isNeedSetUp) {
                // 这里置0
                self.dateTimeIndex = 0;
                self.buffDataTimeIndex = 0;
            }

            self.appointment = appointment;
            self.dateTimeList = dateTimeArray;
            
            [self.timePicker reloadAllComponents];// 刷新
            [self.timePicker selectRow:self.dateTimeIndex inComponent:0 animated:NO];

        };
        
        [cell showDeliveryTimeWithModel:self.deliveryModel index:self.dateTimeIndex];
        
        return cell;
    } else if (indexPath.section == 3) {
        PayRedEnvelopCell *cell = [tableView dequeueReusableCellWithIdentifier:kPayRedEnvelopCellIndetifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.openBlock = ^ (BOOL isOpen) {
            _isOpen = isOpen;
            [self.payTableView reloadData];
        };
        
        // 这里传入满减之后的价格
        [cell updateUIUsingArray:self.voucherList tolPrice:self.orderModel.custprice complete:^(RedPageModel *model) {
            
            self.hasRedModel = model;//使用红包
            
            NSMutableDictionary *redEnvelopGiftDict = [NSMutableDictionary dictionaryWithDictionary:self.orderDetailList[2]];
            NSMutableDictionary *payAddDict = [NSMutableDictionary dictionaryWithDictionary:self.orderDetailList[4]];
            
            NSString *redEnvelopGift = [NSString stringWithFormat:@"-￥%.2f",model.discount.floatValue];
            
            [redEnvelopGiftDict setObject:redEnvelopGift forKey:@"detail"];
            NSString *payAdd = [NSString stringWithFormat:@"￥%.2f",self.orderModel.custprice.floatValue-model.discount.integerValue];
            [payAddDict setObject:payAdd forKey:@"detail"];
            
            [self.orderDetailList replaceObjectAtIndex:2 withObject:redEnvelopGiftDict];
            [self.orderDetailList replaceObjectAtIndex:4 withObject:payAddDict];
            [self.payTableView reloadData];
        }];

        return cell;
    }  else if (indexPath.section == 4) {
        PayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kPayTypeCellIndetifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PayMethodModel *model = self.payMethodList[indexPath.row];
        
        if (model.checked.intValue == 1) {
            self.payType = [model.value intValue];
            
            self.payment = @"1";// 到付
            if (self.payType != PayEngineTypeDelivery) {
                self.payment = @"2";// 线付
            }
        }
        
        cell.topUpAction = ^ {
            BalanceViewController *balance = [[BalanceViewController alloc] init];
            [self pushNewViewController:balance];
        };
        
        [cell showPayMethodWithModel:model];
        
        return cell;
    }  else if (indexPath.section == 5) {
        PayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kPayDetailCellIndetifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *payDetailDict = self.orderDetailList[indexPath.row];
        NSString *title = payDetailDict[@"title"];
        NSString *detail = payDetailDict[@"detail"];
        BOOL ishidden = [payDetailDict[@"hidden"] boolValue];
        
        cell.titleLabel.text = title;
        cell.detailLabel.text = detail;
        cell.lineView.hidden = ishidden;

        return cell;
    } else {
        PayFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:kPayFooterCellIndetifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.remarkBlock = ^ (NSString *remark) {
            self.remark = remark;
        };
        cell.editingStatusBlock = ^ (BOOL isEdit) {
            _isTextViewEditing = isEdit;
        };
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        PayMethodModel *model = self.payMethodList[indexPath.row];
        if (model.checked.intValue != 1) {
            [self.payMethodList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == indexPath.row) {
                    [(PayMethodModel *)obj setChecked:@"1"];
                } else {
                    [(PayMethodModel *)obj setChecked:@"0"];
                }
            }];
            [self.payTableView reloadData];
        }
    }
}

#pragma mark -
#pragma mark - HideTextField

- (UITextField *)hideTextField {
    if (!_hideTextField) {
        _hideTextField= [[UITextField alloc] initWithFrame:CGRectZero];
        _hideTextField.inputView = self.timePicker;
        _hideTextField.inputAccessoryView = self.toolBar;
    }
    return _hideTextField;
}

- (UIPickerView *)timePicker {
    if (!_timePicker) {
        _timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 216)];
        _timePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _timePicker.delegate = self;
        _timePicker.dataSource = self;
        
        //_timePicker.showsSelectionIndicator = YES;
    }
    return _timePicker;
}

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];

        _toolBar.items = @[cancelItem,flexibleItem,confirmItem];
    }
    return _toolBar;
}

// [self.payTableView reloadData] 不能省掉

- (void)cancel {
    [self.hideTextField resignFirstResponder];
}

- (void)confirm {
    if (self.buffDataTimeIndex != self.dateTimeIndex) {
        self.dateTimeIndex = self.buffDataTimeIndex;
    }
    // 刷新第二分区数据
    [self.payTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.hideTextField resignFirstResponder];
}

#pragma mark -
#pragma mark - UIPickerViewDataSource & Delegate

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dateTimeList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    TimeModel *timeModel = self.dateTimeList[row];
    return timeModel.timeTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.buffDataTimeIndex = row;
    //[self.payTableView reloadData];
}



@end
