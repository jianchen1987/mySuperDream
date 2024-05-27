//
//  SAAddressSearchRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddressSearchItem.h"
#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAddressSearchRspModel : SAModel
/// 所有地址
@property (nonatomic, strong) SAAddressSearchItem *result;
@property (nonatomic, copy) NSString *status; ///<
@end

NS_ASSUME_NONNULL_END
