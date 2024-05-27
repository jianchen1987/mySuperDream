//
//  TNPaymentMethodView.h
//  SuperApp
//
//  Created by 谢泽锋 on 2020/9/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"
@class TNPaymentMethodModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNPaymentMethodView : TNView
/// 模型数据
@property (strong, nonatomic) TNPaymentMethodModel *model;
/// 点击事件
@property (nonatomic, copy) void (^clickPaymentCallBack)(TNPaymentMethodModel *payMethodModel);
@end

NS_ASSUME_NONNULL_END
