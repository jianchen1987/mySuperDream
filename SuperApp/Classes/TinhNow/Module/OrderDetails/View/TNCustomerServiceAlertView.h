//
//  TNCustomerServiceAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNCustomerServiceAlertView : HDActionAlertView
/// 联系客服弹窗
/// @param content 显示文本
/// @param storeNo 店铺id
/// @param orderNo 订单id
+ (instancetype)alertViewWithContentText:(NSString *)content storeNo:(NSString *)storeNo orderNo:(NSString *)orderNo;
@end

NS_ASSUME_NONNULL_END
