//
//  PNMSStepView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStepItemModel.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSStepView : PNView

/// 设置数据源
/// @param listModel 数据源
/// @param step 第几个步骤【主要控制虚线颜色】
- (void)setModelList:(NSArray<PNMSStepItemModel *> *)listModel step:(NSInteger)step;
@end

NS_ASSUME_NONNULL_END
