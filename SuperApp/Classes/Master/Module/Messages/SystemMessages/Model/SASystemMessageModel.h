//
//  SASystemMessageModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMessageAction : SAModel
@property (nonatomic, copy) NSString *title;  ///< 按钮名称
@property (nonatomic, copy) NSString *action; ///< 跳转地址
@end


@interface SASystemMessageModel : SAModel
/// 消息标题
@property (nonatomic, strong) SAInternationalizationModel *messageName;
/// 是否已读 10:未读,11:已读
@property (nonatomic, assign) SAStationLetterReadStatus readStatus;
/// 业务id* System Message-站内信
@property (nonatomic, copy) NSString *bizNo;
/// 扩展字段，json格式
@property (nonatomic, copy) NSString *expand;
/// 消息id
@property (nonatomic, copy) NSString *messageNo;
/// 消息发送流水号
@property (nonatomic, copy) NSString *sendSerialNumber;
/// 消息内容
@property (nonatomic, strong) SAInternationalizationModel *messageContent;
/// 消息类型，10-短消息，11-富文本
@property (nonatomic, assign) SAAppInnerMessageContentType messageContentType;
/// 发送时间
@property (nonatomic, copy) NSString *sendTime;
/// 跳转链接（系统消息才有）
@property (nonatomic, copy) NSString *linkAddress;
@property (nonatomic, copy) SAClientType businessLine; ///< 业务线

/// 是否显示底部线条
@property (nonatomic, assign) BOOL showBottomLine;
@property (nonatomic, assign) SAMessageType messageType;              ///< 消息类型
@property (nonatomic, copy) NSString *headPicture;                    ///< 头图
@property (nonatomic, strong) NSArray<SAMessageAction *> *buttonList; ///< 按钮列表
@end

NS_ASSUME_NONNULL_END
