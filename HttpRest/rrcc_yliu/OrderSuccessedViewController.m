//
//  OrderSuccessedViewController.m
//  rrcc_yh
//
//  Created by user on 15/8/4.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "OrderSuccessedViewController.h"
#import "OrderDetailViewController.h"

@interface OrderSuccessedViewController ()
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@end

@implementation OrderSuccessedViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:@"OrderSuccessedViewController" bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下单成功";
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.view1.backgroundColor = BACKGROUND_COLOR;
    self.view2.backgroundColor = BACKGROUND_COLOR;
    
    [self.checkButton SetBorderWithcornerRadius:5.f BorderWith:0.f AndBorderColor:[UIColor clearColor]];
    
    
    // override
    UIButton *barButton = [Tools_Utils createBackButton];
    [barButton addTarget:self action:@selector(onNavBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];

}

-(void)onNavBack {
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabBarViewControllerWillShowNotification object:nil userInfo:@{@"index":@(0)}];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)check:(id)sender {
    OrderDetailViewController *detailOrder = [[OrderDetailViewController alloc] init];
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
