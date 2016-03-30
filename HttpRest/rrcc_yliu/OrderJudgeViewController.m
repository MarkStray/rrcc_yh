//
//  LYOrderJudgeViewController.m
//  rrcc_yh
//
//  Created by user on 15/6/26.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "OrderJudgeViewController.h"


@interface OrderJudgeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *judgeView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIButton *commitButton;

@property (nonatomic, strong) UserOrderDetailModel *orderModel;

@end

@implementation OrderJudgeViewController {
    float callerScore,sendTimeScore,priceScore,totalScore;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"OrderJudgeViewController" bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
    return self;
}

- (void)exitEdit {
    [self.textView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单评价";
    add_tap_gesture(self.view, exitEdit);
    [self creatRatingStar];
    self.orderModel = [[SingleShoppingCar sharedInstance] orderModel];
    [self.textView SetBorderWithcornerRadius:5.f BorderWith:0.8f AndBorderColor:RGBCOLOR(197, 197, 197)];
    [self.commitButton SetBorderWithcornerRadius:5.f BorderWith:0.f AndBorderColor:[UIColor clearColor]];
}

- (void)creatRatingStar {
    for (NSInteger i=0; i<4; i++) {
        ZZStarRating *zz = [[ZZStarRating alloc] initWithFrame:CGRectMake(110, 40+30*i,100,20) backgroundImage:@"Star_Gray" foregroundImage:@"Star_Yellow" maxRating:5 isFractionEnabled:YES];
        zz.tag = 101+i;
        [zz addTarget:self action:@selector(starAction:) forControlEvents:UIControlEventValueChanged];
        [self.judgeView addSubview:zz];
    }
}
- (void)starAction:(ZZStarRating *)zz {
    if (zz.tag == 101) {
        self->callerScore = zz.starLevel;
    } else if (zz.tag == 102) {
        self->sendTimeScore = zz.starLevel;
    } else if (zz.tag == 103) {
        self->priceScore = zz.starLevel;
    } else if (zz.tag == 104) {
        self->totalScore = zz.starLevel;
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""]) {
        self.textView.backgroundColor = [UIColor whiteColor];
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.textView.backgroundColor = [UIColor clearColor];
    }
    return YES;
}

- (IBAction)commit:(id)sender {
    NSString *remark =[self.textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    float colligateScore = (callerScore + sendTimeScore + priceScore + totalScore)/5;
    NSString *param = [NSString stringWithFormat:@"freshScore=%.2f&deliveryScore=%.2f&priceScore=%.2f&serviceScore=%.2f&colligateScore=%.2f&content=%@&orderId=%@&clientId=%@",callerScore,sendTimeScore,priceScore,totalScore,colligateScore,remark,self.orderModel.orderid,self.orderModel.client_id];
    //param = [NSString stringWithFormat:@"callerScore=%.2f&sendTimeScore=%.2f&priceScore=%.2f&totalScore=%.2f&remark=%@",callerScore,sendTimeScore,priceScore,totalScore,remark];
    DLog(@"param: %@",param);
    [[DataEngine sharedInstance] requestUserAppraiseDataClientId:self.orderModel.client_id parameter:param success:^(id responseData) {
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"%@",dic);
        if ([dic[@"Success"] integerValue] == 1) {
            [self showSuccessHUDWithText:@"评价成功"];
        }
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
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
