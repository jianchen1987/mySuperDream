//
//  WMOrderDetailOperationEventModel.h
//  SuperApp
//
//  Created by VanJay on 2020/7/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailOperationEventModel : WMModel
/// 可操作名称
@property (nonatomic, copy) NSString *orderOperation;
@end

NS_ASSUME_NONNULL_END
