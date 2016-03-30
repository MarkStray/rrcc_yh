//
//  AliPayHeader.h
//  rrcc_yh
//
//  Created by user on 15/9/5.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#ifndef rrcc_yh_AliPayHeader_h
#define rrcc_yh_AliPayHeader_h

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"


#define aAppId @"2015081300213630"

/*
 *商户的唯一的parnter和seller。
 *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
 */

//商户PID
#define aPartnerID          @"2088911426319321"

//商户收款账号
#define aSellerID           @"Shirley@renrencaichang.com"

// 商户私钥 pkcs8格式
#define aPrivateKey         @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMwjcr1fSYVshw4qiGphIbbmpBA9OclWeth2MeKpDKqAs0gDUFdq66xQhtyjDNYrAqNQZkuu88AMpR1dRFMAJNSsNu+/G+ewQZUm5rB7fer4HDOynYZSp1OO8/sPliJ9kJRLo5Jatb2NdhPGCBAFam8AtuRiPMiLy/oMT8ZZ30j3AgMBAAECgYAxnqQzN8gtMFYbsWb7RKTnSmSytc8oC2dM2l4B1EmJ4EKzzGpo9UpX1jMRymhCXq4DeHWFC/+fvPMdkiAbdLt+rrB5LDIisGV/+wHX26OTiayeLWmSf6t5gb84v599pQW7aOGyUFUW7D6xxtXjZT3ZORjftvtRMTpbQaYHCRxjMQJBAP0InQWBXEcH4UajaDhJcn7w2bWpLVHO0v0Yce7HQof8Rol+uR6rkAti46xrzAm1BitkOeZOjYoFd3k5nMd1J70CQQDOiBgW+7k8KUXRg1tUibBIDlS3cDgSRC+/pW9etQNvLWHuzTbLnxjicEyFGBFHgiNEC7f0Dj1gZ5dOH9NieFTDAkEA8Y4beHn6AcVABhNRFwrmxtBexdFvdj2fpgaEHZMTrIXlQLU9PE5EANqyxpNSAaJS9XGE5Jvw+uYlHBEn3jG1cQJBAIow38WJGvFZQGEmvlZ7ZptgE2lGSg5W14gpHrLE9Y5PVGbfotluE813jIvFhdJODmC6YpSHbqPxzHi2rM8HatcCQQDCQoJPlYBVNwockSWXoaUqSPkuBSFDxmg63x2xegZViE17sUxHRR4RlwN1HSjmSXAgyUw7wwzwbiDDrMNbbR7h"

//-----BEGIN ENCRYPTED PRIVATE KEY-----
//-----END ENCRYPTED PRIVATE KEY-----

// 支付宝公钥
#define aPublicKey          @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"


#endif
