//
//  PNApartmentDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentDTO.h"
#import "PNRspModel.h"
#import "PNApartmentComfirmRspModel.h"


@implementation PNApartmentDTO

///根据订单号查询订单列表
- (void)getApartmentOrderListData:(NSString *)feesNo success:(void (^)(NSArray<PNApartmentListItemModel *> *rspArray))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = [PNCAMNetworRequest new];
    request.requestURI = @"/fees/app/apartmentPayInfo/selectOrderListByOrderNo.do";

    request.requestParameter = @{
        @"feesNo": feesNo,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:PNApartmentListItemModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询公寓待缴费账单列表
- (void)getApartmentListData:(NSString *)startTime
                     endTime:(NSString *)endTime
                 currentPage:(NSInteger)pageNo
                      status:(NSArray *)statusArray
                     success:(void (^)(PNApartmentListRspModel *rspModel))successBlock
                     failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = [PNCAMNetworRequest new];
    request.requestURI = @"/fees/app/apartmentPayInfo/selectApartmentBillList.do";

    request.requestParameter = @{
        @"paymentStatus": statusArray,
        @"pageNum": @(pageNo),
        @"pageSize": @(20),
        @"startTime": startTime,
        @"endTime": endTime,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNApartmentListRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询账单基本信息
- (void)getApartmentInfoWithNo:(NSString *)paymentId
                        feesNo:(NSString *)feesNo
                       success:(void (^)(PNApartmentListItemModel *rspModel))successBlock
                       failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = [PNCAMNetworRequest new];
    request.requestURI = @"/fees/app/apartmentPayInfo/selectApartmentBillDetail.do";

    request.requestParameter = @{
        @"paymentSlipNo": paymentId,
        @"feesNo": feesNo,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNApartmentListItemModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 立即缴费
- (void)preCheckThePayment:(NSArray *)feesNo success:(void (^)(PNApartmentComfirmRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = [PNCAMNetworRequest new];
    request.requestURI = @"/fees/app/apartmentPayInfo/payTheFees.do";

    request.requestParameter = @{
        @"feesNo": feesNo,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNApartmentComfirmRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 确认缴费
- (void)comfirmThePayment:(NSArray *)feesNo success:(void (^)(PNApartmentComfirmRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = [PNCAMNetworRequest new];
    request.requestURI = @"/fees/app/apartmentPayInfo/confirmThePayment.do";

    request.requestParameter = @{
        @"feesNo": feesNo,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNApartmentComfirmRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 拒绝缴费信息
- (void)refuseApartment:(NSString *)pNo remark:(NSString *)remark success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = [PNCAMNetworRequest new];
    request.requestURI = @"/fees/app/apartmentPayInfo/refuseFeesApartmentPayment.do";

    request.requestParameter = @{
        @"id": pNo,
        @"remark": remark,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 用户已上传凭证
- (void)uploadVoucherApartment:(NSString *)pNo
                        remark:(NSString *)remark
                 voucherImgUrl:(NSString *)voucherImgUrl
                       success:(void (^)(PNRspModel *rspModel))successBlock
                       failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = [PNCAMNetworRequest new];
    request.requestURI = @"/fees/app/apartmentPayInfo/recodeFeesApartmentPayment.do";

    request.requestParameter = @{@"paymentId": pNo, @"remark": remark, @"voucherImgUrl": voucherImgUrl};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
