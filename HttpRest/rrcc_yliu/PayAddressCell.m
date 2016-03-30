//
//  PayAddressCell.m
//  rrcc_yh
//
//  Created by user on 16/1/6.
//  Copyright © 2016年 ting liu. All rights reserved.
//

#import "PayAddressCell.h"

@implementation PayAddressCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ResignFirstResponder" object:nil];
}

- (void)awakeFromNib {
    
    self.addressTextView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ResignFirstResponder" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.addressTextView resignFirstResponder];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (self.addressBlock) self.addressBlock(self.addressTextView.text);
    }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (![text isEqualToString:@""]) {
        self.addressTextView.backgroundColor = [UIColor whiteColor];
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.addressTextView.backgroundColor = [UIColor clearColor];
    }
    return YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
