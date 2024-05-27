//
//  SAMessageDetailRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMessageDetailRspModel : SARspModel
/// 消息标题
@property (nonatomic, strong) SAInternationalizationModel *messageName;
/// 业务id* System Message-站内信
@property (nonatomic, copy) NSString *bizNo;
/// 消息id
@property (nonatomic, copy) NSString *messageNo;
/// 消息发送流水号
@property (nonatomic, copy) NSString *sendSerialNumber;
/// 消息内容
@property (nonatomic, strong) SAInternationalizationModel *messageContent;
/// 发送时间
@property (nonatomic, copy) NSString *sendTime;
@end

NS_ASSUME_NONNULL_END
