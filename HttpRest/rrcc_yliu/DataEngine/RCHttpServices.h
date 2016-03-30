//
//  RCHttpServices.h
//  rrcc_yh
//
//  Created by user on 16/1/21.
//  Copyright © 2016年 yuan liu. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef void(^SuccessBlockType) (id responseData);
//typedef void(^FailedBlockType) (NSError *error);


@interface RCHttpServices : NSObject

/**
 *  请求数据成功
 */
@property (nonatomic, copy) void (^successCallBack) (id responseData);

/**
 *  请求数据失败
 */
@property (nonatomic, copy) void (^failedCallBack) (NSError *error);

/**
 *  不需要权限
 *
 *  @return 返回网络请求对象
 */
+ (RCHttpServices *)restServices;

/**
 *  需要权限
 *
 *  @param uid 用户ID
 *  @param pw  私钥
 *
 *  @return 返回网络请求对象
 */
+ (RCHttpServices *)restServicesWithUid:(NSString *)uid privateKey:(NSString *)pk;


/**
 *  get请求 获取资源
 *
 *  @param resource 资源名
 *  @param resId    资源id
 *  @param query    查询字符串
 */
- (void)getResource:(NSString *)resource resId:(NSString *)resId query:(id)query;

/**
 *  post请求 创建资源
 *
 *  @param resource 资源名
 *  @param resId    资源id
 *  @param query    查询字符串
 *  @param param    请求参数
 */
- (void)postResource:(NSString *)resource resId:(NSString *)resId query:(id)query param:(id)param;

/**
 *  put请求 修改资源
 *
 *  @param resource 资源名
 *  @param resId    资源id
 *  @param query    查询字符串
 *  @param param    请求参数
 */

- (void)putResource:(NSString *)resource resId:(NSString *)resId query:(id)query param:(id)param;

/**
 *  delete请求 删除资源
 *
 *  @param resource 资源名
 *  @param resId    资源id
 *  @param query    查询字符串
 */
- (void)deleteResource:(NSString *)resource resId:(NSString *)resId query:(id)query;


@end




