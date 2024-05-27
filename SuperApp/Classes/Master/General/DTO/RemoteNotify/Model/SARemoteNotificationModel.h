//
//  SARemoteNotificationModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SARemoteNotificationActionModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SARemoteNotificationAPSAlertModel : NSObject
/// 标题
@property (nonatomic, copy) NSString *title;
/// 内容
@property (nonatomic, copy) NSString *body;
@end


@interface SARemoteNotificationAPSModel : NSObject
/// alert
@property (nonatomic, strong) SARemoteNotificationAPSAlertModel *alert;
/// 内容
@property (nonatomic, assign) BOOL mutableContent;
/// 消息 ID
@property (nonatomic, assign) BOOL contentAvailable;
@end


@interface SARemoteNotificationModel : SAModel
/// 标题
@property (nonatomic, copy) NSString *msgTitle;
/// google.c.a.e
@property (nonatomic, copy) NSString *googleCAE;
/// 设备 ID
@property (nonatomic, copy) NSString *deviceNo;
/// 消息内容
@property (nonatomic, copy) NSString *msgBody;
/// aps
@property (nonatomic, strong) SARemoteNotificationAPSModel *aps;
/// 模板号
@property (nonatomic, copy) NSString *templateNo;
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 流水号
@property (nonatomic, copy) NSString *sendSerialNumber;
///< bizId
@property (nonatomic, copy) NSString *bizId;
/// 跳转地址
@property (nonatomic, copy) NSString *linkAddress;
@property (nonatomic, copy) NSString *aggregateOrderNo; ///< 聚合订单号
///推送行为
@property (nonatomic, strong) SARemoteNotificationActionModel *pushAction;
///< 推送渠道
@property (nonatomic, copy) NSString *pushChannel;
///< 1
@property (nonatomic, assign) BOOL newStrategy;
/// 扫码点餐订单id
@property (nonatomic, copy) NSString *orderId;
/// 意见详情id
@property (nonatomic, copy) NSString *suggestionInfoId;

//****************** voip相关 **************************/

///是否为voip推送
@property (nonatomic, copy) NSString *voipType;
/// 是否为拒绝
@property (nonatomic, assign) BOOL isRejected;
/// 拒绝人
@property (nonatomic, copy) NSString *rejectorOperatorNo;
/// voip channel
@property (nonatomic, copy) NSString *channel;
///< 头像
@property (nonatomic, copy) NSString *avatarUrl;
///< token
@property (nonatomic, copy) NSString *token;
///< nickname
@property (nonatomic, copy) NSString *nickname;

//****************** voip相关 **************************/

@end

NS_ASSUME_NONNULL_END
