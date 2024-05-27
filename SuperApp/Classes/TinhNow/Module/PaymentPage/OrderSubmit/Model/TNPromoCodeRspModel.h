//
//  TNOrderSubmitPromotionModel.h
//  SuperApp
//
//  Created by Chaos on 2020/12/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNRspModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAMoneyModel;


@interface TNPromoCodeRspModel : TNRspModel
/// 优惠金额
@property (nonatomic, strong) SAMoneyModel *_Nullable discountAmount;
/// 优惠号
@property (nonatomic, copy) NSString *activityNo;
/// 促销码
@property (nonatomic, copy) NSString *_Nullable promotionCode;
@end

NS_ASSUME_NONNULL_END
