//
//  SALotteryQualificationRspModel.h
//  SuperApp
//
//  Created by seeu on 2021/8/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAEnumModel.h"
#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SALotteryQualificationRspModel : SARspModel

@property (nonatomic, assign) NSUInteger count;        ///< 可以抽奖次数
@property (nonatomic, copy) NSString *lotteryThemeUrl; ///< 弹窗图片
@property (nonatomic, copy) NSString *activityUrl;     ///< 活动链接

@end

NS_ASSUME_NONNULL_END
