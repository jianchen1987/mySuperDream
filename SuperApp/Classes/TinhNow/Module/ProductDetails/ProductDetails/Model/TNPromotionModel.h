//
//  TNPromotionModel.h
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNPromotionModel : TNModel
/// 周几哪个时间端优惠   格式：["00:00-23:59"]
@property (nonatomic, copy) NSString *openingTimes;
/// 活动类型  DISCOUNT:折扣活动   LADDER_FULL_REDUCTION：满减活动   DELIVERY_FEE_REDUCE：减配送费活动
@property (nonatomic, copy) NSString *marketingType; //目前返回 可能会拼接数字  所以判断包含即可
/// 优惠比例
@property (nonatomic, copy) NSString *discountRatio;
/// 活动失效时间
@property (nonatomic, copy) NSString *expireDate;
/// 时间类型     RANDOM_TIME 任意时间   PART_TIME 部分时间
@property (nonatomic, copy) NSString *timeType;
/// 周几优惠    格式：["1","3","5"]
@property (nonatomic, copy) NSString *openingWeekdays;
/// 活动编号
@property (nonatomic, copy) NSString *activityNo;
/// 活动描述
@property (nonatomic, copy) NSString *desc;
/// 活动名称
@property (nonatomic, copy) NSString *name;
/// 活动生效时间
@property (nonatomic, copy) NSString *effectiveDate;
@end

NS_ASSUME_NONNULL_END
