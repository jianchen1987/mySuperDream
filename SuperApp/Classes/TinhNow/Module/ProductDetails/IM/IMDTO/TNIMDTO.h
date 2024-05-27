//
//  TNIMDTO.h
//  SuperApp
//
//  Created by xixi on 2021/1/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "TNIMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNIMDTO : SAModel

/// 获取商户客服列表
/// @param storeNo 店铺ID
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryCustomerList:(NSString *)storeNo success:(void (^_Nullable)(NSArray<TNIMRspModel *> *rspModelArray))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
