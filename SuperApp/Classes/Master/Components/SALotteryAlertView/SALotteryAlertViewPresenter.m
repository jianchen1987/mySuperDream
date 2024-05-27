//
//  SALotteryAlertViewPresenter.m
//  SuperApp
//
//  Created by seeu on 2021/8/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SALotteryAlertViewPresenter.h"
#import "CMNetworkRequest.h"
#import "SALotteryAlertView.h"
#import "SALotteryQualificationRspModel.h"
#import "SAUser.h"
#import <HDKitCore/HDCommonDefines.h>


@implementation SALotteryAlertViewPresenter

+ (void)showLotteryAlertViewWithOrderNo:(NSString *_Nonnull)orderNo completion:(void (^_Nullable)(void))completion;
{
    CMNetworkRequest *request = [[CMNetworkRequest alloc] init];
    request.retryCount = 1;
    request.requestURI = @"/app/activity/lottery/record/aggregateOrder.do";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"aggregateOrderNo"] = orderNo;
    params[@"operatorNo"] = [SAUser.shared operatorNo];
    request.requestParameter = params;
    @HDWeakify(self);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        SARspModel *rspModel = response.extraData;
        if (rspModel.data) {
            SALotteryQualificationRspModel *result = [SALotteryQualificationRspModel yy_modelWithJSON:rspModel.data];
            if (result.count > 0) {
                [self showAlertViewWithModel:result];
            }
        }
        !completion ?: completion();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !completion ?: completion();
    }];
}

+ (void)showAlertViewWithModel:(SALotteryQualificationRspModel *)model {
    SALotteryAlertViewConfig *config = SALotteryAlertViewConfig.new;
    config.count = model.count;
    config.lotteryThemeUrl = model.lotteryThemeUrl;
    config.url = model.activityUrl;
    SALotteryAlertView *alertView = [SALotteryAlertView alertViewWithConfig:config];
    alertView.identitableString = model.activityUrl;
    [alertView show];
}

@end
