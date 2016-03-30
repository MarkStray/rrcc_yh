//
//  UIView+HL.m
//  HLPrivateCustom
//
//  Created by TheMoon on 15/12/7.
//  Copyright (c) 2015年 zangyunzhu. All rights reserved.
//

#import "UIView+HL.h"

@implementation UIView (HL)
#pragma mark - 计算label高度
+ (CGFloat)heightForLabelStr:(NSString *)text fontSize:(CGFloat )fontSize fitWidth:(CGFloat)width{
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    lbl.numberOfLines = 0;
    lbl.text = text;
    lbl.font = [UIFont systemFontOfSize:fontSize];
    
    CGFloat height = [lbl sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
    
    // 最小height为21
    return height > 21 ? height : 21;
}

#pragma mark - 计算高度
+ (CGFloat) heightForTextViewStr:(NSString *)tStr width:(CGFloat)tWidth fontSize:(CGFloat)tSize {
    
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, tWidth, 0)];
    detailTextView.font = [UIFont systemFontOfSize:tSize];
    detailTextView.text = tStr;
    
    NSMutableParagraphStyle *paragraphStyle =
    [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 3; //行距
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle};
    
    detailTextView.attributedText =
    [[NSAttributedString
      alloc]initWithString: detailTextView.text
     attributes:attributes];
    
    CGSize bestSize = [detailTextView sizeThatFits:CGSizeMake(tWidth,CGFLOAT_MAX)];
    
    return bestSize.height;
}
@end
