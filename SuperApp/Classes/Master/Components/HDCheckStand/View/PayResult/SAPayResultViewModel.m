//
//  SAPayResultViewModel.m
//  SuperApp
//
//  Created by seeu on 2020/9/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAPayResultViewModel.h"
#import "SACouponRedemptionDTO.h"
#import "SAGuardian.h"
#import "SAPaymentDTO.h"
#import "SAQueryPaymentStateRspModel.h"
#import "SAUserCenterDTO.h"


@interface SAPayResultViewModel ()

/// paymentDTO
@property (nonatomic, strong) SAPaymentDTO *paymentDTO;
/// couponRedemptionDTO
@property (nonatomic, strong) SACouponRedemptionDTO *couponRedemptionDTO;

/// 查询结果
@property (nonatomic, strong, nullable) SAQueryPaymentStateRspModel *resultModel;
/// 领券结果
@property (nonatomic, strong, nullable) SACouponRedemptionRspModel *couponRspModel;
///< 用户中心DTO
@property (nonatomic, strong) SAUserCenterDTO *userDTO;
@end


@implementation SAPayResultViewModel

- (void)getNewData {
    @HDWeakify(self);
    [self queryOrderPaymentStateSuccess:^(SAQueryPaymentStateRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.resultModel = rspModel;
    } failure:nil];
}

- (void)queryOrderPaymentStateSuccess:(void (^)(SAQueryPaymentStateRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    [self.paymentDTO queryOrderPaymentStateWithOrderNo:self.orderNo success:successBlock failure:failureBlock];
}

- (void)autoCouponRedemptionSuccess:(void (^)(SACouponRedemptionRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [SAGuardian getTokenWithTimeout:5000 completeHandler:^(NSString *_Nonnull token, NSInteger code, NSString *_Nonnull message) {
        @HDStrongify(self);
        [self p_autoCouponRedemptionWithRiskToken:token success:successBlock failure:failureBlock];
    }];
}

- (void)p_autoCouponRedemptionWithRiskToken:(NSString *_Nullable)riskToken success:(void (^)(SACouponRedemptionRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.couponRedemptionDTO autoCouponRedemptionWithOrderNo:self.orderNo businessLine:self.businessLine channel:@"111" riskToken:riskToken success:^(SACouponRedemptionRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.couponRspModel = rspModel;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        self.couponRspModel = nil;
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}

- (void)queryHowManyWPontWillGetWithThisOrderCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.userDTO queryHowManyWPointWillGetWithOrderNo:self.orderNo businessLine:self.businessLine actuallyPaidAmount:self.resultModel.actualPayAmount merchantNo:self.merchantNo
        success:^(SAWPontWillGetRspModel *_Nullable rspModel) {
            @HDStrongify(self);
            self.wpointRspModel = rspModel;
            !completion ?: completion();
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            self.wpointRspModel = nil;
            !completion ?: completion();
        }];
}

#pragma mark - lazy load
- (SAPaymentDTO *)paymentDTO {
    if (!_paymentDTO) {
        _paymentDTO = [[SAPaymentDTO alloc] init];
    }
    return _paymentDTO;
}

- (SACouponRedemptionDTO *)couponRedemptionDTO {
    if (!_couponRedemptionDTO) {
        _couponRedemptionDTO = [[SACouponRedemptionDTO alloc] init];
    }
    return _couponRedemptionDTO;
}

- (SAUserCenterDTO *)userDTO {
    if (!_userDTO) {
        _userDTO = SAUserCenterDTO.new;
    }
    return _userDTO;
}

@end
