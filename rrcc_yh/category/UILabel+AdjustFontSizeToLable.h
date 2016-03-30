//
//  UILabel+AdjustFontSizeToLable.h
//  AdjustFontLable
//
//  Created by qianfeng on 14-8-21.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (AdjustFontSizeToLable)
//lable自适应字体
- (void)AdjustCurrentFont;
- (void)AdjustWithFont:(UIFont *)font;

//开启并设置自适应模式
-(void)AdjustFontSizeWithMinSize:(CGFloat) min AndMaxSize:(CGFloat) max IsFull:(BOOL)isfull;

//Lable自适应内容，可设置间距
- (void)AdjustCurrentAttributeTextWithLineSpacing:(NSInteger)space;
@end
