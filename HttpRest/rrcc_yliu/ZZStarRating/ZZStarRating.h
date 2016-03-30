//
//  ZZStarRating.h
//  ZZStarRating
//


#import <UIKit/UIKit.h>

//@class ZZStarRating;
//
//@protocol StarRatingViewDelegate <NSObject>
//
//@optional
//-(void)starRatingView:(ZZStarRating *)view score:(float)score;
//
//@end

@interface ZZStarRating : UIControl {
    float _starLevel;
}

@property (nonatomic, assign) float starLevel;// 0.f - 1.f

//@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame backgroundImage:(NSString *)bgImg foregroundImage:(NSString *)fgImg maxRating:(NSInteger)maxRating isFractionEnabled:(BOOL)enabled;

@end
