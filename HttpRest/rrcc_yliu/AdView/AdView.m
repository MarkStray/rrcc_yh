//
//  AdView.m
//  广告循环滚动效果
//
//  Created by QzydeMac on 14/12/24.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//

//
//  AdScrollView.m
//  广告循环滚动效果
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//

#import "AdView.h"
//#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"
//广告的宽度
#define kAdViewWidth  _adScrollView.bounds.size.width
//广告的高度
#define kAdViewHeight  _adScrollView.bounds.size.height
 //由于_pageControl是添加进父视图的,所以实际位置要参考,滚动视图的y坐标
#define HIGHT _adScrollView.bounds.origin.y



static NSUInteger centerImageIndex;//记录中间图片的下标,开始总是为1
static NSUInteger leftImageIndex;
static NSUInteger rightImageIndex;

@interface AdView ()
{
    //广告的label
//    UILabel * _adLabel;
    //循环滚动的三个视图
    UIImageView * _leftImageView;
    UIImageView * _centerImageView;
    UIImageView * _rightImageView;
    //循环滚动的周期时间
    
    //用于确定滚动式由人导致的还是计时器到了,系统帮我们滚动的,YES,则为系统滚动,NO则为客户滚动(ps.在客户端中客户滚动一个广告后,这个广告的计时器要归0并重新计时)
    BOOL _isTimeUp;
    //为每一个图片添加一个广告语(可选)
//    UILabel * _leftAdLabel;
    
//    UILabel * _rightAdLabel;
    
    NSInteger _currentPage;
    
}

@property (retain,nonatomic,readonly) UIImageView * leftImageView;
@property (retain,nonatomic,readonly) UIImageView * centerImageView;
@property (retain,nonatomic,readonly) UIImageView * rightImageView;
@end

@implementation AdView

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"currentPage" context:NULL];
}

#pragma mark - 自由指定广告所占的frame
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //默认滚动式3.0s
        _adMoveTime = 3.0;
        _adScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _adScrollView.bounces = NO;
        _adScrollView.showsHorizontalScrollIndicator = NO;
        _adScrollView.showsVerticalScrollIndicator = NO;
        _adScrollView.pagingEnabled = YES;
        _adScrollView.contentOffset = CGPointMake(kAdViewWidth, 0);
        _adScrollView.contentSize = CGSizeMake(kAdViewWidth * 3, kAdViewHeight);
        _adScrollView.delegate = self;
        //该句是否执行会影响pageControl的位置,如果该应用上面有导航栏,就是用该句,否则注释掉即可
        _adScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAdViewWidth, kAdViewHeight)];
        [_adScrollView addSubview:_leftImageView];
        
        
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAdViewWidth, 0, kAdViewWidth, kAdViewHeight)];
        _centerImageView.userInteractionEnabled = YES;
        
        [_centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];

        [_adScrollView addSubview:_centerImageView];
        
        
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAdViewWidth*2, 0, kAdViewWidth, kAdViewHeight)];
        [_adScrollView addSubview:_rightImageView];
        
//        _leftImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _leftImageView.clipsToBounds = YES;
//        
//        _centerImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        _centerImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _centerImageView.clipsToBounds = YES;
//        
//        _rightImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _rightImageView.clipsToBounds = YES;
//        
//        _adScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        _adScrollView.contentMode = UIViewContentModeScaleAspectFill;
//        _adScrollView.clipsToBounds = YES;

        [self addObserver:self forKeyPath:@"currentPage" options:NSKeyValueObservingOptionNew context:NULL];
        
        _adScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_adScrollView];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentPage"]) {
        if (_showPageNO) {
            _showPageNO(_currentPage);
        }
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.moveTimer = [NSTimer scheduledTimerWithTimeInterval:_adMoveTime target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
    _isTimeUp = NO;
}

+ (id)adScrollViewWithFrame:(CGRect)frame imageLinkURL:(NSArray *)imageLinkURL pageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
{
    AdView * adView = [[AdView alloc]initWithFrame:frame];
    [adView setimageLinkURL:imageLinkURL];
    [adView setPageControlShowStyle:PageControlShowStyle];
    
    return adView;
}

