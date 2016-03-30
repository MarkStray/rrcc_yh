//
//  ProductDetailViewController.m
//  rrcc_yh
//
//  Created by user on 15/10/23.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ZZHttpRequest.h"


#define kDetailCellKind         @"DetailCell"
#define kDetailCellKindAnother  @"DetailImageCell"

@interface ProductDetailViewController () <CalculatorViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) NSArray *titleList;

@property (nonatomic, strong) NSMutableArray *detailList;
@property (nonatomic, strong) NSMutableArray *imageDataArray;//计算出每个image size

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIView *expandHeader;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) CalculatorView *calc;

@end

@implementation ProductDetailViewController
{
    int _count;
    NSInteger _sectionNum;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShoppingCarDidClearNotification object:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShoppingCarDidClear:) name:kShoppingCarDidClearNotification object:nil];
    }
    return self;
}

- (void)ShoppingCarDidClear:(NSNotification *)notify {
    _count = 0;//清空购物车的时候置0
    self.detailProductModel.count = _count;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showCustomTabBar];

    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.addView];
    
    _count = self.detailProductModel.count;// plase attention
    self.calc.count = _count;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.addView removeFromSuperview];
    _sectionNum = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleList = @[@"品名:",@"价格:",@"规格:",@"描述:"];
    self.detailList = [NSMutableArray array];
    self.imageDataArray = [NSMutableArray array];
    
    [self.view addSubview:self.detailTableView];
    [self.view addSubview:self.backBtn];
    self.expandHeader = [BZExpandHeaderView expandWithScrollView:self.detailTableView expandView:self.headerView];
    [self downloadProductDetailsData];
}

// 改变状态栏的前景色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 240*autoSizeScaleY)];
        [_headerView sd_setImageWithURL:[NSURL URLWithString:[self.detailProductModel.imgurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"Loading"]];
    }
    return _headerView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(16, 30, 50, 30);
        [_backBtn SetBorderWithcornerRadius:15.f BorderWith:0.f AndBorderColor:nil];
        _backBtn.backgroundColor = [UIColor grayColor];
        [_backBtn setImage:[UIImage imageNamed:@"Arrow_Normal"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (UITableView *)detailTableView {
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height-49) style:UITableViewStylePlain];
        _detailTableView.delegate = self;
        _detailTableView.dataSource = self;
        _detailTableView.separatorColor = [UIColor clearColor];
        
        [_detailTableView registerNib:[UINib nibWithNibName:kDetailCellKind bundle:nil] forCellReuseIdentifier:kDetailCellKind];
        [_detailTableView registerNib:[UINib nibWithNibName:kDetailCellKindAnother bundle:nil] forCellReuseIdentifier:kDetailCellKindAnother];

    }
    return _detailTableView;
}

- (UIView *)addView {
    if (!_addView) {
        _addView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth-80, 49)];
        _addView.backgroundColor = [UIColor whiteColor];
        self.calc = [[CalculatorView alloc] initWithFrame:CGRectMake(40, -5, 120, 60)];
        self.calc.delegate = self;
        self.calc.isZeroShow = YES;
        self.calc.isButtonEnable = NO;
        [_addView addSubview:self.calc];
    }
    return _addView;
}

