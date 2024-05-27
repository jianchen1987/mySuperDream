//
//  WMPromotionItemView.h
//  SuperApp
//
//  Created by Chaos on 2020/7/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMOrderRelatedEnum.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMPromotionItemView : SAView

/// 类型
@property (nonatomic, assign) WMStorePromotionMarketingType itemType;
/// 显示内容
@property (nonatomic, copy) NSString *showTips;
/// 显示图标
@property (nonatomic, strong) UIImage *showImage;
/// 隐藏左边文字
@property (nonatomic, assign) BOOL hideLeftBTN;

- (void)setColor:(UIColor *)color title:(NSString *)title;

- (void)setGradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor title:(NSString *)title imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
