//
//  ZZFactory.m
//  rrcc_yh
//
//  Created by user on 15/10/8.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "ZZFactory.h"

@implementation ZZFactory

+ (UIView *)viewWithFrame:(CGRect)aframe color:(UIColor *)acolor {
    UIView *baseView = [[UIView alloc] initWithFrame:aframe];
    baseView.backgroundColor = acolor;
    return baseView;
}

+ (UILabel *)labelWithFrame:(CGRect)aframe font:(UIFont *)afont color:(UIColor *)acolor text:(NSString *)atext {
    UILabel *baseLabel = [[UILabel alloc] initWithFrame:aframe];
    if (afont) baseLabel.font = afont;
    if (acolor) baseLabel.textColor = acolor;
    baseLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    baseLabel.text = atext;
    baseLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    if(aframe.size.height > 20) {
        baseLabel.numberOfLines = 0;
    }
    if (!aframe.size.height) {
        baseLabel.numberOfLines=0;
        CGSize size = [baseLabel sizeThatFits:CGSizeMake(aframe.size.width, MAXFLOAT)];
        aframe.size.height = size.height;
        baseLabel.frame = aframe;
    }else if (!aframe.size.width) {
        CGSize size = [baseLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
        aframe.size.width = size.width;
        baseLabel.frame = aframe;
    }
    baseLabel.backgroundColor = [UIColor clearColor];
    baseLabel.highlightedTextColor = [UIColor whiteColor];
    return baseLabel;// autorelease];
}

+ (UIButton *)buttonWithFrame:(CGRect)aframe title:(NSString *)atitle titleColor:(UIColor *)atitleColor image:(NSString *)aImage bgImage:(NSString *)abgImage {
    UIButton *baseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[[UIButton alloc] initWithFrame:aframe];
    baseButton.frame = aframe;
    if (atitle) {
        [baseButton setTitle:atitle forState:UIControlStateNormal];
        [baseButton setTitleColor:atitleColor forState:UIControlStateNormal];
    }
    if (aImage) {
        [baseButton setImage:[UIImage imageNamed:aImage] forState:UIControlStateNormal];
    }
    if (abgImage) {
        UIImage *bg = [UIImage imageNamed:abgImage];
        [baseButton setBackgroundImage:bg forState:UIControlStateNormal];
        if (aframe.size.height<0.00001) {
            aframe.size.height = bg.size.height * aframe.size.width / bg.size.width;
            [baseButton setFrame:aframe];
        }else if(aframe.size.width<0.00001) {
            aframe.size.width = bg.size.width * aframe.size.height / bg.size.height;
            aframe.origin.x = (kScreenWidth-aframe.size.width)/2.0;
            [baseButton setFrame:aframe];
        }
    }
    return baseButton;// autorelease];
}

+ (UIImageView *)imageViewWithFrame:(CGRect)aframe defaultImage:(NSString *)aImage {
    return [self imageViewWithFrame:aframe image:aImage stretchW:0 stretchH:0];// autorelease];
}

//-1 if want stretch half of image.size
+ (UIImageView *)imageViewWithFrame:(CGRect)aframe image:(NSString *)aImage stretchW:(NSInteger)_w stretchH:(NSInteger)_h {
    UIImage *stretchImage = nil;
    UIImage *image = [UIImage imageNamed:aImage];
    if (_w && _h) {
        if (_w == -1) {
            _w = image.size.width/2;
        }
        if(_h == -1){
            _h = image.size.height/2;
        }
        stretchImage = [image stretchableImageWithLeftCapWidth:_w topCapHeight:_h];
    } else {
        stretchImage = image;
    }
    
    UIImageView *baseImageView = [[UIImageView alloc] initWithImage:stretchImage];

    if (CGRectIsEmpty(aframe)) {
        [baseImageView setFrame:CGRectMake(aframe.origin.x,aframe.origin.y, baseImageView.image.size.width, baseImageView.image.size.height)];
    }else{
        [baseImageView setFrame:aframe];
    }
    return  baseImageView;// autorelease];
}

+ (UITextField *)textFieldWithFrame:(CGRect)aframe font:(UIFont *)afont color:(UIColor *)acolor placeHolder:(NSString *)atext delegate:(id<UITextFieldDelegate>)delegate {
    UITextField *baseTextField = [[UITextField alloc] initWithFrame:aframe];
    baseTextField.borderStyle = UITextBorderStyleNone;
    if (afont) baseTextField.font = afont;
    if (acolor) baseTextField.textColor = acolor;
    if (atext) baseTextField.placeholder = atext;
    if (delegate) baseTextField.delegate = delegate;
    return baseTextField;// autorelease];
}

/////////////////////////-----include super view version----/////////////////////////////

+ (void)viewWithFrame:(CGRect)aframe color:(UIColor *)acolor superView:(UIView *)sview {
    UIView *baseView = [[UIView alloc] initWithFrame:aframe];
    baseView.backgroundColor = acolor;
    [sview addSubview:baseView];
}

+ (void)labelWithFrame:(CGRect)aframe font:(UIFont *)afont color:(UIColor *)acolor text:(NSString *)atext superView:(UIView *)sview {
    UILabel *baseLabel = [[UILabel alloc] initWithFrame:aframe];
    if (afont) baseLabel.font = afont;
    if (acolor) baseLabel.textColor = acolor;
    baseLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    baseLabel.text = atext;
    baseLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    if(aframe.size.height > 20) {
        baseLabel.numberOfLines = 0;
    }
    if (!aframe.size.height) {
        baseLabel.numberOfLines=0;
        CGSize size = [baseLabel sizeThatFits:CGSizeMake(aframe.size.width, MAXFLOAT)];
        aframe.size.height = size.height;
        baseLabel.frame = aframe;
    }else if (!aframe.size.width) {
        CGSize size = [baseLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
        aframe.size.width = size.width;
        baseLabel.frame = aframe;
    }
    baseLabel.backgroundColor = [UIColor clearColor];
    baseLabel.highlightedTextColor = [UIColor whiteColor];
    [sview addSubview:baseLabel];
}

+ (void)buttonWithFrame:(CGRect)aframe title:(NSString*)atitle titleColor:(UIColor *)atitleColor image:(NSString*)aImage bgImage:(NSString*)abgImage superView:(UIView *)sview {
    UIButton *baseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[[UIButton alloc] initWithFrame:aframe];
    baseButton.frame = aframe;
    if (atitle) {
        [baseButton setTitle:atitle forState:UIControlStateNormal];
        [baseButton setTitleColor:atitleColor forState:UIControlStateNormal];
    }
    if (aImage) {
        [baseButton setImage:[UIImage imageNamed:aImage] forState:UIControlStateNormal];
    }
    if (abgImage) {
        UIImage *bg = [UIImage imageNamed:abgImage];
        [baseButton setBackgroundImage:bg forState:UIControlStateNormal];
        if (aframe.size.height<0.00001) {
            aframe.size.height = bg.size.height * aframe.size.width / bg.size.width;
            [baseButton setFrame:aframe];
        }else if(aframe.size.width<0.00001) {
            aframe.size.width = bg.size.width * aframe.size.height / bg.size.height;
            aframe.origin.x = (kScreenWidth-aframe.size.width)/2.0;
            [baseButton setFrame:aframe];
        }
    }
    [sview addSubview:baseButton];
}

+ (void)imageViewWithFrame:(CGRect)aframe defaultImage:(NSString *)aImage superView:(UIView *)sview {
    UIImageView *baseImageView = [self imageViewWithFrame:aframe image:aImage stretchW:0 stretchH:0];
    [sview addSubview:baseImageView];
}

+ (void)imageViewWithFrame:(CGRect)aframe image:(NSString *)aImage stretchW:(NSInteger)_w stretchH:(NSInteger)_h superView:(UIView *)sview {
    UIImage *stretchImage = nil;
    UIImage *image = [UIImage imageNamed:aImage];
    if (_w && _h) {
        if (_w == -1) {
            _w = image.size.width/2;
        }
        if(_h == -1){
            _h = image.size.height/2;
        }
        stretchImage = [image stretchableImageWithLeftCapWidth:_w topCapHeight:_h];
    } else {
        stretchImage = image;
    }
    
    UIImageView *baseImageView = [[UIImageView alloc] initWithImage:stretchImage];
    
    if (CGRectIsEmpty(aframe)) {
        [baseImageView setFrame:CGRectMake(aframe.origin.x,aframe.origin.y, baseImageView.image.size.width, baseImageView.image.size.height)];
    }else{
        [baseImageView setFrame:aframe];
    }
    [sview addSubview:baseImageView];
}

+ (void)textFieldWithFrame:(CGRect)aframe font:(UIFont *)afont color:(UIColor *)acolor placeHolder:(NSString *)atext delegate:(id<UITextFieldDelegate>)delegate superView:(UIView *)sview {
    UITextField *baseTextField = [[UITextField alloc] initWithFrame:aframe];
    baseTextField.borderStyle = UITextBorderStyleNone;
    if (afont) baseTextField.font = afont;
    if (acolor) baseTextField.textColor = acolor;
    if (atext) baseTextField.placeholder = atext;
    if (delegate) baseTextField.delegate = delegate;
    [sview addSubview:baseTextField];
}





@end
