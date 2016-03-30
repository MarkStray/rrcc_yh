//
//  PayTypeCell.m
//  rrcc_yh
//
//  Created by user on 15/11/5.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "PayTypeCell.h"

@implementation PayTypeCell
{
    __weak IBOutlet UIImageView *_logoImageView;
    
    __weak IBOutlet UILabel *_titleLabel;
    
    __weak IBOutlet UIView *_topUpView;// 充值
    __weak IBOutlet UILabel *_topUpLabel;//充值label

    __weak IBOutlet UIButton *_checkButton;
    
    __weak IBOutlet UIView *_lineView;
}

- (void)awakeFromNib {
    [_checkButton setImage:[UIImage imageNamed:@"UnSelected"] forState:UIControlStateNormal];
    [_checkButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    
    //_checkButton.enabled = NO;//不可行
    _checkButton.userInteractionEnabled = NO;//可行
    
    [_topUpView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goTopUp)]];
}

// 去充值
- (void)goTopUp {
    if (self.topUpAction) self.topUpAction();
}


- (void)showPayMethodWithModel:(PayMethodModel *)model {

    sd_image_url(_logoImageView, model.img);
 
    if (model.value.intValue == 4) {
        if (model.checkImgStatus.intValue == 1) {
            _topUpView.hidden = YES;
            NSString *balanceStr = [NSString stringWithFormat:@"%@ (%@元)",model.title ,model.balance];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:balanceStr];
            [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(5, balanceStr.length-5)];
            _titleLabel.attributedText = attrStr;

        } else {
            _topUpView.hidden = NO;
        }
    } else {
        _titleLabel.text = model.title;
        _topUpView.hidden = YES;
    }
    
    _checkButton.selected = model.checked.intValue==1 ?YES :NO;
    
    _lineView.hidden = model.lineHidden;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
