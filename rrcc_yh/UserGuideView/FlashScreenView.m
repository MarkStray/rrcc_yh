//
//  FlashScreenView.m
//  MyStyle
//
//  Created by kangylk on 14-12-30.
//  Copyright (c) 2014年 Huuhoo. All rights reserved.
//
#import "FlashScreenView.h"

#define imageNum 3

@interface FlashScreenView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIViewController *rootViewController;

@end


@implementation FlashScreenView

- (BOOL)isShowedFlashScreen
{
    NSUserDefaults *sd = [NSUserDefaults standardUserDefaults];
    BOOL bb = [sd boolForKey:@"flashscreen"];
    [sd setBool:YES forKey:@"flashscreen"];
    [sd synchronize];
    return bb;
}

- (instancetype)initWithRootViewController:(UIViewController *)aViewController {
    self = [super init];
    self.rootViewController = aViewController;
    if ([self isShowedFlashScreen]) return (id)self.rootViewController;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        for (int i = 0; i < imageNum; i++) {
            CGRect imgRect = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight);
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:imgRect];
            NSString *imgPath = [NSString stringWithFormat:@"flashscreen-%d.jpg",i+1];
            //imgPath = [[NSBundle mainBundle] pathForResource:imgPath ofType:@"jpg"];
            //UIImage *img = [[UIImage alloc] initWithContentsOfFile:imgPath];
            UIImage *img = [UIImage imageNamed:imgPath];
            imgView.image = img;
            imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
            [_scrollView addSubview:imgView];

            if (i == imageNum-1) {
                UIButton *btn = [ZZFactory buttonWithFrame:CGRectMake(kScreenWidth*i+16, kScreenHeight-100*autoSizeScaleY, kScreenWidth-16*2, 40) title:nil titleColor:nil image:nil bgImage:@"flashscreen"];
                [btn addTarget:self action:@selector(setWindowRootViewController) forControlEvents:UIControlEventTouchUpInside];
                [_scrollView addSubview:btn];
            }
            
        }
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(kScreenWidth*imageNum, 1);
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight-50*autoSizeScaleY, kScreenWidth, 30)];
        _pageControl.numberOfPages = imageNum;
        _pageControl.currentPage = 0;
        //设置 小圆圈的颜色(未选中部分)
        _pageControl.pageIndicatorTintColor = BACKGROUND_COLOR;
        //设置选中 当前的小圆圈的颜色
        _pageControl.currentPageIndicatorTintColor = GLOBAL_COLOR;

    }
    return _pageControl;
}

- (void)setWindowRootViewController {
    AppDelegate *delegate = [AppDelegate Share];
    UIWindow *window = delegate.window;
    window.rootViewController = self.rootViewController;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint curPoint = scrollView.contentOffset;
    self.pageControl.currentPage = curPoint.x/kScreenWidth;
}


@end
