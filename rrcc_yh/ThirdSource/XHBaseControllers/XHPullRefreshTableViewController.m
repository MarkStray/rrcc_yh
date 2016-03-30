

#import "XHPullRefreshTableViewController.h"

#import "XHRefreshControl.h"

@interface XHPullRefreshTableViewController () <XHRefreshControlDelegate>

@property (nonatomic, strong) XHRefreshControl *refreshControl;

@end

@implementation XHPullRefreshTableViewController

- (void)startPullDownRefreshing {
    [self.refreshControl startPullDownRefreshing];
}

- (void)endPullDownRefreshing {
    [self.refreshControl endPullDownRefreshing];
}

- (void)endLoadMoreRefreshing {
    [self.refreshControl endLoadMoreRefresing];
}

#pragma mark - Propertys

- (XHRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[XHRefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    }
    return _refreshControl;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _requestCurrentPageSize = 20;
    self.refreshControl;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XHRefreshControl Delegate

- (BOOL)isLoading {
    return self.isDataLoading;
}

- (void)beginPullDownRefreshing {
    self.requestCurrentPage = 0;
    [self loadDataSource];
}

- (void)beginLoadMoreRefreshing {
    self.requestCurrentPage ++;
    [self loadDataSource];
}

- (NSDate *)lastUpdateTime {
    return [NSDate date];
}

- (BOOL)keepiOS7NewApiCharacter {
    if (!self.navigationController)
        return NO;
    BOOL keeped = [[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0;
    return keeped;
}

- (BOOL)isLoadMoreRefreshed
{
    return NO;
//    return _requestCurrentPageSize == 20;
}

- (NSInteger)autoLoadMoreRefreshedCountConverManual {
    return 2;
}

- (XHRefreshViewLayerType)refreshViewLayerType {
    return XHRefreshViewLayerTypeOnSuperView;
}





-(void)endRequestSuccess:(BOOL)isSuccess
{
    if(self.requestCurrentPage == 0){
        [self endPullDownRefreshing];
    }else{
        [self endLoadMoreRefreshing];
        if (!isSuccess) {
            self.requestCurrentPage--;
        }
    }
}

@end
