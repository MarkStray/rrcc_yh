//
//  SalaryCell.h
//  rrcc_yh
//
//  Created by user on 15/9/20.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalaryCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *validLbl;
@property (weak, nonatomic) IBOutlet UILabel *reguLbl;
@property (weak, nonatomic) IBOutlet UILabel *deadLineLbl;

- (void)updateUIUsingModel:(RedPageModel *)model;

@end
