//
//  WMStoreThemeModel.h
//  SuperApp
//
//  Created by wmz on 2022/3/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMStoreDetailPromotionModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreThemeModel : WMModel
/// storeName
@property (nonatomic, copy) NSString *storeName;
///优惠活动
@property (nonatomic, copy) NSArray<WMStoreDetailPromotionModel *> *promotions;
/// storeNo
@property (nonatomic, copy) NSString *storeNo;
/// images
@property (nonatomic, copy) NSString *images;
/// logo
@property (nonatomic, copy) NSString *logo;
///评分
@property (nonatomic, assign) CGFloat reviewScore;
///优化标签卡顿
@property (nonatomic, strong) NSMutableAttributedString *tagString;
/// 是否是新店
@property (nonatomic, assign) BOOL isNew;

@end

NS_ASSUME_NONNULL_END
