//
//  WMReviewFilterButtonConfig.h
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMReviewFilterButtonConfig : WMModel
/// 标题
@property (nonatomic, copy) NSString *title;
/// 类型
@property (nonatomic, copy) WMReviewFilterType type;
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;

+ (instancetype)configWithTitle:(NSString *)title type:(WMReviewFilterType)type;
@end

NS_ASSUME_NONNULL_END
