//
//  SalaryViewController.m
//  rrcc_yh
//
//  Created by user on 15/8/12.
//  Copyright (c) 2015年 yuan liu. All rights reserved.
//

#import "SalaryViewController.h"

#define kSalaryCellId @"SalaryCell"

@interface SalaryViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SalaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的红包";
    self.dataSource = [NSMutableArray array];

    [self downloadUserVoucherListData];
    
    [self.view addSubview:self.collectionView];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(kScreenWidth, 75*autoSizeScaleY);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, self.view.height-64) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = BACKGROUND_COLOR;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        // 设置数据很少的时候也是可以滚动的
        _collectionView.bounces = YES;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerNib:[UINib nibWithNibName:kSalaryCellId bundle:nil] forCellWithReuseIdentifier:kSalaryCellId];
    }
    return _collectionView;
}

- (void)downloadUserVoucherListData {
    [self showLoadingGIF];
    [[DataEngine sharedInstance] requestUserVoucherListDataSuccess:^(id responseData) {
        [self hideLoadingGIF];
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"红包 %@",dic);
        if ([dic[@"Success"] integerValue] == 1) {
            NSArray *info = dic[@"CallInfo"];
            for (NSDictionary *d in info) {
                RedPageModel *model = [RedPageModel creatWithDictionary:d];
                [self.dataSource addObject:model];
            }
            [self.collectionView reloadData];
        }
        if (self.dataSource.count == 0) [self.view addSubview:self.lowerFloorView];
    } failed:^(NSError *error) {
        [self hideLoadingGIF];
        [self.view addSubview:self.lowerFloorView];
        DLog(@"%@",error);
    }];
}

- (UIView *)lowerFloorView {
    if (!_lowerFloorView) {
        _lowerFloorView = [[UIView alloc] initWithFrame:self.view.bounds];
        _lowerFloorView.backgroundColor = [UIColor whiteColor];
        UIImageView *imgV = [ZZFactory imageViewWithFrame:CGRectMake(0, 0, 150, 150) defaultImage:@"radish"];
        imgV.center = self.view.center;
        [_lowerFloorView addSubview:imgV];
        UILabel *lbl = [ZZFactory labelWithFrame:CGRectMake(0, imgV.bottom, kScreenWidth, 21) font:Font(14) color:[UIColor darkGrayColor] text:@"亲,你还没有红包,注册新用户送红包"];
        lbl.textAlignment = NSTextAlignmentCenter;
        [_lowerFloorView addSubview:lbl];
    }
    return _lowerFloorView;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SalaryCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kSalaryCellId forIndexPath:indexPath];
    RedPageModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell updateUIUsingModel:model];
    return cell;
}





@end
