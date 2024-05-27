//
//  TNHorizontalSpecsView.h
//  SuperApp
//
//  Created by 张杰 on 2022/7/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"
@class TNProductSpecPropertieModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNHorizontalSpecsView : TNView
/// 规格值：黑色，红色
@property (nonatomic, strong) NSArray<TNProductSpecPropertieModel *> *specValues;
///
@property (nonatomic, copy) void (^selectedItemCallBack)(TNProductSpecPropertieModel *model);
@end

NS_ASSUME_NONNULL_END
