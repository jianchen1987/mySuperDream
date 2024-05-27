//
//  TNShippingMethodModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN
@class SAInternationalizationModel;


@interface TNShippingMethodModel : TNModel
/// 配送方式id
@property (nonatomic, copy) NSString *shippingMethodId;
/// 图标
@property (nonatomic, copy) NSString *icon;
/// 名称
@property (nonatomic, strong) SAInternationalizationModel *name;
/// 描述
@property (nonatomic, copy) NSString *desc;
@end

NS_ASSUME_NONNULL_END
