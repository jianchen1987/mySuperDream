//
//  HDPaymentMethodType.h
//  SuperApp
//
//  Created by seeu on 2021/12/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "HDCheckStandEnum.h"
#import "HDOnlinePaymentToolsModel.h"
#import "SACodingModel.h"
#import "SAEnum.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDPaymentMethodType : SACodingModel

///< 支付方式
@property (nonatomic, assign) SAOrderPaymentType method;
///< 支付工具名称
@property (nonatomic, copy, readonly) NSString *toolName;
///< 支付工具编码
@property (nonatomic, copy) HDCheckStandPaymentTools toolCode;
///< 支付营销活动No
@property (nonatomic, copy, nullable) NSString *ruleNo;
///< 营销信息
@property (nonatomic, strong) NSArray<NSString *> *marketing;
/// 副标题
@property (nonatomic, copy) NSString *subToolName;
/// 副图标路径
@property (nonatomic, copy) NSString *subIcon;
/// 图标路径
@property (nonatomic, copy) NSString *icon;
/// 是否可用，不可用置灰
@property (nonatomic, assign) BOOL isShow;

+ (instancetype)onlineMethodWithPaymentTool:(HDCheckStandPaymentTools)toolCode;

+ (instancetype)onlineMethodWithPaymentTool:(HDCheckStandPaymentTools)toolCode marketing:(nullable NSArray<NSString *> *)marking;

+ (instancetype)onlineMethodWithPaymentModel:(HDOnlinePaymentToolsModel *)paymentModel;

+ (instancetype)online;
+ (instancetype)cashOnDelivery;
+ (instancetype)cashOnTransfer;
+ (instancetype)qrCodePay;

+ (instancetype)cashOnDeliveryForbidden;
+ (instancetype)cashOnDeliveryForbiddenByToStore;

@end

NS_ASSUME_NONNULL_END
