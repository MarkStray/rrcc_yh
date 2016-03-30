//
//  RCHttpServices.m
//  rrcc_yh
//
//  Created by user on 16/1/21.
//  Copyright © 2016年 yuan liu. All rights reserved.
//

#import "RCHttpServices.h"

@interface RCHttpServices ()
//NSString *_privateKey;
//NSString *_userId;
//NSString *_timeStamp;
//NSString *_payload;
//
////NSTimeInterval _threshold;//定位限制
//BOOL _isClose;

/**
 *  是否需要认证权限 authority
 */
@property (nonatomic, assign) BOOL isNeedAuth;

/**
 *  用户Id
 */
@property (nonatomic, copy) NSString *userId;

/**
 *  用户私钥
 */
@property (nonatomic, copy) NSString *privateKey;


/**
 *  网络请求管理对象
 */
@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;

@end

/**
 *  服务器地址
 */
static NSString * const mServer = @"http://rest.renrencaichang.com/";
//static NSString * const mServer = @"http://rest.dev.renrencaichang.com/";
//static NSString * const mServer = @"http://rest.test.renrencaichang.com/";

@implementation RCHttpServices

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [AFHTTPRequestOperationManager manager];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

/**
 *  不需要权限
 *
 *  @return 返回网络请求对象
 */
+ (RCHttpServices *)restServices {
    static RCHttpServices *defaultService = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultService = [[RCHttpServices alloc] init];
        defaultService.isNeedAuth = NO;
    });

    return defaultService;
}

/**
 *  需要权限
 *
 *  @param uid 用户ID
 *  @param pw  私钥
 *
 *  @return 返回网络请求对象
 */
+ (RCHttpServices *)restServicesWithUid:(NSString *)uid privateKey:(NSString *)pk {
    static RCHttpServices *defaultService = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultService = [[RCHttpServices alloc] init];
        defaultService.isNeedAuth = YES;
        defaultService.userId = uid;
        defaultService.privateKey = pk;
    });
    
    return defaultService;
}

#pragma mark 
#pragma mark 私有方法

/**
 *  toString
 *
 *  @param paramDict 字典参数链接成string
 *
 *  @return string (& =)
 */
- (NSString *)componentsJoined:(NSDictionary *)paramDict {
    NSEnumerator *enumKey = [paramDict keyEnumerator];
    NSString *key = nil;
    NSString *result = @"";
    while (key = [enumKey nextObject]) {
        NSString *value = [paramDict objectForKey:key];
        result = [key stringByAppendingFormat:@"&%@=%@",key,value];
        //result = [NSString stringWithFormat:@"%@&%@=%@",result,key,value];
    }
    return result;
}

/**
 *  权限认证
 *
 *  @param resource 资源
 *  @param resId    资源ID
 *  @param payload  请求参数
 *
 *  @return URI
 */
- (NSString *)authWithResource:(NSString *)resource resId:(NSString *)resId payload:(NSString *)payload {
    if (self.userId == nil || self.privateKey == nil) {
        return nil;
    }
    
    NSString *timeStamp = [[Utility Share] GetUnixTime];
    
    if (payload == nil) {
        payload = @"";
    }
    
    if (resId == nil) {
        resId = @"";
    }
    
    NSString *publicKey = [[NSString stringWithFormat:@"%@%@%@%@",self.privateKey,resId,timeStamp,payload] md5];
    
    resource = [resource stringByAppendingFormat:@"&t=%@&k=%@&uid=%@",timeStamp,publicKey,self.userId];
    
    return resource;
}

/**
 *  private get
 *
 *  @param query NSString
 */
- (void)getQuery:(NSString *)query {
    NSString *url = [NSString stringWithFormat:@"%@%@",mServer,query];
    
    [self requestDataWithBaseUrl:url parameter:nil Success:self.successCallBack failed:self.failedCallBack requestType:GET];
}

/**
 *  private post
 *
 *  @param query NSString
 *  @param param NSDictionary
 */
- (void)postQuery:(NSString *)query param:(id)param {
    NSString *url = [NSString stringWithFormat:@"%@%@",mServer,query];
    
    [self requestDataWithBaseUrl:url parameter:param Success:self.successCallBack failed:self.failedCallBack requestType:POST];
}

/**
 *  private put
 *
 *  @param query NSString
 *  @param param NSDictionary
 */
- (void)putQuery:(NSString *)query param:(id)param {
    NSString *url = [NSString stringWithFormat:@"%@%@",mServer,query];
    
    [self requestDataWithBaseUrl:url parameter:param Success:self.successCallBack failed:self.failedCallBack requestType:PUT];
}


/**
 *  private delete
 *
 *  @param query NSString
 */
- (void)deleteQuery:(NSString *)query {
    NSString *url = [NSString stringWithFormat:@"%@%@",mServer,query];
    
    [self requestDataWithBaseUrl:url parameter:nil Success:self.successCallBack failed:self.failedCallBack requestType:DELETE];
}


///////////////////////--我是华丽的分割线--////////////////////


/**
 *  get请求 获取资源
 *
 *  @param resource 资源名
 *  @param resId    资源id
 *  @param query    查询字符串
 */
