//
//  BalanceDetailViewController.m
//  rrcc_yh
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "BalanceDetailViewController.h"

#define kBanlanceCellIdentifier @"BalanceCell"

@interface BalanceDetailViewController () <UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UILabel *currentBalanceLabel;
    
    __weak IBOutlet UILabel *balanceLabel;
    
    __weak IBOutlet UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation BalanceDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:@"BalanceDetailViewController" bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
    return self;
}

- (void)initFontSize {
    currentBalanceLabel.font = Font(14);
    balanceLabel.font = BoldFont(18);
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

- (void)requestTopupDetailData {
    
    self.dataSource = [NSMutableArray array];

    [[DataEngine sharedInstance] requestUserTopupDetailTopupid:@"-1" success:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"余额明细: %@",dic);
        if ([dic[@"Success"] integerValue] == 1) {
            
            if ([dic[@"CallInfo"] isNotNullObject]) {
                NSArray *callInfo = dic[@"CallInfo"];
                [callInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TopUpModel *model = [TopUpModel creatWithDictionary:obj];
                    
                    [self.dataSource addObject:model];
                    
                }];
            }
            
            [_tableView reloadData];
        }
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;

    self.title = @"余额明细";
    [self initFontSize];
    [self requestBalanceData];
    
    [self requestTopupDetailData];
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    [_tableView registerNib:[UINib nibWithNibName:kBanlanceCellIdentifier bundle:nil] forCellReuseIdentifier:kBanlanceCellIdentifier];
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*autoSizeScaleY;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [ZZFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 30) color:BACKGROUND_COLOR];
    [ZZFactory labelWithFrame:CGRectMake(16, 0, kScreenWidth-16, 30) font:Font(16) color:[UIColor lightGrayColor] text:@"余额明细" superView:headView];
    return headView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:kBanlanceCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateUIWithModel:self.dataSource[indexPath.row]];
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
