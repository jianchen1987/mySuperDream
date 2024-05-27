//
//  TNApplyRefundModel.h
//  SuperApp
//
//  Created by xixi on 2021/1/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNApplyRefundModel : TNModel
/// 订单ID
@property (nonatomic, strong) NSString *orderNo;
/// 申请类型
@property (nonatomic, strong) NSString *applyType;
/// 退款类型
@property (nonatomic, strong) NSString *refundType;
/// 退款金额
@property (nonatomic, strong) NSString *refundAmount;
/// 申请原因
@property (nonatomic, strong) NSString *refundReason;
/// 补充说明
@property (nonatomic, strong) NSString *remarks;
/// 图片 item 类型: string
@property (nonatomic, strong) NSArray<NSString *> *images;
///
@property (nonatomic, strong) NSString *mobile;
@end

NS_ASSUME_NONNULL_END
