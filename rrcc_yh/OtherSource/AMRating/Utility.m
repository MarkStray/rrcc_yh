//
//  Utility.m
//  CloudTravel
//
//  Created by hetao on 10-12-5.
//  Copyright 2010 oulin. All rights reserved.
//

#import "Utility.h"
#import <Reachability.h>
#import <JSONKit.h>
#import "NSDictionary+expanded.h"
//#import "DMHessian.h"
#import <arpa/inet.h>
#import "AppDelegate.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>



#define picMidWidth 200
#define picSmallWidth 100
@interface Utility (){//<IFlyRecognizerViewDelegate>
    UITextField *accountField,*passField;
    NSString *phoneNum;
    UIAlertView *alertview;
    NSString *strIFlyType;
    
    
}
@property (nonatomic,strong) NSURL *phoneNumberURL;
@property (nonatomic,strong) Reachability *reachability;
//@property (nonatomic, strong) LoginView *loginView;
//@property (nonatomic, strong) RegisterView *registerView;

@end

@implementation Utility
@synthesize ZKMessageTypeArray_mode=_ZKMessageTypeArray_mode,ZKWeixinTypeArray=_ZKWeixinTypeArray,ZKWaparticleTypeArray=_ZKWaparticleTypeArray;
@synthesize ACSelsetBFArray=_ACSelsetBFArray;

static Utility *_utilityinstance=nil;
static dispatch_once_t utility;

+(id)Share
{
    dispatch_once(&utility, ^ {
        _utilityinstance = [[Utility alloc] init];
      //  _utilityinstance.deviceNum=[self getMacAddress].md5;
    });
	return _utilityinstance;
}

- (BOOL)offline
{
   // return ![[NetEngine Share] isReachable];
    return NO;
}

#pragma mark -
#pragma mark getAddressBy
-(NSString *)getAddressBy:(NSString *)description{
	NSArray *strArray = [description componentsSeparatedByString:@" "];
	
	return [strArray objectAtIndex:1];
}

#pragma mark -
#pragma mark validateEmail
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}


#pragma ImagePeSize
-(CGFloat)percentage:(NSString*)per width:(NSInteger)width
{
    if (per) { 
        NSArray *stringArray = [per componentsSeparatedByString:@"*"];
        
        if ([stringArray count]==2) {
            CGFloat w=[[stringArray objectAtIndex:0] floatValue];
            CGFloat h=[[stringArray objectAtIndex:1] floatValue];
            if (w>=width) {
                return h*width/w;
            }else{
                return  h;
            }
        }
    }
    return width;
}

//判断ios版本AVAILABLE
- (BOOL)isAvailableIOS:(CGFloat)availableVersion
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=availableVersion) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark TimeTravel
- (NSString*)timeToNow:(NSString*)theDate
{
    if (!theDate) {
        return nil;
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *d=[dateFormatter dateFromString:theDate];
    if (!d) {
        return theDate;
    }
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=(now-late)>0 ? (now-late) : 0;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ 分前", timeString];
        
    }else if (cha/3600>1 && cha/3600<24) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ 小时前", timeString];
    }
    else
    {
       /* if (needYear) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        else
        {
            [dateFormatter setDateFormat:@"MM-dd"];
        }
        timeString=[dateFormatter stringFromDate:d];*/
        timeString = [NSString stringWithFormat:@"%.0f 天前",cha/3600/24];
    }
    
    return timeString;
}
+ (void)alertError:(NSString*)content
{
    dispatch_async(dispatch_get_main_queue(), ^{
      //  [SVProgressHUD showErrorWithStatus:content];
    });
}
+ (void)alertSuccess:(NSString*)content
{
    dispatch_async(dispatch_get_main_queue(), ^{
       // [SVProgressHUD showSuccessWithStatus:content];
    });
}
- (void)alert:(NSString*)content
{
    [self alert:content delegate:nil];
}
- (void)alert:(NSString*)content delegate:(id)delegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (alertview) {
            [alertview dismissWithClickedButtonIndex:-1 animated:NO];
        }
        alertview =  [[UIAlertView alloc] initWithTitle:UI_language(@"提示", @"tips") message:content delegate:delegate cancelButtonTitle:nil otherButtonTitles:UI_language(@"确定", @"OK"), nil] ;[alertview show];//UI_language(@"取消", @"cancel")
    });
}
/**
 *	保存obj的array到本地，如果已经存在会替换本地。
 *
 *	@param	obj	待保存的obj
 *	@param	key	保存的key
 */
