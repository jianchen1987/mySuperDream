//
//  WMOrderDetailViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailViewModel.h"
#import "SAPaymentDTO.h"
#import "SAQueryPaymentStateRspModel.h"
#import "WMOrderDetailCancelOrderRspModel.h"
#import "WMOrderDetailDTO.h"
#import "WMOrderDetailDeliveryRiderRspModel.h"
#import "WMOrderDetailRspModel.h"
#import "WMStoreShoppingCartDTO.h"


@interface WMOrderDetailViewModel ()
/// 订单详情 DTO
@property (nonatomic, strong) WMOrderDetailDTO *orderDetailDTO;
/// 购物车DTO
@property (nonatomic, strong) WMStoreShoppingCartDTO *storeShoppingCartDTO;

@property (nonatomic, strong) SAPaymentDTO *paymentDto; ///<
@end


@implementation WMOrderDetailViewModel

- (CMNetworkRequest *)getOrderDetailSuccess:(void (^)(WMOrderDetailRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    return [self.orderDetailDTO getOrderDetailWithOrderNo:self.orderNo success:^(WMOrderDetailRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.orderDetailRspModel = rspModel;
        !successBlock ?: successBlock(rspModel);
    } failure:failureBlock];
}

- (CMNetworkRequest *)getDeliverManLocationWithDeliveryManId:(NSString *)deliveryRiderId
                                                     success:(void (^)(WMOrderDetailDeliveryRiderRspModel *rspModel))successBlock
                                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    return [self.orderDetailDTO getDeliverManLocationWithDeliveryManId:deliveryRiderId success:^(WMOrderDetailDeliveryRiderRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.deliveryRiderRspModel = rspModel;
        !successBlock ?: successBlock(rspModel);
    } failure:failureBlock];
}

- (CMNetworkRequest *)userCancelOrderWithCancelReason:(nullable WMOrderCancelReasonModel *)model
                                              success:(void (^)(WMOrderDetailCancelOrderRspModel *rspModel))successBlock
                                              failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    return [self.orderDetailDTO userCancelOrderWithOrderNo:self.orderNo cancelReason:model success:successBlock failure:failureBlock];
}

- (CMNetworkRequest *)userUrgeOrderSuccess:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    return [self.orderDetailDTO userUrgeOrderWithOrderNo:self.orderNo success:successBlock failure:failureBlock];
}

- (BOOL)shouldHideMap {
    WMOrderDetailRspModel *orderDetailRspModel = self.orderDetailRspModel;
    WMBusinessStatus bizStatus = orderDetailRspModel.orderDetailForUser.bizState;
    // 如果在售后、已完成、已评价状态，隐藏地图
    WMOrderDetailRefundState refundState = orderDetailRspModel.orderDetailForUser.refundInfo.refundState;
    BOOL hasAsOrderInfo = !HDIsObjectNil(orderDetailRspModel.orderDetailForUser.refundInfo) && refundState != WMOrderDetailRefundStateUnknown;
    BOOL isOnlineWaitingPay = orderDetailRspModel.orderDetailForUser.paymentMethod == SAOrderPaymentTypeOnline && bizStatus == WMBusinessStatusWaitingInitialized;
    if (hasAsOrderInfo || isOnlineWaitingPay || bizStatus == WMBusinessStatusDeliveryArrived || bizStatus == WMBusinessStatusOrderCancelling || bizStatus == WMBusinessStatusOrderCancelled
        || bizStatus == WMBusinessStatusCompleted || bizStatus == WMBusinessStatusUserRefundApplying) {
        return true;
    }
    //自取的时候隐藏地图
    if (self.orderDetailRspModel.orderDetailForUser.serviceType == 20) {
        return true;
    }

    return false;
}

- (void)getNewData {
    @HDWeakify(self);
    self.requestState = 1;
    [self getOrderDetailSuccess:^(WMOrderDetailRspModel *_Nonnull rspModel) {
        // 如果有骑手 id 并且是未完成状态，获取骑手位置
        @HDStrongify(self);
        self.requestState = 2;
        self.hasGotInitializedData = true;
        if (HDIsStringNotEmpty(rspModel.orderDetailForUser.deliveryInfo.rider.riderId) && !self.shouldHideMap) {
            [self getDeliverManLocationWithDeliveryManId:rspModel.orderDetailForUser.deliveryInfo.rider.riderId success:nil failure:nil];
            // 配送时，检测麦克风权限，避免骑手无法联系
            [self microphoneDetection];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.requestState = 3;
    }];

    [self getTGBindComplete:^(NSString *_Nullable bindURL) {
        @HDStrongify(self);
        NSString *str = bindURL;
        if (HDIsStringNotEmpty(str) && ![str hasPrefix:@"http"]) {
            str = [@"https://" stringByAppendingString:str];
        }
        self.TGBotLink = str;
    }];
}


- (void)microphoneDetection {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    // 已禁止麦克风权限，用户选择是否去开启
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        // 弹窗提示
        [NAT showAlertWithTitle:nil message:SALocalizedString(@"alert_open_microphone", @"大象App需要使用您的麦克风，以便骑手能够及时联系您。")
            confirmButtonTitle:SALocalizedString(@"O3N3zScm", @"去开启") confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                [alertView dismiss];
                //跳转到系统设置开启麦克风
                [HDSystemCapabilityUtil openAppSystemSettingPage];
            }
            cancelButtonTitle:SALocalizedStringFromTable(@"confirm", @"稍后设置", @"Buttons") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                [alertView dismiss];
            }];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted){

        }];
    }
}


- (void)getTGBindComplete:(void (^_Nullable)(NSString *_Nullable bindURL))successBlock {
    [self.orderDetailDTO WMCheckTGBindWithBlock:successBlock];
}

- (void)getOrderPaymentStateSuccess:(void (^_Nullable)(SAQueryPaymentStateRspModel *rspModel))success failure:(CMNetworkFailureBlock _Nullable)failure {
    [self.paymentDto queryOrderPaymentStateWithOrderNo:self.orderNo success:success failure:failure];
}

- (void)userCancelOrderReasonSuccess:(void (^)(NSArray<WMOrderCancelReasonModel *> *rspModel, BOOL error))successBlock {
    [self.orderDetailDTO userCancelOrderReasonWithOrderNo:self.orderNo success:^(NSArray<WMOrderCancelReasonModel *> *_Nonnull rspModel) {
        !successBlock ?: successBlock(rspModel, rspModel ? NO : YES);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !successBlock ?: successBlock(nil, YES);
    }];
}

#pragma mark - getter
- (NSString *)storeNo {
    return self.orderDetailRspModel.merchantStoreDetail.storeNo;
}

#pragma mark - lazy load
- (WMOrderDetailDTO *)orderDetailDTO {
    if (!_orderDetailDTO) {
        _orderDetailDTO = WMOrderDetailDTO.new;
    }
    return _orderDetailDTO;
}

- (WMStoreShoppingCartDTO *)storeShoppingCartDTO {
    if (!_storeShoppingCartDTO) {
        _storeShoppingCartDTO = WMStoreShoppingCartDTO.new;
    }
    return _storeShoppingCartDTO;
}

/** @lazy paymentDto */
- (SAPaymentDTO *)paymentDto {
    if (!_paymentDto) {
        _paymentDto = [[SAPaymentDTO alloc] init];
    }
    return _paymentDto;
}

@end
