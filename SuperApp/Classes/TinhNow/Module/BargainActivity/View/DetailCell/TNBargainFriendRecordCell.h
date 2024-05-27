//
//  TNBargainFriendRecordCell.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNHelpPeolpleRecordeModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainFriendRecordCell : SATableViewCell
/// 助力任务类型
@property (nonatomic, assign) TNBargainTaskType bargainType;
/// 助力人模型
@property (strong, nonatomic) TNHelpPeolpleRecordeModel *model;
@end

NS_ASSUME_NONNULL_END
