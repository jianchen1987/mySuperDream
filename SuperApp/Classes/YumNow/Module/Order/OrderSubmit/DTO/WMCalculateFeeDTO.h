//
//  WMCalculateFeeDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

@class WMOrderSubmitCalDeliveryFeeRspModel;
@class WMCalculateProductPriceRspModel;
@class SAMoneyModel;
@class WMCalculateProductPriceGoodsItem;
@class WMOrderSubscribeTimeModel;

NS_ASSUME_NONNULL_BEGIN

/// 计算各种费用 DTO
@interface WMCalculateFeeDTO : WMModel

/// 计算配送费和出餐时间
/// @param storeNo 门店号
/// @param longitude 经度
/// @param latitude 纬度
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getDeliveryFeeAndDeliveryTimeWithStoreNo:(NSString *)storeNo
                                                     longitude:(NSString *)longitude
                                                      latitude:(NSString *)latitude
                                             deliveryTimeModel:(WMOrderSubscribeTimeModel *)deliveryTimeModel
                                                       success:(void (^)(WMOrderSubmitCalDeliveryFeeRspModel *rspModel))successBlock
                                                       failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 商品-规格金额核算或检查
/// @param type 类型 10:核算，11：检查
/// @param packingChargesTotalPrice type 为 11 需传，打包费
/// @param goodsList 商品列表
/// @param productTotalPrice type 为 11 需传，打包费
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)calculateOrCheckProductPriceWithType:(NSUInteger)type
                                  packingChargesTotalPrice:(SAMoneyModel *_Nullable)packingChargesTotalPrice
                                                 goodsList:(NSArray<WMCalculateProductPriceGoodsItem *> *)goodsList
                                         productTotalPrice:(SAMoneyModel *_Nullable)productTotalPrice
                                                   success:(void (^)(WMCalculateProductPriceRspModel *rspModel))successBlock
                                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