+ (void)saveToArrayDefaults:(id)obj forKey:(NSString*)key
{
    [self saveToArrayDefaults:obj replace:obj forKey:key];
}
+ (void)saveToArrayDefaults:(id)obj replace:(id)oldobj forKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults valueForKey:key];
    
    NSMutableArray *marray = [NSMutableArray array];
    if (!oldobj) {
        oldobj = obj;
    }
    if (array) {
        [marray addObjectsFromArray:array];
        if ([marray containsObject:oldobj]) {
            [marray replaceObjectAtIndex:[marray indexOfObject:oldobj] withObject:obj];
        }else{
            [marray addObject:obj];
        }
    }else{
      [marray addObject:obj];  
    }
    [defaults setValue:marray forKey:key];
    [defaults synchronize];
}

+ (BOOL)removeForArrayObj:(id)obj forKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults valueForKey:key];
    
    NSMutableArray *marray = [NSMutableArray array];
    if (array) {
        [marray addObjectsFromArray:array];
        if ([marray containsObject:obj]) {
            [marray removeObject:obj];
        }
    }
    if (marray.count) {
        [defaults setValue:marray forKey:key];
    }else{
        [defaults removeObjectForKey:key];
    }
    [defaults synchronize];
    return marray.count;
}
/**
 *	保存obj到本地
 *
 *	@param	obj	数据
 *	@param	key	键
 */
+ (void)saveToDefaults:(id)obj forKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:obj forKey:key];
    [defaults synchronize];
}

+ (id)defaultsForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}
+ (void)removeForKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

+(id)uid
{
    return [[Utility Share] userId];
}
-(void)ShowMessage:(NSString *)title msg:(NSString *)msg
{
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
}

-(void)getUserIdByDeviceNum{
    //getgetUserIdByDeviceNum1_1
  /*  [NetEngine createSoapAction:[NSString stringWithFormat:getgetUserIdByDeviceNum1_1,[[Utility Share] deviceNum]] onCompletion:^(id jsonData, BOOL isCache) {
        DLog(@"jsonData:%@",jsonData);
        if ([[jsonData objectForJSONKey:@"status"] integerValue]) {
            [[Utility Share] setUserIdFromDeviceNum:[jsonData objectForJSONKey:@"status"]];
        }
    } onError:^(NSError *error) {
        DLog(@"______________error:%@",error);
    } useCache:NO useMask:SVProgressHUDMaskTypeNone];
    */
}

#pragma mark -
#pragma mark makeCall
- (NSString*) cleanPhoneNumber:(NSString*)phoneNumber
{
    return [[[[phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""]
              stringByReplacingOccurrencesOfString:@"-" withString:@""]
             stringByReplacingOccurrencesOfString:@"(" withString:@""]
            stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    //return number1;
}

- (void) makeCall:(NSString *)phoneNumber
{
    phoneNum=[self cleanPhoneNumber:phoneNumber];
    if ([phoneNum intValue]!=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"拨打号码?"
                                                        message:phoneNum
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"拨打",nil];
        
        [alert show];
    }else {
        [[[UIAlertView alloc] initWithTitle:nil message:@"无效号码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil] show];
        return;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ([alertView.title isEqualToString:@"拨打号码?"]) {//phoneCall AlertView
        if (buttonIndex==1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNum]]];
        }
        phoneNum=nil;
	}
    else if (alertView.tag == 1001) {//版本验证
        UIView *notTouchView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        notTouchView.backgroundColor = [UIColor blackColor];
        notTouchView.alpha = 0.2;
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:notTouchView];
    }
}
- (NSString*)timeToNow:(NSString*)theDate needYear:(BOOL)needYear
{
    if (!theDate) {
        return nil;
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[dateFormatter dateFromString:theDate];
    if (!d) {
        return theDate;
    }
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=(now-late)>0 ? (now-late) : 0;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *dateOfCurrentString = [dateFormatter stringFromDate:d];
    NSString *dateOfYesterdayString = [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]]];
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        if ([timeString intValue]==0) {
            timeString=@"刚刚";
        }else{
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        }
        
    }else if (cha/3600>1 && [todayString isEqualToString:dateOfCurrentString]) {
        [dateFormatter setDateFormat:@"HH:mm"];
        timeString = [dateFormatter stringFromDate:d];
        timeString=[NSString stringWithFormat:@"今天%@", timeString];
    }else if ([dateOfCurrentString isEqualToString:dateOfYesterdayString]){
        [dateFormatter setDateFormat:@"HH:mm"];
        timeString = [dateFormatter stringFromDate:d];
        timeString=[NSString stringWithFormat:@"昨天%@", timeString];
    }
    else
    {
        if (needYear) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        }
        else
        {
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        }
        timeString=[dateFormatter stringFromDate:d];
    }
    
    return timeString;
}

