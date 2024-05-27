//
//  TNBargainSpecTagsCell.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class TNProductSpecificationModel;
@class TNProductSpecPropertieModel;


@interface TNBargainSpecTagsCell : SATableViewCell
/// 规格项
@property (nonatomic, strong) TNProductSpecificationModel *model;
/// 选择回调
@property (nonatomic, copy) void (^specValueSelected)(TNProductSpecPropertieModel *specValueModel, TNProductSpecificationModel *model);
@end

NS_ASSUME_NONNULL_END