- (void)downloadProductDetailsData {
    //self.calc.isButtonEnable = NO;//不可点
    [[DataEngine sharedInstance] requestUserProductDetailsDataWithSiteProductId:self.detailProductModel.id success:^(id responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        DLog(@"%@",dict);
        NSDictionary *CallInfo = dict[@"CallInfo"];
        if ([dict[@"Success"] integerValue] == 1) {
            
            self.detailProductModel = [ProductsModel creatWithDictionary:CallInfo];
            self.detailProductModel.count = _count;//赋值原来已经添加的数量
            
            NSArray *images = CallInfo[@"imageList"];
            NSMutableArray *imageList = [NSMutableArray array];
             for (NSDictionary *dic in images) {
                ImageModel *model = [ImageModel creatWithDictionary:dic];
                [imageList addObject:model];
            }
            self.detailProductModel.imageList = imageList;
            
            NSString *skuname = [NSString stringWithFormat:@"%@",self.detailProductModel.skuname==nil? @"": self.detailProductModel.skuname];
            
            NSString *price = [NSString stringWithFormat:@"%@元/份",self.detailProductModel.price];
            if (self.detailProductModel.onsale.integerValue == 1) {
                price = [NSString stringWithFormat:@"促销 %@元/份 原价 %@元/份",self.detailProductModel.saleprice,self.detailProductModel.price];
            }
            
            NSString *spec = [NSString stringWithFormat:@"%@",self.detailProductModel.spec==nil? @"": self.detailProductModel.spec];
            
            NSString *remark = [NSString stringWithFormat:@"%@",self.detailProductModel.remark==nil? @"": self.detailProductModel.remark];
            
            [self.detailList addObject:skuname];
            [self.detailList addObject:price];
            [self.detailList addObject:spec];
            [self.detailList addObject:remark];
            
            //self.calc.isButtonEnable = YES;//可点击
            //[self.detailTableView reloadData];
            
            if (imageList.count != 0) {
                [self downloadImageData];
            } else {
                self.calc.isButtonEnable = YES;//可点击
                _sectionNum = 2;
                [self.detailTableView reloadData];
            }
        }
    } failed:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

- (void)downloadImageData {
    
    NSMutableArray *imgurlList = [NSMutableArray array];
    for (ImageModel *model in self.detailProductModel.imageList) {
        [imgurlList addObject:model.imgurl];
    }
    
    ZZHttpRequest *request = [[ZZHttpRequest alloc] init];
    [request downloadImageData:imgurlList complete:^(NSArray *dataArray) {
        self.imageDataArray = [dataArray mutableCopy];
        if (self.imageDataArray.count > 0) {
            self.calc.isButtonEnable = YES;//可点击
            _sectionNum = 2;
            [self.detailTableView reloadData];
        }
    }];

}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return self.detailList.count;
    return self.detailProductModel.imageList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat height = [BZ_Tools heightForTextString:self.detailList[indexPath.row] width:kScreenWidth-(16*2+40) fontSize:17];
        DLog(@" %f ",height);
        return height < 35 ? 50 : height+20;
}
    
    if (self.imageDataArray.count != 0) {
        
        NSData *data = self.imageDataArray[indexPath.row];
        UIImage *image = [UIImage imageWithData:data];
        CGSize size = image.size;

        DLog(@"image.size = %@",NSStringFromCGSize(size));
        return size.height*(kScreenWidth/size.width);
    }
    
    return 0;
    //return kScreenWidth/16*9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kDetailCellKind forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = self.titleList[indexPath.row];
        cell.detailLabel.text = self.detailList[indexPath.row];
        return cell;
    }
    
    DetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kDetailCellKindAnother forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSData *data = self.imageDataArray[indexPath.row];
    UIImage *image = [UIImage imageWithData:data];

    cell.detailImageView.image = image;
    //ImageModel *model = self.detailProductModel.imageList[indexPath.row];
    //sd_image_url(cell.detailImageView, model.imgurl);
    return cell;
}


#pragma mark - CalculatorViewDelegate

- (void)CalculatorViewDidClickReduceButton:(CalculatorView *)aView {
    self.detailProductModel.count --;
    if ([[SingleShoppingCar sharedInstance] playerProductsModel:self.detailProductModel]) {
        self.calc.count = self.detailProductModel.count;
    }
}

- (void)CalculatorViewDidClickAddButton:(CalculatorView *)aView {
    
    if (self.detailProductModel.onsale.intValue == 1) {
        if (self.calc.count == self.detailProductModel.saleamount.intValue) {
            NSString *msg = [NSString stringWithFormat:@"亲,本促销品每单限购%d份!",self.detailProductModel.saleamount.intValue];
            show_alertView(msg);
            return ;
            
        } else {
            self.detailProductModel.count ++;
        }
    } else {
        if (self.calc.count == 99) {
            NSString *msg = [NSString stringWithFormat:@"亲!本商品每单最多能购买99份!"];
            show_alertView(msg);
            return ;

        } else {
            self.detailProductModel.count ++;
        }
    }

    if ([[SingleShoppingCar sharedInstance] playerProductsModel:self.detailProductModel]) {
        self.calc.count = self.detailProductModel.count;
    } else {
        self.detailProductModel.count --;
        self.calc.count = self.detailProductModel.count;
    }
}


@end