//时间戳
-(NSString *)timeToTimestamp:(NSString *)timestamp{
    if (!timestamp) {
        return @"";
    }    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
     NSDate *aTime = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
    
    NSString *str=[dateFormatter stringFromDate:aTime];
    return str;
}
#pragma login
-(void)isLoginAccount:(NSString *)account pwd:(NSString *)password aLogin:(LoginSuc)aLoginSuc
{
    self.loginSuc = aLoginSuc;
    [self loginWithAccount:account pwd:password];
    
}



- (void)hiddenLoginAlert
{
   // [_loginView hidden];
   //  [[AppDelegate Share].navController dismissModalViewControllerAnimated:YES];
}

#pragma mark 数据更新
-(void)saveUserInfoToDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.userName forKey:default_userName];
    [defaults setValue:self.userPwd forKey:default_pwd];
    [defaults setValue:self.userLogo forKey:default_userLogo];
    [defaults setValue:self.userId forKey:default_userId];
    [defaults setValue:self.userToken forKey:default_userToken];
    [defaults setValue:self.captchCode forKey:default_captchCode];
    [defaults setValue:self.storeId forKey:default_storeId];
    [defaults synchronize];
}
-(void)readUserInfoFromDefault
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self setUserPwd:[defaults valueForKey:default_pwd]];
    [self setUserName:[defaults valueForKey:default_userName]];
    [self setUserLogo:[defaults valueForKey:default_userLogo]];
    [self setUserToken:[defaults valueForKey:default_userToken]];
    [self setUserId:[defaults valueForKey:default_userId]];
    [self setCaptchCode:[defaults valueForKey:default_captchCode]];
    [self setStoreId:[defaults valueForKey:default_storeId]];
    self.isAlertViewFlag=NO;
}
-(void)clearUserInfoInDefault
{
    //
    self.userId=nil;
    self.userName=nil;
    self.userPwd=nil;
    self.userLogo=nil;
    self.userToken=nil;
    self.captchCode = nil;
    self.storeId   = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //消除用户手势
    [defaults removeObjectForKey:default_pwd];
    [defaults removeObjectForKey:default_userLogo];
    [defaults removeObjectForKey:default_userName];
    [defaults removeObjectForKey:default_userId];
    [defaults removeObjectForKey:default_userToken];
    [defaults removeObjectForKey:default_captchCode];
    [defaults removeObjectForKey:default_storeId];
    [defaults synchronize];
    
    //消除用户资料
    [self removeSqlData];
    
}


//清除本地数据库
-(void)removeSqlData{
   // delete from tabname(表名)
   // [ZKSqlData deleteSqlData];
}




-(void)loginWithAccount:(NSString *)account pwd:(NSString *)password
{
    
       NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:account,@"username",password,@"password", nil];
   
}


-(void)registerWithAccount:(NSString *)account pwd:(NSString *)password authorCode:(NSString *)code
{
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

}



+ (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        free(msgBuffer);
        //NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

/**
 *  获取当前时间距1970的时间差
 *
 *  @return 精度为秒的 字符串
 */
- (NSString *)GetUnixTime {
    NSDate *currectDate = [NSDate date];
    NSString *timeStamp = [NSString stringWithFormat:@"%lf",[currectDate timeIntervalSince1970]];
    return [[timeStamp componentsSeparatedByString:@"."] objectAtIndex:0];
}

/**
 *  获取当前时间的格式化字符串
 *
 *  @return 字符串
 */
-(NSString*)GetNowTime {
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    return currentTime;
}

/**
 *  获取某一个时间距1970年的时间差 单位为秒
 *
 *  @param timeFormatStr 时间格式化字符串 yyyy-MM-dd HH:mm:ss
 *
 *  @return 时间差
 */
- (NSTimeInterval)GetTimeIntervalSince1970:(NSString *)timeFormatStr {
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateTime = [formatter dateFromString:timeFormatStr];
    return [dateTime timeIntervalSince1970];
}


//获得分时秒的时间格式
-(NSString*)GetHMSTime {
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmmss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    return currentTime;
}

-(NSString*)GetHMSTimeIntervalSinceNow:(NSTimeInterval)secs {
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmmss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:secs]];
    return currentTime;
}

