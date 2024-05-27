//
//  TNExpressTrackingContentView.h
//  SuperApp
//
//  Created by 张杰 on 2021/9/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"
@class TNExpressDetailsModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNExpressTrackingContentView : TNView <HDCategoryListContentViewDelegate>

/// 运单详情视图
/// @param model 包裹详情模型
/// @param isFreeshipping 是否免邮
- (instancetype)initWithExpressModel:(TNExpressDetailsModel *)model isFreeshipping:(BOOL)isFreeshipping;
@end

NS_ASSUME_NONNULL_END
