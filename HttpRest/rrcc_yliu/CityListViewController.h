//
//  CityListViewController.h
//  rrcc_yh
//
//  Created by user on 15/6/12.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "XHBaseViewController.h"

@interface CityListViewController : XHBaseViewController

@property (nonatomic, copy) NSString *selectedCity;// 标记选中城市

@property (nonatomic, copy) void (^updateCity) (CityListModel *model);

- (void)startDownLoadCityListData;// switch method

@end
