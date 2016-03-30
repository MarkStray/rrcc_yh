//
//  MineCell.h
//  rrcc_yh
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCell : UITableViewCell

- (void)updateUIUsingImage:(NSString *)imageN
            lineViewHidden:(BOOL)hidden
                     title:(NSString *)title
                    detail:(NSString *)detail
                     color:(UIColor *)detailColor;

@end
