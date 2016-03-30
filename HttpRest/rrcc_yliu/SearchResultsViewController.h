//
//  SearchResultsViewController.h
//  rrcc_yh
//
//  Created by user on 15/9/22.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "XHBaseViewController.h"

@interface SearchResultsViewController : XHBaseViewController

@property (nonatomic, strong) CityListModel *cityListmodel;

@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, strong) UISearchBar *addrSearchBar;

@property (nonatomic, copy) void (^updateSite) (SiteListModel *model);

- (void)startDownLoadSearchResultData;// switch method

@end
