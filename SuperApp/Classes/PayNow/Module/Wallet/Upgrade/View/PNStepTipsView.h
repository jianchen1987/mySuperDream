//
//  PNStepTipsView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/1/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNEnum.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNStepTipsView : PNView
/// 升级账户 使用这个属性来设置
@property (nonatomic, assign) NSInteger step;

/// 升级账户结果页 使用这个属性来设置
@property (nonatomic, assign) PNAccountLevelUpgradeStatus upgradeStatus;
@end

NS_ASSUME_NONNULL_END
