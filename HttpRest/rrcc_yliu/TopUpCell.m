//
//  TopUpCell.m
//  rrcc_yh
//
//  Created by user on 15/12/21.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "TopUpCell.h"

@implementation TopUpCell
{
    __weak IBOutlet UILabel *topUpLabel;
    
    __weak IBOutlet UILabel *preSentLabel;
    
    __weak IBOutlet UIButton *_selectedButton;
    
    void (^_completeCB) (BOOL isSelected);
    
}

- (void)awakeFromNib {
    
    topUpLabel.font = Font(16);
    preSentLabel.font = Font(16);
    
    [_selectedButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    [_selectedButton setImage:[UIImage imageNamed:@"UnSelected"] forState:UIControlStateNormal];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedButtonAction:)]];
}

- (void)updateUIWithModel:(TopUpModel *)model complete:(void (^) (BOOL isSelected))completeCB
{
    _completeCB = completeCB;
    
    topUpLabel.text = model.amount;
    preSentLabel.text = [NSString stringWithFormat:@"(充%@送%@)",model.amount,model.present];
    if ([model.present isEqualToString:@"0"] || model.present == nil) {
        preSentLabel.text = @"";
    }
    _selectedButton.selected = model.isSelected;
}

- (IBAction)selectedButtonAction:(id)sender
{
    if (_selectedButton.selected) return;
    if (_completeCB) _completeCB(!_selectedButton.selected);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
