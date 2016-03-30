

#import "XHBaseViewController.h"



@interface XHBaseViewController () <MBProgressHUDDelegate>
{
    MBProgressHUD *_indicatorHUD;
}
@property (nonatomic, copy) XHBarButtonItemActionBlock barbuttonItemAction;
@property (nonatomic, copy) XHBarButtonItemActionBlock backbuttonItemAction;

@property (nonatomic, strong) UIView *loadingView;// 加载视图
@property (nonatomic, strong) UIImageView *gifImageView;
@property (nonatomic, strong) UIView *translucentView;// 半透明视图

@end

@implementation XHBaseViewController

- (void)clickedBarButtonItemAction {
    if (self.barbuttonItemAction) {
        self.barbuttonItemAction();
    }
}

#pragma mark - Public Method

- (void)configureBarbuttonItemStyle:(XHBarbuttonItemStyle)style action:(XHBarButtonItemActionBlock)action {
    switch (style) {
        case XHBarbuttonItemStyleSetting: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonicon_set"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        case XHBarbuttonItemStyleMore: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonicon_more"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        case XHBarbuttonItemStyleCamera: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"album_add_photo"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        case XHBarbuttonItemStyleAdd: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
            
        default:
            break;
    }
    self.barbuttonItemAction = action;
}

- (void)configureBackBarbuttonAction:(XHBarButtonItemActionBlock)action {
    UIButton *barBtn = [Tools_Utils createBackButton];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:barBtn];
    self.navigationItem.leftBarButtonItem = barItem;
    [barBtn addTarget:self action:@selector(clickedBackButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.backbuttonItemAction = action;
}

- (void)clickedBackButtonItemAction
{
    if (self.barbuttonItemAction) {
        self.barbuttonItemAction();
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setupBackgroundImage:(UIImage *)backgroundImage {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
}

- (void)pushNewViewController:(UIViewController *)newViewController
{
    [self.navigationController pushViewController:newViewController animated:YES];
}



- (void)pushReplaceViewController:(UIViewController *)newViewController {
    NSArray *arr = self.navigationController.viewControllers;
    
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:arr];
    
    NSInteger nn = arr.count;
    
    mArr[nn-1] = newViewController;
    
    [self.navigationController setViewControllers:[NSArray arrayWithArray:mArr]];
    
//    [self.navigationController pushViewController:newViewController animated:YES];
}
- (void)pushRootViewController:(UIViewController *)newViewController {
    NSArray *arr = self.navigationController.viewControllers;
    
    NSMutableArray *mArr = [NSMutableArray arrayWithObjects:arr[0],newViewController,nil];
    
    [self.navigationController setViewControllers:[NSArray arrayWithArray:mArr]];
    
    //    [self.navigationController pushViewController:newViewController animated:YES];
}


#pragma mark - pop view

- (UIView *)translucentView {
    if (!_translucentView) {
        _translucentView = [[UIView alloc] initWithFrame:self.view.bounds];
        _translucentView.backgroundColor = [UIColor blackColor];
        _translucentView.alpha = 0.5;
    }
    return _translucentView;
}

- (void) popTipView:(UIView *)aView {
    //[self.view insertSubview:self.translucentView atIndex:1000];
    //[self.view insertSubview:aView atIndex:1001];
    [self.view addSubview:self.translucentView];
    [self.view addSubview:aView];
}

- (void) pushTipView:(UIView *)aView {
    [aView removeFromSuperview];
    [self.translucentView removeFromSuperview];
}

#pragma mark - Loading & hud

//- (UIView *)loadingView {
//    if (!_loadingView) {
//        _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
//        _loadingView.backgroundColor = BACKGROUND_COLOR;
//        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
//        webView.center = self.view.center;
//        webView.backgroundColor = BACKGROUND_COLOR;
//        webView.userInteractionEnabled = NO;
//        webView.scrollView.scrollEnabled = NO;
//        webView.opaque = NO;// 使网页透明
//        //webView.delegate = self;
//        //webView.scalesPageToFit = YES;
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
//        NSString *html = @"<html><head><body><img src=\"loading.gif\"><body></head></html>";
//        NSURL *baseURL = [NSURL fileURLWithPath:path];
//        [webView loadHTMLString:html baseURL:baseURL];
//        
//        //NSData *gif = [NSData dataWithContentsOfFile:path];
//        //[webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//        [_loadingView addSubview:webView];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(webView.left+10, webView.bottom-10, 160, 20)];
//        label.text = @"数据正在加载中...";
//        label.font = [UIFont systemFontOfSize:14];
//        label.textColor = [UIColor lightGrayColor];
//        label.backgroundColor = [UIColor clearColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        [_loadingView addSubview:label];
//    }
//    return _loadingView;
//}

- (UIView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        _loadingView.backgroundColor = BACKGROUND_COLOR;
        
        _gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        _gifImageView.center = self.view.center;
        NSArray *gifArray = [NSArray arrayWithObjects:
                             [UIImage imageNamed:@"loading1.jpg"],
                             [UIImage imageNamed:@"loading2.jpg"],nil];
        _gifImageView.animationImages = gifArray; //动画图片数组
        _gifImageView.animationDuration = 0.5; //执行一次完整动画所需的时长
        _gifImageView.animationRepeatCount = 999;  //动画重复次数
        [_loadingView addSubview:_gifImageView];
        
        UILabel *label = [ZZFactory labelWithFrame:CGRectMake(_gifImageView.left, _gifImageView.bottom-10, 150, 20) font:[UIFont systemFontOfSize:14] color:[UIColor lightGrayColor] text:@"数据正在加载中..."];
        //label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [_loadingView addSubview:label];
    }
    return _loadingView;
}


///////////////////////////////-GIF-//////////////////////////

- (void)showLoadingGIF {
    [self.view addSubview:self.loadingView];
    [self.gifImageView startAnimating];

}

- (void)hideLoadingGIF {
    [self.loadingView removeFromSuperview];
    [self.gifImageView stopAnimating];
}

/**
 *  显示加载的菊花
 */

- (void)showLoadingIndicator {
    [self showLoadingIndicatorWithText:nil];
}

- (void)showLoadingIndicatorWithText:(NSString *)text {
    if (_indicatorHUD) {
        _indicatorHUD.delegate = self;
        _indicatorHUD.labelText = text;//加载时候显示的文本
        
        [[UIApplication sharedApplication].keyWindow addSubview:_indicatorHUD];
        [_indicatorHUD show:YES];
    }
}

- (void)hideLoadingIndicator {
    if (_indicatorHUD) {
        [_indicatorHUD hide:YES];
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    _indicatorHUD.delegate = nil;
    [_indicatorHUD removeFromSuperview];
    _indicatorHUD = nil;
}



///////////////////////////////-HUD-//////////////////////////

- (void)showHUDWithText:(NSString *)text {
    [self showHUDWithText:text onView:self.view];
}


- (void)showSuccessHUDWithText:(NSString *)text {
    [self showSuccessHUDWithText:text onView:self.view];
}

- (void)showErrorHUDWithText:(NSString *)text {
    [self showErrorHUDWithText:text onView:self.view];
}

/** costom view */
- (void)showHUDWithText:(NSString *)text onView:(UIView *)aView {
    MBProgressHUD *_HUD = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    _HUD.mode = MBProgressHUDModeText;
    _HUD.labelText = text;
    _HUD.removeFromSuperViewOnHide = YES;
    [_HUD hide:YES afterDelay:1.5];
}

- (void)showSuccessHUDWithText:(NSString *)text onView:(UIView *)aView {
    MBProgressHUD *_HUD = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
    _HUD.labelText = text;
    _HUD.removeFromSuperViewOnHide = YES;
    [_HUD hide:YES afterDelay:1.5];
}

- (void)showErrorHUDWithText:(NSString *)text onView:(UIView *)aView {
    MBProgressHUD *_HUD = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"failed"]];
    _HUD.labelText = text;
    _HUD.removeFromSuperViewOnHide = YES;
    [_HUD hide:YES afterDelay:1.5];
}

