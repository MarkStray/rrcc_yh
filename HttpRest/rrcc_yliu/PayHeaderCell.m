//
//  PayHeaderCell.m
//  rrcc_yh
//
//  Created by user on 15/11/5.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "PayHeaderCell.h"

@implementation PayHeaderCell
{
    __weak IBOutlet UILabel *contactTitle;
    
    __weak IBOutlet UILabel *mobileTitle;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ResignFirstResponder" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)awakeFromNib {
//    contactTitle.font = Font(16);
//    mobileTitle.font = Font(16);
//    
//    self.takeTitleLabel.font = Font(16);
//    self.takeDetailLabel.font = Font(14);
//    
//    self.timeTitleLabel.font = Font(16);
//    self.timeDetailLabel.font = Font(14);
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ResignFirstResponder" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.contactTextField resignFirstResponder];
        [self.telTextField resignFirstResponder];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (self.contactBlock) self.contactBlock(self.contactTextField.text);
        if (self.mobileBlock) self.mobileBlock(self.telTextField.text);
    }];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