- (void)getResource:(NSString *)resource resId:(NSString *)resId query:(id)query {
    if (resource == nil) {
        return;
    }
    
    if (resId == nil) {
        resource = [resource stringByAppendingString:@"?"];
    } else {
        resource = [resource stringByAppendingFormat:@"/%@?",resId];
    }
    
    if (query != nil) {
        NSString *queryStr = [self componentsJoined:query];
        resource = [resource stringByAppendingString:queryStr];
    }
    
    if (self.isNeedAuth) {
        resource = [self authWithResource:resource resId:resId payload:nil];
    }
    
    [self getQuery:resource];
}

/**
 *  post请求 创建资源
 *
 *  @param resource 资源名
 *  @param resId    资源id
 *  @param query    查询字符串
 *  @param param    请求参数
 */
- (void)postResource:(NSString *)resource resId:(NSString *)resId query:(id)query param:(id)param {
    if (resource == nil) {
        return;
    }
    
    if (resId == nil) {
        resource = [resource stringByAppendingString:@"?"];
    } else {
        resource = [resource stringByAppendingFormat:@"/%@?",resId];
    }
    
    if (query != nil) {
        NSString *queryStr = [self componentsJoined:query];
        resource = [resource stringByAppendingString:queryStr];
    }
    
    if (self.isNeedAuth) {
        NSString *payloadStr = [self componentsJoined:param];
        payloadStr = [[Utility Share] base64Encode:payloadStr];
        param = [NSDictionary dictionaryWithObjectsAndKeys:payloadStr,@"payload",nil];
        
        resource = [self authWithResource:resource resId:resId payload:payloadStr];
    }
    
    [self postQuery:resource param:param];
}

/**
 *  put请求 修改资源
 *
 *  @param resource 资源名
 *  @param resId    资源id
 *  @param query    查询字符串
 *  @param param    请求参数
 */

- (void)putResource:(NSString *)resource resId:(NSString *)resId query:(id)query param:(id)param {
    if (resource == nil) {
        return;
    }
    
    if (resId == nil) {
        resource = [resource stringByAppendingString:@"?"];
    } else {
        resource = [resource stringByAppendingFormat:@"/%@?",resId];
    }
    
    if (query != nil) {
        NSString *queryStr = [self componentsJoined:query];
        resource = [resource stringByAppendingString:queryStr];
    }
    
    if (self.isNeedAuth) {
        NSString *payloadStr = [self componentsJoined:param];
        payloadStr = [[Utility Share] base64Encode:payloadStr];
        param = [NSDictionary dictionaryWithObjectsAndKeys:payloadStr,@"payload",nil];
        
        resource = [self authWithResource:resource resId:resId payload:payloadStr];
    }
    
    [self putQuery:resource param:param];
}

/**
 *  delete请求 删除资源
 *
 *  @param resource 资源名
 *  @param resId    资源id
 *  @param query    查询字符串
 */
- (void)deleteResource:(NSString *)resource resId:(NSString *)resId query:(id)query {
    if (resource == nil) {
        return;
    }
    
    if (resId == nil) {
        resource = [resource stringByAppendingString:@"?"];
    } else {
        resource = [resource stringByAppendingFormat:@"/%@?",resId];
    }
    
    if (query != nil) {
        NSString *queryStr = [self componentsJoined:query];
        resource = [resource stringByAppendingString:queryStr];
    }
    
    if (self.isNeedAuth) {
        resource = [self authWithResource:resource resId:resId payload:nil];
    }
    
    [self deleteQuery:resource];
}


///////////////////////////////////////////////////////////////////////////////////////////////
//#define kSuccessCB      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil]; \
//if (successCallBack) successCallBack(dictionary);


#define kSuccessCB      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil]; \
                        if ([dictionary[@"ErrorCode"] integerValue] == 2002) { \
                        [[SingleUserInfo sharedInstance] setLocationPlayerStatus:NO]; \
                        } \
                        if (successCallBack) successCallBack(dictionary);

#define kFailedCB       MBProgressHUD *_HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES]; \
                        _HUD.mode = MBProgressHUDModeText; \
                        _HUD.labelText = @"网络异常,请检查您的网络状态"; \
                        _HUD.removeFromSuperViewOnHide = YES; \
                        [_HUD hide:YES afterDelay:1.5]; \
                        if (failedCallBack) failedCallBack(error);

// 取消请求

- (void)cancleAllRequest {
    [[AppDelegate Share].manager.operationQueue cancelAllOperations];
}

/* 请求基类 */
- (void)requestDataWithBaseUrl:(NSString *)url
                     parameter:(id)param
                       Success:(SuccessBlockType)successCallBack
                        failed:(FailedBlockType)failedCallBack
                   requestType:(DataRequestType)type {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    switch (type) {
        case GET:{
            [[AppDelegate Share].manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                kSuccessCB;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                kFailedCB;
            }];
        }
            break;
        case POST:{
            [[AppDelegate Share].manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                kSuccessCB;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                kFailedCB;
            }];
        }
            break;
        case PUT:{
            [[AppDelegate Share].manager PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                kSuccessCB;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                kFailedCB;
            }];
        }
            break;
        case DELETE:{
            [[AppDelegate Share].manager DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                kSuccessCB;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                kFailedCB;
            }];
        }
            break;
        case OPTIONS:
            break;
        default:
            break;
    }
}


@end
