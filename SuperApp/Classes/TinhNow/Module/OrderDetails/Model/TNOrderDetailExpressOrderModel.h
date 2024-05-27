//
//  TNOrderDetailExpressOrderModel.h
//  SuperApp
//
//  Created by xixi on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderDetailExpressOrderModel : TNModel
/// 物流公司名称
@property (nonatomic, copy) NSString *name;
/// 状态
@property (nonatomic, copy) NSString *status;
/// 状态国际化
@property (nonatomic, copy) NSString *statusTitle;
/// 创建时间时间戳
@property (nonatomic, copy) NSString *createTime;
/// 运单号
@property (nonatomic, copy) NSString *trackingNo;
/// 订单号
@property (nonatomic, copy) NSString *unifiedOrderNo;
/// 骑手手机号
@property (nonatomic, copy) NSString *riderPhone;
/// 骑手名称
@property (nonatomic, copy) NSString *riderName;
/// 骑手id
@property (nonatomic, copy) NSString *riderId;
/// 骑手操作员编号
@property (nonatomic, copy) NSString *riderOperatorNo;
@end

NS_ASSUME_NONNULL_END
