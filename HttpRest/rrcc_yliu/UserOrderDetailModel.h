//
//  UserOrderDetailModel.h
//  rrcc_yh
//
//  Created by user on 15/7/2.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "BaseModel.h"

@interface UserOrderDetailModel : BaseModel

@property (nonatomic, copy) NSString * id; //  订单 ID //  订单 ID  // 记录 ID
@property (nonatomic, copy) NSString * ordercode; // 订单号
@property (nonatomic, copy) NSString * inserttime;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * status_title;

@property (nonatomic, copy) NSString * payment;
@property (nonatomic, copy) NSString * payment_title;

@property (nonatomic, copy) NSString * delivery;
@property (nonatomic, copy) NSString * delivery_title;

@property (nonatomic, copy) NSString * has_deliveried;
@property (nonatomic, copy) NSString * has_paid;
@property (nonatomic, copy) NSString * has_dispatched;
@property (nonatomic, copy) NSString * siteid; // 小区 ID
@property (nonatomic, copy) NSString * order_contact;
@property (nonatomic, copy) NSString * order_tel;
@property (nonatomic, copy) NSString * order_domain;
@property (nonatomic, copy) NSString * order_address;
@property (nonatomic, copy) NSString * clientname;
@property (nonatomic, copy) NSString * logo;
@property (nonatomic, copy) NSString * pushid;
@property (nonatomic, copy) NSString * stime;
@property (nonatomic, copy) NSString * contact;
@property (nonatomic, copy) NSString * tel;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * svtime;
@property (nonatomic, copy) NSString * etime;
@property (nonatomic, copy) NSString * score;
@property (nonatomic, copy) NSString * confirmtime;
@property (nonatomic, copy) NSString * deliverytime;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * isappraise;
@property (nonatomic, copy) NSString * presell_discount;//优惠
@property (nonatomic, copy) NSString * discount;
@property (nonatomic, copy) NSString * gift;
@property (nonatomic, copy) NSString * voucher;
@property (nonatomic, copy) NSString * voucherid; // 红包 ID
@property (nonatomic, copy) NSString * custprice;// 合计总价
@property (nonatomic, copy) NSString * payprice;// 配送费
@property (nonatomic, copy) NSString * price;// 原始价格
@property (nonatomic, copy) NSString * ordercount;
@property (nonatomic, copy) NSString * appointment;
@property (nonatomic, copy) NSString * clientid; // 商户 ID


@property (nonatomic, copy) NSString * userid; // 用户 ID
@property (nonatomic, copy) NSString * domain; // 小区名字
@property (nonatomic, copy) NSString * delivery_fee;


@property (nonatomic, copy) NSString *client_id; // 商户 ID
@property (nonatomic, copy) NSString *dislogo;
@property (nonatomic, copy) NSString *disname;
@property (nonatomic, copy) NSString *orderid; //  订单 ID
@property (nonatomic, copy) NSString *tolprice;

@property (nonatomic, copy) NSString *transaction_id;// 预支付


@property (nonatomic, strong) NSMutableArray *productItemList;

@property (nonatomic, strong) NSMutableArray *actionList;
@property (nonatomic, strong) NSMutableArray *statusList;

@end

/* - creat order - <1>
 address = "\U6c11\U6da6\U5927\U53a6";
 appointment = "2015-09-06 18:00:00";
 clientid = 21;
 contact = "Mr Lou";
 custprice = "52.50";
 delivery = 2;
 "delivery_fee" = "0.00";
 discount = "0.00";
 distributerid = 0;
 domain = "\U6d77\U5c1a\U5eb7\U5ead";
 gift = "";
 id = 4146;
 ordercode = 153600004146;
 ordercount = 3;
 payment = 2;
 price = "52.50";
 siteid = 139808;
 status = 0;
 tel = 13012810811;
 userid = 75;

 */

/*  - update order - <2>
 address = "\U822a\U534e\U4e8c\U6751";
 appointment = "2015-6-5 15:40:40";
 clientid = 8;
 clientname = "\U4faf\U6c0f\U83dc\U6bbf";
 confirmtime = "2015-04-07 11:55:55";
 contact = "\U8001\U4faf";
 custprice = "39.72";
 delivery = 2;
 deliverytime = "2015-04-07 12:00:34";
 discount = "0.00";
 etime = "23:00:00";
 gift = "";
 "has_deliveried" = 0;
 "has_dispatched" = 0;
 "has_paid" = 0;
 id = 209;
 inserttime = "2015-04-05 11:22:36";
 isappraise = 0;
 logo = "http://img.renrencaichang.com/images/default.png";
 "order_address" = null;
 "order_contact" = null;
 "order_domain" = "\U822a\U534e\U4e8c\U6751\U4e8c\U8857\U574a";
 "order_tel" = null;
 ordercode = 51340209;
 ordercount = 3;
 payment = 2;
 payprice = "0.00";
 "presell_discount" = 0;
 price = "41.00";
 pushid = "<null>";
 remark = "";
 score = "4.67";
 siteid = 132143;
 status = 1;
 stime = "00:00:00";
 svtime = "2015-04-05 13:45:00";
 tel = 18918275561;
 voucher = 0;
 voucherid = "";
 */

/*  - order list -
 //address = "\U6d77\U5c1a\U5eb7\U5ead \U963f\U62c9\U4f2f";
 //"client_id" = 21;
 //confirmtime = "<null>";
 //contact = "\U5c0f\U662d";
 //delivery = 2;
 //deliverytime = "<null>";
 //dislogo = "http://img.renrencaichang.com/images/7237BCE5-6A1E-9AEB-E198-9D9E065FFCE9.jpg";
 //disname = "\U5218\U5c0f\U6c9b";
 //"has_deliveried" = 0;
 //"has_dispatched" = 0;
 //"has_paid" = 1;
 //inserttime = "2015-07-20 10:15:22";
 //isappraise = 0;
 //ordercode = 152900002557;
 //orderid = 2557;
 //payment = 2;
 //payprice = "0.00";
 //price = "33.00";
 //remark = "";
 //status = 1;
 //svtime = "2015-07-20 11:15:22";
 //tel = 17701619893;
 //tolprice = "33.00";

 */
