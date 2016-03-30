

#import <Foundation/Foundation.h>
#import "WXUtil.h"
#import "ApiXml.h"
/*
 // 签名实例
 // 更新时间：2015年3月3日
 // 负责人：李启波（marcyli）
 // 该Demo用于ios sdk 1.4
 
 //微信支付服务器签名支付请求请求类
 //============================================================================
 //api说明：
 //初始化商户参数，默认给一些参数赋值，如cmdno,date等。
 -(BOOL) init:(NSString *)app_id (NSString *)mch_id;
 
 //设置商户API密钥
 -(void) setKey:(NSString *)key;
 
 //生成签名
 -(NSString*) createMd5Sign:(NSMutableDictionary*)dict;
 
 //获取XML格式的数据
 -(NSString *) genPackage:(NSMutableDictionary*)packageParams;
 
 //提交预支付交易，获取预支付交易会话标识
 -(NSString *) sendPrepay:(NSMutableDictionary *);
 
 //签名实例测试
 - ( NSMutableDictionary *)sendPay_demo;
 
 //获取debug信息日志
 -(NSString *) getDebugifo;
 
 //获取最后返回的错误代码
 -(long) getLasterrCode;
 //============================================================================
 */

// 账号帐户资料
//更改商户把相关参数后可测试

#define APP_ID          @"wx3ef7c1295c8ab9f6"               //APPID
#define APP_SECRET      @"842cd1d6d2698590b55a747942dca12b" //appsecret
//商户号，填写商户对应参数
#define MCH_ID          @"1264739201"
//商户API密钥，填写相应参数
#define PARTNER_KEY      @"e4e8e80b9e949caf838bf2e938a35a58"

//支付结果回调页面
#define NOTIFY_URL      @"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php"
//获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"

/* 微信支付现在分为v2版和v3版，2014年9月10号之前申请的为v2版，
 之后申请的为v3版。V3版的微信支付没有paySignKey参数 */


@interface payRequsestHandler : NSObject{
	//预支付网关url地址
    NSString *payUrl;
    //lash_errcode;
    long     last_errcode;
	//debug信息
    NSMutableString *debugInfo;
    NSString *appid,*mchid,*spkey;
    NSString *_orderName,*_orderPrice,*_orderNO;

}
//初始化函数
-(BOOL) initWithAppId:(NSString *)app_id
               mch_id:(NSString *)mch_id
            orderName:(NSString *)orderName
           orderPrice:(NSString *)orderPrice
              orderNO:(NSString *)orderNO;

-(NSString *) getDebugifo;
-(long) getLasterrCode;
//设置商户密钥
-(void) setKey:(NSString *)key;

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict;
//获取package带参数的签名包
-(NSString *)genPackage:(NSMutableDictionary*)packageParams;
//提交预支付
-(NSString *)sendPrepay:(NSMutableDictionary *)prePayParams;
//签名实例测试
- ( NSMutableDictionary *)sendPay;

@end