//
//  WMCouponActivityContentModel.h
//  SuperApp
//
//  Created by wmz on 2022/7/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"
#import "WMStoreCouponDetailModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMCouponActivityContentModel : WMRspModel
///活动编号
@property (nonatomic, copy) NSString *activityNo;
///标题
@property (nonatomic, copy) NSString *title;
///门店参与编号
@property (nonatomic, copy) NSString *storeJoinNo;
///是否领取
@property (nonatomic, assign) BOOL isReceive;
///是否还有券可领
@property (nonatomic, assign) BOOL hasCouponReceive;
///门店NO
@property (nonatomic, copy) NSString *storeNo;
///需要展示的券列表
@property (nonatomic, copy) NSArray<WMStoreCouponDetailModel *> *coupons;

@end

NS_ASSUME_NONNULL_END
