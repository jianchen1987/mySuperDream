//
//  GNCouponDetailModel.h
//  SuperApp
//
//  Created by wmz on 2022/8/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "WMMessageCode.h"
#import "WMStoreCouponDetailModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNCouponDetailModel : WMStoreCouponDetailModel
///剩余库存
@property (nonatomic, assign) NSInteger remainNum;
///总库存
@property (nonatomic, assign) NSInteger stock;
/// name
@property (nonatomic, copy) NSString *couponName;
/// storeNo
@property (nonatomic, copy) NSString *storeNo;
/// storeName
@property (nonatomic, strong) SAInternationalizationModel *storeName;
///订单已完成
@property (nonatomic, assign) BOOL finish;
@end

NS_ASSUME_NONNULL_END
