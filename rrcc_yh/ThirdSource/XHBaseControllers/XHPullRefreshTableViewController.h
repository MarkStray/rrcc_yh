

#import "XHBaseTableViewController.h"

@interface XHPullRefreshTableViewController : XHBaseTableViewController

@property (nonatomic, assign) BOOL isDataLoading;

@property (nonatomic, assign) NSInteger requestCurrentPage;
@property (nonatomic, assign) NSInteger requestCurrentPageSize;

- (void)startPullDownRefreshing;

- (void)endPullDownRefreshing;

- (void)endLoadMoreRefreshing;

-(void)endRequestSuccess:(BOOL)isSuccess;

@end