#pragma mark - 设置广告所使用的图片(名字)
- (void)setimageLinkURL:(NSArray *)imageLinkURL
{
    _imageLinkURL = imageLinkURL;
    
    if (_imageLinkURL.count == 0) {
        return ;
    } else if (_imageLinkURL.count == 1){
        leftImageIndex = 0;
        centerImageIndex = 0;
        rightImageIndex = 0;
    } else {
        leftImageIndex = imageLinkURL.count-1;
        centerImageIndex = 0;
        rightImageIndex = 1;
    }
    
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[[imageLinkURL[leftImageIndex] objectForKey:@"img_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:[[imageLinkURL[centerImageIndex] objectForKey:@"img_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[[imageLinkURL[rightImageIndex] objectForKey:@"img_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
//    [_leftImageView setImageWithURL:[NSURL URLWithString:imageLinkURL[leftImageIndex]]];
//    [_centerImageView setImageWithURL:[NSURL URLWithString:imageLinkURL[centerImageIndex]]];
//    [_rightImageView setImageWithURL:[NSURL URLWithString:imageLinkURL[rightImageIndex]]];
}

#pragma mark - 设置每个对应广告对应的广告语
- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle
{
    _adTitleArray = adTitleArray;
    
    if(adTitleStyle == AdTitleShowStyleNone)
    {
        return;
    }
    
    //上面的灰色遮罩
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, kAdViewHeight - 30, kAdViewWidth, 30)];
    vv.backgroundColor = [UIColor blackColor];
    vv.alpha = 0.3;
    [self addSubview:vv];
    
    [self bringSubviewToFront:_pageControl];
    //上面的标题
    _centerAdLabel = [[UILabel alloc]init];
    _centerAdLabel.backgroundColor = [UIColor clearColor];
    _centerAdLabel.frame = CGRectMake(0, kAdViewHeight - 30, kAdViewWidth-20, 30);
    _centerAdLabel.textColor = [UIColor lightGrayColor];
    _centerAdLabel.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_centerAdLabel];
    
    if (adTitleStyle == AdTitleShowStyleLeft) {
        _centerAdLabel.textAlignment = NSTextAlignmentLeft;
    }
    else if (adTitleStyle == AdTitleShowStyleCenter)
    {
        _centerAdLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        _centerAdLabel.textAlignment = NSTextAlignmentRight;
    }
    
    _centerAdLabel.text = _adTitleArray[centerImageIndex];
}


#pragma mark - 创建pageControl,指定其显示样式
- (void)setPageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
{
    if (PageControlShowStyle == UIPageControlShowStyleNone) {
        return;
    }
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = _imageLinkURL.count;
    
    if (PageControlShowStyle == UIPageControlShowStyleLeft)
    {
        _pageControl.frame = CGRectMake(0, kAdViewHeight - 20, 20*_pageControl.numberOfPages, 20);
        
    }
    else if (PageControlShowStyle == UIPageControlShowStyleCenter)
    {
        _pageControl.frame = CGRectMake(0, 0, 20*_pageControl.numberOfPages, 20);
        _pageControl.center = CGPointMake(kAdViewWidth/2.0, kAdViewHeight - 15);
    }
    else
    {
        _pageControl.frame = CGRectMake( kAdViewWidth - 20*_pageControl.numberOfPages, kAdViewHeight - 20, 20*_pageControl.numberOfPages, 20);
    }
    _pageControl.currentPage = 0;
    
    _pageControl.enabled = NO;
    [self addSubview:_pageControl];
}

#pragma mark - 计时器到时,系统滚动图片
- (void)animalMoveImage
{
    // 广告页数量少于2 的时候不让其滚动
    if (_imageLinkURL.count < 2) {
        _adScrollView.scrollEnabled = NO;
        //[self.moveTimer setFireDate:[NSDate distantFuture]];
        
    } else {
        [_adScrollView setContentOffset:CGPointMake(kAdViewWidth * 2, 0) animated:YES];
        _isTimeUp = YES;
        
        _adScrollView.scrollEnabled = YES;
        //[self.moveTimer setFireDate:[NSDate distantPast]];

        //[self scrollViewDidEndDecelerating:_adScrollView];
        // 对应 刷新 pageControl
        [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
    }

}

#pragma mark - 图片停止时,调用该函数使得滚动视图复用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (_adScrollView.contentOffset.x == 0) {
        centerImageIndex = centerImageIndex - 1;
        leftImageIndex = leftImageIndex - 1;
        rightImageIndex = rightImageIndex - 1;
        
        if (leftImageIndex == -1) {
            leftImageIndex = _imageLinkURL.count-1;
        }
        if (centerImageIndex == -1)
        {
            centerImageIndex = _imageLinkURL.count-1;
        }
        if (rightImageIndex == -1)
        {
            rightImageIndex = _imageLinkURL.count-1;
        }
    } else if (_adScrollView.contentOffset.x == kAdViewWidth * 2) {
        centerImageIndex = centerImageIndex + 1;//1
        leftImageIndex = leftImageIndex + 1;//3 -->0
        rightImageIndex = rightImageIndex + 1;//2
        
        if (leftImageIndex == _imageLinkURL.count) {
            leftImageIndex = 0;
        }
        if (centerImageIndex == _imageLinkURL.count)
        {
            centerImageIndex = 0;
        }
        if (rightImageIndex == _imageLinkURL.count)
        {
            rightImageIndex = 0;
        }
    } else {
        return;
    }
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[[_imageLinkURL[leftImageIndex] objectForKey:@"img_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:[[_imageLinkURL[centerImageIndex] objectForKey:@"img_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[[_imageLinkURL[rightImageIndex] objectForKey:@"img_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
//    [_leftImageView setImageWithURL:[NSURL URLWithString:_imageLinkURL[leftImageIndex]]];
//    
//    [_centerImageView setImageWithURL:[NSURL URLWithString:_imageLinkURL[centerImageIndex]]];
//    
//    [_rightImageView setImageWithURL:[NSURL URLWithString:_imageLinkURL[rightImageIndex]]];
    
    //_pageControl.currentPage = centerImageIndex;
    
    [self willChangeValueForKey:@"currentPage"];
    _currentPage = centerImageIndex;
    [self didChangeValueForKey:@"currentPage"];

    //有时候只有在右广告标签的时候才需要加载
    if (_adTitleArray)
    {
        if (centerImageIndex<=_adTitleArray.count-1) {
            _centerAdLabel.text = _adTitleArray[centerImageIndex];
        }
    }
    _adScrollView.contentOffset = CGPointMake(kAdViewWidth, 0);
    
    //手动控制图片滚动应该取消那个三秒的计时器
    if (!_isTimeUp) {
        [self.moveTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_adMoveTime]];
    }
    _isTimeUp = NO;
}

/**
 *  @author ZY, 15-04-26
 *
 *  @brief  当前显示的图片被点击
 */
-(void)tap
{
    if (_callBack) {
        _callBack(centerImageIndex,_imageLinkURL[centerImageIndex]);
    }
}

@end
