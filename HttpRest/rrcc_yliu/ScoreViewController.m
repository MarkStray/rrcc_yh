//
//  ScoreViewController.m
//  rrcc_yh
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "ScoreViewController.h"
#import "UIView+HL.h"

#define kCreditRoleCell         @"CreditRoleCell"

#define kCreditRoleTextCell     @"CreditRoleTextCell"

@interface ScoreViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    __weak IBOutlet UIView *headerView;
    
    __weak IBOutlet UILabel *currentScoreLabel;
    __weak IBOutlet UILabel *scoreLabel;
    
    __weak IBOutlet UITableView *_tableView;
    
}

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSString *roleText;

@property (nonatomic, copy) NSString *credit;// 积分

@property (nonatomic, strong) CreditRoleModel *roleModel;// 兑换规则 模型

@end

@implementation ScoreViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:@"ScoreViewController" bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
    return self;
}

- (void)initFontSize {
    currentScoreLabel.font = Font(14);
    scoreLabel.font = BoldFont(18);
}

- (void)requestCreditData {
    [[DataEngine sharedInstance] requestUserDataSuccess:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"User: %@",dic);

        if ([dic[@"Success"] integerValue] == 1) {
            NSDictionary *userDict = dic[@"CallInfo"][@"User"];
            
            self.credit = userDict[@"credit"];
            
            scoreLabel.text = [NSString stringWithFormat:@"%@分",self.credit];
        }
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;

    self.title = @"积分兑换";
    [self initFontSize];
    [self requestCreditData];
    
    [self initData];
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerNib:[UINib nibWithNibName:kCreditRoleCell bundle:nil] forCellReuseIdentifier:kCreditRoleCell];
    [_tableView registerNib:[UINib nibWithNibName:kCreditRoleTextCell bundle:nil] forCellReuseIdentifier:kCreditRoleTextCell];
    
}

- (void)initData {
    self.roleText = @"1.用户在人人菜场完成订单后，每消费1元积1分，如消费30.9元，积30分，小数部分不计\n2.积分只适用于完成订单，下单后取消或下单未成功将不享有此福利\n3.如订单产生退货，积分将不能享有\n4.完成订单后，积分将于2天内自动累计到下单账户，登陆人人菜场微信，进入“我的”即可查看\n5.用户积分可兑换相应的奖品、参加用户积分系列活动（具体奖品以活动为主）\n6.用户积分不找零、不挂失、不退换、不兑现\n7.人人菜场拥有对积分活动的最终解释权";
    
    self.dataSource = [NSMutableArray array];
    
    [[DataEngine sharedInstance] requestUserCreditRoleid:@"-1" success:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"role %@",dic);
        if ([dic[@"Success"] integerValue] == 1) {
            NSArray *info = dic[@"CallInfo"];
            
            // 顺序遍历
            [info enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *d = (NSDictionary *)obj;
                CreditRoleModel *model = [CreditRoleModel creatWithDictionary:d];
                [self.dataSource addObject:model];
            }];
            
        }
        
        if (self.dataSource.count == 0) {
            [self.view addSubview:self.lowerFloorView];
        } else {
            [_tableView reloadData];
        }
        
    } failed:^(NSError *error) {
        [self.view addSubview:self.lowerFloorView];
        DLog(@"%@",error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.dataSource.count)  return 80;
    
    //NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
    //CreditRoleTextCell *cell = [_tableView cellForRowAtIndexPath:lastIndexPath];
    return [self.roleText boundingRectWithSize:CGSizeMake(kScreenWidth-16*2, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+60;

    //return [BZ_Tools heightForTextString:self.roleText width:kScreenWidth-16*2 fontSize:14]+150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.dataSource.count) {
        CreditRoleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCreditRoleCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CreditRoleModel *model = self.dataSource[indexPath.row];
        [cell updateUIWithModel:model];
        return cell;
    } else {
        CreditRoleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCreditRoleTextCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.roleTextLabel.text = self.roleText;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataSource.count) return;
    
    self.roleModel = self.dataSource[indexPath.row];
    
    if (self.credit.integerValue > self.roleModel.gift_credit.integerValue) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要兑换吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    } else {
        show_alertView(@"亲,您的积分不足,请充值");
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        CreditRoleModel *model = self.roleModel;
        
        //    NSString *giftTitle = [model.gift_title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *param = [NSString stringWithFormat:@"giftid=%@&gift_credit=%@&gift=%@&gift_title=%@&gift_limit=%@&gift_starttime=%@&gift_expired=%@",model.id,model.gift_credit,model.gift,model.gift_title,model.gift_limit,model.gift_starttime,model.gift_expired];
        
        [[DataEngine sharedInstance] requestUserCreditConsumeParameter:param success:^(id responseData) {
            NSDictionary *dic = (NSDictionary *)responseData;
            DLog(@"积分兑换 %@",dic);
            if ([dic[@"Success"] integerValue] == 1) {
                
                [self requestCreditData];
                
                [self showSuccessHUDWithText:@"兑换成功"];
            }
        } failed:^(NSError *error) {
            DLog(@"%@",error);
        }];

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
