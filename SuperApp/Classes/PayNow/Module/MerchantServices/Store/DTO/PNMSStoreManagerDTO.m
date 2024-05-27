//
//  PNMSStoreManagerDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreManagerDTO.h"
#import "PNMSStoreAllOperatorModel.h"
#import "PNMSStoreInfoModel.h"
#import "PNMSStoreOperatorInfoModel.h"
#import "PNMSStoreOperatorRspModel.h"
#import "PNRspModel.h"
#import "VipayUser.h"


@implementation PNMSStoreManagerDTO

/// 获取门店列表数据
- (void)getStoreListData:(void (^)(NSArray<PNMSStoreInfoModel *> *rspArray))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/merchant/app/mer/role/queryMerStore.do";

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];

    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSArray *arr = [NSArray yy_modelArrayWithClass:PNMSStoreInfoModel.class json:rspModel.data];
        !successBlock ?: successBlock(arr);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取门店详情
- (void)getStoreDetailWithStoreNo:(NSString *)storeNo success:(void (^)(PNMSStoreInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/merchant/app/mer/role/queryMerStoreDetail.do";

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];
    [params setValue:storeNo forKey:@"storeNo"];

    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNMSStoreInfoModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 新增或者编辑 门店信息
- (void)saveOrUpdateStore:(NSDictionary *)dict success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/merchant/app/mer/role/addAndUpdateStore.do";

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dict];
    [params setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];

    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取门店操作员列表
- (void)getOperatorListWithStoreNo:(NSString *)storeNo success:(void (^)(PNMSStoreOperatorRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    return [self getOperatorListWithStoreNo:storeNo currentPage:-1 success:successBlock failure:failureBlock];
}

/// 获取门店操作员列表 - 带page
- (void)getOperatorListWithStoreNo:(NSString *)storeNo
                       currentPage:(NSInteger)currentPage
                           success:(void (^)(PNMSStoreOperatorRspModel *rspModel))successBlock
                           failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/merchant/app/mer/role/selectClerkList.do";

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];
    [params setValue:storeNo forKey:@"storeNo"];

    if (currentPage > 0) {
        [params setValue:@(currentPage) forKey:@"pageNo"];
        [params setValue:@(20) forKey:@"pageSize"];
    }

    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNMSStoreOperatorRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查找门店操作员详情
- (void)getStoreOperatorDetail:(NSString *)storeOperatorId success:(void (^)(PNMSStoreOperatorInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/merchant/app/mer/role/selectClerkDetail.do";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];
    [params setValue:VipayUser.shareInstance.accountNo forKey:@"accountNo"];
    [params setValue:storeOperatorId forKey:@"id"];

    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNMSStoreOperatorInfoModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 保存编辑门店操作员
- (void)saveOrUpdateStoreOperator:(NSDictionary *)dict success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/merchant/app/mer/role/saveAndUpdateClerk.do";

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dict];
    [params setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];
    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 通过手机号码反查 账号信息
- (void)getCCAmountWithMobile:(NSString *)mobile success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/info/query.do";
    request.requestParameter = @{
        @"payeeMobile": mobile,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询所有门店和操作员
- (void)getStoreAllOperator:(void (^_Nullable)(NSArray<PNMSStoreAllOperatorModel *> *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/merchant/app/mer/role/selectStoreAllStaff.do";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = @{};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSDictionary *dict = rspModel.data;
        NSArray *storeListArray;
        if ([dict.allKeys containsObject:@"storeList"]) {
            storeListArray = [NSArray yy_modelArrayWithClass:PNMSStoreAllOperatorModel.class json:[dict objectForKey:@"storeList"]];
        }
        !successBlock ?: successBlock(storeListArray ?: @[]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
