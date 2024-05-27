//
//  TNBargainPeopleRecordRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/3/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNPagingRspModel.h"
#import "TNHelpPeolpleRecordeModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainPeopleRecordRspModel : TNPagingRspModel
/// 助力人总数
@property (nonatomic, assign) NSInteger peopleAmount;
/// 助力人记录列表
@property (strong, nonatomic) NSArray<TNHelpPeolpleRecordeModel *> *items;
@end

NS_ASSUME_NONNULL_END
