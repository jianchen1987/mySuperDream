//
//  WMOrderSubmitPaymentMethodCellModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitPaymentMethodCellModel : WMModel
/// 标题
@property (nonatomic, copy) NSString *title;
/// 描述
@property (nonatomic, copy) NSString *subTitle;
/// 图片 logo 本地名
@property (nonatomic, copy) NSArray<NSString *> *imageNames;
/// 是否要顶部线
@property (nonatomic, assign) BOOL needTopLine;
/// 是否要底部线
@property (nonatomic, assign) BOOL needBottomLine;
/// 付款方式
@property (nonatomic, copy) WMOrderAvailablePaymentType paymentType;
@end

NS_ASSUME_NONNULL_END
