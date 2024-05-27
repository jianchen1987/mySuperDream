//
//  GNOneClickCouponAlert.h
//  SuperApp
//
//  Created by wmz on 2022/8/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNCouponDetailModel.h"
#import "GNMessageCode.h"
#import "WMOneClickCouponAlert.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNOneClickCouponAlert : WMOneClickCouponAlert
///使用回调
@property (nonatomic, copy) void (^useBlock)(GNCouponDetailModel *rspModel);
///配置信息
- (void)configDataSource:(NSArray<GNCouponDetailModel *> *)dataSource finish:(BOOL)finish;
@end

NS_ASSUME_NONNULL_END
