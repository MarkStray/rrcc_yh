//
//  viewCategory.h
//  cloud
//
//  Created by jack ray on 11-4-16.
//  Copyright 2011年 oulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView(Addition)

@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

// Setting these modifies the origin but not the size.
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

-(BOOL) containsSubView:(UIView *)subView;
//-(BOOL) containsSubViewOfClassType:(Class)class;


-(void)roundCorner;
-(void)rotateViewStart;
-(void)rotateViewStop;
-(void)addSubviews:(UIView *)view,...;

//for UIImageView & UIButton.backgroudImage
-(void)imageWithURL:(NSString *)url;
-(void)imageWithURL:(NSString *)url useProgress:(BOOL)useProgress useActivity:(BOOL)useActivity;

//设置边框弧度，宽度，颜色
- (void)SetBorderWithcornerRadius:(CGFloat)radius BorderWith:(CGFloat)width AndBorderColor:(UIColor *)color;

// [UIColor clearColor] 清空背景  .n.g  //取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
