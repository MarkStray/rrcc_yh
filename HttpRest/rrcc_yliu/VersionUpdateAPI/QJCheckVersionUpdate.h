//
//  QJCheckVersionUpdate.h
//  QJVersionUpdateView
//
//  Created by user on 16/4/6.
//  Copyright © 2016年 rrcc. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for VersionUpdateSDK.
FOUNDATION_EXPORT double VersionUpdateSDKVersionNumber;

//! Project version string for VersionUpdateSDK.
FOUNDATION_EXPORT const unsigned char VersionUpdateSDKVersionString[];


typedef void(^UpdateBlock)(NSString *str, NSArray *DataArr);

@interface QJCheckVersionUpdate : NSObject

/**
 *  show updateVersion View
 */
- (void)showAlertView;

@property(nonatomic, copy)UpdateBlock updateBlock;

@end
