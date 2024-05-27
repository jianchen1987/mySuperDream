//
//  TNPaymentMethodCell.h
//  SuperApp
//
//  Created by 谢泽锋 on 2020/9/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNPaymentMethodModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNPaymentMethodCellModel : TNModel
///可用的支付方式
@property (nonatomic, strong) NSArray<TNPaymentMethodModel *> *methods;
@end


@interface TNPaymentMethodCell : SATableViewCell
///选中的支付方式
//@property (nonatomic, strong) TNPaymentMethodModel *selectModel;
///可用的支付方式
@property (nonatomic, strong) NSArray<TNPaymentMethodModel *> *dataSource;
/// 选择了item回调
@property (nonatomic, copy) void (^selectedItemHandler)(TNPaymentMethodModel *model);

@end

NS_ASSUME_NONNULL_END
