//
//  huxianLabel.h
//  rrcc_yh
//
//  Created by lawwilte on 15-5-13.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface LineLabel : UILabel{
    BOOL _isWithStrikeThrough;
}

@property (nonatomic, assign) BOOL isWithStrikeThrough;

@end
