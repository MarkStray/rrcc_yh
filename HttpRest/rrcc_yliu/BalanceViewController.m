//
//  BalanceViewController.m
//  rrcc_yh
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "BalanceViewController.h"
#import "WebViewController.h"
#import "BalanceDetailViewController.h"

#import <AlipaySDK/AlipaySDK.h>// 支付宝
#import "AliPayHeader.h"


#import "WXApi.h"// 微信
#import "payRequsestHandler.h"

#import "PayEngine.h"



@interface BalanceViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,PayEngineDelegate>
{
    __weak IBOutlet UIView *headerView;
    
    __weak IBOutlet UILabel *tipLabel;
    
    __weak IBOutlet UILabel *tipDetailLabel;

    __weak IBOutlet UILabel *balanceLabel;
    
    // 充值金额
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet NSLayoutConstraint *_heightConstraint;
    
    // 支付方式
    
    __weak IBOutlet UILabel *payTypeLabel;

    __weak IBOutlet UIView *wxPayView;
    
    __weak IBOutlet UILabel *wxPayLabel;

    __weak IBOutlet UIButton *wxPayButton;
    
    __weak IBOutlet UIView *aliPayView;
    
    __weak IBOutlet UILabel *aliPayLabel;
    
    __weak IBOutlet UIButton *aliPayButton;
    
    // 余额协议
    __weak IBOutlet UIButton *agreeButton;
    
    __weak IBOutlet UILabel *agreeLabel;

    __weak IBOutlet UIButton *protocolButton;
    
    // 确认
    __weak IBOutlet UIButton *confirmButton;
}

/**
 *  payType = 1 微信
 *  payType = 2 支付宝
 */
@property (nonatomic, assign) int payType;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSString *topupId;// 一次充值的唯一标识符

@property (nonatomic, strong) TopUpModel *topUpModel;

@end

@implementation BalanceViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:@"BalanceViewController" bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
    return self;
}

- (void)initButtonStatus
{
    [wxPayButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    [wxPayButton setImage:[UIImage imageNamed:@"UnSelected"] forState:UIControlStateNormal];
    
    [aliPayButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    [aliPayButton setImage:[UIImage imageNamed:@"UnSelected"] forState:UIControlStateNormal];
    
    [agreeButton setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateSelected];
    [agreeButton setImage:[UIImage imageNamed:@"disagree"] forState:UIControlStateNormal];
    
    [wxPayButton setSelected:YES];
    self.payType = 1;
    
    [agreeButton setSelected:YES];
    
    [confirmButton SetBorderWithcornerRadius:5.f BorderWith:0.f AndBorderColor:nil];
}

- (void)initViewGesture
{
    [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushDetail)]];
    
    [wxPayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wxButtonAction:)]];
    
    [aliPayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aliButtonAction:)]];
}

- (void)initFontSize
{
    tipLabel.font = Font(14);
    tipDetailLabel.font = Font(14);
    balanceLabel.font = BoldFont(18);
    
    payTypeLabel.font = Font(14);
    wxPayLabel.font = Font(16);
    aliPayLabel.font = Font(16);
    
    agreeLabel.font = Font(14);
}

- (void)initData
{
    self.dataSource = [NSMutableArray array];
    
    [[DataEngine sharedInstance] requestUserTopupRoleid:@"-1" success:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"role %@",dic);
        if ([dic[@"Success"] integerValue] == 1) {
            NSArray *info = dic[@"CallInfo"];

            [info enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *d = (NSDictionary *)obj;
                TopUpModel *model = [TopUpModel creatWithDictionary:d];
                if (idx == 0) {
                    model.isSelected = YES;
                } else {
                    model.isSelected = NO;
                }
                
                [self.dataSource addObject:model];

            }];
        }
        if (self.dataSource.count == 0) [self.view addSubview:self.lowerFloorView];
        
        _heightConstraint.constant = 30 + self.dataSource.count*35*autoSizeScaleY;
        [_tableView reloadData];

    } failed:^(NSError *error) {
        [self.view addSubview:self.lowerFloorView];
    }];
}

- (UIView *)lowerFloorView {
    if (!_lowerFloorView) {
        _lowerFloorView = [[UIView alloc] initWithFrame:self.view.bounds];
        _lowerFloorView.backgroundColor = [UIColor whiteColor];
        UIImageView *imgV = [ZZFactory imageViewWithFrame:CGRectMake(0, 0, 150, 150) defaultImage:@"radish"];
        imgV.center = self.view.center;
        [_lowerFloorView addSubview:imgV];
        UILabel *lbl = [ZZFactory labelWithFrame:CGRectMake(0, imgV.bottom, kScreenWidth, 21) font:Font(14) color:[UIColor darkGrayColor] text:@"数据加载失败"];
        lbl.textAlignment = NSTextAlignmentCenter;
        [_lowerFloorView addSubview:lbl];
    }
    return _lowerFloorView;
}


