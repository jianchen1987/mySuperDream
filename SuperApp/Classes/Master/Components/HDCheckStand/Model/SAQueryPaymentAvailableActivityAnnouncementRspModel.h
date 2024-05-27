//
//  SAQueryPaymentAvailableActivityAnnouncementRspMode.h
//  SuperApp
//
//  Created by seeu on 2022/5/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAQueryPaymentAvailableActivityAnnouncementRspModel : SARspInfoModel
///< 公告数据
@property (nonatomic, strong) NSArray<NSString *> *bulletinList;
@end

NS_ASSUME_NONNULL_END
