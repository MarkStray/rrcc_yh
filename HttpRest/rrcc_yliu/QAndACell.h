//
//  QAndACell.h
//  rrcc_yh
//
//  Created by user on 15/10/23.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAndACell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *qLabel;
@property (weak, nonatomic) IBOutlet UILabel *aLabel;

- (CGFloat)updateUIUsingModel:(QAModel *)model;


@end