- (void)hideHUD {
    
}


#pragma mark - Life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    //self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;/**(0 64; 320 504)*/
    //self.edgesForExtendedLayout = UIRectEdgeBottom;/**(0 64; 320 504)*/
    //self.edgesForExtendedLayout = UIRectEdgeNone;/**(0 64; 320 455)*/
    //self.edgesForExtendedLayout = UIRectEdgeTop;/**(0 0; 320 519)*/
    //self.edgesForExtendedLayout = UIRectEdgeAll;/**(0 0; 320 568)*/
    //self.navigationController.navigationBar.translucent = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _indicatorHUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /**
     *  默认所有界面都隐藏 只有需要显示的界面 在显示的时候出现
     */
    [self hideCustomTabBar];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    NSLog(@"\n\n\n\n\n\n\n\n%f %f\n\n\n\n\n\n\n\n",kScreenHeight,kScreenWidth);
//    [BZ_Tools recursiveDescription:self.view];
//    NSLog(@"%d %@",__LINE__,NSStringFromSelector(_cmd));
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideLoadingGIF];
    //[[DataEngine sharedInstance] cancleAllRequest];
}

/**
 *  显示底部的tabbar
 */
- (void)showCustomTabBar {
    NSArray *array = self.tabBarController.view.subviews;
    for (UIView *view in array) {
        if (view.tag == _tabbar_tag) {
            view.hidden = NO;
            return ;
        }
    }
}

/**
 *  隐藏底部的tabbar
 */
- (void)hideCustomTabBar {
    NSArray *array = self.tabBarController.view.subviews;
    for (UIView *view in array) {
        if (view.tag == _tabbar_tag) {
            view.hidden = YES;
            return ;
        }
    }
}

// 改变状态栏的前景色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View rotation

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

/////////////////////////--webViewDelegate--//////////////修改属性/////////////

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //            NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.2, user-scalable=yes\"", webView.frame.size.width];
    //        [webView stringByEvaluatingJavaScriptFromString:meta];
    //    @"function increaseMaxZoomFactor() {"
    //    "var element = document.createElement('meta');
    //    "element.name = \"viewport\";"
    //    "element.content = \"maximum-scale=10\";"
    //    "var head = document.getElementsByTagName('head')[0];"
    //    "head.appendChild(element);"
    //    "}"
    //    [webView stringByEvaluatingJavaScriptFromString:
    //     @"var script = document.createElement('script');"
    //     "script.type = 'text/javascript';"
    //     "script.text = \"function ResizeImages() { "
    //     "var myimg,oldwidth;"
    //     "var maxwidth = 300.0;" // UIWebView中显示的图片宽度
    //     "for(i=0;i <document.images.length;i++){"
    //     "myimg = document.images[i];"
    //     "if(myimg.width > maxwidth){"
    //     "oldwidth = myimg.width;"
    //     "myimg.width = maxwidth;"
    //     "}"
    //     "}"
    //     "}\";"
    //     "document.getElementsByTagName('head')[0].appendChild(script);"];
    //        [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    //NSString *js = @"window.onload = function(){ document.body.style.backgroundColor = '#f3f3f3'; }";
    
    //[webView stringByEvaluatingJavaScriptFromString:js];
}



@end
