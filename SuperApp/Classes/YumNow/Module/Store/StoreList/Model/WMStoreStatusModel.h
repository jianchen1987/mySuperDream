//
//  WMStoreStatusModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMEnumModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreStatusModel : WMEnumModel
/// 状态
@property (nonatomic, copy) WMStoreStatus status;
@end

NS_ASSUME_NONNULL_END
