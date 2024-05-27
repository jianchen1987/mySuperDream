//
//  WMStoreFillGiftRuleModel.h
//  SuperApp
//
//  Created by wmz on 2021/7/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SAMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface WMStoreFillGiftRuleModel : SAModel
/// 赠送数量
@property (nonatomic, assign) NSInteger quantity;
/// 赠品名称
@property (nonatomic, copy) NSString *giftName;
/// 赠品ID
@property (nonatomic, copy) NSString *giftId;
/// 满赠金额
@property (nonatomic, strong) NSString *amount;
/// 活动ID
@property (nonatomic, copy) NSString *activityId;
/// 图片
@property (nonatomic, copy) NSString *imagePath;
/// 图片
@property (nonatomic, copy) NSArray *commodityPictureIds;

/// 订单详情里的
/// 赠品名称
@property (nonatomic, copy) NSString *commodityName;
/// 赠品ID
@property (nonatomic, copy) NSString *commodityId;

@end

NS_ASSUME_NONNULL_END
