//
//  MineViewController.m
//  rrcc_yh
//
//  Created by user on 15/9/18.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "MineViewController.h"

#import "OrderListViewController.h"
#import "BalanceViewController.h"
#import "SalaryViewController.h"
#import "ScoreViewController.h"
#import "QAndAViewController.h"

#import "LoginPhoneView.h"

#import "UMSocial.h"
#define UMKEY @"55ac540f67e58e29c3005d2d"

#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>


@interface MineViewController () <UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    NSString *_balance,*_credit;
}
@property (nonatomic, strong) UITableView *mineTableView;

@property (nonatomic, strong) NSArray *imgAndTitle;
@property (nonatomic, strong) NSMutableArray *details;

@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, strong) UILabel *headerLabel;

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showCustomTabBar];

    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserverForName:kDidLoginStatusNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        BOOL loginStatus = [note.userInfo[@"loginStatus"] boolValue];
        if (loginStatus) {
            NSString *mobile = [[[SingleUserInfo sharedInstance] playerInfoModel] mobile];
            self.headerLabel.text = mobile;
        } else {
            self.headerLabel.text = @"点击头像登录";
        }
    }];
    
    //[self playerLoginStatusMonitor];
    [self initUserData];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidLoginStatusNotification object:nil];
}

- (void)login {
    //检测用户是否登录
    if (![[SingleUserInfo sharedInstance] locationPlayerStatus]) {
        [[SingleUserInfo sharedInstance] showLoginView];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
}

- (UITableView *)mineTableView {
     if (!_mineTableView) {
         _mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, kScreenWidth, self.view.height-49-140) style:UITableViewStyleGrouped];
         _mineTableView.delegate = self;
         _mineTableView.dataSource = self;
         _mineTableView.rowHeight = 40;
         _mineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
         [_mineTableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"MineCellId"];
    }
    return _mineTableView;
}

- (void)initUI {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    headerView.backgroundColor = BACKGROUND_COLOR;
    UIImageView *headerImgView = [[UIImageView alloc] initWithFrame:headerView.bounds];
    headerImgView.image = [UIImage imageNamed:@"mine-background"];
    [headerView addSubview:headerImgView];
    
    self.headerBtn = [ZZFactory buttonWithFrame:CGRectMake(kScreenWidth/2-35, 25, 70, 70) title:nil titleColor:nil image:nil bgImage:@"portrait"];
    [self.headerBtn SetBorderWithcornerRadius:35.f BorderWith:0.f AndBorderColor:nil];
    [self.headerBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.headerBtn];
    
    NSString *mobile = [[[SingleUserInfo sharedInstance] playerInfoModel] mobile];
    
    self.headerLabel = [ZZFactory labelWithFrame:CGRectMake(0, 95, kScreenWidth, 30) font:Font(16) color:[UIColor whiteColor] text:mobile==nil?@"点击头像登录":mobile];
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:self.headerLabel];
    [self.view addSubview:headerView];
    
    [self.view addSubview:self.mineTableView];
}

