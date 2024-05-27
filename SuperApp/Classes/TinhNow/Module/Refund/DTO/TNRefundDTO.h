//
//  TNRefundDTO.h
//  SuperApp
//
//  Created by xixi on 2021/1/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

@class TNRefundCommonDictModel, TNRefundSimpleOrderInfoModel, TNRefundDetailsModel;

NS_ASSUME_NONNULL_BEGIN


@interface TNRefundDTO : TNModel

/// 取消申请退款
- (void)cancelApplyRefundWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询退款记录
- (void)getRefundDetailsWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(TNRefundDetailsModel *refundDetailsModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 申请退款
- (void)postApplyInfoData:(NSDictionary *)paramsDic success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 通过订单ID获取订单信息
- (void)getSimpleOrderInfoByOrderId:(NSString *)orderNo success:(void (^_Nullable)(TNRefundSimpleOrderInfoModel *orderInfoModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取字典数据
- (void)getCommonDataDictByTypes:(NSArray *)types success:(void (^_Nullable)(TNRefundCommonDictModel *commonDictModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
