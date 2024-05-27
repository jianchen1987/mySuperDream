//
//  WMStoreProductDetailDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

@class WMStoreProductDetailRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreProductDetailDTO : WMModel

/// 获取门店商品详情
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getStoreProductDetailInfoWithGoodsId:(NSString *)goodsId
                                                   success:(void (^_Nullable)(WMStoreProductDetailRspModel *rspModel))successBlock
                                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