- (NSString*)ACtime_ChangeTheFormat:(NSString*)theDate
{
    DLog(@"________%@",theDate);
    if (!theDate) {
        return @"";
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
    NSDate *d=[dateFormatter dateFromString:theDate];
    DLog(@"_______________%@",d);
    if (!d) {
        return @"";
    }
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:d];
}

-(NSInteger)ACtimeToNow:(NSString*)theDate
{
    /*
        -1过期
     */
  
    
    if (!theDate) {
        return -1;
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
    NSDate *d=[dateFormatter dateFromString:theDate];
    if (!d) {
        return -1;
    }
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
   // NSString *timeString=@"";
    
    NSTimeInterval cha=(now-late);//>0 ? (now-late) : 0
//    if (cha==0) {
//        return -1;
//    }else{
        return -cha/3600/24;
    //}

   
//    if (cha/3600<1) {
//        timeString = [NSString stringWithFormat:@"%f", cha/60];
//        timeString = [timeString substringToIndex:timeString.length-7];
//        timeString=[NSString stringWithFormat:@"%@ 分前", timeString];
//        
//    }else if (cha/3600>1 && cha/3600<24) {
//        timeString = [NSString stringWithFormat:@"%f", cha/3600];
//        timeString = [timeString substringToIndex:timeString.length-7];
//        timeString=[NSString stringWithFormat:@"%@ 小时前", timeString];
//    }
//    else
//    {
//        /* if (needYear) {
//         [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//         }
//         else
//         {
//         [dateFormatter setDateFormat:@"MM-dd"];
//         }
//         timeString=[dateFormatter stringFromDate:d];*/
//        timeString = [NSString stringWithFormat:@"%.0f 天前",cha/3600/24];
//    }
//    
//    return timeString;
}


#pragma mark AC选中险种
-(NSMutableArray*)addallBFArray:(NSMutableArray*)strarray
{
   
    _ACSelsetBFArray=[[NSMutableArray alloc] init];
    for (int i=0; i<strarray.count; i++) {
        [_ACSelsetBFArray addObject:[strarray objectAtIndex:i]];
    }
    DLog(@"_ACSelsetBFArray:%@",_ACSelsetBFArray)
    return _ACSelsetBFArray;
}
//添加选中险种
-(NSMutableArray*)AddSelectBFArray:(NSString *)strIndex{
    if (!_ACSelsetBFArray) {
        _ACSelsetBFArray=[[NSMutableArray alloc] init];
    }
    [_ACSelsetBFArray addObject:strIndex];
    DLog(@"_ACSelsetBFArray:%@",_ACSelsetBFArray)
    return _ACSelsetBFArray;
}
//移除险种
-(NSMutableArray*)removeSelectBFArray:(NSString *)strIndex{
    [_ACSelsetBFArray removeObject:strIndex];
    DLog(@"_ACSelsetBFArray:%@",_ACSelsetBFArray)
    return _ACSelsetBFArray;
}
//移除所有
-(void)removeAllSelectBF{
    [_ACSelsetBFArray removeAllObjects];
    DLog(@"_ACSelsetBFArray:%@",_ACSelsetBFArray)
}

#pragma mark view
//类似qq聊天窗口的抖动效果
-(void)viewAnimations:(UIView *)aV{
    CGFloat t =5.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    CGAffineTransform translateTop =CGAffineTransformTranslate(CGAffineTransformIdentity,0.0,1);
    CGAffineTransform translateBottom =CGAffineTransformTranslate(CGAffineTransformIdentity,0.0,-1);
    
    aV.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse animations:^{//UIViewAnimationOptionRepeat
        //[UIView setAnimationRepeatCount:2.0];
        aV.transform = translateRight;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.07 animations:^{
            aV.transform = translateBottom;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.07 animations:^{
                aV.transform = translateTop;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    aV.transform =CGAffineTransformIdentity;//回到没有设置transform之前的坐标
                } completion:NULL];
            }];
        }];
//        if(finished){
//            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//                aV.transform =CGAffineTransformIdentity;//回到没有设置transform之前的坐标
//            } completion:NULL];
//        }else{
//            aV.transform = translateTop;
//            
//        }
    }];
}