- (void)initUserData {
    
    // load location resource
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mine" ofType:@"plist"];
    NSArray *mineAsset = [NSArray arrayWithContentsOfFile:plistPath];
    self.imgAndTitle = mineAsset;
    
    [self showLoadingIndicator];//
    [[DataEngine sharedInstance] requestUserDataSuccess:^(id responseData) {
        [self hideLoadingIndicator];//
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"User: %@",dic);
        if ([dic[@"Success"] integerValue] == 1) {
            NSDictionary *userDict = dic[@"CallInfo"][@"User"];
            
            _balance = userDict[@"balance"];
            NSString *balance = [NSString stringWithFormat:@"当前余额%@元",_balance];
            
            _credit  = userDict[@"credit"];
            NSString *credit = [NSString stringWithFormat:@"当前积分%@分",_credit];
            
            self.details = [NSMutableArray arrayWithArray:@[@[@"查看全部订单"],@[balance,@"查看",credit],@[@"",@"",@""]]];
            [self.mineTableView reloadData];
        } else {
            self.details = [NSMutableArray arrayWithArray:@[@[@""],@[@"",@"",@""],@[@"",@"",@""]]];
            [self.mineTableView reloadData];
        }
        
    } failed:^(NSError *error) {
        [self hideLoadingIndicator];//

        DLog(@"%@",error);
    }];
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.details.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSArray *)self.details[section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *tempDict = [self.imgAndTitle[indexPath.section] objectAtIndex:indexPath.row];
    NSString *imageName = [tempDict objectForKey:@"img"];
    NSString *title = [tempDict objectForKey:@"title"];
    
    NSString *detail = [self.details[indexPath.section] objectAtIndex:indexPath.row];
    
    UIColor *detailTextColor = [UIColor lightGrayColor];
    if (indexPath.section == 1) {
        detailTextColor = [UIColor redColor];
        if (indexPath.row == 2) {
            detailTextColor = [UIColor greenColor];
        }
    }
    
    BOOL isHidden = YES;
    if (indexPath.section == 1) {
        if (indexPath.row != 2) {
            isHidden = NO;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row != 2) {
            isHidden = NO;
        }
    }
    
    [cell updateUIUsingImage:imageName lineViewHidden:isHidden title:title detail:detail color:detailTextColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (indexPath.section == 0) {
        //检测用户是否登录
        if (![[SingleUserInfo sharedInstance] locationPlayerStatus]) {
            [[SingleUserInfo sharedInstance] showLoginView];
            return;
        }

        
        OrderListViewController *orderList = [[OrderListViewController alloc] init];
        [self pushNewViewController:orderList];
    } else if (indexPath.section == 1) {
        //检测用户是否登录
        if (![[SingleUserInfo sharedInstance] locationPlayerStatus]) {
            [[SingleUserInfo sharedInstance] showLoginView];
            return;
        }

        if (indexPath.row == 0) {
            // 余额
            BalanceViewController *balance = [[BalanceViewController alloc] init];
            [self pushNewViewController:balance];
        } else if (indexPath.row == 1) {
            // 红包
            SalaryViewController *salary = [[SalaryViewController alloc] init];
            [self pushNewViewController:salary];
        } else if (indexPath.row == 2) {
            // 积分
            ScoreViewController *score = [[ScoreViewController alloc] init];
            [self pushNewViewController:score];
        }
    } else {
        if (indexPath.row == 0) {
            [self share];
        } else if (indexPath.row == 1) {
            [[Utility Share] makeCall:@"4000-285-927"];
        } else if (indexPath.row == 2) {
            QAndAViewController *qa = [[QAndAViewController alloc] init];
            [self pushNewViewController:qa];
        }
    }
}

- (void)share {
    
    //NSMutableArray *snsArray = [NSMutableArray arrayWithObject:UMShareToSina];
    NSMutableArray *snsArray = [NSMutableArray array];
    
    if ([WXApi isWXAppInstalled]) {// 是否安装微信
        [snsArray addObject:UMShareToWechatSession];
        [snsArray addObject:UMShareToWechatTimeline];
    }
    
    if ([QQApiInterface isQQInstalled]) {// 是否安装QQ
        [snsArray addObject:UMShareToQQ];
        [snsArray addObject:UMShareToQzone];
    }
    
    if (snsArray.count == 0) {
        show_alertView(@"请安装微信或者QQ才能使用分享");
        return;
    }

    
    // 是否安装新浪微博
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]]) {
        DLog(@"安装了新浪客户端");
    } else {
        DLog(@"没有安装新浪客户端");
    }
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMKEY shareText:@"开通新用户立享5元新人红包" shareImage:[UIImage imageNamed:@"sharelogo"] shareToSnsNames:snsArray delegate:self];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"人人菜场 买菜好帮手";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"人人菜场 买菜好帮手";
    [UMSocialData defaultData].extConfig.qqData.title = @"人人菜场 买菜好帮手";
    [UMSocialData defaultData].extConfig.qzoneData.title = @"人人菜场 买菜好帮手";
    
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"www.renrencaichang.com";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"www.renrencaichang.com";
    [UMSocialData defaultData].extConfig.qqData.url = @"www.renrencaichang.com";
    [UMSocialData defaultData].extConfig.qzoneData.url = @"www.renrencaichang.com";
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if(response.responseCode == UMSResponseCodeSuccess) {
        DLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        DLog(@"%@",response);
    }
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
