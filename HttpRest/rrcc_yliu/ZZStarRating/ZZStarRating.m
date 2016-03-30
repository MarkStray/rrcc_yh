//
//  ZZStarRating.m
//  ZZStarRating
//


#import "ZZStarRating.h"

// config default
static const NSInteger DefaultMaxRating = 5;
static const BOOL DefaultFractionEnabled = YES;
static  NSString * const DefaultBackgroundImageName = @"backgroundStar";
static  NSString * const DefaultForegroundImageName = @"foregroundStar";

@interface ZZStarRating ()

@property (nonatomic, assign) NSInteger MAXRating;
@property (nonatomic, assign) BOOL isFractionEnabled;

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation ZZStarRating

// override
- (void)setStarLevel:(float)starLevel {
    if (self.isFractionEnabled) {
        self.starForegroundView.frame = CGRectMake(0, 0, self.frame.size.width * starLevel, self.frame.size.height);
        _starLevel = starLevel;
    }else {// the whole star
        NSInteger stars = (NSInteger)(starLevel * self.MAXRating+0.99999999);
        self.starForegroundView.frame = CGRectMake(0, 0, self.frame.size.width * stars/self.MAXRating, self.frame.size.height);
        _starLevel = stars;
    }
}
#pragma mark - init

- (id)initWithFrame:(CGRect)frame {// default
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInitBackgroundImage:DefaultBackgroundImageName foregroundImage:DefaultForegroundImageName maxRating:DefaultMaxRating isFractionEnabled:DefaultFractionEnabled];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame backgroundImage:(NSString *)bgImg foregroundImage:(NSString *)fgImg maxRating:(NSInteger)maxRating isFractionEnabled:(BOOL)enabled{// custom
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInitBackgroundImage:bgImg foregroundImage:fgImg maxRating:maxRating isFractionEnabled:enabled];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {// load xib
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userInteractionEnabled = NO;
        [self baseInitBackgroundImage:DefaultBackgroundImageName foregroundImage:DefaultForegroundImageName maxRating:DefaultMaxRating isFractionEnabled:DefaultFractionEnabled];
    }
    return self;
}

- (void)baseInitBackgroundImage:(NSString *)bgImg foregroundImage:(NSString *)fgImg maxRating:(NSInteger)maxRating isFractionEnabled:(BOOL)enabled{
    self.MAXRating = maxRating;
    self.isFractionEnabled = enabled;
    if (bgImg == nil) bgImg = DefaultBackgroundImageName;
    if (fgImg == nil) fgImg = DefaultForegroundImageName;
    if (maxRating == 0) maxRating = DefaultMaxRating;
    self.starBackgroundView = [self buildStarViewWithImageName:bgImg];
    self.starForegroundView = [self buildStarViewWithImageName:fgImg];
    [self addSubview:self.starBackgroundView];
    [self addSubview:self.starForegroundView];
    [self setStarLevel:0.f];// init foreground
}
- (UIView *)buildStarViewWithImageName:(NSString *)imageName {
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.userInteractionEnabled = NO;
    view.clipsToBounds = YES;
    for (int i = 0; i < self.MAXRating; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * frame.size.width / self.MAXRating, 0, frame.size.width / self.MAXRating, frame.size.height);
        [view addSubview:imageView];
    }
    return view;
}

#pragma mark - UIControl

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    [self changeStarForegroundViewWithTouch:touch];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    [self changeStarForegroundViewWithTouch:touch];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    [self changeStarForegroundViewWithTouch:touch];

}
- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self changeStarForegroundViewWithTouch:[touches anyObject]];
//}
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self changeStarForegroundViewWithTouch:[touches anyObject]];
//}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [UIView transitionWithView:self.starForegroundView duration:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [self changeStarForegroundViewWithTouch:[touches anyObject]];
//    } completion:nil];
//}
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self changeStarForegroundViewWithTouch:[touches anyObject]];
//}

- (void)changeStarForegroundViewWithTouch:(UITouch *)touch {
    
    CGPoint point = [touch locationInView:self];
    
    if (point.x < 0) point.x = 0;
    if (point.x > self.frame.size.width) point.x = self.frame.size.width;
    
    float rating = point.x / self.frame.size.width;
    [self setStarLevel:rating];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
//    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
//    {
//        [self.delegate starRatingView:self score:score];
//    }
}



@end
