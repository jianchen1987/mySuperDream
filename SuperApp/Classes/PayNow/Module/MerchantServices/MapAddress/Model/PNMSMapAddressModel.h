//
//  PNMSMapAddressModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/7/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSMapAddressModel : PNModel
/// 省份编码
@property (nonatomic, copy) NSString *code;
/// 等级（11：省，12：区）
@property (nonatomic, assign) NSInteger zLevel;
/// 省份名称
@property (nonatomic, copy) NSString *msg;
@end

NS_ASSUME_NONNULL_END
