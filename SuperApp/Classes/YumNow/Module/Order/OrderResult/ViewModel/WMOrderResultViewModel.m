//
//  WMOrderResultViewModel.m
//  SuperApp
//
//  Created by Chaos on 2021/1/12.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMOrderResultViewModel.h"
#import "SACouponRedemptionDTO.h"
#import "SAGuardian.h"


@interface WMOrderResultViewModel ()

/// couponRedemptionDTO
@property (nonatomic, strong) SACouponRedemptionDTO *couponRedemptionDTO;

/// 领券结果
@property (nonatomic, strong) SACouponRedemptionRspModel *couponRspModel;
@end


@implementation WMOrderResultViewModel

- (void)autoCouponRedemptionSuccess:(void (^)(SACouponRedemptionRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [SAGuardian getTokenWithTimeout:5000 completeHandler:^(NSString *_Nonnull token, NSInteger code, NSString *_Nonnull message) {
        @HDStrongify(self);
        [self p_autoCouponRedemptionWithRiskToken:token Success:successBlock failure:failureBlock];
    }];
}

- (void)p_autoCouponRedemptionWithRiskToken:(NSString *)riskToken Success:(void (^)(SACouponRedemptionRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.couponRedemptionDTO autoCouponRedemptionWithOrderNo:self.orderNo businessLine:SAClientTypeYumNow channel:@"111" riskToken:riskToken success:^(SACouponRedemptionRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.couponRspModel = rspModel;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}

#pragma mark - lazy load
- (SACouponRedemptionDTO *)couponRedemptionDTO {
    if (!_couponRedemptionDTO) {
        _couponRedemptionDTO = [[SACouponRedemptionDTO alloc] init];
    }
    return _couponRedemptionDTO;
}

@end
