//
//  LoginPhoneView.m
//  expressapp
//
//  Created by kangylk on 15-3-3.
//  Copyright (c) 2015年 Kevin Kang. All rights reserved.
//

#import "LoginPhoneView.h"

@interface LoginPhoneView () <UITextFieldDelegate>
{
    __weak IBOutlet UITextField *phoneTextField;
    __weak IBOutlet UITextField *codeTextField;
    
    __weak IBOutlet UIButton *checkBtn;
    __weak IBOutlet UIButton *codeBtn;
    
    __weak IBOutlet UIView *phoneView;
    __weak IBOutlet UIView *codeView;
    
    __weak IBOutlet UIButton *callButton;

    NSTimer* timer;
    NSInteger timeCount;
    
    CGRect viewFrame;
}
@end

@implementation LoginPhoneView

- (void)dealloc {
    [self stopTimer];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"LoginPhoneView" bundle:nil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";

    [checkBtn SetBorderWithcornerRadius:5.f BorderWith:0.f AndBorderColor:nil];
    [codeBtn SetBorderWithcornerRadius:5.f BorderWith:0.f AndBorderColor:nil];
    
    [phoneView SetBorderWithcornerRadius:5.f BorderWith:1.f AndBorderColor:GLOBAL_COLOR];
    [codeView SetBorderWithcornerRadius:5.f BorderWith:1.f AndBorderColor:[UIColor colorWithWhite:0.92 alpha:1.0]];
    
    NSMutableAttributedString *callText = [[NSMutableAttributedString alloc] initWithString:callButton.titleLabel.text];
    [callText addAttributes:@{NSForegroundColorAttributeName:GLOBAL_COLOR,NSFontAttributeName:BoldFont(17)} range:NSMakeRange(11, 12)];
    callButton.titleLabel.attributedText = callText;


    UIButton *barBtn = [Tools_Utils createBackButton];
    [barBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barBtn];
    
    codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [phoneTextField becomeFirstResponder];
}

#pragma mark 打电话
- (IBAction)sendCall:(id)sender {
    [[Utility Share] makeCall:@"4000-285-927"];
}

-(void)dismissSelf {
    DLog(@"dismiss");
    [self stopTimer];
    [[SingleUserInfo sharedInstance] loginDissmiss];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == phoneTextField) {
        [phoneView SetBorderWithcornerRadius:5.f BorderWith:1.f AndBorderColor:GLOBAL_COLOR];
        [codeView SetBorderWithcornerRadius:5.f BorderWith:1.f AndBorderColor:[UIColor colorWithWhite:0.92 alpha:1.0]];
    } else if (textField == codeTextField) {
        [phoneView SetBorderWithcornerRadius:5.f BorderWith:1.f AndBorderColor:[UIColor colorWithWhite:0.92 alpha:1.0]];
        [codeView SetBorderWithcornerRadius:5.f BorderWith:1.f AndBorderColor:GLOBAL_COLOR];
    }
    return YES;
}

//发送验证码
- (IBAction)onGetCodeBtn:(UIButton *)sender {
    
    if (![Tools_Utils validateMobile:phoneTextField.text]) {
        show_alertView(@"请输入正确的手机号码!");
        return;
    }
    [self setCodeBtnBg:NO];//立即禁用键盘
    [[DataEngine sharedInstance] requestUserCaptchaDataWithMobile:phoneTextField.text captcha:nil success:^(id responseData) {
        NSDictionary *userDic = (NSDictionary *)responseData;
        DLog(@"验证码: %@",userDic);
        if ([userDic[@"Success"] integerValue] == 1) {
            [self getCodeSuccess];
        } else {
            [self showErrorHUDWithText:@"发送失败,请重新发送!"];
        }
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

//登陆
- (IBAction)onSignInBtn:(id)sender {
    
    if (![Tools_Utils validateMobile:phoneTextField.text]) {
        show_alertView(@"请输入正确的手机号码!");
        return;
    }
    if (codeTextField.text.length < 4) {
        show_alertView(@"请输入四位数字的验证码!");
        return;
    }
    [self userWebSignIn];//登陆
}

//登录
- (void)userWebSignIn {
    [self resignAll];
    [[DataEngine sharedInstance] requestUserCaptchaDataWithMobile:phoneTextField.text captcha:codeTextField.text success:^(id responseData) {
        NSDictionary *userDic = (NSDictionary *)responseData;
        DLog(@"登陆: %@",userDic);
        
        if ([userDic[@"Success"] integerValue] == 1) {
            NSDictionary *userInfoDic = [userDic[@"CallInfo"] lastObject];
            NSString *userid = userInfoDic[@"userid"];
            
            if ([userid isEqualToString:@"0"]) {//
                
                phoneTextField.text = @"";
                codeTextField.text = @"";
                [phoneTextField becomeFirstResponder];

                [self showErrorHUDWithText:@"手机号或验证码错误,请重新输入"];
            } else {
                NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
                [infoDic setObject:phoneTextField.text forKey:@"mobile"];
                [infoDic setObject:codeTextField.text forKey:@"captcha"];
                [infoDic setObject:codeTextField.text.md5 forKey:@"privateKey"];
                DLog(@"用户信息:%@",infoDic);
                
                [[SingleUserInfo sharedInstance] savePlayerInfoLocationWithDictionary:infoDic];//save
                [[SingleUserInfo sharedInstance] loginDissmiss];//dismiss
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginStatusNotification object:nil userInfo:@{@"loginStatus":@YES}];
            }
        } else {
            phoneTextField.text = @"";
            codeTextField.text = @"";
            [phoneTextField becomeFirstResponder];
            
            [self showErrorHUDWithText:@"手机号或验证码错误,请重新输入"];
        }
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}



- (void)getCodeSuccess {
    [self showSuccessHUDWithText:@"发送成功,请注意查收!"];
    [codeTextField becomeFirstResponder];
}

-(void)startTimer {
    if (timer==nil) {
        codeBtn.userInteractionEnabled = NO;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
        //[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

-(void)stopTimer {
    codeBtn.userInteractionEnabled = YES;
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

-(void) tick {
    timeCount--;
    NSString *str = [NSString stringWithFormat:@"再次获取%ld",(long)timeCount];
    [codeBtn setTitle:str forState:UIControlStateNormal];
    if (timeCount<=0) {
        [self setCodeBtnBg:YES];
    }
}

-(void)setCodeBtnBg:(BOOL)isNormal
{
    if (isNormal) {
        [codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [codeBtn setBackgroundColor:UIColorFromHEX(0x2ea821)];
        [self stopTimer];
    } else {
        [codeBtn setTitle:@"再次获取60" forState:UIControlStateNormal];
        [codeBtn setBackgroundColor:[UIColor lightGrayColor]];
        timeCount = 60;
        [self startTimer];
    }
}



- (void)resignAll {
    [self setCodeBtnBg:YES];
    [self.view endEditing:YES];
}

@end