- (void)requestBalanceData {
    [[DataEngine sharedInstance] requestUserDataSuccess:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"User: %@",dic);
        if ([dic[@"Success"] integerValue] == 1) {
            NSDictionary *userDict = dic[@"CallInfo"][@"User"];
            
            NSString *balance = userDict[@"balance"];
            
            balanceLabel.text = [NSString stringWithFormat:@"%@元",balance];
        }
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestBalanceData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.title = @"余额充值";
    
    [self initButtonStatus];
    [self initViewGesture];
    
    [self initFontSize];
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerNib:[UINib nibWithNibName:@"TopUpCell" bundle:nil] forCellReuseIdentifier:@"TopUpCell"];
    
    [self initData];
}

- (void)pushDetail
{
    BalanceDetailViewController *balanceDetail = [[BalanceDetailViewController alloc] init];
    [self pushNewViewController:balanceDetail];
}

- (IBAction)wxButtonAction:(id)sender
{
    wxPayButton.selected = YES;
    aliPayButton.selected = NO;
    self.payType = 1;
}

- (IBAction)aliButtonAction:(id)sender
{
    wxPayButton.selected = NO;
    aliPayButton.selected = YES;
    self.payType = 2;
}

- (IBAction)agreeButtonAction:(id)sender
{
    agreeButton.selected = !agreeButton.selected;
}

- (IBAction)protocolButtonAction:(id)sender
{
    // 跳转协议页面
    WebViewController *web = [WebViewController new];
    [self pushNewViewController:web];
}

- (IBAction)confirmButtonAction:(id)sender
{
    // 确认支付
    if (!agreeButton.selected) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否同意\"人人菜场余额协议\"?" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alertView show];
        return ;
    }
    // 支付
    [self sendPay];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        agreeButton.selected = YES;
        // 支付
        [self sendPay];
    }
}

- (void)sendPay // 支付
{
    __block TopUpModel *model = nil;
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([(TopUpModel *)obj isSelected]) {
            model = obj;
            *stop = YES;
        }
     }];
    
    NSString *param = [NSString stringWithFormat:@"type=1&expenditure=%@&title=余额充值&referid=%@",model.amount,model.id];
    DLog(@"param: %@",param);

    [[DataEngine sharedInstance] requestUserTopupResourceId:@"" parameter:param type:POST success:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"开启充值 %@",dic);
        
        if ([dic[@"Success"] integerValue] == 1) {
            // 创建充值记录 成功
            NSString *topupId = dic[@"CallInfo"][@"topupid"];
            
            if (topupId != nil || ![topupId isEqualToString:@""]) {
                
                self.topupId = topupId;
                // 预充值
                [self preTopup];
            }
            
        }
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

- (void)preTopup {
    
    if (self.payType == 1) {// 检测是否安装微信
        if (![WXApi isWXAppInstalled]) {
            show_alertView(@"检测到您的设备没有安装微信,请选择支付宝支付,或安装微信后再来支付!!")
            return ;
        }
    }
    
    NSString  *param = [NSString stringWithFormat:@"action=prepay&platform=%@",self.payType==1? @"wxapp": @"taobao"];
    DLog(@"param: %@",param);
    
    [[DataEngine sharedInstance] requestUserTopupResourceId:self.topupId parameter:param type:PUT success:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"预充值： %@",dic);
        
        if ([dic[@"Success"] integerValue] == 1) {
            
            // 创建充值记录 成功
            self.topUpModel = [TopUpModel creatWithDictionary:dic[@"CallInfo"]];
            
            // 新纪录插入成功
            if ([self.topUpModel.status isEqualToString:@"1"]) {
                // 在线 充值
                [self topupOnline];
            }
            
        } else {
            show_alertView(@"充值失败");
        }
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}
#pragma mark - 发起支付 充值
////////////////////////////////////////////////////////////////////////


