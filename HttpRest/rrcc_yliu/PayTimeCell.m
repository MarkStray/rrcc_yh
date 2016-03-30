//
//  PayTimeCell.m
//  rrcc_yh
//
//  Created by user on 16/1/7.
//  Copyright © 2016年 ting liu. All rights reserved.
//

#import "PayTimeCell.h"

@implementation PayTimeCell
{
    
    __weak IBOutlet UIView *view1;
    __weak IBOutlet UIView *view2;
    
    __weak IBOutlet UILabel *title1Label;
    __weak IBOutlet UILabel *title2Label;

    __weak IBOutlet UIButton *select1button;
    __weak IBOutlet UIButton *select2button;
    
    __weak IBOutlet UIView *selectTimeView;
    
    __weak IBOutlet UILabel *timeShowLabel;
    
    int _flag;// 1 第一个 2 第二个
    NSInteger _index;// 上次选中的index
    BOOL _isNeedSetUp;//时间是否需要重置
    NSArray *_dateTimeArray;
    
    DeliveryModel *_deliveryModel;
    TakeDescModel *_firstModel;
    TakeDescModel *_lastModel;
}



- (void)awakeFromNib {
    [view1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(view1Action)]];
    
    [view2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(view2Action)]];

    [selectTimeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTime)]];
    
    
    [select1button setImage:[UIImage imageNamed:@"UnSelected"] forState:UIControlStateNormal];
    [select1button setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    select1button.userInteractionEnabled = NO;
    
    [select2button setImage:[UIImage imageNamed:@"UnSelected"] forState:UIControlStateNormal];
    [select2button setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    select2button.userInteractionEnabled = NO;
    
    _flag = 0;// 初始化
    _index = 0;
    _isNeedSetUp = NO;
}

// 在view2 上添加两个constraints 设置不同的优先级 实现动态展示

- (void)showDeliveryTimeWithModel:(DeliveryModel *)model index:(NSInteger)index {
    _deliveryModel = model;
    _index = index;
    NSMutableArray *deliveryList = model.deliveryList;
    
    if (deliveryList.count == 1) {
        [view1 removeFromSuperview];// 这里hidden NG
        _flag = 1;
        
        _lastModel = [[deliveryList lastObject] objectForKey:@"desc"];
        title2Label.text = _lastModel.title;
        select2button.selected = _lastModel.checked.intValue==1 ? YES: NO;
    } else {
            _firstModel = [[deliveryList firstObject] objectForKey:@"desc"];
            title1Label.text = _firstModel.title;
            
            _lastModel = [[deliveryList lastObject] objectForKey:@"desc"];
            title2Label.text = _lastModel.title;

            if (_firstModel.checked.intValue == 1) {
                _flag = 1;
                select1button.selected =  YES;
                select2button.selected =  NO;
            } else if (_lastModel.checked.intValue == 1) {
                _flag = 2;
                select1button.selected =  NO;
                select2button.selected =  YES;
            } else {// 默认情况 程序不会崩溃
                //一般情况 程序执行不到这里，如果服务器数据没有任何选中
                _flag = 1;
            }
    }
    
    // 展示 选取的日期
    [self updateTimeShowWithIndex:index];
}

- (void)updateTimeShowWithIndex:(NSInteger)index {
    NSMutableArray *deliveryList = _deliveryModel.deliveryList;

    _dateTimeArray = [deliveryList[_flag-1] objectForKey:@"timeArray"];
    
    TimeModel *timeModel = _dateTimeArray[index];
    
    timeShowLabel.text = timeModel.timeTitle;
    
    if (self.updateTimeAction) {
        self.updateTimeAction(_isNeedSetUp, timeModel.value, _dateTimeArray);
    }
    
    _isNeedSetUp = NO;
}

- (void)view1Action {
    if (_firstModel.checked.intValue == 1) return ;
    
    _firstModel.checked = @"1";
    _lastModel.checked = @"0";
    select1button.selected = YES;
    select2button.selected = NO;
    
    _flag = 1;
    _isNeedSetUp = YES;

    [self updateTimeShowWithIndex:0];
    [self resignTTFirstResponder];
}

- (void)view2Action {
    if (_lastModel.checked.intValue == 1) return ;

    _firstModel.checked = @"0";
    _lastModel.checked = @"1";

    select1button.selected = NO;
    select2button.selected =YES;
    
    _flag = 2;
    _isNeedSetUp = YES;
    
    if (_deliveryModel.deliveryList.count == 1) {
        _flag = 1;
        _isNeedSetUp = NO;
        [self updateTimeShowWithIndex:_index];
    } else {
        [self updateTimeShowWithIndex:0];
    }
    
    [self resignTTFirstResponder];
}

- (void)selectTime {
    if (self.selectTimeAction)  self.selectTimeAction();
}


- (void)resignTTFirstResponder {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResignFirstResponder" object:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
