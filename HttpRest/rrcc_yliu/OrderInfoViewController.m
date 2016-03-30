//
//  LYOrderInfoViewController.m
//  rrcc_yh
//
//  Created by user on 15/6/11.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "OrderInfoViewController.h"

#define kOrderInfoCellId         @"OrderInfoCell"
#define kOrderPreferInfoCellId   @"OrderPreferInfoCell"
#define kOrderExtraInfoCellId    @"OrderExtraInfoCell"


@interface OrderInfoViewController () <UITableViewDataSource,UITableViewDelegate>;

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *preferInfoList;
@property (nonatomic, strong) NSMutableArray *extraInfoList;

@end

@implementation OrderInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    // 优惠合计
    [self customOrderPreferInfoData];
    
    // 其他信息
    [self customOrderExtraInfoData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64-40) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.separatorColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:kOrderInfoCellId bundle:nil] forCellReuseIdentifier:kOrderInfoCellId];
        [_tableView registerNib:[UINib nibWithNibName:kOrderPreferInfoCellId bundle:nil] forCellReuseIdentifier:kOrderPreferInfoCellId];
        [_tableView registerNib:[UINib nibWithNibName:kOrderExtraInfoCellId bundle:nil] forCellReuseIdentifier:kOrderExtraInfoCellId];
    }
    return _tableView;
}

- (void)customOrderExtraInfoData {
    self.extraInfoList = [NSMutableArray array];
    [self.extraInfoList addObject:@{@"title":@"订单号    :",@"detail":self.orderModel.ordercode}];
    [self.extraInfoList addObject:@{@"title":@"联系人    :",@"detail":self.orderModel.order_contact}];
    [self.extraInfoList addObject:@{@"title":@"手机号    :",@"detail":self.orderModel.order_tel}];
    [self.extraInfoList addObject:@{@"title":@"商户名称 :",@"detail":self.orderModel.clientname}];
    [self.extraInfoList addObject:@{@"title":@"预约方式 :",@"detail":self.orderModel.delivery_title}];
    [self.extraInfoList addObject:@{@"title":@"预约地址 :",@"detail":self.orderModel.order_address}];
    [self.extraInfoList addObject:@{@"title":@"支付方式 :",@"detail":self.orderModel.payment_title}];
    [self.extraInfoList addObject:@{@"title":@"下单时间 :",@"detail":self.orderModel.inserttime}];
    [self.extraInfoList addObject:@{@"title":@"预约时间 :",@"detail":self.orderModel.svtime}];
    [self.extraInfoList addObject:@{@"title":@"备注信息 :",@"detail":self.orderModel.remark}];
}

