//
//  PNHandOutModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNHandOutModel : PNModel
/// 拆分类型，10:拼手气, 11:平均金额
@property (nonatomic, assign) PNPacketSplitType splitType;
/// 红包类型，10:普通红包, 11:口令红包
@property (nonatomic, assign) PNPacketType packetType;
/// 接收对象，10:内部用户, 11:外部用户
@property (nonatomic, assign) PNPacketGrantObject grantObject;
/// 口令类型，10:系统推荐口令, 11:自定义口令
@property (nonatomic, assign) PNPacketKeyType keyType;
/// 单个红包或者红包金额
@property (nonatomic, copy) NSString *amt;
/// 红包数量
@property (nonatomic, assign) NSInteger qty;
/// 接收人手机号
@property (nonatomic, strong) NSArray *receivers;
/// 币种
@property (nonatomic, strong) PNCurrencyType cy;
/// 红包图片
@property (nonatomic, copy) NSString *imageUrl;
/// 祝福语
@property (nonatomic, copy) NSString *remarks;

///
@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *ip;

/// 根据输入的值amt(khr) 换算成 usd
@property (nonatomic, assign) CGFloat usd;
@end

NS_ASSUME_NONNULL_END
