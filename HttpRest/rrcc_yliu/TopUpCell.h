//
//  TopUpCell.h
//  rrcc_yh
//
//  Created by user on 15/12/21.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopUpCell : UITableViewCell

- (void)updateUIWithModel:(TopUpModel *)model complete:(void (^) (BOOL isSelected))completeCB;

- (IBAction)selectedButtonAction:(id)sender;

@end
