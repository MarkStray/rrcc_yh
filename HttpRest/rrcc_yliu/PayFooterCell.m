//
//  PayFooterCell.m
//  rrcc_yh
//
//  Created by user on 15/11/5.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "PayFooterCell.h"

@implementation PayFooterCell
{
    __weak IBOutlet UIView *bgView;
    __weak IBOutlet UITextView *placeHolderTextView;
    
    __weak IBOutlet UITextView *topTextView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ResignFirstResponder" object:nil];
}

- (void)awakeFromNib {
    topTextView.delegate = self;
    bgView.backgroundColor = BACKGROUND_COLOR;
    //[bgView SetBorderWithcornerRadius:5.f BorderWith:0.f AndBorderColor:nil];
    placeHolderTextView.backgroundColor = BACKGROUND_COLOR;
    topTextView.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ResignFirstResponder" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [topTextView resignFirstResponder];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (self.remarkBlock) self.remarkBlock(topTextView.text);
    }];

}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //if (self.remarkBlock) self.remarkBlock(textView.text);
    
    // 键盘定制
    if (![text isEqualToString:@""]) {
        topTextView.backgroundColor = BACKGROUND_COLOR;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        topTextView.backgroundColor = [UIColor clearColor];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.editingStatusBlock) self.editingStatusBlock(YES);
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.editingStatusBlock) self.editingStatusBlock(NO);
    return YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
