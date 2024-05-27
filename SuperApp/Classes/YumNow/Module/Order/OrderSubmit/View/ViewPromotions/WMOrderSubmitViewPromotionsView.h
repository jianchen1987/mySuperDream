//
//  WMOrderSubmitViewPromotionsView.h
//  SuperApp
//
//  Created by VanJay on 2020/7/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class WMOrderSubmitPromotionModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitViewPromotionsView : SAView <HDCustomViewActionViewProtocol>
/// 活动列表，不包含减配送费活动
@property (nonatomic, copy) NSArray<WMOrderSubmitPromotionModel *> *noneDeliveryPromotionList;
@end

NS_ASSUME_NONNULL_END
