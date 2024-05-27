//
//  WMSpecialBrandModel.h
//  SuperApp
//
//  Created by wmz on 2022/3/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMSpecialBrandModel : WMRspModel
///名称
@property (nonatomic, strong) SAInternationalizationModel *name;
/// logo
@property (nonatomic, strong) SAInternationalizationModel *logo;
/// link
@property (nonatomic, copy) NSString *link;
/// 爆单状态 10正常 20爆单 30爆单停止接单
@property (nonatomic, assign) WMStoreFullOrderState fullOrderState;
/// 出餐慢状态 10正常 20出餐慢
@property (nonatomic, assign) WMStoreSlowMealState slowMealState;
/// 展示出来的时间
@property (nonatomic, copy) NSString *showTime;

@end

NS_ASSUME_NONNULL_END
