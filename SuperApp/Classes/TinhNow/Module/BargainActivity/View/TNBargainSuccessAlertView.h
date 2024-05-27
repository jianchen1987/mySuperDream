//
//  TNBargainSuccessAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2021/3/1.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNBargainDetailModel.h"
#import "TNEnum.h"
#import <HDUIKit/HDUIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainSuccessAlertView : HDActionAlertView
/// 发起我的助力回调
@property (nonatomic, copy) void (^beginMyBargainClick)(void);
/// 查看我的优惠券
@property (nonatomic, copy) void (^viewNowCouponListClick)(void);

/// 创建砍价成功弹窗
/// @param price 砍价金额  可传空  不展示
/// @param showTips 显示文案
/// @param couponArray 优惠券数组
+ (instancetype)alertViewWithBargainPrice:(NSString *)price showTips:(NSString *)showTips coupon:(NSArray<TNCouponModel *> *)couponArray;

@end

NS_ASSUME_NONNULL_END
