//
//  WMOrderDetailRiderModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailRiderModel : WMModel
/// 骑手 id
@property (nonatomic, copy) NSString *riderId;
/// 骑手姓名
@property (nonatomic, copy) NSString *riderName;
/// 骑手电话
@property (nonatomic, copy) NSString *riderPhone;
/// 骑手编号
@property (nonatomic, copy) NSString *riderNo;
@end

NS_ASSUME_NONNULL_END
