//
//  TNCheckRegionModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/5/10.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *TNReginTipsCode NS_STRING_ENUM;
/// 有合适的店铺
FOUNDATION_EXPORT TNReginTipsCode const TNReginTipsCodeHasStoreArea;
/// 没有有合适的店铺
FOUNDATION_EXPORT TNReginTipsCode const TNReginTipsCodeNotStoreArea;


@interface TNRedZoneReginTipsModel : TNModel
/// 店铺id
@property (nonatomic, copy) NSString *storeNo;
/// 店铺名称
@property (nonatomic, copy) NSString *storeName;
/// NOT_STORE_AREA //没有合适的店铺   ,HAS_STORE_AREA 有合适的店铺
@property (nonatomic, copy) TNReginTipsCode tipsCode;
/// 提示标题
@property (nonatomic, copy) NSString *tipsInfo;
/// 配送范围
@property (nonatomic, copy) NSString *deliveryArea;
/// 商家位置
@property (nonatomic, copy) NSString *storeAddress;
@end


@interface TNCheckRegionModel : TNModel
/// 店铺id
@property (nonatomic, copy) NSString *storeNo;
/// 是否可以送到
@property (nonatomic, assign) BOOL deliveryValid;
/// 不能送到提示
@property (nonatomic, copy) NSString *tipsInfo;
/// 是否酒水店铺
@property (nonatomic, assign) BOOL takeawayStore;
/// 红区酒水店铺提示文案
@property (strong, nonatomic) TNRedZoneReginTipsModel *regionTipsInfoDTO;
@end

NS_ASSUME_NONNULL_END
