//
//  WMPromotionLabel.h
//  SuperApp
//
//  Created by Chaos on 2020/9/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "WMUIButton.h"
#import <HDUIKit/HDUIKit.h>

@class WMStoreDetailPromotionModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMPromotionLabel : NSObject

+ (WMUIButton *)createFastServiceBtn;

+ (WMUIButton *)createFastServiceBtnWithNewStyle;

+ (WMUIButton *)createWMFastServiceBtn;

+ (WMUIButton *)createBtnWithBackGroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor title:(NSString *)title;

+ (WMUIButton *)createBtnWithBackGroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor title:(NSString *)title alpha:(CGFloat)alpha;

+ (WMUIButton *)createBtnWithBackGroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor title:(NSString *)title alpha:(CGFloat)alpha border:(nullable UIColor *)borderColor;
/// 是否超过最大限购数量(例：最大限购为3，超过（不包含） 4 时返回YES，其余都返回NO)
/// 正好为4时会自动弹toast提示，外部无需再次提示
/// promotions 判断是否存在互斥活动（不与首单/平台折扣/平台满减/门店满减同享）
+ (BOOL)showToastWithMaxCount:(NSUInteger)maxCount currentCount:(NSUInteger)currentCount otherSkuCount:(NSUInteger)otherSkuCount promotions:(NSArray<WMStoreDetailPromotionModel *> *)promotions;

+ (WMUIButton *)createBtnWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
