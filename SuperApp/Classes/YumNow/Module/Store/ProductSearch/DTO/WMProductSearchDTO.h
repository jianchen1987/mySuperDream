//
//  WMProductSearchDTO.h
//  SuperApp
//
//  Created by Chaos on 2020/11/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMProductSearchRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMProductSearchDTO : WMModel

/// 门店内商品搜索
/// @param storeNo 门店号
/// @param keyword 搜索内容
/// @param pageNum 页码
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)searchProductInStore:(NSString *)storeNo
                                   keyword:(NSString *)keyword
                                   pageNum:(NSUInteger)pageNum
                                   success:(void (^)(WMProductSearchRspModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