//view 左右抖动
-(void)leftRightAnimations:(UIView *)view{
    
    CGFloat t =5.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    
    view.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        view.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                view.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
    
}
- (UIView*)tipsView:(NSString*)str;
{
    UIView *v = [[UIView alloc] init];
   // UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_data_hint_ic.png"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 150, 250,80)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor lightGrayColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = str?str:@"暂无数据，敬请期待！";
   // [imageview setCenter:CGPointMake(160, 120)];
   // [v addSubview:imageview];
    [v addSubview:label];
    return v;
}
//圆角或椭圆
-(void)viewLayerRound:(UIView *)view borderWidth:(float)width borderColor:(UIColor *)color{
    // 必須加上這一行，這樣圓角才會加在圖片的「外側」
    view.layer.masksToBounds = YES;
    // 其實就是設定圓角，只是圓角的弧度剛好就是圖片尺寸的一半
    view.layer.cornerRadius =H(view)/ 35.0;
    //边框
    view.layer.borderWidth=width;
    view.layer.borderColor =[color CGColor];
}

-(NSString *)VersionSelect{
     NSString *v = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return v;
}




#pragma mark -数据格式化
//////////////数据格式化
//格式化电话号码
-(NSString *)ACFormatPhone:(NSString *)str{
    if (str.length<10) {
        return str;
    }else{
        NSString *s1=[str substringToIndex:3];
        NSString *s2=[str substringWithRange:NSMakeRange(3, 4)];
        NSString *s3=[str substringFromIndex:7];
        DLog(@"%@,%@,%@",s1,s2,s3);
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@",s1,s2,s3];
        return turntoCarIDString;
    }
}
///格式化手机号
-(NSString *)ACFormatMobile:(NSString *)str{
    if (str.length<10) {//含固定电话
        return str;
    }else{
        NSString *s1=[str substringToIndex:3];
        NSString *s2=[str substringWithRange:NSMakeRange(3, 4)];
        NSString *s3=[str substringFromIndex:7];
        DLog(@"%@,%@,%@",s1,s2,s3);
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@",s1,s2,s3];
        return turntoCarIDString;
    }
}
///格式化身份证号
-(NSString *)ACFormatIDC:(NSString *)str{
    if (str.length==18) {
        NSString *s1=[str substringToIndex:3];
        NSString *s2=[str substringWithRange:NSMakeRange(3, 3)];
        NSString *s3=[str substringWithRange:NSMakeRange(6, 4)];
        NSString *s4=[str substringWithRange:NSMakeRange(10, 4)];
        NSString *s5=[str substringFromIndex:14];
        DLog(@"%@,%@,%@,%@,%@",s1,s2,s3,s4,s5);
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",s1,s2,s3,s4,s5];
        return turntoCarIDString;
    }else if(str.length>=15){
        NSString *s1=[str substringToIndex:(str.length-8)];
        NSString *s4=[str substringWithRange:NSMakeRange((str.length-8), 4)];
        NSString *s5=[str substringFromIndex:(str.length-4)];
        DLog(@"%@,%@,%@",s1,s4,s5);
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@",s1,s4,s5];
        return turntoCarIDString;
    }else{
        return str;
    }
}

//// 格式化组织机构代码证
-(NSString *)ACFormatOCC:(NSString *)str{
    if (str.length<9) {
        return str;
    }else{
        NSString *s1=[str substringToIndex:4];
        NSString *s2=[str substringWithRange:NSMakeRange(4, 4)];
        NSString *s3=[str substringFromIndex:8];
        DLog(@"%@,%@,%@",s1,s2,s3);
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@",s1,s2,s3];
        return turntoCarIDString;
    }
}
////格式化车牌号
-(NSString *)ACFormatPlate:(NSString *)str{
    if (str.length<7) {
        return str;
    }else{
        NSString *s1=[str substringToIndex:(str.length-5)];
        NSString *s2=[str substringWithRange:NSMakeRange((str.length-5), 5)];
        DLog(@"%@,%@",s1,s2);
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@",s1,s2];
        return turntoCarIDString;
    }
}
//格式化vin
-(NSString *)ACFormatVin:(NSString *)str{
    if (str.length<17) {
        return str;
    }
    else
    {
        NSString *s1=[str substringToIndex:4];
        NSString *s2=[str substringWithRange:NSMakeRange(4, 4)];
        NSString *s3=[str substringWithRange:NSMakeRange(8, 1)];
        NSString *s4=[str substringWithRange:NSMakeRange(9, 4)];
        NSString *s5=[str substringWithRange:NSMakeRange(13, 4)];
        DLog(@"%@,%@,%@,%@,%@",s1,s2,s3,s4,s5);
        NSString *turntoVinString=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",s1,s2,s3,s4,s5];
        return turntoVinString;
    }
}
//------数字格式化----------------
-(NSString*)ACFormatNumStr:(NSString*)nf
{
    float f=[nf floatValue];
    DLog(@"%f",f);//
    NSNumberFormatter * formatter=[[NSNumberFormatter alloc]init];
    formatter.numberStyle=kCFNumberFormatterCurrencyStyle;
    NSString *turnstr=[formatter stringFromNumber:[NSNumber numberWithFloat:f]];
  
    
    DLog(@"turnstr=%@_______",turnstr);
    
    turnstr=[turnstr substringFromIndex:1];
    
    DLog(@"turnstr=%@___asdfasdfas____",turnstr);
    return turnstr;
}

