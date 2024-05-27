//
//  TNPaymentMethodModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDPaymentMethodType.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN
@class SAInternationalizationModel;


@interface TNPaymentMethodModel : TNModel
/// 支付方式枚举
@property (nonatomic, copy) TNPaymentMethod method;
/// 支付对应的id
@property (nonatomic, copy) NSString *methodValue;
/// 内容
@property (nonatomic, copy) NSString *content;
/// 支付方式id
@property (nonatomic, copy) NSString *paymentMethodId;
/// 类型
@property (nonatomic, copy) NSString *type;
/// 描述
@property (nonatomic, copy) NSString *desc;
/// 名称
@property (nonatomic, strong) SAInternationalizationModel *name;
/// 图表
@property (nonatomic, copy) NSString *icon;
/// 底部图标
@property (nonatomic, strong) NSArray<NSString *> *bottomIcons;
/// 超时时间
@property (nonatomic, assign) NSTimeInterval timeout;

/// 是否选中
@property (nonatomic, assign) BOOL isSelected;
/// 支付营销优惠
@property (strong, nonatomic) NSArray *marktingInfos;

/// 选中的在线支付渠道
@property (strong, nonatomic) HDPaymentMethodType *selectedOnlineMethodType;
/// 选中支付方式的 - 图片名字
@property (nonatomic, copy, readonly) NSString *selectOnlineMethodTypeImageName;
@end

NS_ASSUME_NONNULL_END
