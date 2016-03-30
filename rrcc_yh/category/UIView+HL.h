//
//  UIView+HL.h
//  HLPrivateCustom
//
//  Created by TheMoon on 15/12/7.
//  Copyright (c) 2015年 zangyunzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HL)
/**
 *  计算label高度
 *
 *  @param text   文字内容
 *  @param fontSize  文字大小
 *  @param width   最大宽度
 *
 *  @return
 */
+ (CGFloat)heightForLabelStr:(NSString *)text fontSize:(CGFloat )fontSize fitWidth:(CGFloat)width;

/**
 *  计算textView高度
 *
 *  @param text   文字内容
 *  @param fontSize  文字大小
 *  @param width   最大宽度
 *
 *  @return
 */

+ (CGFloat) heightForTextViewStr:(NSString *)tStr width:(CGFloat)tWidth fontSize:(CGFloat)tSize;
@end