- (void)topupOnline {
    
    DLog(@"支付金额: %@",self.topUpModel.expenditure);
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TestSwitch" ofType:@"plist"];
    NSDictionary *testDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    BOOL isTest = [(NSNumber *)testDict[@"isTest"] boolValue];

    if (self.payType == 1) {/*微信支付*/
        NSString *WxpayPrice = nil;
        
        if (isTest) {
            WxpayPrice = @"1";
        } else {
            WxpayPrice = [NSString stringWithFormat:@"%.f",self.topUpModel.expenditure.floatValue * 100];//参数值不能带小数点 默认为分
        }
        
        //创建支付签名对象
        payRequsestHandler *req = [payRequsestHandler alloc];
        //初始化支付签名对象
        [req initWithAppId:APP_ID mch_id:MCH_ID orderName:self.topUpModel.title orderPrice:WxpayPrice orderNO:self.topUpModel.transaction_id];
        //设置密钥
        [req setKey:PARTNER_KEY];
        
        //获取到实际调起微信支付的参数后，在app端调起支付
        NSMutableDictionary *dict = [req sendPay];
        
        if(dict){
            
            PayReq *pay             = [[PayReq alloc] init];//调起微信支付
            pay.openID              = [dict objectForKey:@"appid"];
            pay.partnerId           = [dict objectForKey:@"partnerid"];
            pay.prepayId            = [dict objectForKey:@"prepayid"];
            pay.nonceStr            = [dict objectForKey:@"noncestr"];
            pay.timeStamp           = [[dict objectForKey:@"timestamp"] intValue];
            pay.package             = [dict objectForKey:@"package"];
            pay.sign                = [dict objectForKey:@"sign"];
            
            [WXApi sendReq:pay];
            
            [[PayEngine sharedPay] setDelegate:self];// 设置回调代理
        }

        
    } else if (self.payType == 2) { /*支付宝支付*/
        
        NSString *AliPrice = nil;

        if (isTest) {
            AliPrice = @"0.01";
        } else {
            AliPrice = [NSString stringWithFormat:@"%.f",self.topUpModel.expenditure.floatValue];
        }

        /* 1.生成订单信息 */
        Order *order = [[Order alloc] init];
        order.partner = aPartnerID;
        order.seller = aSellerID;
        
        //[self generateTradeNO];// 订单ID(由商家自行制定)
        order.tradeNO = self.topUpModel.transaction_id;
        order.productName = self.topUpModel.title; // 商品名称
        order.productDescription = self.topUpModel.title; // 商品描述
        order.amount = AliPrice;
        
        order.notifyURL = @"http://shop.renrencaichang.com/order/zfbnotifydiff";
        order.service = @"mobile.securitypay.pay";
        order.paymentType = @"1";
        order.inputCharset = @"utf-8";
        order.itBPay = @"30m";// 支付时间
        order.showUrl = @"m.alipay.com";
        order.appID = aAppId;
        
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = @"rrcc2015081300213630";// 用appId作为 URLScheme
        /* 2.签名 */
        //将商品信息拼接成字符串
        NSString *orderSpec = [order description];
        
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        id<DataSigner> signer = CreateRSADataSigner(aPrivateKey);
        // 使用私钥描述字符串
        NSString *signedString = [signer signString:orderSpec];
        
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = nil;
        if (signedString != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, signedString, @"RSA"];
            // 3.调用 支付宝客户端 进行支付 传入我们的 appSchema
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    [self PayEngineType:PayEngineTypeAli result:resultDic];
            }];
        }
        
    }

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

#pragma mark - 支付成功

- (void)handlePayResult {// 通知服务器支付成功
    
    NSString  *param = [NSString stringWithFormat:@"action=pay&transactionId=%@&platformId=",self.topUpModel.transaction_id];// 这里没有拿不到第三方的交易流水号
    DLog(@"param: %@",param);
    
    [[DataEngine sharedInstance] requestUserTopupResourceId:self.topupId parameter:param type:PUT success:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"充值成功: %@",dic);
        
        if ([dic[@"Success"] integerValue] == 1) { // 第三方 支付
            
            NSString *status        = dic[@"CallInfo"][@"status"];
            
            if ([status isEqualToString:@"2"]) {
                
                //[self requestBalanceData];
                
                //[self showSuccessHUDWithText:@"充值成功"];
                
                // 展示详情
                [self pushDetail];
                
            }
        }

    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}



#pragma mark - UITableView delegate & dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [ZZFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 30) color:[UIColor whiteColor]];
    [ZZFactory labelWithFrame:CGRectMake(16, 0, kScreenWidth-16, 30) font:Font(14) color:[UIColor lightGrayColor] text:@"请选择充值金额" superView:headView];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35*autoSizeScaleY;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopUpCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TopUpModel *model = self.dataSource[indexPath.row];
    [cell updateUIWithModel:model complete:^(BOOL isSelected) {
        model.isSelected = isSelected;
        for (int i=0; i<self.dataSource.count; i++) {
            if (i != indexPath.row) {
                TopUpModel *mdl = self.dataSource[i];
                mdl.isSelected = NO;
            }
        }
        [_tableView reloadData];
    }];
    return cell;
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
