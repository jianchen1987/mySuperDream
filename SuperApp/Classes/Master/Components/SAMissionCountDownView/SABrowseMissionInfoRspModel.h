//
//  SABrowseMissionInfoRspModel.h
//  SuperApp
//
//  Created by seeu on 2023/6/27.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SABrowseMissionInfoRspModel : SARspInfoModel

@property (nonatomic, copy) NSString *specifyUrl;
///< 是否可展示
@property (nonatomic, assign) BOOL hasBrowseTask;
///< 浏览时间
@property (nonatomic, assign) NSInteger browseTime;
///<
@property (nonatomic, copy) NSString *browseType;
///< 任务id
@property (nonatomic, copy) NSString *taskNo;

@end

NS_ASSUME_NONNULL_END
