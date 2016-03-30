//
//  StarLevelView.h
//  UITableView_Cell定制
//
//  Created by LZXuan on 14-12-18.
//  Copyright (c) 2014年 LZXuan. All rights reserved.
//

#import <UIKit/UIKit.h>
//专门封装一个星级视图类型 可以评分设置星级
@interface StarLevelView : UIView

//设置星级
- (void)setStarLevel:(double)level;
@end
