//
//  QAndAViewController.m
//  rrcc_yh
//
//  Created by user on 15/10/22.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "QAndAViewController.h"

#define kQAndACellId @"QAndACell"

@interface QAndAViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation QAndAViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self downloadUserVoucherListData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常见问题";
    
    self.dataSource = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, self.view.height-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = BACKGROUND_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        /**
         * if set like this, using autolayout don't need call (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
         */
        //_tableView.rowHeight = UITableViewAutomaticDimension;
        //_tableView.estimatedRowHeight = 80.f;
        
        //使用本例所示方法 下面这行代码可加可不加 (最好加上 提升性能)
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;

        
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = YES;
        [_tableView registerNib:[UINib nibWithNibName:kQAndACellId bundle:nil] forCellReuseIdentifier:kQAndACellId];
    }
    return _tableView;
}

- (void)downloadUserVoucherListData {
    [self showLoadingGIF];
    [[DataEngine sharedInstance] requestQAndADataSuccess:^(id responseData) {
        [self hideLoadingGIF];
        NSDictionary *dic = (NSDictionary *)responseData;
        DLog(@"红包 %@",dic);
        if ([dic[@"Success"] integerValue] == 1) {
            NSArray *info = dic[@"CallInfo"];
            for (NSDictionary *d in info) {
                QAModel *model = [QAModel creatWithDictionary:d];
                [self.dataSource addObject:model];
            }
            [self.tableView reloadData];
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
        UILabel *lbl = [ZZFactory labelWithFrame:CGRectMake(0, imgV.bottom, kScreenWidth, 21) font:Font(14) color:[UIColor darkGrayColor] text:@"数据加载失败"];
        lbl.textAlignment = NSTextAlignmentCenter;
        [_lowerFloorView addSubview:lbl];
    }
    return _lowerFloorView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static QAndACell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // WARNING: Don't call the table view's dequeueReusableCellWithIdentifier: method here because this will result
        // in a memory leak as the cell is created but never returned from the tableView:cellForRowAtIndexPath: method!
        cell = [[[NSBundle mainBundle] loadNibNamed:kQAndACellId owner:nil options:nil] lastObject];
    });
    QAModel *model = [self.dataSource objectAtIndex:indexPath.row];
    //return [cell updateUIUsingModel:model];
    
    /**CGFloat h = */[cell updateUIUsingModel:model];
    
    /**hard coding need following code but nib not */
    //[cell setNeedsUpdateConstraints];
    //[cell updateConstraintsIfNeeded];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));

    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints
    // (Note that the preferredMaxLayoutWidth is set on multi-line UILabels inside the -[layoutSubviews] method
    // in the UITableViewCell subclass

    /** refresh layout */
    [cell setNeedsLayout];
    [cell layoutIfNeeded];

    
    // 触发cell的布局过程，会基于布局约束计算所有视图的frame。
    // （注意，你必须要在cell的-[layoutSubviews]方法中给多行的UILabel设置好preferredMaxLayoutWidth值；
    // 或者在下面2行代码前手动设置！）
    cell.qLabel.preferredMaxLayoutWidth = CGRectGetWidth(cell.qLabel.frame);
    cell.aLabel.preferredMaxLayoutWidth = CGRectGetWidth(cell.aLabel.frame);

    //cell.qLabel.preferredMaxLayoutWidth = kScreenWidth-16*2-24;
    //cell.aLabel.preferredMaxLayoutWidth = kScreenWidth-16*2-24;

    // Get the actual height required for the cell
    CGFloat height= [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    return height+1.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QAndACell *cell = [self.tableView dequeueReusableCellWithIdentifier:kQAndACellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    QAModel *model = [self.dataSource objectAtIndex:indexPath.row];
    
    [cell updateUIUsingModel:model];
    
    /**hard coding need following code but nib not */
    
    //[cell setNeedsUpdateConstraints];
    //[cell updateConstraintsIfNeeded];

    return cell;
}


@end




