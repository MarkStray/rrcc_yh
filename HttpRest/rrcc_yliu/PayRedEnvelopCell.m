//
//  PayRedEnvelopCell.m
//  rrcc_yh
//
//  Created by user on 15/11/5.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "PayRedEnvelopCell.h"

@interface PayRedEnvelopCell () <UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *redEnvelopList;

@property (nonatomic, copy) NSString *orderPrice;

@property (nonatomic, copy) void (^completeCB) (RedPageModel *model);

@end

//static NSString * const reuseIdentifier = @"RedEnvelopCell";

@implementation PayRedEnvelopCell
{
    __weak IBOutlet UIView *envelopContentView;
    
    __weak IBOutlet UILabel *_countLabel;
    
    BOOL _isOpen;
    
}
- (void)awakeFromNib {
    _isOpen = NO;
    envelopContentView.width = kScreenWidth;
    envelopContentView.clipsToBounds = YES;
}
- (IBAction)envelopBtnAction:(id)sender {
    _isOpen = !_isOpen;
    if (self.redEnvelopList.count == 0) {
        show_animationAlert(@"您的账户没有可用红包!");
        return;
    }
    if (self.openBlock) self.openBlock(_isOpen);
}

- (void)updateUIUsingArray:(NSMutableArray *)array
                  tolPrice:(NSString *)price
                  complete:(void (^) (RedPageModel *))completeCB {
    self.redEnvelopList = array;
        
    self.orderPrice = price;
    self.completeCB = completeCB;
    
    _countLabel.text = [NSString stringWithFormat:@"(%d个红包)",(int)array.count-1];
    if (array.count == 0) {
        _countLabel.text = @"无可用红包";
    }
    
    if (![envelopContentView.subviews containsObject:self.collectionView]) {
        [envelopContentView addSubview:self.collectionView];
    }
    
    self.collectionView.frame = CGRectMake(0, 0, envelopContentView.width, (array.count/2+1)*75);
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat width = (envelopContentView.width-16*3)/2;

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(width, 70);
        flowLayout.minimumInteritemSpacing = 16;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);

        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"RedEnvelopCell" bundle:nil] forCellWithReuseIdentifier:@"RedEnvelopCellId"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.redEnvelopList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RedEnvelopCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"RedEnvelopCellId" forIndexPath:indexPath];
    RedPageModel *model = [self.redEnvelopList objectAtIndex:indexPath.row];
    [cell updateUIUsingModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.redEnvelopList.count - 1) {// 放弃使用红包
        BOOL hasSelected = NO;//是否有选中红包
        for (RedPageModel *model in self.redEnvelopList) {
            if (model.isSelected) {
                hasSelected = YES;
                break;
            }
        }
        if (hasSelected) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否放弃使用红包" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        } else {
            show_alertView(@"当前没有选中任何红包");
        }
    } else {
        RedPageModel *model = [self.redEnvelopList objectAtIndex:indexPath.row];
        if ([model.status isEqualToString:@"1"]) {
            if (!model.isSelected) {
                
                if (self.orderPrice.floatValue < model.limit.floatValue) {
                    show_alertView(@"未达满减额度,该红包不能使用");
                    return ;
                }
                
                NSTimeInterval interval1 = [[NSDate date] timeIntervalSince1970];
                NSTimeInterval interval2 = [[NSString stringToDate_yMd:model.start] timeIntervalSince1970];
                if (interval1 < interval2) {
                    show_alertView(@"未在使用期间,该红包不能使用");
                    return ;
                }

                model.isSelected = YES;
                [self.redEnvelopList replaceObjectAtIndex:indexPath.row withObject:model];

                for (int i=0; i<self.redEnvelopList.count; i++) {
                    RedPageModel *rModel = self.redEnvelopList[i];
                    if (i != indexPath.row) {
                        rModel.isSelected = NO;
                    }
                    [self.redEnvelopList replaceObjectAtIndex:i withObject:rModel];
                }
                [self.collectionView reloadData];
                if (self.completeCB) self.completeCB(model);
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        for (int i=0; i<self.redEnvelopList.count; i++) {
            RedPageModel *rModel = self.redEnvelopList[i];
            rModel.isSelected = NO;
            [self.redEnvelopList replaceObjectAtIndex:i withObject:rModel];
        }
        [self.collectionView reloadData];
        if (self.completeCB) self.completeCB(nil);// 返回空
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
