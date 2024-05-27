//
//  PNMSVoucherDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSVoucherDTO.h"
#import "PNMSVoucherRspModel.h"
#import "PNRspModel.h"
#import "VipayUser.h"


@implementation PNMSVoucherDTO

/// 查询门店上传凭证纪录列表
- (void)getVoucherList:(NSDictionary *)param success:(void (^)(PNMSVoucherRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/app/mer/store-voucher/query";

    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:param];
    [paramDict setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];

    request.requestParameter = paramDict;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNMSVoucherRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 新增一条门店上传凭证记录
- (void)saveVoucher:(NSDictionary *)dict success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/app/mer/store-voucher/add";

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dict];
    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取凭证详情
- (void)getVoucherDetail:(NSString *)voucherId success:(void (^)(PNMSVoucherInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/app/mer/store-voucher/detail";

    request.requestParameter = @{
        @"id": voucherId,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNMSVoucherInfoModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
