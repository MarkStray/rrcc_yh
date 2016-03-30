//
//  PayEngineView.h
//  rrcc_yh
//
//  Created by user on 15/11/11.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayEngine.h"

typedef void (^CancelBlock) ();
typedef void (^ConfirmBlock) (PayEngineType);

@interface PayEngineView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) CancelBlock cancelBlock;
@property (nonatomic, copy) ConfirmBlock confirmBlock;

@end
