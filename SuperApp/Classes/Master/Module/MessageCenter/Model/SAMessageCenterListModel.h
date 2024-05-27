//
//  SAMessageCenterListCellModel.h
//  SuperApp
//
//  Created by seeu on 2021/7/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"
#import "SASystemMessageModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMessageCenterListModel : SACodingModel
/// 类型  10-营销消息,11- 个人消息
@property (nonatomic, copy) NSString *businessMessageType;
/// 未读数
@property (nonatomic, assign) NSInteger unReadNumber;
/// 列表
@property (nonatomic, copy) NSArray<SASystemMessageModel *> *messageRespList;

@end

NS_ASSUME_NONNULL_END
