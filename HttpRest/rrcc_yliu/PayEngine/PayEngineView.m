//
//  PayEngineView.m
//  rrcc_yh
//
//  Created by user on 15/11/11.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "PayEngineView.h"
/*
 alipay =                 {
 balance = "-1";
 checkImgStatus = 0;
 checked = 0;
 img = "http://image.renrencaichang.com/icon/zhifubao.png";
 msg = "";
 title = "\U652f\U4ed8\U5b9d\U652f\U4ed8";
 value = 3;
 };
 daofu =                 {
 balance = "-1";
 checkImgStatus = 0;
 checked = 0;
 img = "http://image.renrencaichang.com/icon/dao.png";
 msg = "";
 title = "\U8d27\U5230\U4ed8\U6b3e";
 value = 1;
 };
 wx =                 {
 balance = "-1";
 checkImgStatus = 0;
 checked = 0;
 img = "http://image.renrencaichang.com/icon/weixin.png";
 msg = "";
 title = "\U5fae\U4fe1\U652f\U4ed8";
 value = 2;
 };
 yue =                 {
 balance = "2420.80";
 checkImgStatus = 1;
 checked = 1;
 img = "http://image.renrencaichang.com/icon/topupfang.png";
 msg = "";
 title = "\U4f59\U989d\U652f\U4ed8";
 value = 4;
 };

 */
@implementation PayEngineView
{
    
    __weak IBOutlet UITableView *methodTableView;
    
    NSMutableArray *_payBtnArray;
    NSMutableArray *_payImgArray;
    PayEngineType _payType;
}

#pragma mark - custom pay view

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _payBtnArray = [NSMutableArray array];
        _payImgArray = [NSMutableArray array];
        
        NSArray *payLogoImgs = @[@"Pay_Balance",@"Pay_WeChat",@"Pay_Ali"];
        
        NSArray *payTitles = @[@"余额支付",@"微信支付",@"支付宝支付"];
        
        for (int i=0; i<payTitles.count; i++) {
            CGFloat offsetY = 35+(25+10)*i;
            [ZZFactory imageViewWithFrame:CGRectMake(16, offsetY, 25, 25) defaultImage:payLogoImgs[i] superView:self];
            [ZZFactory labelWithFrame:CGRectMake(50, offsetY, kScreenWidth-16*2-25*2, 25) font:Font(16) color:[UIColor darkGrayColor] text:payTitles[i] superView:self];
            
            UIImageView *img = [ZZFactory imageViewWithFrame:CGRectMake(self.width-32, offsetY, 25, 25) defaultImage:@"UnSelected"];
            if (i == 0) {
                _payType = PayEngineTypeWX;
                img.image = [UIImage imageNamed:@"Selected"];
            }
            [self addSubview:img];
            [_payImgArray addObject:img];
            
            UIButton *btn = [ZZFactory buttonWithFrame:CGRectMake(0, offsetY-5, kScreenWidth, 35) title:nil titleColor:nil image:nil bgImage:nil];
            btn.tag = 1001 + i;
            [btn addTarget:self action:@selector(payBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [_payBtnArray addObject:btn];
            
            [ZZFactory viewWithFrame:CGRectMake(0, btn.bottom, kScreenWidth, 1) color:BACKGROUND_COLOR superView:self];
        }
        
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)payBtnAction:(UIButton *)btn {
    _payType = btn.tag - 1001 == 0? PayEngineTypeWX: PayEngineTypeAli;
    for (int i=0; i<_payBtnArray.count; i++) {
        UIButton *button = (UIButton *)_payBtnArray[i];
        UIImageView *imageView = (UIImageView *)_payImgArray[i];
        if (btn.tag == button.tag) {
            imageView.image = [UIImage imageNamed:@"Selected"];
        } else {
            imageView.image = [UIImage imageNamed:@"UnSelected"];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sView = [ZZFactory viewWithFrame:CGRectMake(0, 0, self.width, 40) color:[UIColor whiteColor]];
    
    UILabel *title = [ZZFactory labelWithFrame:CGRectMake(0, 10, self.width, 20) font:Font(16) color:[UIColor darkGrayColor] text:@"请选择支付方式"];
    title.textAlignment = NSTextAlignmentCenter;
    [sView addSubview:title];
    
    return sView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *sView = [ZZFactory viewWithFrame:CGRectMake(0, 0, self.width, 40) color:[UIColor whiteColor]];
    
    UIButton *leftBtn = [ZZFactory buttonWithFrame:CGRectMake(30, 120, 60, 30) title:@"取消" titleColor:[UIColor darkGrayColor] image:nil bgImage:nil];
    [leftBtn addTarget:self action:@selector(popLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [ZZFactory buttonWithFrame:CGRectMake(self.width-30-60, 120, 60, 30) title:@"确定" titleColor:[UIColor darkGrayColor] image:nil bgImage:nil];
    [rightBtn addTarget:self action:@selector(popRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [sView addSubview:leftBtn];
    [sView addSubview:rightBtn];
    
    return sView;
}

- (void)popLeftBtnClick:(UIButton *)button {//取消
    if (self.cancelBlock) self.cancelBlock();
}

- (void)popRightBtnClick:(UIButton *)button {//支付
    if (self.confirmBlock) self.confirmBlock(_payType);
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



@end
