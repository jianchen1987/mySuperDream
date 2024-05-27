//
//  GNModel.h
//  SuperApp
//
//  Created by wmz on 2021/5/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNModel : SARspModel
///定位
@property (nonatomic, copy) NSDictionary *locationInfo;
@end

NS_ASSUME_NONNULL_END
