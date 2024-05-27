//
//  TNSpecialActivityDTO.m
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSpecialActivityDTO.h"
#import "TNActivityCardRspModel.h"
#import "TNCategoryModel.h"
#import "TNRedZoneActivityModel.h"
#import <NSArray+HDKitCore.h>


@implementation TNSpecialActivityDTO

- (void)querySpecialActivityDetailWithActivityId:(NSString *)activityId success:(void (^)(TNSpeciaActivityDetailModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/productSpecial/detail";
    request.isNeedLogin = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = activityId;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNSpeciaActivityDetailModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryGoodCategoryDataWithActivityId:(NSString *)activityId success:(void (^)(NSArray<TNCategoryModel *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/es/product/searchCategoryBySpecial";
    //    @"/api/merchant/productSpecial/categoryList/v2";
    request.isNeedLogin = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"specialId"] = activityId;
    if ([SAUser hasSignedIn]) {
        params[@"loginName"] = SAUser.shared.loginName;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;

        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:[TNCategoryModel class] json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)querySpeciaActivityCardWithActivityId:(NSString *)activityId success:(void (^)(TNActivityCardRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/advertisement/v3/list.do";
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"clientType"] = activityId;
    if ([SAUser hasSignedIn]) {
        params[@"loginName"] = SAUser.shared.loginName;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        TNActivityCardRspModel *cardRspModel = [TNActivityCardRspModel yy_modelWithJSON:rspModel.data];
        //异步处理数据
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableArray *sortArr = [NSMutableArray arrayWithArray:cardRspModel.list];
            [sortArr sortUsingComparator:^NSComparisonResult(TNActivityCardModel *obj1, TNActivityCardModel *obj2) {
                return obj1.sort > obj2.sort;
            }];
            NSArray *filterArr = [sortArr hd_filterWithBlock:^BOOL(TNActivityCardModel *item) {
                return item.cardStyle == TNActivityCardStyleText || item.cardStyle == TNActivityCardStyleBanner || item.cardStyle == TNActivityCardStyleScorllItem
                       || item.cardStyle == TNActivityCardStyleSixItem || item.cardStyle == TNActivityCardStyleMultipleBanners || item.cardStyle == TNActivityCardStyleSquareScorllItem;
            }];
            if (!HDIsArrayEmpty(filterArr)) {
                for (int i = 0; i < filterArr.count; i++) {
                    TNActivityCardModel *model = filterArr[i];
                    model.scene = TNActivityCardSceneTopic;
                    //                        if (i == filterArr.count - 1 && model.cardStyle != TNActivityCardStyleText) {
                    //                            model.rectCorner = TNActivityCardRectCornerBottom;  //目前设置这个值 是为了给底部增加间距  以后改
                    //                        }
                }
            }
            cardRspModel.list = filterArr;
            cardRspModel.scene = TNActivityCardSceneTopic;
            dispatch_async(dispatch_get_main_queue(), ^{
                !successBlock ?: successBlock(cardRspModel);
            });
        });
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryRedZoneSpeciaActivityIdWithLongitude:(NSNumber *)longitude
                                         latitude:(NSNumber *)latitude
                                          success:(void (^)(TNRedZoneActivityModel *_Nonnull))successBlock
                                          failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/productSpecial/getSpecialByAddress";
    if (longitude && latitude) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"longitude"] = longitude ? longitude.stringValue : @"";
        params[@"latitude"] = latitude ? latitude.stringValue : @"";
        request.requestParameter = params;
    }
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNRedZoneActivityModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
