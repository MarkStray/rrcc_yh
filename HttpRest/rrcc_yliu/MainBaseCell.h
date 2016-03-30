//
//  MainBaseCell.h
//  rrcc_yh
//
//  Created by user on 15/9/24.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainBaseCell : UITableViewCell

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) void (^handleTypeCB) (ProductsModel *model);

- (void)updateUIUsingModel:(NSArray *)items complete:(void (^) (ProductsModel *model))handle;


@end