//格式化身份证号
-(NSString *)ACFormatIDC_DH:(NSString *)str{
    if (str.length==18) {
        NSString *s1=[str substringToIndex:3];
        NSString *s2=[str substringWithRange:NSMakeRange(3, 3)];
        NSString *s3=[str substringWithRange:NSMakeRange(6, 4)];
        NSString *s4=[str substringWithRange:NSMakeRange(10, 4)];
        NSString *s5=[str substringFromIndex:14];
        DLog(@"%@,%@,%@,%@,%@",s1,s2,s3,s4,s5);
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",s1,s2,@"****",@"****",@"****"];
        return turntoCarIDString;
    }else if(str.length>=15){
        NSString *s1=[str substringToIndex:(str.length-8)];
        NSString *s4=[str substringWithRange:NSMakeRange((str.length-8), 4)];
        NSString *s5=[str substringFromIndex:(str.length-4)];
        DLog(@"%@,%@,%@",s1,s4,s5);
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@",s1,@"****",@"****"];
        return turntoCarIDString;
    }else{
        return str;
    }
}
//格式化vin2
-(NSString *)ACFormatVin_DH:(NSString *)str{
    if (str.length<17) {
        return str;
    }
    else
    {
        NSString *s1=[str substringToIndex:4];
        NSString *s2=[str substringWithRange:NSMakeRange(4, 4)];
        NSString *s3=[str substringWithRange:NSMakeRange(8, 1)];
        NSString *s4=[str substringWithRange:NSMakeRange(9, 4)];
        NSString *s5=[str substringWithRange:NSMakeRange(13, 4)];
        DLog(@"%@,%@,%@,%@,%@",s1,s2,s3,s4,s5);
        NSString *turntoVinString=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",s1,@"****",s3,@"****",s5];
        return turntoVinString;
    }
}


//获取KeyStr
-(NSString*)GetPriviteKey:(NSString *)PriviteKey GetResourceId:(NSString *)ResourceId GetPayLoad:(NSString *)PayLoad GetTimeStamp:(NSString*)TimeStamp;
{
    NSString *EndStr  = [NSString stringWithFormat:@"%@%@%@%@",PriviteKey,ResourceId,TimeStamp,PayLoad].md5;
    return EndStr;
}

//图片转Base64
-(NSString*)image2DataURL:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr =  [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];    
    return encodedImageStr;
}

//Base64转图片
-(NSData*)Data2Image:(NSString*)string
{
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return imageData;
}


//字符串转Base64

-(NSString*)toBase64String:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUnicodeStringEncoding];
    data = [data base64EncodedDataWithOptions:0];
    NSString *endStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return endStr;
}


- (NSString *)base64Decode:(NSString *)base64String
{
    NSData *plainTextData = [NSData dataFromBase64String:base64String];
    NSString *plainText = [[NSString alloc] initWithData:plainTextData encoding:NSUTF8StringEncoding];
    return plainText;
}

- (NSString *)base64Encode:(NSString *)plainText
{
    NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    //NSString *base64String = [plainTextData base64EncodedString];// 加/n
    NSString *base64String = [plainTextData base64EncodedStringWithOptions:0];
    return base64String;
}


//验证身份证

- (BOOL) validateIdentityCard: (NSString *)identityCard;
{
    BOOL flag;
    if (identityCard.length <= 0)
    {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


@end
