//
//  SAAddressCacheAdaptor.h
//  SuperApp
//
//  Created by Chaos on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddressModel.h"
#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAddressCacheAdaptor : SAModel

/// 缓存地址
/// @param clientType 业务线  maste存储为真实地址，yum存储为手切地址
/// @param addressModel 模型
+ (void)cacheAddressForClientType:(SAClientType)clientType addressModel:(SAAddressModel *_Nullable)addressModel;

/// 获取缓存地址
/// @param clientType 业务线
+ (SAAddressModel *)getAddressModelForClientType:(SAClientType)clientType;

/// 清空外卖选择的一次性地址
+ (void)removeYumAddress;

@end

NS_ASSUME_NONNULL_END
