//
//  WMStoreCouponDetailModel.h
//  SuperApp
//
//  Created by wmz on 2022/7/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMMessageCode.h"
#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreCouponDetailModel : WMRspModel
///券No
@property (nonatomic, copy) NSString *couponNo;
/////面值
//@property (nonatomic, copy) NSString *faceValue;
///面值
@property (nonatomic, copy) NSString *faceValueStr;
///门槛
@property (nonatomic, copy) NSString *threshold;
///标题
@property (nonatomic, copy) NSString *title;
/// APP使用链接
@property (nonatomic, copy) NSString *appLink;
/// 有效期开始日期
@property (nonatomic, copy) NSString *effectDate;
///有效期结束日期
@property (nonatomic, copy) NSString *expireDate;
///过几天失效
@property (nonatomic, assign) NSInteger afterExpire;
///有效期类型
/// FIXED_DATE :固定日期区间 10 FIXED_DURATION :固定时长 11 PERPETUAL :永久有效 12
@property (nonatomic, strong) WMMessageCode *effectiveType;
///是否没有库存
@property (nonatomic, assign) BOOL isStockOut;
///是否已领取
@property (nonatomic, assign) BOOL isReceived;
///是否达到领取上限
@property (nonatomic, assign) BOOL isOver;
/// 展示去使用
@property (nonatomic, assign) BOOL showUse;
/// 展示已抢光
@property (nonatomic, assign) BOOL showStockOut;

@end

NS_ASSUME_NONNULL_END
