//
//  ZZFactory.h
//  rrcc_yh
//
//  Created by user on 15/10/8.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZFactory : NSObject

+ (UIView *)viewWithFrame:(CGRect)aframe color:(UIColor *)acolor;
/**
 *	根据aframe返回相应高度的label（默认透明背景色，白色高亮文字）
 *
 *	@param	aframe	预期框架 若height=0则计算高度  若width=0则计算宽度
 *	@param	afont	字体
 *	@param	acolor	颜色
 *	@param	atext	内容
 *
 *	@return	UILabel
 */
+ (UILabel *)labelWithFrame:(CGRect)aframe font:(UIFont *)afont color:(UIColor *)acolor text:(NSString *)atext;

+ (UIButton *)buttonWithFrame:(CGRect)aframe title:(NSString *)atitle titleColor:(UIColor *)atitleColor image:(NSString *)aImage bgImage:(NSString *)abgImage;

// 0 ,0  signify nature
+ (UIImageView *)imageViewWithFrame:(CGRect)aframe defaultImage:(NSString *)aImage;

// -1 if want stretch half of image.size
+ (UIImageView *)imageViewWithFrame:(CGRect)aframe image:(NSString *)aImage stretchW:(NSInteger)_w stretchH:(NSInteger)_h;

+ (UITextField *)textFieldWithFrame:(CGRect)aframe font:(UIFont *)afont color:(UIColor *)acolor placeHolder:(NSString *)atext delegate:(id<UITextFieldDelegate>)delegate;


// -- superView version

+ (void)viewWithFrame:(CGRect)aframe color:(UIColor *)acolor superView:(UIView *)sview;

+ (void)labelWithFrame:(CGRect)aframe font:(UIFont *)afont color:(UIColor *)acolor text:(NSString *)atext superView:(UIView *)sview;

+ (void)buttonWithFrame:(CGRect)aframe title:(NSString*)atitle titleColor:(UIColor *)atitleColor image:(NSString*)aImage bgImage:(NSString*)abgImage superView:(UIView *)sview;

+ (void)imageViewWithFrame:(CGRect)aframe defaultImage:(NSString *)aImage superView:(UIView *)sview;

+ (void)imageViewWithFrame:(CGRect)aframe image:(NSString *)aImage stretchW:(NSInteger)_w stretchH:(NSInteger)_h superView:(UIView *)sview;

+ (void)textFieldWithFrame:(CGRect)aframe font:(UIFont *)afont color:(UIColor *)acolor placeHolder:(NSString *)atext delegate:(id<UITextFieldDelegate>)delegate superView:(UIView *)sview;

@end
