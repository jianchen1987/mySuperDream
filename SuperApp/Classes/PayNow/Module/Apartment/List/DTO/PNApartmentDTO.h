//
//  PNApartmentDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "PNApartmentListRspModel.h"
#import "PNApartmentComfirmRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNApartmentDTO : PNModel
///根据订单号查询订单列表
- (void)getApartmentOrderListData:(NSString *)feesNo success:(void (^)(NSArray<PNApartmentListItemModel *> *rspArray))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询公寓待缴费账单列表
- (void)getApartmentListData:(NSString *)startTime
                     endTime:(NSString *)endTime
                 currentPage:(NSInteger)pageNo
                      status:(NSArray *)statusArray
                     success:(void (^)(PNApartmentListRspModel *rspModel))successBlock
                     failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询账单基本信息
- (void)getApartmentInfoWithNo:(NSString *)paymentId feesNo:(NSString *)feesNo success:(void (^)(PNApartmentListItemModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 拒绝缴费信息
- (void)refuseApartment:(NSString *)pNo remark:(NSString *)remark success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 用户已上传凭证
- (void)uploadVoucherApartment:(NSString *)pNo
                        remark:(NSString *)remark
                 voucherImgUrl:(NSString *)voucherImgUrl
                       success:(void (^)(PNRspModel *rspModel))successBlock
                       failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 立即缴费
- (void)preCheckThePayment:(NSArray *)feesNo success:(void (^)(PNApartmentComfirmRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 确认缴费
- (void)comfirmThePayment:(NSArray *)feesNo success:(void (^)(PNApartmentComfirmRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
