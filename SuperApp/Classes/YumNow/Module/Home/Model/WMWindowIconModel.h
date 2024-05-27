//
//  WMWindowIconModel.h
//  SuperApp
//
//  Created by Chaos on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

@class SAInternationalizationModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMWindowItemModel : WMModel

/// 图片
@property (nonatomic, copy) NSString *imageUrl;
/// 事件
@property (nonatomic, copy) NSString *actionUrl;
/// 名称
@property (nonatomic, strong) SAInternationalizationModel *name;
/// 排序
@property (nonatomic, assign) int sort;

@end

NS_ASSUME_NONNULL_END