- (void)customOrderPreferInfoData {
    self.preferInfoList = [NSMutableArray array];
    if (self.orderModel.gift != nil && ![self.orderModel.gift isEqualToString:@""]) {
        [self.preferInfoList addObject:@{@"title":@"    赠品  :",@"detail":self.orderModel.gift,@"align":@"left",@"color":@"gray",@"font":@"14"}];
    }
    if (self.orderModel.discount != nil && self.orderModel.discount.floatValue != 0.f) {
        NSString *discount = [NSString stringWithFormat:@"-￥%@",self.orderModel.discount];
        [self.preferInfoList addObject:@{@"title":@"    满减  :",@"detail":discount,@"align":@"right",@"color":@"gray",@"font":@"14"}];
    }
    if (self.orderModel.voucher != nil && self.orderModel.voucher.floatValue != 0.f) {
        NSString *voucher = [NSString stringWithFormat:@"-￥%@",self.orderModel.voucher];
        [self.preferInfoList addObject:@{@"title":@"    红包  :",@"detail":voucher,@"align":@"right",@"color":@"gray",@"font":@"14"}];
    }
    NSString *custprice = [NSString stringWithFormat:@"￥%@",self.orderModel.custprice];
    [self.preferInfoList addObject:@{@"title":@"    合计  :",@"detail":custprice,@"align":@"right",@"color":@"red",@"font":@"18"}];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.orderModel.productItemList.count;
    } else if (section == 1) {
        return self.preferInfoList.count;
    }else {
        return self.extraInfoList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderInfoCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ProductsModel *model = self.orderModel.productItemList[indexPath.row];
        [cell showDataUsingModel:model];
        
        if (indexPath.row == self.self.orderModel.productItemList.count-1) {
            cell.lineView.hidden = YES;
        } else {
            cell.lineView.hidden = NO;
        }
        return cell;
    } else if (indexPath.section == 1) {
        
        OrderPreferInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderPreferInfoCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *title  = [self.preferInfoList[indexPath.row] objectForKey:@"title"];
        NSString *detail = [self.preferInfoList[indexPath.row] objectForKey:@"detail"];
        NSString *align  = [self.preferInfoList[indexPath.row] objectForKey:@"align"];
        NSString *color = [self.preferInfoList[indexPath.row] objectForKey:@"color"];
        NSString *font  = [self.preferInfoList[indexPath.row] objectForKey:@"font"];
        
        //相关属性
        if ([align isEqualToString:@"left"]) {
            cell.detailLabel.textAlignment = NSTextAlignmentLeft;
        } else if ([align isEqualToString:@"right"]) {
            cell.detailLabel.textAlignment = NSTextAlignmentRight;
        }
        
        if ([color isEqualToString:@"red"]) {
            cell.detailLabel.textColor = [UIColor redColor];
        } else if ([align isEqualToString:@"gray"]) {
            cell.detailLabel.textColor = [UIColor lightGrayColor];
        }
        
        if ([font isEqualToString:@"14"]) {
            cell.detailLabel.font = [UIFont systemFontOfSize:14];
        } else if ([align isEqualToString:@"18"]) {
            cell.detailLabel.font = BoldFont(18);
        }
        
        cell.titleLabel.text  = title;
        cell.detailLabel.text = detail;
        
        
        cell.lineView.hidden = YES;
        return cell;
    } else {
        OrderExtraInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderExtraInfoCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *title  = [self.extraInfoList[indexPath.row] objectForKey:@"title"];
        NSString *detail = [self.extraInfoList[indexPath.row] objectForKey:@"detail"];
        
        cell.titleLabel.text  = title;
        cell.detailLabel.text = detail;
        
        if (indexPath.row == self.extraInfoList.count-1) {
            cell.lineView.hidden = YES;
        } else {
            cell.lineView.hidden = NO;
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    } else if (indexPath.section == 1) {
        NSString *detail = [self.preferInfoList[indexPath.row] objectForKey:@"detail"];
        
        CGFloat height = [detail boundingRectWithSize:CGSizeMake(kScreenWidth-16*2-80, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+25;
        
        return height < 40? 40: height;
    } else {
        NSString *detail = [self.extraInfoList[indexPath.row] objectForKey:@"detail"];
        
        CGFloat height = [detail boundingRectWithSize:CGSizeMake(kScreenWidth-16*2-80, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+25;
        
        return height < 40? 40: height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 40;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *hView = [ZZFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 30) color:BACKGROUND_COLOR];
        [ZZFactory labelWithFrame:CGRectMake(16, 0, kScreenWidth-16*2, 30) font:[UIFont systemFontOfSize:14] color:[UIColor darkGrayColor] text:@"订单明细" superView:hView];
        return hView;
    } else if (section == 1) {
        UIView *hView = [ZZFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 30) color:[UIColor whiteColor]];
        [ZZFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 2) color:BACKGROUND_COLOR superView:hView];

        [ZZFactory labelWithFrame:CGRectMake(16, 2, kScreenWidth-16*2, 28) font:[UIFont systemFontOfSize:14] color:[UIColor darkGrayColor] text:@"优惠合计" superView:hView];
        return hView;
    } else {
        UIView *hView = [ZZFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 30) color:BACKGROUND_COLOR];
        [ZZFactory labelWithFrame:CGRectMake(16, 0, kScreenWidth-16*2, 30) font:[UIFont systemFontOfSize:14] color:[UIColor darkGrayColor] text:@"其他信息" superView:hView];
        return hView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *fView = [ZZFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 40) color:[UIColor whiteColor]];
    return fView;
}

@end
