//
//  WMOrderSubmitPromotionItemView.h
//  SuperApp
//
//  Created by Chaos on 2020/7/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMOrderRelatedEnum.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitPromotionItemView : SAView
///
@property (nonatomic, assign) WMStorePromotionMarketingType marketingType;
/// 左标题
@property (nonatomic, copy) NSString *leftTitle;
/// 右标题
@property (nonatomic, copy) NSString *rightTitle;
/// 1 从提交订单页来 2 从订单详情来
@property (nonatomic, assign) NSInteger from;
/// 点击事件
@property (nonatomic, copy) void (^blockOnClickPromotion)(void);

@end

NS_ASSUME_NONNULL_END
