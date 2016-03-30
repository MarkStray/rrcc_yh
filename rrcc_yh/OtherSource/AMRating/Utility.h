//
//  Utility.h
//  CloudTravel
//
//  Created by hetao on 10-12-5.
//  Copyright 2010 oulin. All rights reserved.
//  先放在这边，后期有时间再整合

#import <Foundation/Foundation.h>

#define default_pwd @"default_pwd"
#define default_userName @"default_userName"
#define default_userLogo @"default_userLogo"
#define default_userId @"default_userId"
#define default_userToken @"default_userToken"
#define default_captchCode @"default_captchCode"
#define default_storeId   @"default_storeId"


//1成功 0失败 2未知错误
typedef void (^LoginSuc)(NSInteger NoLogin);


typedef void (^DownloadNewData)(BOOL isSuccess);

@interface Utility : NSObject
//启用缓存
@property (nonatomic,assign) BOOL offline;

+(id)Share;
+ (void)alertError:(NSString*)content;
+ (void)alertSuccess:(NSString*)content;
- (void)alert:(NSString*)content;
- (void)alert:(NSString*)content delegate:(id)delegate;
- (NSString*)timeToNow:(NSString*)theDate;
- (BOOL) validateEmail: (NSString *) candidate;
- (BOOL) validateIdentityCard: (NSString *)identityCard;



- (void) makeCall:(NSString *)phoneNumber;
+ (BOOL)removeForArrayObj:(id)obj forKey:(NSString*)key;
+ (void)saveToDefaults:(id)obj forKey:(NSString*)key;
+ (void)saveToArrayDefaults:(id)obj forKey:(NSString*)key;
+ (void)saveToArrayDefaults:(id)obj replace:(id)oldobj forKey:(NSString*)key;

+ (id)defaultsForKey:(NSString*)key;
+ (void)removeForKey:(NSString*)key;

//用户相关
@property (nonatomic, strong) NSString *userId;//用户ID
@property (nonatomic, strong) NSString *userName;//用户姓名
@property (nonatomic, strong) NSString *userPwd;//用户密码/
@property (nonatomic, strong) NSString *userLogo;//用户头像
@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *captchCode;//验证码
@property (nonatomic, strong) NSString *storeId;//店铺Id 






//配置-type
@property (nonatomic, strong) NSMutableArray *ZKMessageTypeArray_mode;//模板类别
@property (nonatomic, strong) NSMutableArray *ZKWeixinTypeArray;//微信类别
@property (nonatomic, strong) NSMutableArray *ZKWaparticleTypeArray;//文章类别
@property (nonatomic, assign) BOOL isMan;
@property (nonatomic, assign) BOOL isPushEnable;
@property (nonatomic,assign ) BOOL isAlertViewFlag;//弹出类型设置
@property (nonatomic, strong) NSString *deviceNum;
@property (nonatomic, strong) LoginSuc loginSuc;
@property (nonatomic, strong) DownloadNewData loadNewData;
//
@property (nonatomic, strong) NSMutableDictionary *badgeViewDict;
//保费计算选中的险种
@property (nonatomic, strong) NSMutableArray *ACSelsetBFArray;
//添加选中险种
-(NSMutableArray*)AddSelectBFArray:(NSString *)strIndex;
//移除险种
-(NSMutableArray*)removeSelectBFArray:(NSString *)strIndex;
//移除所有
-(void)removeAllSelectBF;
//添加所有选中险种
-(NSMutableArray*)addallBFArray:(NSMutableArray*)strarray;


+(id)uid;
+ (NSString *)getMacAddress;
-(void)ShowMessage:(NSString *)title msg:(NSString *)msg;
-(void)isLoginAccount:(NSString *)account pwd:(NSString *)password aLogin:(LoginSuc)aLoginSuc;

-(void)loginWithAccount:(NSString *)account pwd:(NSString *)password;
-(void)registerWithAccount:(NSString *)account pwd:(NSString *)password authorCode:(NSString *)code;
//-(void)registerWithAccount:(NSString *)account code:(NSString *)aCode pwd:(NSString *)password name:(NSString *)name sex:(BOOL)isMan;
//获取内存地址
-(NSString *)getAddressBy:(NSString *)description;
- (BOOL)isAvailableIOS:(CGFloat)availableVersion;
//-(NSString*)blowfish:(NSString*)password;
//登陆注册
- (void)showLoginAlert:(BOOL)abool;
- (void)hiddenLoginAlert;
//刷新push enable
- (void)reloadIsPushEnable;
//用户本地数据
-(void)saveUserInfoToDefault;
-(void)readUserInfoFromDefault;
-(void)clearUserInfoInDefault;
//清除本地数据库
-(void)removeSqlData;


// 获取当前时间
-(NSString*)GetNowTime;

//获取当前时间戳
- (NSString *)GetUnixTime;

//获取某一个时间距1970年的时间差
- (NSTimeInterval)GetTimeIntervalSince1970:(NSString *)timeFormatStr;

//获得分时秒的时间格式
-(NSString*)GetHMSTime;
-(NSString*)GetHMSTimeIntervalSinceNow:(NSTimeInterval)secs;

///改变时间格式
- (NSString*)ACtime_ChangeTheFormat:(NSString*)theDate;
///计算时间差
-(NSInteger)ACtimeToNow:(NSString*)theDate;
//时间转换
- (NSString*)timeToNow:(NSString*)theDate needYear:(BOOL)needYear;
//时间戳
-(NSString *)timeToTimestamp:(NSString *)timestamp;
//
-(void)getUserIdByDeviceNum;




//类似qq聊天窗口的抖动效果
-(void)viewAnimations:(UIView *)aV;

//view 左右抖动
-(void)leftRightAnimations:(UIView *)view;
//背景view
- (UIView*)tipsView:(NSString*)str;
//圆角或椭圆
-(void)viewLayerRound:(UIView *)view borderWidth:(float)width borderColor:(UIColor *)color;


//讯飞
//-(void)iflyView:(NSString *)str;

//获取当前app版本
-(NSString *)VersionSelect;


//////////////数据格式化
//格式化电话号码
-(NSString *)ACFormatPhone:(NSString *)str;
//格式化手机号
-(NSString *)ACFormatMobile:(NSString *)str;
//格式化身份证号
-(NSString *)ACFormatIDC:(NSString *)str;
//格式化组织机构代码证
-(NSString *)ACFormatOCC:(NSString *)str;
//格式化车牌号
-(NSString *)ACFormatPlate:(NSString *)str;
//格式化vin
-(NSString *)ACFormatVin:(NSString *)str;
//------数字格式化----------------
-(NSString*)ACFormatNumStr:(NSString*)nf;


//格式化身份证号2
-(NSString *)ACFormatIDC_DH:(NSString *)str;
//格式化vin2
-(NSString *)ACFormatVin_DH:(NSString *)str;





-(NSString*)GetPriviteKey:(NSString *)PriviteKey GetResourceId:(NSString *)ResourceId GetPayLoad:(NSString *)PayLoad GetTimeStamp:(NSString*)TimeStamp;

- (NSString *) image2DataURL: (UIImage *) image;
-(NSData*)Data2Image:(NSString*)string;


-(NSString*)toBase64String:(NSString*)string;

- (NSString *)base64Decode:(NSString *)base64String;
- (NSString *)base64Encode:(NSString *)plainText;

@end
