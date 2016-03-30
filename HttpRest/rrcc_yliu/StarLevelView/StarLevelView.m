//
//  StarLevelView.m
//  UITableView_Cell定制
//
//  Created by LZXuan on 14-12-18.
//  Copyright (c) 2014年 LZXuan. All rights reserved.
//

#import "StarLevelView.h"

@implementation StarLevelView
{
    //背景视图
    UIImageView *_backImageView;
    //前景图片视图
    UIImageView *_foreImageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self creatView];
    }
    return self;
}
//解归档的时候调用 如果 把当前视图关联上xib 文件之后
//那么在加载显示这个自定义的视图的时候需要解归档
//xib 中自定义的视图需要解归档
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self creatView];
    }
    return self;
}

- (void)creatView {
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 12)];
    _backImageView.image = [UIImage imageNamed:@"星星小灰色"];
    //设置内容模式
    _backImageView.contentMode = UIViewContentModeLeft;
    //先粘贴的在下面
    [self addSubview:_backImageView];
    
    //前景  在背景的上面
    _foreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 12)];
    _foreImageView.image = [UIImage imageNamed:@"星星小黄色"];
    //设置内容模式
    _foreImageView.contentMode = UIViewContentModeLeft;
    
    //允许_foreImageView的内容图片 裁剪
    //图片超出_foreImageView的范围 裁剪
    _foreImageView.clipsToBounds = YES;
    
    //先粘贴的在下面
    [self addSubview:_foreImageView];
}
- (void)setStarLevel:(double)level {
    //改变前景的frame 的宽
    _foreImageView.frame = CGRectMake(0, 0, _foreImageView.frame.size.width*(level/5.0), 12);
}
@end
