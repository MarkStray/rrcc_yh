//
//  BaseViewController.m
//  dby
//
//  Created by thomas on 13-6-8.
//  Copyright (c) 2013年 thomas. All rights reserved.
//

#import "BaseViewController.h"
#import "Reachability.h"
#include <objc/runtime.h>
//#import <NimbusModels.h>
@interface BaseViewController ()
@property (nonatomic,strong) UILabel *sizeLabel;
@property (nonatomic,strong) UIButton *navleftButton;
@property (nonatomic,strong) UIButton *navrightButton;
//@property (nonatomic, readwrite, retain) NITableViewModel* model;
//@property (nonatomic, readwrite, retain) NITableViewActions* actions;
@end
@implementation BaseViewController

- (id)initWithNavStyle:(NSInteger)style
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(reachabilityChanged:)
    name:kReachabilityChangedNotification object:nil];
   //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    /*if (self.hideTabbar) {
        [self hideTabBar];
    }else{
        [self showTabBar];
    }*/
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    if (IOS7) {
        self.automaticallyAdjustsScrollViewInsets=NO;
        
        
    }
   
//    if (self.stretchButton.currentBackgroundImage) {
//        CGSize size = self.stretchButton.currentBackgroundImage.size;
//        [self.stretchButton setBackgroundImage:[self.stretchButton.currentBackgroundImage  stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height/2] forState:UIControlStateNormal];
//    }
	// Do any additional setup after loading the view.
}
-(void)viewDidLayoutSubviews{
    if (IOS7) {
        CGRect viewBounds = self.view.frame;
        //CGFloat topBarOffset = [[self performSelector:@selector(topLayoutGuide)] length];
//        
        viewBounds.origin.y = 20;//topBarOffset * -1;
        // viewBounds.size.height -= 20;
        viewBounds.size.height=kScreenHeight-20;
        DLog(@"viewBounds:%@",NSStringFromCGRect(viewBounds));
        self.view.frame = viewBounds;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
}
- (UIView*)navbarTitle:(NSString*)title
{
    if(!self.navView)
    {
        self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [self.navView setBackgroundColor:[UIColor blackColor]];
        UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar.png"]];
        imageview.contentMode = UIViewContentModeScaleToFill;
        if (IOS7) {
            [imageview setFrame:CGRectMake(0, -20, 320, 64)];
            self.navView.clipsToBounds = NO;
            self.view.clipsToBounds = NO;
        }else{
            [imageview setFrame:CGRectMake(0, 0, 320, 44)];
        }
        [self.navView addSubview:imageview];
        if (title.length) {
            UIView *nV=[[UIView alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
            nV.backgroundColor=[UIColor clearColor];
            nV.clipsToBounds=YES;
            nV.tag=102;
            
            CAGradientLayer* gradientMask = [CAGradientLayer layer];
            gradientMask.bounds = nV.layer.bounds;
            gradientMask.position = CGPointMake([nV bounds].size.width / 2, [nV bounds].size.height / 2);
            NSObject *transparent = (NSObject*) [[UIColor clearColor] CGColor];
            NSObject *opaque = (NSObject*) [[UIColor blackColor] CGColor];
            gradientMask.startPoint = CGPointMake(0.0, CGRectGetMidY(nV.frame));
            gradientMask.endPoint = CGPointMake(1.0, CGRectGetMidY(nV.frame));
            float fadePoint = (float)10/nV.frame.size.width;
            [gradientMask setColors: [NSArray arrayWithObjects: transparent, opaque, opaque, transparent, nil]];
            [gradientMask setLocations: [NSArray arrayWithObjects:
                                         [NSNumber numberWithFloat: 0.0],
                                         [NSNumber numberWithFloat: fadePoint],
                                         [NSNumber numberWithFloat: 1 - fadePoint],
                                         [NSNumber numberWithFloat: 1.0],
                                         nil]];
            nV.layer.mask = gradientMask;
            
            
            
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 44)];
            label.backgroundColor = [UIColor clearColor];
            label.font = BoldFont(18);
            label.textColor  = [UIColor whiteColor];
            label.shadowOffset = CGSizeMake(0, 0);
            label.text = title;
            label.tag = 101;
            label.textAlignment = NSTextAlignmentCenter;
            [nV addSubview:label];
            [self.navView addSubview:nV];
        }
        [self.view addSubview:self.navView];
    }
    UILabel *label = (UILabel*)[self.navView viewWithTag:101];
    label.text = title;
    CGRect frame=label.frame;
    CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
    if (frame.size.width<size.width) {
        frame.size.width=size.width;
        label.frame=frame;        
        frame.origin.x=-frame.size.width;
        UIView *nBGv=[self.navView viewWithTag:102];
        [UIView animateWithDuration:10.8 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            label.frame = frame;
        } completion:^(BOOL finished) {
            [self EntertainingDiversionsAnimation:10.8 aView:label subView:nBGv];
        }];
    }
    
    return self.navView;
}
-(void)EntertainingDiversionsAnimation:(NSTimeInterval)interval aView:(UIView *)av subView:(UIView *)sv{
    CGRect frame =av.frame;
    frame.origin.x=sv.frame.size.width;
    av.frame=frame;
    frame.origin.x=-frame.size.width;
    [UIView animateWithDuration:interval
                          delay:0.0
                        options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear
                     animations:^{
                         av.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (UIButton*)backButton
{
    return [self backButton:self];
}
- (UIButton*)backButton:(BaseViewController*)target
{    
    UIButton *button = (UIButton*)[self.navView viewWithTag:100];
    if (button) {
        return button;
    }
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [button setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];//back.png
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -47, 0, 0)];
    //[button setTitle:@"返回" forState:UIControlStateNormal];
   // [button setTitleColor:RGBCOLOR(85, 161, 226) forState:UIControlStateNormal];
    button.titleLabel.font = Font(12);
    button.tag = 100;
    [button addTarget:target action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [target.navView addSubview:button];
    return button;
}
- (UIButton*)leftButton:(NSString*)title image:(NSString*)image sel:(SEL)sel
{
    if (!self.navleftButton) {
        self.navleftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    }
    if(image)[self.navleftButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    if(title){
        [self.navleftButton setTitle:title forState:UIControlStateNormal];
        [self.navleftButton setTitleColor:RGBCOLOR(0, 191, 234) forState:UIControlStateNormal];
        [self.navleftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -47, 0, 0)];
        [self.navleftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -47, 0, 0)];
       
        self.navleftButton.titleLabel.font = Font(15);
    }
    if(sel)[self.navleftButton addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.navleftButton];
    return self.navleftButton;
}
- (UIButton*)rightButton:(NSString*)title image:(NSString*)image sel:(SEL)sel
{
    if (!self.navrightButton)
    {
        self.navrightButton = [[UIButton alloc] initWithFrame:CGRectMake(220,0, 100, 44)];
    }
    if(image)
    {
        [self.navrightButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [self.navrightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    }
    if(title)
    {
        [self.navrightButton setTitle:title forState:UIControlStateNormal];
        [self.navrightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (image)
        {
            [self.navrightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
            [self.navrightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        }else{
            [self.navrightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        }
        self.navrightButton.titleLabel.font = Font(15);
        
    }
    self.navrightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    if(sel)[self.navrightButton addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.navrightButton];
    return self.navrightButton;
}

- (void)setTitle:(NSString *)title
{
    for (UIView *view in self.navView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            ((UILabel*)view).text = title;
            break;
        }
    }
    [super setTitle:title];
}
- (NSString*)title
{
    for (UIView *view in self.navView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            return ((UILabel*)view).text;
        }
    }
    return [super title];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}
#pragma mark - Methods
- (void)hideTabBar
{
    [self.navigationController.tabBarController performSelector:@selector(hideTabBar)];
}
- (void)showTabBar
{
    [self.navigationController.tabBarController performSelector:@selector(showTabBar)];
}

- (BaseViewController*)pushController:(Class)controller withInfo:(id)info
{
    return [self pushController:controller withInfo:info withTitle:nil withOther:nil];
}
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title
{
    return [self pushController:controller withInfo:info withTitle:title withOther:nil];
}
/**
 *	自动配置次级controller头部并跳转
 *  次级controller为base的基类的时候，参数生效，否则无效
 *
 *	@param	controller	次级controller
 *	@param	info	主参数
 *	@param	title	次级顶部title（次级设置优先）
 *	@param	other	附加参数
 *
 *	@return	次级controller实体
 */
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other
{
    DLog(@"Base UserInfo:%@",info);
    BaseViewController *base = [[controller alloc] init];
    if ([(NSObject*)base respondsToSelector:@selector(setUserInfo:)]) {
        base.userInfo = info;
        base.otherInfo = other;
    }
    [self.navigationController pushViewController:base animated:YES];
    
    if ([(NSObject*)base respondsToSelector:@selector(setUserInfo:)]) {
        //如果次级controller自定义了title优先展示
        [base navbarTitle:base.title?base.title:title];
        if (base.navleftButton) {
            [base.navView addSubview:base.navleftButton];
        }else{
            [base backButton:base];
        }
        if (base.navrightButton) {
            [base.navView addSubview:base.navrightButton];
        }
    }
    return base;
}
//不需要Base来配置头部
- (BaseViewController*)pushController:(Class)controller withOnlyInfo:(id)info
{
    DLog(@"Base UserInfo:%@",info);
    BaseViewController *base = [[controller alloc] init];
    if ([(NSObject*)base respondsToSelector:@selector(setUserInfo:)]) {
        base.userInfo = info;
    }
    [self.navigationController pushViewController:base animated:YES];
    return base;
}
- (void)lj_popController:(id)controller
{
    //Class cls = NSClassFromString(controller);
    if ([controller isKindOfClass:[UIViewController class]]) {
        [self.navigationController popToViewController:controller animated:YES];
    }else{
        DLog(@"popToController NOT FOUND.");
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)popController:(NSString*)controllerstr withSel:(SEL)sel withObj:(id)info
{
    for (id controller in self.navigationController.viewControllers) {
        if ([NSStringFromClass([controller class]) isEqualToString:controllerstr]) {
            if ([(NSObject*)controller respondsToSelector:sel]) {
                [controller performSelector:sel withObject:info afterDelay:0.01];
            }
            [self lj_popController:controller];
            break;
        }
    }
}

- (void)popController:(NSString*)controller
{
    Class cls = NSClassFromString(controller);
    if ([cls isSubclassOfClass:[UIViewController class]]) {
        [self.navigationController popToViewController:(UIViewController*)cls animated:YES];
    }else{
        DLog(@"popToController NOT FOUND.");
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/*
- (void)popController:(NSString*)controllerstr withSel:(NSString*)sel withObj:(id)info
{
    for (id controller in self.navigationController.viewControllers) {
        if ([NSStringFromClass([controller class]) isEqualToString:controller]) {
            if ([(NSObject*)controller respondsToSelector:@selector(sel)]) {
                [controller performSelector:@selector(sel) withObject:info afterDelay:0.01];
            }
            break;
        }
    }
    [self popController:controllerstr];
}
 */
/**
 *	根据文字计算Label高度
 *
 *	@param	_width	限制宽度
 *	@param	_font	字体
 *	@param	_text	文字内容
 *
 *	@return	Label高度
 */
- (CGFloat)heightForLabel:(CGFloat)_width font:(UIFont*)_font text:(NSString*)_text
{
    if (!self.sizeLabel) {
        self.sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.sizeLabel.numberOfLines = 0;
    }
   // self.sizeLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    self.sizeLabel.font = _font;
    if (_text) {
        self.sizeLabel.text = _text;
        return [self.sizeLabel sizeThatFits:CGSizeMake(_width, MAXFLOAT)].height;
    }else{
        return 0;
    }
}
#pragma mark - Actions
- (IBAction)backByButtonTagNavClicked:(UIButton*)sender
{
    NSArray *controllers = [(UITabBarController*)[(UIWindow*)[[UIApplication sharedApplication] windows][0] rootViewController] viewControllers];
    if (controllers.count>sender.tag) {
        [controllers[sender.tag] popViewControllerAnimated:YES];
    }else{
        DLog(@"Nav Not Found.");
    }
}
- (IBAction)backButtonClicked:(id)sender
{
   // [SVProgressHUD dismiss];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        //[self dismissModalViewControllerAnimated:YES];
    }
}
- (IBAction)rootButtonClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -Notify
-(void) reachabilityChanged:(NSNotification*) notification
{
    if ([(Reachability*)[notification object] currentReachabilityStatus] == ReachableViaWiFi) {
        NSLog(@"baseview  net changes.");
        //do some refresh
    }
}
- (void)dealloc
{
}
#pragma mark - public

/*
- (void)UITableViewModel:(Block)block
{
    [self setDelegates];
    _model = [[NITableViewModel alloc] initWithListArray:block(_actions,nil)
                                                delegate:(id)[NICellFactory class]];
    self.tableView.dataSource = _model;
}
- (void)RHTableViewUrl:(NSString*)url withModel:(Block)block
{
    [self setDelegates];
    self.tableView.dataSource = nil;
    [self RHTableViewWithRefresh:YES withLoadmore:YES withMask:SVProgressHUDMaskTypeClear Url:url withParam:nil data:nil offline:nil loaded:^(NSArray *array, BOOL cache) {
        _model = [[NITableViewModel alloc] initWithListArray:block(_actions,array)
                                                    delegate:(id)[NICellFactory class]];
        self.tableView.dataSource = _model;
    }];
}
- (void)RHTableViewBlock:(RHTableDataBlock)datablock withModel:(Block)block
{
    [self setDelegates];
    self.tableView.dataSource = nil;
    [self RHTableViewWithRefresh:YES withLoadmore:YES withMask:SVProgressHUDMaskTypeClear Url:nil withParam:nil data:datablock offline:nil loaded:^(NSArray *array, BOOL cache) {
        _model = [[NITableViewModel alloc] initWithListArray:block(_actions,array)
                                                    delegate:(id)[NICellFactory class]];
        self.tableView.dataSource = _model;
    }];
}*/
@end
